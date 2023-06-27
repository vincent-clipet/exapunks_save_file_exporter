require_relative 'kaitai/exapunks_solution'
require 'kaitai/struct/struct'
require 'fileutils'

##########
# CONFIG #
##########

INPUT_DIR = './data/test_data'
OUTPUT_DIR = './solutions'
OUTPUT_BEST_SOLUTIONS = "best_solutions.md"
DEBUG = false





#############
# FUNCTIONS #
#############

class ExapunksSolution
  def to_md
    ret = []
    cycles = @win_stats[0].value
    size = @win_stats[1].value
    activity = @win_stats[2].value

    ret << "## #{@name.string}"
    ret << ""
    ret << "| cycles | size | activity |"
    ret << "| ------ | ---- | -------- |"
    ret << "| #{cycles} | #{size} | #{activity} |"

    ret << "<hr>"

    @exa_instances.each do | exa |
      ret << "<br>"
      ret << exa.to_md
      ret << ""
    end
    return ret.join("\n")
  end
end

class ExapunksSolution::ExaInstance
  def to_md
    ret = []
    name = @name.string.empty? ? 'NO_NAME' : @name.string
    ret << ""
    ret << "**#{name}**"
    ret << ""
    ret << "```"
    ret << @code.string
    ret << "```"
    return ret.join("\n")
  end
end


def setup_best_solutions_key(best_solutions, key)
  best_solutions[key] = {
    :cycles => 999999,
    :size => 999999,
    :activity => 999999,
    :best_by_cycles => "",
    :best_by_size => "",
    :best_by_activity => "",
    :solutions => []
  }
  return best_solutions
end

def update_solution_stats(best_solutions, name, filename, win_stats)
  if best_solutions[name][:cycles] > win_stats[0] then
    best_solutions[name][:cycles] = win_stats[0]
    best_solutions[name][:best_by_cycles] = filename
  end
  if best_solutions[name][:size] > win_stats[1] then
    best_solutions[name][:size] = win_stats[1]
    best_solutions[name][:best_by_size] = filename
  end
  if best_solutions[name][:activity] > win_stats[2] then
    best_solutions[name][:activity] = win_stats[2]
    best_solutions[name][:best_by_activity] = filename
  end
end

def update_best_solutions(best_solutions, name, filename, win_stats)
  # this solution was not run in-game, and does not have any win stat
  return false if win_stats[0].nil?

  # Create the entry in hash if it doesn't exist
  setup_best_solutions_key(best_solutions, name) if best_solutions[name] == nil

  # add current solution to the list
  best_solutions[name][:solutions] << {
    :name => filename,
    :cycles => win_stats[0],
    :size => win_stats[1],
    :activity => win_stats[2]
  }

  # update best values
  update_solution_stats(best_solutions, name, filename, win_stats)

  return true
end

def write_solutions_markdown(best_solutions)
  file_best = File.new(OUTPUT_BEST_SOLUTIONS, 'w')
  file_best.puts("| cycles | size | activity | &nbsp; | solution_best_cycles | solution_best_size | solution_best_activity |")
  file_best.puts("| :------: | :----: | :--------: | --- | -------------------- | ------------------ | ---------------------- |")

  best_solutions.each do | name, v |
    file_best.puts("| #{v[:cycles]} | #{v[:size]} | #{v[:activity]} | &nbsp; | `#{v[:best_by_cycles]}` | `#{v[:best_by_size]}` | `#{v[:best_by_activity]}` |")
  end
  file_best.close
end





#######
# RUN #
#######

best_solutions = {}

# Get list of every save file we need to read
input_filenames = Dir["#{INPUT_DIR}/*.solution"]

# Clean the output folder, to remove any solutions that might not exist anymore
delete_filenames =  Dir.glob("#{OUTPUT_DIR}/*.md")
FileUtils.rm_f(delete_filenames)


# Iterate list of every save file
input_filenames.each do | filename |

  # Deserialize save file with Kaitai
  stream = Kaitai::Struct::Stream.new(File.open(filename, 'r'))
  solution = ExapunksSolution.new(stream)

  # transform data for convenience
  name_level = filename.gsub(/.*\/(.*)-(.*)\.solution/, '\1')
  name_solution = filename.gsub(/.*\/(.*)-(.*)\.solution/, '\1-\2')
  puts "[DEBUG] name_level = #{name_level}" if DEBUG
  win_stats = solution.win_stats.map { |i| i.value.to_i }

  # Update the hash that we'll need to extract the best solution for each level
  solved = update_best_solutions(best_solutions, name_level, name_solution, win_stats)

  # Write the solution to disk in a readable format
  tmp = "#{OUTPUT_DIR}/#{name_solution}.md"
  if solved then
    IO.write(tmp, solution.to_md)
    puts "Saved : #{tmp}"
  else
    puts "Skipped (unsolved): #{tmp}"
  end
end



# Write a markdown table containing the best values for each level on disk
write_solutions_markdown(best_solutions)
