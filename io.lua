#!/usr/bin/env th
-- Lua IO library.
--
-- History
--   create  -  Feng Zhou (zhfe99@gmail.com), 08-02-2015
--   modify  -  Feng Zhou (zhfe99@gmail.com), 08-14-2015

----------------------------------------------------------------------
-- Load lines from the given file.
--
-- Input
--   lstPath  -  list path
--
-- Ouput
--   lns      -  lines, n x
function lua_lib.loadLns(lstPath)
  local lns = {}
  for ln in io.lines(lstPath) do
    table.insert(lns, ln)
  end
  return lns
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
  local foldNms = {}
  local foldPaths = {}

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

----------------------------------------------------------------------
-- Get the lmdb handle of a given sequence.
--
-- Input
--   lmdbPath  -  path of the lmdb file
--
-- Output
--    ha       -  handles
function lua_lib.lmdbRIn(lmdbPath)
  require 'lmdb'

  -- open
  local env = lmdb.env {
    Path = lmdbPath,
    Name = lmdbPath
  }
  env:open()

  -- cursor
  local txn = env:txn()
  local cur = txn:cursor()

  -- store
  local ha = {
    env = env,
    cur = cur,
    co = 0,
    lmdbPath = lmdbPath,
    n = env:stat().entries
  }

  return ha
end

----------------------------------------------------------------------
-- Read one item from lmdb handle.
--
-- Input
--   ha   -  handle
--
-- Output
--   key  -  key
--   val  -  value
function lua_lib.lmdbR(ha)
  -- local val2 = ha.cur:getData()
  local key, val = ha.cur:get()

  ha.cur:next()
  return key, val
end

----------------------------------------------------------------------
-- Close the handler.
--
-- Input
--   ha  -  handle
function lua_lib.lmdbROut(ha)
  ha.env:close()
end
