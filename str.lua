#!/usr/bin/env th
-- Lua string library.
--
-- History
--   create  -  Feng Zhou (zhfe99@gmail.com), 08-09-2015
--   modify  -  Feng Zhou (zhfe99@gmail.com), 08-11-2015

----------------------------------------------------------------------
-- Split string into parts.
--
-- Example
--   input:  str = '1, 3, 4'
--   call:   idx = split(str)
--   output: idx = ['1', '3', '4']
--
-- Input
--   str    -  string
--   sep    -  separator
--
-- Ouput
--   parts  -  parts, n x
function lua_lib.split(str, sep)
   local parts = {}
   local regex = string.format("([^%s]+)", sep)

   for part, _ in str:gmatch(regex) do
      table.insert(parts, part)
   end
   return parts
end

----------------------------------------------------------------------
-- Convert a string to an index array.
--
-- Example
--   input:  str = '1, 3, 4'
--   call:   idx = str2idx(str)
--   output: idx = [1, 3, 4]
--
-- Input
--   str  -  string input
--
-- Output
--   idx  -  index, n x
function lua_lib.str2idx(str)
  parts = lua_lib.split(str, ',')
  idx = {}
  for i, part in ipairs(parts) do
    table.insert(idx, tonumber(part))
  end
  return idx
end
