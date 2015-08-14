#!/usr/bin/env th
-- Lua math library.
--
-- History
--   create  -  Feng Zhou (zhfe99@gmail.com), 08-09-2015
--   modify  -  Feng Zhou (zhfe99@gmail.com), 08-13-2015

----------------------------------------------------------------------
-- Compute the maximum value of a given table.
--
-- Input
--   as  -  table
--
-- Ouput
--   ma   -  maximum value
function lua_lib.tmax(as)
   require 'torch'
   local bs = torch.Tensor(as)
   return bs:max()
end

----------------------------------------------------------------------
-- Compute the minumum value of a given table.
--
-- Input
--   as  -  table
--
-- Ouput
--   mi   -  minumum value
function lua_lib.tmin(as)
   require 'torch'
   local bs = torch.Tensor(as)
   return bs:min()
end

----------------------------------------------------------------------
-- Round to integer.
--
-- Input
--   a  -  a float
--
-- Output
--   b  -  an integer
function lua_lib.round(a)
  return math.floor(a + 0.5)
end
