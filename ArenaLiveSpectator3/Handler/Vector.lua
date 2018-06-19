--[[
    ArenaLive [Spectator] is an user interface for spectated arena 
	wargames in World of Warcraft.
    Copyright (C) 2015  Harald Böhm <harald@boehm.agency>
	Further contributors: Jochen Taeschner and Romina Schmidt.
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
	
	ADDITIONAL PERMISSION UNDER GNU GPL VERSION 3 SECTION 7:
	As a special exception, the copyright holder of this add-on gives you
	permission to link this add-on with independent proprietary software,
	regardless of the license terms of the independent proprietary software.
]]

-- Initialisation:
local addonName, L = ...;
local VectorClass = {};
local VectorMetaTable = {
	__index = VectorClass,
	__metatable = true, -- Prevents changes to the metatable
}
LibVector = {};
-- Private functions:


--[[
	This function is used as a constructor for new n-dimensional vectors.
	
	@param (number) dimension The number of dimensions the vector has.
	@param [optional] (table) Initial values of the vector.
							  This has to be a table with indices as keys.
	@return (table) a new vector object.
]]
function LibVector:New(numDimension, values)

	assert( (type(numDimension) == "number"),
		"LibVector:New(): paramter #1 must be of type number.");
	assert( (not values or type(values) == "table"), 
		"LibVector:New(): Optional parameter #2 must be of type table.");

	local vector = {};
	local privateAttributes = {};
	
	numDimension = math.floor(numDimension); -- Make sure value is an int
	if (not values) then
		for (i = 0, numDimension, i = i + 1) do
		end
	else
	end
	setmetatable(vector, VectorClass);
	
	return vector;
end
