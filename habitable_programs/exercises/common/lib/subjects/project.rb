require_relative "source_file"
require "pathname"

module Subjects
  class Project
    attr_reader :root

    def initialize(root)
      @root = root
    end

    def files
      if root.end_with?(".rb")
        [SourceFile.new(root, self)]
      else
        Dir.glob("#{root}/**/*.rb")
          .reject { |f| f.include? '/spec/' } # ignore test code
          .map { |f| SourceFile.new(f, self) }
      end
    end

    def files_other_than(file)
      files.reject { |f| f == file }
    end

    def relative_path_to(absolute_path)
      base = Pathname.new(root)
      base = base.parent if root.end_with?(".rb")
      Pathname.new(absolute_path).relative_path_from(base).to_s
    end
  end
end
