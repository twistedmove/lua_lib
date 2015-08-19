#!/usr/bin/env th
-- Lua string library.
--
-- History
--   create  -  Feng Zhou (zhfe99@gmail.com), 08-09-2015
--   modify  -  Feng Zhou (zhfe99@gmail.com), 08-18-2015

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
  local parts = lua_lib.split(str, ',')
  local idx = {}
  for i, part in ipairs(parts) do
    table.insert(idx, tonumber(part))
  end
  return idx
end

----------------------------------------------------------------------
-- Remove subfix from a file name.
--
-- Input
--   name0  -  original name
--
-- Output
--   name   -  new name
function lua_lib.strDelSub(name0)
  local tail = string.find(name0, '[.]')

  local name = name0
  if tail then
    name = string.sub(name0, 1, tail - 1)
  end
  return name
end

----------------------------------------------------------------------
-- Same as python's 'startswith' function.
--
-- Input
--   s    -  string
--   pre  -  prefix
--
-- Output
--   res  -  result, true | false
function lua_lib.startswith(s, pre)
  return string.sub(s, 1, s.len(pre)) == pre
end

----------------------------------------------------------------------
-- Same as python's 'endswith' function.
--
-- Input
--   s    -  string
--   sub  -  subfix
--
-- Output
--   res  -  result, true | false
function lua_lib.endswith(s, sub)
  return sub == '' or string.sub(s, -string.len(sub)) == sub
end
