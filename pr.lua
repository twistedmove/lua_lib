#!/usr/bin/env th
-- Lua library.
--
-- History
--   create  -  Feng Zhou (zhfe99@gmail.com), 08-02-2015
--   modify  -  Feng Zhou (zhfe99@gmail.com), 08-02-2015

----------------------------------------------------------------------
-- Print the keys of a table.
--
-- Input
--   tab  -  table
function lua_lib.prKeys(tab)
  -- each key
  for k, v in pairs(tab) do
    print(k)
  end
end

----------------------------------------------------------------------
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
  -- nmPrs = range(nMa)
  -- ticPrs = range(nMa)
  -- ticPr0s = range(nMa)
  -- nRepPrs = range(nMa)
  -- scaPrs = range(nMa)
end

----------------------------------------------------------------------
-- Print information
--
-- Input
--   msg  -  message
function lua_lib.pr(msg)
  -- set promption level
  if not lPr then
    lua_lib.prSet(3)
  end

  if lPr < lMaPr then
    for l = 1, lPr + 1 do
      io.write('-')
    end
    print(msg)
  end
end

----------------------------------------------------------------------
-- Return the list of all sub-folders under a folder.
--
-- Input
--   fold       -  root fold
--
-- Output
--   foldNms    -  directory name list, n x
--   foldPaths  -  directory path list, n x
function lua_lib.listFold(fold)
  foldNms = {}
  foldPaths = {}

  -- each sub file
  for foldNm in paths.files(fold) do
    local foldPath = paths.concat(fold, foldNm)
    if paths.dirp(foldPath) and foldNm ~= '..' and foldNm ~= '.' then
      table.insert(foldNms, foldNm)
      table.insert(foldPaths, foldPath)
    end
  end
  return foldNms, foldPaths
end
