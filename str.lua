#!/usr/bin/env th
-- Lua string library.
--
-- History
--   create  -  Feng Zhou (zhfe99@gmail.com), 08-09-2015
--   modify  -  Feng Zhou (zhfe99@gmail.com), 08-09-2015

----------------------------------------------------------------------
-- Split string into parts.
--
-- Input
--   str    -  string
--   sep    -  separator
--
-- Ouput
--   parts  -  parts, n x
function lua_lib.split(str, sep)
   local result = {}
   local regex = string.format("([^%s]+)", sep)

   for line, _ in str:gmatch(regex) do
      table.insert(result, line)
   end
   return result
end
