#!/usr/bin/ruby

# Copyright 2024 hidenorly
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

class MarkdownTableUtil
	def self.isTableSepatorIdentifier( cols )
		result = false

		cols.each do |aCol|
			aCol = aCol.to_s.strip
			result =  aCol.start_with?(":---") || aCol.end_with?("---:")
			break if result
		end

		return result
	end

	def self.cleanupMdCols(cols)
		_cols = []
		isFirst = true
		cols.each do | aCol |
			_cols << aCol.strip if !isFirst
			isFirst = false
		end
		return _cols
	end

	def self.putColsIntoNestedHash(cols, theHash)
		_theHash = theHash
		_cols = cols.clone()
		lastValue = _cols.pop().to_s
		lastValue = "" if lastValue=="``````"
		lastHash = theHash
		lastCol = nil
		_cols.each do |aCol|
			if _theHash.kind_of?(Hash) then
				if !_theHash.has_key?(aCol) then
					_theHash[aCol] = {}
				end
				lastHash = _theHash
				lastCol = aCol
				_theHash = _theHash[aCol]
			end
		end
		if lastHash[lastCol].kind_of?(String) then
			if !lastValue.empty? then
				lastHash[lastCol] = "#{lastHash[lastCol]} <br> #{lastValue}"
			end
		else
			lastHash[lastCol] = lastValue
		end

		return theHash
	end

	def self.getColsFromNestedHash(result, theHash)
		if theHash.kind_of?(Hash) then
			theHash.each do |key, value|
				result << key
				getColsFromNestedHash(result, value)
				break # TODO: multiple key case support
			end
		else
			result << theHash
		end
	end

	def self.getFlattenTablesFromNestedHash(theHash)
		result = []
		theHash.each do |key, value|
			cols = [key]
			getColsFromNestedHash(cols, value)
			result << cols
		end
		return result
	end

end

#---- main --------------------------

firstLine = true
tables = []
theTable = {:keys=>nil, :data=>[], :hash=>{}}
tables << theTable
foundTable = false

while line = gets
	aLine = line.chomp
	aLine = aLine.to_s.strip

	# parse multiple markdown tables
	cols = aLine.split("|")
	if cols.length >=2 then
		# should be markdown table
		if MarkdownTableUtil.isTableSepatorIdentifier(cols) then
			theTable[:keys] = theTable[:data].pop()
			foundTable = true
		else
			cols = MarkdownTableUtil.cleanupMdCols(cols)
			theTable[:data] << cols
			if foundTable then
				MarkdownTableUtil.putColsIntoNestedHash(cols, theTable[:hash])
			end
		end
	else
		# found non table line
		if foundTable then
			theTable = {:keys=>nil, :data=>[], :hash=>{}}
			tables << theTable
			foundTable = false
		end
	end
end

tables.each do | theTable |
	if !theTable[:data].empty? then
		puts "| #{theTable[:keys].join(" | ")} |" if theTable[:keys]
		puts "#{ "| :--- " * theTable[:data][0].length } |"

		_data = MarkdownTableUtil.getFlattenTablesFromNestedHash(theTable[:hash]) #theTable[:data]
		_data.each do | theCols |
			puts "| #{theCols.join(" | ")} |" if !theCols.empty?
		end
		puts ""
	end
end

