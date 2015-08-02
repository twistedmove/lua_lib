#!/usr/bin/env th
-- Lua IO library.
--
-- History
--   create  -  Feng Zhou (zhfe99@gmail.com), 08-02-2015
--   modify  -  Feng Zhou (zhfe99@gmail.com), 08-02-2015

----------------------------------------------------------------------
-- Load lines.
--
-- Input
--   lstPath  -  list path
--
-- Ouput
--   lns      -  lines, n x
function lua_lib.loadLns(lstPath)
  lns = {}
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
