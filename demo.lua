
-- 获取当前活动精灵
local sprite = app.activeSprite

-- 检查是否有活动精灵
if not sprite then
  app.alert("没有打开的精灵。")
  return
end

-- 获取当前活动帧
local frame = app.frame

-- 检查是否有活动帧
if not frame then
  app.alert("当前精灵没有帧。")
  return
end

-- 获取当前活动图层
local layer = app.layer

-- 检查是否有活动图层
if not layer then
  app.alert("当前精灵没有图层。")
  return
end

-- 获取当前活动图像
local image = layer.cels[1].image

-- 检查是否有活动图像
if not image then
  app.alert("当前图层没有图像。")
  return
end

-- 定义要设置的像素坐标 (例如，x=10, y=20)
local pixel_x = 10
local pixel_y = 20

-- 定义要设置的颜色 (RGBA 格式，范围 0-255)
local red = 255   -- 红色
local green = 0     -- 绿色
local blue = 0      -- 蓝色
local alpha = 255   -- 透明度 (255 为完全不透明)

-- 创建颜色对象
local color = Color(red, green, blue, alpha)

-- 设置像素颜色
image:putPixel(pixel_x, pixel_y, color)

-- 可选: 更新精灵的显示 (如果需要立即看到效果)
app.refresh()