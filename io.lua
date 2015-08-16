#!/usr/bin/env th
-- Lua IO library.
--
-- History
--   create  -  Feng Zhou (zhfe99@gmail.com), 08-02-2015
--   modify  -  Feng Zhou (zhfe99@gmail.com), 08-16-2015

local lmdb = require 'lmdb'
local hdf5 = require 'hdf5'

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
  if ha.co == 0 then
    ha.cur:first()
  else
    ha.cur:next()
  end
  ha.co = ha.co + 1

  -- local val2 = ha.cur:getData()
  local key, val = ha.cur:get()
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

----------------------------------------------------------------------
-- Save matrix to file.
--
-- Input
--   fpath  -  file path
--   A      -  torch tensor
--   fmt    -  format
function lua_lib.matSave(fpath, A, fmt)
  local fio = io.open(fpath, "w")
  local dims = #A
  fio:write(string.format('%d %d %d %d\n', dims[1], dims[2], dims[3], dims[4]))
  for i1 = 1, dims[1] do
    for i2 = 1, dims[2] do
      for i3 = 1, dims[3] do
        for i4 = 1, dims[4] do
          fio:write(string.format(fmt, A[i1][i2][i3][i4]))
          fio:write(' ')
        end
      end
    end
  end
  fio:close()
end

----------------------------------------------------------------------
-- Load matrix from file.
--
-- Input
--   fpath  -  file path
--   fmt    -  format
--
-- Output
--   A      -  torch tensor
function lua_lib.matLoad(fpath, fmt)
  local fio = io.open(fpath, "r")
  local dims = torch.LongStorage(4)

  local ln = fio:read('*l')
  local parts = lua_lib.split(ln, ' ')
  local dims = torch.LongStorage(4)
  for i = 1, 4 do
    dims[i] = tonumber(parts[i])
  end

  local A = torch.Tensor(dims)
  ln = fio:read('*l')
  parts = lua_lib.split(ln, ' ')
  local co = 0
  for i1 = 1, dims[1] do
    for i2 = 1, dims[2] do
      for i3 = 1, dims[3] do
        for i4 = 1, dims[4] do
          co = co + 1
          A[i1][i2][i3][i4] = tonumber(parts[co])
        end
      end
    end
  end
  fio:close()

  return A
end

----------------------------------------------------------------------
-- Open an HDF handler for reading.
--
-- Input
--   hdfPath  -  hdf path
function lua_lib.hdfRIn(hdfPath)
  local ha
  return ha
end

----------------------------------------------------------------------
-- Open an HDF handler for writing.
--
-- Input
--   hdfPath  -  hdf path
--
-- Output
--   ha       -  hdf handler
function lua_lib.hdfWIn(hdfPath)
  local ha = hdf5.open(hdfPath, 'w')

  return ha
end

----------------------------------------------------------------------
-- Write a tensor to hdf.
--
-- Input
--   ha  -  hdf handler
--   A   -  matrix
--   nm  -  variable name
function lua_lib.hdfW(ha, A, nm)
  if nm == nil then
    nm = 'a'
  end
  ha:write(nm, A)
end

----------------------------------------------------------------------
-- Close an HDF handler.
--
-- Input
--   ha  -  hdf handler
function lua_lib.hdfWOut(ha)
  ha:close()
end
