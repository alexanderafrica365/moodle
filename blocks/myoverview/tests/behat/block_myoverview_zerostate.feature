@block @block_myoverview @javascript
Feature: Zero state on my overview block
  In order to know what should be the next step
  As a user
  I should see the proper information based on my capabilities

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email                | idnumber |
      | user     | User      | X        | user@example.com     | U1       |
      | manager  | Manager   | X        | manager@example.com  | M1       |
    And the following "role assigns" exist:
      | user    | role    | contextlevel | reference |
      | manager | manager | System       |           |

  Scenario: Users with no permissions don't see any CTA
    Given I am on the "My courses" page logged in as "user"
    When I should see "You're not enrolled in any course"
    Then I should see "Once you enrol in a course, it will appear here"
    And I should not see "Create course"
    And I should not see "Request a course"

  Scenario: Users with permissions to request a course should see a Request course button
    Given the following "permission overrides" exist:
      | capability            | permission | role  | contextlevel | reference |
      | moodle/course:request | Allow      | user  | System       |           |
    When I am on the "My courses" page logged in as "user"
    Then I should see "Request your first course"
    And "Moodle documentation" "link" should exist
    And "Quickstart guide" "link" should exist
    And "Request a course" "button" should exist
    And I click on "Request a course" "button"
    And I should see "Details of the course"

  Scenario: Users with permissions to create a course when there is no course created
    Given I am on the "My courses" page logged in as "manager"
    When I should see "Create your first course"
    Then "Moodle documentation" "link" should exist
    And "View Quickstart guide" "button" should exist
    And "Create course" "button" should exist
    And I click on "Create course" "button"
    And I should see "Add a new course"

  Scenario: Users with permissions to create a course but is not enroled in any existing course
    Given the following "course" exists:
      | fullname         | Course 1 |
      | shortname        | C1       |
    When I am on the "My courses" page logged in as "manager"
    Then I should see "You're not enrolled in any course"
    Then I should see "Once you enrol in a course, it will appear here."
    And "Manage courses" "button" should exist
    And "Create course" "button" should exist
    And I click on "Create course" "button"
    And I should see "Add a new course"
    And I am on the "My courses" page
    And I click on "Manage courses" "button"
    And I should see "Course 1"

  Scenario: Users with permissions to create but not to manage courses and is not enroled in any existing course
    Given the following "permission overrides" exist:
      | capability             | permission | role     | contextlevel | reference |
      | moodle/category:manage | Prohibit   | manager  | System       |           |
    And the following "course" exists:
      | fullname         | Course 1 |
      | shortname        | C1       |
    When I am on the "My courses" page logged in as "manager"
    Then I should see "You're not enrolled in any course"
    Then I should not see "To view all courses on this sie, go to Manage courses"
    And "Manage courses" "button" should not exist
    And "Create course" "button" should exist
    And I click on "Create course" "button"
    And I should see "Add a new course"
