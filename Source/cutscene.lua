-- ============================================================
--  Cutscene / dialogue system (portrait + name plate + typewriter)
--  Cut.start({ {who="RYE", port="rye", txt="..."}, ... })
--  Cut.update() -> true when the whole scene is done.
-- ============================================================
import "portraits"
local gfx <const> = playdate.graphics
local SW <const>, SH <const> = 400, 240

Cut = {}
local lines, idx, shown, charT, done

local function wrap(text, width)
  local out, line = {}, ""
  for word in string.gmatch(text, "%S+") do
    local test = (line == "") and word or (line .. " " .. word)
    if gfx.getTextSize(test) > width and line ~= "" then out[#out + 1] = line; line = word
    else line = test end
  end
  if line ~= "" then out[#out + 1] = line end
  return out
end

function Cut.start(l)
  lines = l; idx = 1; shown = 0; charT = 0; done = false
end

function Cut.active() return lines ~= nil and not done end

function Cut.update()
  if not lines then return true end
  local DT <const> = 1 / 30
  local cur = lines[idx]
  local full = cur.txt
  -- typewriter
  charT = charT + DT
  if charT > 0.018 then shown = math.min(#full, shown + 1); charT = 0 end

  if playdate.buttonJustPressed(playdate.kButtonA) then
    if shown < #full then shown = #full
    else
      idx = idx + 1; shown = 0
      if idx > #lines then done = true; lines = nil; return true end
    end
  end
  if playdate.buttonJustPressed(playdate.kButtonB) then done = true; lines = nil; return true end

  -- draw scene
  gfx.clear(gfx.kColorBlack)
  -- portrait (large, left) — bobs while the character is "talking"
  local talking = shown < #full
  local bob = talking and math.floor(math.sin(playdate.getCurrentTimeMilliseconds() / 90) * 2) or 0
  Portraits.draw(cur.port or "rye", 16, 24 + bob, 150, 150)
  -- speaker name plate (right of portrait, above box)
  gfx.setColor(gfx.kColorWhite); gfx.setLineWidth(2)
  local nm = cur.who or ""
  local nw = gfx.getTextSize(nm)
  gfx.fillRect(SW - nw - 28, 150, nw + 18, 22)
  gfx.setImageDrawMode(gfx.kDrawModeFillBlack)
  gfx.drawText(nm, SW - nw - 19, 153)
  gfx.setImageDrawMode(gfx.kDrawModeCopy)
  -- dialogue box
  gfx.setColor(gfx.kColorBlack); gfx.fillRect(8, 176, SW - 16, 58)
  gfx.setColor(gfx.kColorWhite); gfx.drawRect(8, 176, SW - 16, 58)
  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  local txt = string.sub(full, 1, shown)
  local rows = wrap(txt, SW - 36)
  for i = 1, math.min(3, #rows) do gfx.drawText(rows[i], 18, 182 + (i - 1) * 17) end
  -- advance prompt
  if shown >= #full and (math.floor(playdate.getCurrentTimeMilliseconds() / 350) % 2 == 0) then
    gfx.drawText("A", SW - 26, 214)
  end
  gfx.setImageDrawMode(gfx.kDrawModeCopy)
  return false
end
