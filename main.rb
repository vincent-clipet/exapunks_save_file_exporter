require_relative 'kaitai/exapunks_solution'
require 'kaitai/struct/struct'
require 'fileutils'

##########
# CONFIG #
##########

DEBUG = false
INPUT_DIR = './data/example'
OUTPUT_DIR = './solutions-example'
OUTPUT_BEST_SOLUTIONS = "best_solutions-example.md"





#############
# FUNCTIONS #
#############

INPUT_DIR = ARGV[0] unless ARGV[0].nil?
OUTPUT_DIR = ARGV[1] unless ARGV[1].nil?
OUTPUT_BEST_SOLUTIONS = ARGV[2] unless ARGV[2].nil?

LEVELS = {
  "PB000"=>"trash-world-news", 
  "PB001"=>"trash-world-news", 
  "PB002"=>"trash-world-news", 
  "PB003B"=>"euclids-pizza", 
  "PB004"=>"mitsuzen-hdi10", 
  "PB005"=>"last-stop-snaxnet", 
  "PB006B"=>"zebros-copies", 
  "PB007"=>"sfcta-highway-sign-#4902", 
  "PB008"=>"unknown-network-1", 
  "PB009"=>"uc-berkeley", 
  "PB010B"=>"workhouse", 
  "PB011B"=>"mitsuzen-hdi10", 
  "PB012"=>"equity-first-bank", 
  "PB013C"=>"trash-world-news",
  "PB014"=>"kgogtv", 
  "PB015"=>"tec-redshift", 
  "PB016"=>"digital-library-project",
  "PB018"=>"emersons-guide", 
  "PB020"=>"sawayama-wonderdisc", 
  "PB021"=>"alliance-power-and-light", 
  "PB022"=>"deadlocks-domain", 
  "PB023"=>"xtreme-league-baseball",
  "PB024"=>"kings-ransom-online", 
  "PB025"=>"equity-first-bank", 
  "PB027"=>"valhalla", 
  "PB028"=>"kgogtv", 
  "PB037"=>"trash-world-news", 
  "PB038"=>"mitsuzen-hdi10", 
  "PB039"=>"sandbox", 
  "PB040"=>"tec-exablaster-modem"
}



class ExapunksSolution
  def to_md
    ret = []
    level = @file_id.string
    cycles = @win_stats[0].value
    size = @win_stats[1].value
    activity = @win_stats[2].value

    ret << "## #{@file_id.string} --- #{@name.string}"
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

def update_solution_stats(best_solutions, level_id, filename, win_stats)
  if best_solutions[level_id][:cycles] > win_stats[0] then
    best_solutions[level_id][:cycles] = win_stats[0]
    best_solutions[level_id][:best_by_cycles] = filename
  end
  if best_solutions[level_id][:size] > win_stats[1] then
    best_solutions[level_id][:size] = win_stats[1]
    best_solutions[level_id][:best_by_size] = filename
  end
  if best_solutions[level_id][:activity] > win_stats[2] then
    best_solutions[level_id][:activity] = win_stats[2]
    best_solutions[level_id][:best_by_activity] = filename
  end
end

def update_best_solutions(best_solutions, level_id, filename, win_stats)
  # this solution was not run in-game, and does not have any win stat
  return false if win_stats[0].nil?

  # Create the entry in hash if it doesn't exist
  setup_best_solutions_key(best_solutions, level_id) if best_solutions[level_id] == nil

  # add current solution to the list
  best_solutions[level_id][:solutions] << {
    :name => filename,
    :cycles => win_stats[0],
    :size => win_stats[1],
    :activity => win_stats[2]
  }

  # update best values
  update_solution_stats(best_solutions, level_id, filename, win_stats)

  return true
end

def write_solutions_markdown(best_solutions)
  best_solutions = best_solutions.sort.to_h
  file_best = File.new(OUTPUT_BEST_SOLUTIONS, 'w')
  file_best.puts("| id  | level | cycles | size  | activity | &nbsp; | solution_best_cycles | solution_best_size | solution_best_activity |")
  file_best.puts("| --- | ----- | :----: | :---: | :------: | ------ | -------------------- | ------------------ | ---------------------- |")

  best_solutions.each do | level_id, v |
    # puts level_id
    # puts 
    # puts v.to_s
    file_best.puts("| #{level_id} | #{LEVELS[level_id]} | #{v[:cycles]} | #{v[:size]} | #{v[:activity]} | &nbsp; | `#{v[:best_by_cycles]}` | `#{v[:best_by_size]}` | `#{v[:best_by_activity]}` |")
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

all_levels = {} if DEBUG

# Iterate list of every save file
input_filenames.each do | filename |

  # Deserialize save file with Kaitai
  stream = Kaitai::Struct::Stream.new(File.open(filename, 'r'))
  solution = ExapunksSolution.new(stream)

  # transform data for convenience
  level_id = solution.file_id.string
  level_name = LEVELS[level_id]
  # level_name = filename.gsub(/.*\/(.*)-(.*)\.solution/, '\1')
  solution_name = filename.gsub(/.*\/(.*)-(.*)\.solution/, '\1-\2')
  win_stats = solution.win_stats.map { |i| i.value.to_i }
  all_levels[level_id] = level_name if DEBUG

  # Update the hash that we'll need to extract the best solution for each level
  solved = update_best_solutions(best_solutions, level_id, solution_name, win_stats)

  # Write the solution to disk in a readable format
  tmp = "#{OUTPUT_DIR}/#{solution_name}.md"
  if solved then
    IO.write(tmp, solution.to_md)
    puts "Saved : #{tmp}"
  else
    puts "Skipped (unsolved): #{tmp}"
  end
end

# Write a markdown table containing the best values for each level on disk
write_solutions_markdown(best_solutions)



puts all_levels.sort.to_h.to_s if DEBUG
puts best_solutions if DEBUG