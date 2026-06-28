-- ============================================================
--  Shared animated 1-bit studio intro ("we really made it")
--  Usage in main.lua:
--     import "intro"
--     Intro.name = "NIKOLAI GAMES"     -- optional
--     Intro.tagline = "we really made it"
--     Intro.reset()
--     ...in update while state=="intro":  if Intro.update() then state="title" end
-- ============================================================
local gfx <const> = playdate.graphics
local SW <const>, SH <const> = 400, 240
local CX <const>, CY <const> = 200, 120

Intro = {}
Intro.name = "NIKOLAI GAMES"
Intro.tagline = "we really made it"

local t, parts, done, started

function Intro.reset()
  t = 0; done = false; started = false
  parts = {}
end

local function burst(n)
  for i = 1, n do
    local a = math.random() * math.pi * 2
    local sp = 60 + math.random() * 160
    parts[#parts + 1] = { x = CX, y = CY + 18, vx = math.cos(a) * sp, vy = math.sin(a) * sp - 40, life = 0.7 + math.random() * 0.5 }
  end
end

function Intro.update()
  if not started then Intro.reset(); started = true end
  local DT <const> = 1 / 30
  t = t + DT
  if playdate.buttonJustPressed(playdate.kButtonA) or playdate.buttonJustPressed(playdate.kButtonB) then
    t = math.max(t, 2.9)
  end

  gfx.clear(gfx.kColorBlack)
  gfx.setColor(gfx.kColorWhite)

  -- drifting starfield
  for i = 1, 40 do
    local sx = (i * 97 + math.floor(t * 30)) % SW
    local sy = (i * 53) % SH
    gfx.fillRect(sx, sy, 1, 1)
  end

  -- studio name slides in + settle (phase 0..1.0s)
  local slide = math.min(1, t / 0.8)
  local ease = 1 - (1 - slide) * (1 - slide)
  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  local nw, nh = gfx.getTextSize(Intro.name)
  local nx = -nw + (CX - nw / 2 + nw) * ease
  local ny = CY - 26
  gfx.drawText(Intro.name, nx, ny)
  gfx.setImageDrawMode(gfx.kDrawModeCopy)

  -- underline sweep
  if t > 0.8 then
    local sw = math.min(1, (t - 0.8) / 0.5)
    gfx.setColor(gfx.kColorWhite); gfx.setLineWidth(2)
    gfx.drawLine(CX - nw / 2, ny + nh + 2, CX - nw / 2 + nw * sw, ny + nh + 2)
    -- spark on the sweep tip
    if sw < 1 then gfx.fillCircleAtPoint(CX - nw / 2 + nw * sw, ny + nh + 2, 3) end
    if sw >= 1 and #parts == 0 and t < 1.6 then burst(26) end
  end

  -- tagline typed in (phase ~1.4..2.4s)
  if t > 1.4 then
    local frac = math.min(1, (t - 1.4) / 1.0)
    local n = math.floor(#Intro.tagline * frac)
    local shown = string.sub(Intro.tagline, 1, n)
    gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    local tw = gfx.getTextSize(Intro.tagline)
    gfx.drawText(shown, CX - tw / 2, CY + 8)
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
  end

  -- particles
  gfx.setColor(gfx.kColorWhite)
  for i = #parts, 1, -1 do
    local p = parts[i]
    p.vy = p.vy + 200 * DT
    p.x = p.x + p.vx * DT; p.y = p.y + p.vy * DT; p.life = p.life - DT
    if p.life <= 0 then table.remove(parts, i) else gfx.fillRect(p.x, p.y, 2, 2) end
  end

  -- white wipe out (phase 2.5..2.9s)
  if t > 2.5 then
    local w = (t - 2.5) / 0.4
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, SW * math.min(1, w), SH)
  end

  if t < 1.0 then
    gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    gfx.drawText("(A) skip", SW - 70, SH - 20)
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
  end

  if t >= 2.9 then done = true end
  return done
end
