#!/usr/bin/env th
-- Lua image library.
--
-- History
--   create  -  Feng Zhou (zhfe99@gmail.com), 08-10-2015
--   modify  -  Feng Zhou (zhfe99@gmail.com), 2015-09

local image = require 'image'

----------------------------------------------------------------------
-- Split string into parts.
--
-- Input
--   imgPath  -  file path
--
-- Ouput
--   img      -  image, d x h x w
function lua_lib.imgLoad(imgPath)
  local gm = require 'graphicsmagick'
  local ok, img = pcall(gm.Image, imgPath)

  -- error
  if not ok or img == nil then
    print(imgPath .. ' is buggy')
    os.exit()
  end

  -- convert to tensor
  img = img:toTensor('float', 'RGB', 'DHW')

  -- different format
  if img:dim() == 2 then
    img = img:reshape(1, img:size(1), img:size(2))
  end
  if img:size(1) == 1 then
    img = torch.repeatTensor(img, 3, 1, 1)
  end
  if img:size(1) > 3 then
    img = img[{{1, 3}, {}, {}}]
  end

  return img
end

----------------------------------------------------------------------
-- Save image.
--
-- Input
--   imgPath  -  image path
--   img      -  image
function lua_lib.imgSave(imgPath, img)
  image.save(imgPath, img)
end

----------------------------------------------------------------------
-- Resize an image.
--
-- Input
--   img0   -  original image
--   sizMa  -  maximum size
--
-- Output
--   img    -  new image
function lua_lib.imgSizNew(img0, sizMa)
  img = image.scale(img0, '^' .. sizMa)

  return img
end

----------------------------------------------------------------------
-- Crop an image.
--
-- Input
--   img    -  original image
--   w      -  width
--
-- Output
--   img    -  new image
function lua_lib.imgCrop(img, w)
  local nDim = img:dim()
  local x0 = math.ceil((img:size(nDim) - w) / 2)
  local y0 = math.ceil((img:size(nDim - 1) - w) / 2)
  img = img:narrow(nDim, x0, w):narrow(nDim - 1, y0, w)

  return img
end
