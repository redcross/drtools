require_dependency Iap::Engine.root.join('lib', 'flat_group_by').to_s

module Iap
  class WorkLocationVerification
    def initialize plan
      @plan = plan
      @environment = plan.environment
    end

    attr_reader :plan, :environment

    def mismatched_staff
      @mismatched_staff ||= calculate_mismatched_staff
    end

    def calculate_mismatched_staff
      staff_by_name = assigned_staff.flat_group_by(&:name)
      lines_by_name = assignment_lines.flat_group_by(&:leader)

      unmatched = []
      mismatched = []
      lines_by_name.each do |name, assignment|
        staff = staff_by_name[name]
        unless staff
          unmatched << assignment
          next
        end

        record = Record.new(staff, staff.work_location, assignment.work_assignment.work_location, assignment)
        mismatched << record if record.mismatched?
      end

      mismatched
    end

    def assigned_staff
      @assigned_staff ||= environment.assigned_staff.to_a
    end

    def assignment_lines
      @assignment_lines ||= WorkAssignmentLine.joins{work_assignment}.where{work_assignment.plan_id == my{plan}}.preload{work_assignment}.to_a
    end

    Record = Struct.new(:person, :old_location, :new_location, :work_assignment) do
      def mismatched?
        old_location != new_location
      end
    end
  end
end