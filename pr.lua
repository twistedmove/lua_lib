#!/usr/bin/env th
-- Lua library.
--
-- History
--   create  -  Feng Zhou (zhfe99@gmail.com), 08-02-2015
--   modify  -  Feng Zhou (zhfe99@gmail.com), 2015-08

----------------------------------------------------------------------
-- Print information.
-- Similar to matlab's sprintf function.
--
-- Input
--   fmt  -  format
--   ...  -  message
--
-- Output
--   str  -  string
function lua_lib.sprintf(fmt, ...)
  -- string format
  local arg = {...}
  local str
  if #arg == 0 then
    str = fmt
  else
    str = string.format(fmt, ...)
  end
  return str
end

----------------------------------------------------------------------
-- Print information
--
-- Input
--   fmt  -  format
--   ...  -  message
function lua_lib.printf(fmt, ...)
  -- string format
  local str = lua_lib.sprintf(fmt, ...)

  print(str)
end

----------------------------------------------------------------------
-- Print the keys of a table.
--
-- Input
--   tab  -  table
function lua_lib.keys(tab)
  -- each key
  for k, v in pairs(tab) do
    print(k)
  end
end

----------------------------------------------------------------------
-- Return the number of keys of a table.
--
-- Input
--   tab  -  table
--
-- Output
--   n    -  #keys
function lua_lib.nkeys(tab)
  -- each key
  local n = 0
  for k, v in pairs(tab) do
    n = n + 1
  end
  return n
end

----------------------------------------------------------------------
-- Print table.
--
-- Input
--   tab  -  table
--   nm   -  name of table
function lua_lib.prTab(tab, nm)
  -- table name
  if nm then
    lua_lib.prIn(string.format('table "%s" content', nm))
  else
    lua_lib.prIn('table content')
  end

  -- each key
  for k, v in pairs(tab) do
    lua_lib.pr(k .. ': ' .. tostring(v))
  end
  lua_lib.prOut()
end

----------------------------------------------------------------------
-- upvalue used by prXXX functions.
local logFile = nil
local lPr = nil
local lMaPr = nil
local nmPrs = nil
local ticPrs = nil
local ticPr0s = nil
local nRepPrs = nil
local scaPrs = nil

----------------------------------------------------------------------
-- Set the promption level
--
-- Input
--   lMa  -  maximum level
function lua_lib.prSet(lMa)
  -- level
  lPr = 1
  lMaPr = lMa

  -- list
  nMa = 10
  nmPrs = {}
  ticPrs = {}
  ticPr0s = {}
  nRepPrs = {}
  scaPrs = {}
  for i = 1, nMa do
    nmPrs[i] = nil
    ticPrs[i] = nil
    ticPr0s[i] = nil
    nRepPrs[i] = nil
    scaPrs[i] = nil
  end
end

----------------------------------------------------------------------
-- Print information
--
-- Input
--   fmt  -  format
--   msg  -  message
function lua_lib.pr(fmt, ...)
  -- set promption level
  if not lPr then
    lua_lib.prSet(3)
  end

  -- string format
  local arg = {...}
  local str
  if #arg == 0 then
    str = fmt
  else
    str = string.format(fmt, ...)
  end

  if lPr < lMaPr then
    local prefix = ''
    for l = 1, lPr do
      prefix = prefix .. '-'
    end
    print(prefix .. str)
  end
end

----------------------------------------------------------------------
-- Enter a loop.
--
-- Input
--   nm    -  function name
--   nRep  -  #steps
--   sca   -  scale of moving, (0, 1) | 1 | 2 | ...
function lua_lib.prCIn(nm, nRep, sca)
  -- insert
  nmPrs[lPr] = nm
  ticPrs[lPr] = sys.clock()
  ticPr0s[lPr] = ticPrs[lPr]
  nRepPrs[lPr] = nRep

  -- scaling
  if sca < 1 then
    sca = lua_lib.round(nRep * sca)
  end
  if sca == 0 then
    sca = 1
  end
  scaPrs[lPr] = sca

  -- print
  lua_lib.pr(string.format('%s: %d %d', nm, nRep, sca))

  lPr = lPr + 1
end

----------------------------------------------------------------------
-- Leave a loop.
--
-- Input
--   nRep  -  #steps
function lua_lib.prCOut(nRep)
  lPr = lPr - 1

  -- time
  local t = sys.clock() - ticPr0s[lPr]

  -- print
  lua_lib.pr(string.format('%s: %d iters, %.2f secs', nmPrs[lPr], nRep, t))
end

----------------------------------------------------------------------
-- Prompt information for a loop.
--
-- Input
--   iRep  -  current step
function lua_lib.prC(iRep)
  lPr = lPr - 1

  if (iRep ~= 0 and iRep % scaPrs[lPr] == 0) or (iRep == nRepPrs[lPr]) then
    -- time
    local t = sys.clock() - ticPrs[lPr]

    -- print
    lua_lib.pr(string.format('%s: %d/%d, %.2f secs', nmPrs[lPr], iRep, nRepPrs[lPr], t))

    -- re-start a timer
    ticPrs[lPr] = sys.clock()
  end
  lPr = lPr + 1
end

----------------------------------------------------------------------
-- Enter function.
--
-- Input
--   nm   -  function name
--   fmt  -  format
function lua_lib.prIn(nm, fmt, ...)
  -- init
  if lPr == nil then
    lua_lib.prSet(3)
  end

  if fmt then
    lua_lib.pr(nm .. ': ' .. fmt, ...)
  else
    lua_lib.pr(nm)
  end

  lPr = lPr + 1
end

----------------------------------------------------------------------
-- Leave function.
function lua_lib.prOut()
  lPr = lPr - 1
end

----------------------------------------------------------------------
-- Enter and leave function.
--
-- Input
--   ...  -  same input to prIn
function lua_lib.prInOut(...)
  lua_lib.prIn(...)
  lua_lib.prOut()
end
