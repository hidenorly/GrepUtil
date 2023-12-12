#!/usr/bin/ruby

# Copyright 2023 hidenorly
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'optparse'

def getFolderAndFileName(path)
	folder = ""
	filename = ""

	path = path.to_s
	path = path.slice(2..) if path.start_with?("./")

	pos = path.index("/")
	if pos!=nil then
		folder = path.slice(0, pos)
		filename = path.slice(pos+1..)
	else
		filename = path
	end

	return folder, filename
end


#---- main --------------------------
options = {
	:splitFolderFile=>false
}


opt_parser = OptionParser.new do |opts|
	opts.banner = "Usage: grep keyword | ruby grep2markdown"
	opts.on("-s", "--splitFolderFile", "If you want to output folder and filename as split") do
		options[:splitFolderFile] = true
	end

end.parse!

firstLine = true

while line = gets
	aLine = line.chomp
	aLine = aLine.to_s.strip
	pos = aLine.index(":")
	if pos!=nil then
		path = aLine.slice(0, pos)
		if options[:splitFolderFile] then
			folder, filename = getFolderAndFileName(path)
			path = "#{folder} | #{filename}"
		end
		lineNum = nil
		pos2 = aLine.index(":", pos+1)
		if pos2!=nil then
			lineNum = aLine.slice(pos+1..pos2-1)
			result = aLine.slice(pos2+1..).strip
			if firstLine then
				puts options[:splitFolderFile] ? "| dir | path | line | result |" : "| path | line | result |"
				puts options[:splitFolderFile] ? "| :--- | :--- | :--- | :--- |" : "| :--- | :--- | :--- |"
				firstLine = false
			end
			puts "| #{path} | #{lineNum} | ```#{result}``` |"
		else
			result = aLine.slice(pos+1, aLine.length).strip
			if firstLine then
				puts options[:splitFolderFile] ? "| dir | path | result |" : "| path | result |"
				puts options[:splitFolderFile] ? "| :--- | :--- | :--- |" : "| :--- | :--- |"
				firstLine = false
			end
			puts "| #{path} | ```#{result}``` |"
		end
	end
end