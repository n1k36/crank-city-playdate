-- ============================================================
--  Character portraits for cutscenes (1-bit, code-drawn).
--  If Source/art/<id>.png exists it is used instead (drop your
--  anime art there later — e.g. art/rye.png).
-- ============================================================
local gfx <const> = playdate.graphics
Portraits = {}
local cache = {}

local function tryImage(id)
  if cache[id] ~= nil then return cache[id] or nil end
  local img = gfx.image.new("art/" .. id)   -- looks for art/<id>.png
  cache[id] = img or false
  return img
end

-- id params: hair style, scar, accessory
local DEF = {
  rye    = { hair = "undercut", scar = true,  acc = "toothpick", jaw = 1 },
  viktor = { hair = "bald",     scar = false, acc = "cigar",     jaw = 2 },
  elena  = { hair = "bun",      scar = false, acc = "none",      jaw = 0 },
  mara   = { hair = "short",    scar = false, acc = "none",      jaw = 0 },
  nyx    = { hair = "long",     scar = false, acc = "shades",    jaw = 0 },
}

-- draw a stylized bust inside box (x,y,w,h)
function Portraits.draw(id, x, y, w, h)
  local img = tryImage(id)
  if img then
    local iw, ih = img:getSize()
    img:draw(x + (w - iw) // 2, y + (h - ih) // 2)
    return
  end
  local p = DEF[id] or DEF.rye
  gfx.setColor(gfx.kColorWhite); gfx.setLineWidth(2)
  -- screentone background panel
  gfx.setPattern({ 0x88, 0x22, 0x88, 0x22, 0x88, 0x22, 0x88, 0x22 })
  gfx.fillRect(x, y, w, h)
  gfx.setColor(gfx.kColorWhite); gfx.drawRect(x, y, w, h)
  local cx = x + w / 2
  local headY = y + h * 0.42
  local hw, hh = w * 0.30, h * 0.30
  -- shoulders / jacket collar
  gfx.setColor(gfx.kColorBlack); gfx.fillRect(x + 2, y + h * 0.66, w - 4, h * 0.34)
  gfx.setColor(gfx.kColorWhite); gfx.setLineWidth(2)
  gfx.drawLine(cx - hw, y + h * 0.70, cx - hw * 0.2, y + h * 0.80)
  gfx.drawLine(cx + hw, y + h * 0.70, cx + hw * 0.2, y + h * 0.80)
  -- neck
  gfx.setColor(gfx.kColorWhite); gfx.fillRect(cx - hw * 0.3, headY + hh * 0.7, hw * 0.6, hh * 0.5)
  -- head
  gfx.setColor(gfx.kColorWhite); gfx.fillEllipseInRect(cx - hw, headY - hh, hw * 2, hh * 2)
  -- hair
  gfx.setColor(gfx.kColorBlack)
  if p.hair == "undercut" then
    gfx.fillRect(cx - hw, headY - hh, hw * 2, hh * 0.7)
    gfx.fillTriangle(cx - hw, headY - hh * 0.4, cx + hw, headY - hh, cx + hw, headY - hh * 0.2)
  elseif p.hair == "bald" then
    -- none
  elseif p.hair == "bun" then
    gfx.fillEllipseInRect(cx - hw, headY - hh - hh*0.3, hw * 2, hh * 0.9)
    gfx.fillCircleAtPoint(cx, headY - hh * 1.3, hw * 0.4)
  elseif p.hair == "long" then
    gfx.fillRect(cx - hw - 2, headY - hh, 6, hh * 2.0)
    gfx.fillRect(cx + hw - 4, headY - hh, 6, hh * 2.0)
    gfx.fillRect(cx - hw, headY - hh, hw * 2, hh * 0.6)
  else
    gfx.fillRect(cx - hw, headY - hh, hw * 2, hh * 0.55)
  end
  -- eyes (sharp)
  gfx.setColor(gfx.kColorBlack)
  gfx.fillRect(cx - hw * 0.55, headY - 2, hw * 0.35, 3)
  gfx.fillRect(cx + hw * 0.2, headY - 2, hw * 0.35, 3)
  -- brow / scar
  gfx.setLineWidth(2)
  gfx.drawLine(cx - hw * 0.6, headY - 8, cx - hw * 0.2, headY - 6)
  gfx.drawLine(cx + hw * 0.2, headY - 6, cx + hw * 0.6, headY - 8)
  if p.scar then gfx.drawLine(cx + hw * 0.5, headY - 14, cx + hw * 0.35, headY + 2) end
  -- mouth / accessory
  gfx.drawLine(cx - hw * 0.25, headY + hh * 0.55, cx + hw * 0.25, headY + hh * 0.55)
  if p.acc == "toothpick" then gfx.drawLine(cx + hw * 0.15, headY + hh * 0.55, cx + hw * 0.7, headY + hh * 0.45) end
  if p.acc == "cigar" then gfx.setColor(gfx.kColorWhite); gfx.fillRect(cx + hw*0.2, headY + hh*0.5, hw*0.6, 3) end
  if p.acc == "shades" then gfx.setColor(gfx.kColorBlack); gfx.fillRect(cx - hw*0.6, headY - 5, hw*1.2, 6) end
  gfx.setColor(gfx.kColorWhite); gfx.setLineWidth(1)
end
