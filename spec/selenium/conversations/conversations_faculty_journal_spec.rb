# frozen_string_literal: true

#
# Copyright (C) 2014 - present Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.

require_relative "../helpers/conversations_common"
require_relative "../helpers/assignment_overrides"

describe "conversations new" do
  include_context "in-process server selenium tests"
  include AssignmentOverridesSeleniumHelper
  include ConversationsCommon

  let(:account) { Account.default }
  let(:account_settings_url) { "/accounts/#{account.id}/settings" }
  let(:user_notes_url) { "/courses/#{@course.id}/user_notes" }
  let(:student_user_notes_url) { "/users/#{@s1.id}/user_notes" }

  before do
    conversation_setup
    @s1 = user_factory(name: "first student")
    @s2 = user_factory(name: "second student")
    @s3 = user_factory(name: "third student")
    [@s1, @s2, @s3].each { |s| @course.enroll_student(s).update_attribute(:workflow_state, "active") }
    cat = @course.group_categories.create(name: "the groups")
    @group = cat.groups.create(name: "the group", context: @course)
    @group.users = [@s1, @s2]
  end

  context "Conversations Faculty Journal" do
    before do
      Account.default.update_attribute(:enable_user_notes, true)
      Account.site_admin.disable_feature!(:deprecate_faculty_journal)
    end

    context "react_inbox", :ignore_js_errors do
      it "can faculty journalize a message sent to a student that has common courses" do
        user_session(@teacher)
        get conversations_path
        f("button[data-testid='compose']").click
        # must drill down
        f("input[placeholder='Select Course']").click
        fj("li:contains('#{@course.name}')").click
        f("input[aria-label='To']").click
        fj("li:contains('Students')").click
        fj("li:contains('third student')").click
        fj("label:contains('Add as a Faculty Journal entry')").click
        f("textarea[data-testid='message-body']").send_keys "this for third student"
        fj("button:contains('Send')").click
        wait_for_ajaximations
        expect(UserNote.last.note).to eq "this for third student"
      end

      it "can faculty journalize a message sent to a group" do
        user_session(@teacher)
        get conversations_path
        f("button[data-testid='compose']").click
        f("input[placeholder='Select Course']").click
        fj("li:contains('#{@course.name}')").click
        f("input[aria-label='To']").click
        fj("li:contains('Student Groups')").click
        wait_for_ajaximations
        fj("li:contains('#{@group.name}')").click
        fj("li:contains('All in #{@group.name}')").click
        fj("label:contains('Add as a Faculty Journal entry')").click
        f("textarea[data-testid='message-body']").send_keys "this is a group message!"
        fj("button:contains('Send')").click
        wait_for_ajaximations
        expect(UserNote.last.note).to eq "this is a group message!"
      end

      it "does not show faculty journal option if sender is a student" do
        user_session(@s1)
        get conversations_path
        f("button[data-testid='compose']").click
        f("input[placeholder='Select Course']").click
        fj("li:contains('#{@course.name}')").click
        f("input[aria-label='To']").click
        fj("li:contains('Students')").click
        wait_for_ajaximations
        fj("li:contains('#{@s2.name}')").click
        wait_for_ajaximations
        expect(f("body")).not_to contain_jqcss "label:contains('Add as a Faculty Journal entry')"
      end

      it "does not show faculty journal option if disabled at the account level" do
        account.update_attribute(:enable_user_notes, false)

        user_session(@teacher)
        get conversations_path
        f("button[data-testid='compose']").click
        f("input[placeholder='Select Course']").click
        fj("li:contains('#{@course.name}')").click
        f("input[aria-label='To']").click
        fj("li:contains('Students')").click
        wait_for_ajaximations
        fj("li:contains('#{@s2.name}')").click
        wait_for_ajaximations
        expect(f("body")).not_to contain_jqcss "label:contains('Add as a Faculty Journal entry')"
      end

      it "does not show faculty journal option if messaging a non-student" do
        user_session(@teacher)
        get conversations_path
        f("button[data-testid='compose']").click
        f("input[placeholder='Select Course']").click
        fj("li:contains('#{@course.name}')").click
        f("input[aria-label='To']").click
        fj("li:contains('Teachers')").click
        wait_for_ajaximations
        fj("li:contains('#{@teacher.name}')").click
        wait_for_ajaximations
        expect(f("body")).not_to contain_jqcss "label:contains('Add as a Faculty Journal entry')"
      end
    end
  end
end
