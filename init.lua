th_lib = {}

function th_lib.prKeys(tab)
  -- Print the keys of a table.
  --
  -- Input
  --   tab  -  table

  -- each key
  for k,v in pairs(tab) do
    print(k)
  end
end

local logFile = nil
local lPr = nil
local lMaPr = nil
local nmPrs = nil
local ticPrs = nil
local ticPr0s = nil
local nRepPrs = nil
local scaPrs = nil

function prSet(lMa)
  -- Set the promption level
  --
  -- Input
  --   lMa  -  maximum level

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

function th_lib.pr(msg)
  -- Print information
  --
  -- Input
  --   msg  -  message
  assert(lPr)
  if lPr < lMaPr then
    for l = 1, lPr + 1 do
      io.write('-')
    end
    print(msg)
  end
end

return th_lib
