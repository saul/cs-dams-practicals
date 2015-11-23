require_relative "york/student_info"

class Assessment
  def initialize(registry:, assessment:)
    @registry = registry
    @assessment = assessment
  end

  def add_mark(student_number, mark)
    @registry.add_mark(@assessment, student_number, mark)
  end

  def finalise
    @registry.finalise_assessment(@assessment)
  end
end

class Registry
  def initialize
    @instance = York::StudentInfo.instance
  end

  def find_module(module_code, create_if_not_found)
    @instance.find_module(module_code, create_if_not_found)
  end

  def create_assessment(mod, year)
    ass = @instance.create_assessment(mod, year)
    Assessment.new(registry: @instance, assessment: ass)
  end

  def find_assessment(module_code, year)
    mod = find_module(module_code, false)

    unless mod.nil?
      mod.assessments.find { |ass| ass.year == year }
    end
  end
end

class MarkingSystem
  def initialize(registry:Registry.new)
    @registry = registry
  end

  def add_marks(module_code, year, marks)
    mod = @registry.find_module(module_code, true)
    assessment = @registry.create_assessment(mod, year)

    marks.each do |student_number, mark|
      assessment.add_mark(student_number, mark)
    end

    assessment.finalise
  end

  def summarise_marks(module_code, year)
    ass = @registry.find_assessment(module_code, year)
    return "" if ass.nil?

    ass.marks.map { |student_number, mark| "#{student_number}: #{mark}" }.join("\n")
  end
end
