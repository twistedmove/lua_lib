#!/usr/bin/env th
-- Lua Table library.
--
-- History
--   create  -  Feng Zhou (zhfe99@gmail.com), 08-02-2015
--   modify  -  Feng Zhou (zhfe99@gmail.com), 08-18-2015

-- Return a new array containing the concatenation of all of its parameters.
--
--
-- Input
--   ...  -  a list of tables
--
-- Output
--   res  -  result
function lua_lib.tabCon(...)
  local res = {}

  -- each parameter
  for n = 1, select('#', ...) do
    local arg = select(n, ...)
    assert(type(arg) == 'table')

    -- each element
    for _, v in ipairs(arg) do
      res[#res + 1] = v
    end
  end
  return res
end
