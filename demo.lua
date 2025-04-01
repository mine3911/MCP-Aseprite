-- 填充坐标所在区域颜色
function FillAreaColor(image, x, y, color)
  -- 获取当前像素的颜色
  local currentColor = image:getPixel(x, y)
  -- 如果当前像素已经是目标颜色，直接返回
  if currentColor == color then
    return
  end
  local i = 1;

  -- 递归填充函数
  local function fill(x, y)
    if i > 30 then
      return;
    end

    -- 检查边界条件
    if x < 0 or x >= app.sprite.width or y < 0 or y >= app.sprite.height then
      return
    end

    print(image:getPixel(35, 29))
    print(currentColor)
    -- 如果当前像素不是要填充的颜色，直接返回
    if image:getPixel(x, y) ~= currentColor then
      return
    end

    -- 绘制像素
    image:drawPixel(x, y, color)
    print("填充像素：" .. x .. "," .. y)
    i = i + 1;

    -- 递归填充上下左右四个方向
    fill(x + 1, y)
    fill(x - 1, y)
    fill(x, y + 1)
    fill(x, y - 1)
  end

  -- 开始填充
  fill(x, y)
end

-- FillAreaColor(app.image,31,31,app.pixelColor.rgba(255,0,0,255))
local sprite = app.sprite

local layer = app.sprite.layers[1]
if not layer then
  return
end
local cel = layer:cel(1)
if not cel then
  print("未找到指定帧:")
  cel = app.sprite:newCel(layer,1,Image(64,64))
end
-- print(cel.position)
-- print(cel.image.width..cel.image.height)

-- cel.image:drawPixel(0,0,app.pixelColor.rgba(255,0,0,255))
-- cel.image:drawPixel(0,1,app.pixelColor.rgba(255,0,0,255))
-- cel.image:drawPixel(0,2,app.pixelColor.rgba(255,0,0,255))
-- cel.image:drawPixel(1,0,app.pixelColor.rgba(255,0,0,255))
-- cel.image:drawPixel(1,2,app.pixelColor.rgba(255,0,0,255))
-- cel.image:drawPixel(2,0,app.pixelColor.rgba(255,0,0,255))
-- cel.image:drawPixel(2,1,app.pixelColor.rgba(255,0,0,255))
-- cel.image:drawPixel(2,2,app.pixelColor.rgba(255,0,0,255))
-- print(cel.image.width..cel.image.height)
print(cel.image.width..cel.image.height)
-- local newImage = Image(64,64)
-- local point = Point(0,0)
-- newImage:drawImage(cel.image,point)
-- cel.image = newImage
-- print(cel.image.width..cel.image.height)
-- cel.image:resize({size=Size(64,64),method="bilinear",pivot=Point(0,0)})
-- print(cel.image.width..cel.image.height)
print(cel.image.width..cel.image.height)

app.refresh()




