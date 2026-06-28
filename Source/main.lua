-- ============================================================
--  CRANK CITY — story-driven 1-bit crime game (Playdate)
--  One game, four mission modes tied by cutscenes:
--    drive / foot / port / sonar / safe / chase
--  Crank = car throttle, safe dial, and sonar beam.
--  Main character: RYE. Cutscene portraits in art/ (swap in anime).
-- ============================================================
import "CoreLibs/graphics"
import "intro"
import "cutscene"
import "missions"

local gfx <const> = playdate.graphics
local SW <const>, SH <const> = 400, 240
local CXs <const>, CYs <const> = 200, 120
local CELL <const> = 64

playdate.display.setRefreshRate(30)
math.randomseed(playdate.getSecondsSinceEpoch())
Intro.name = "NIKOLAI GAMES"; Intro.tagline = "we really made it"

local save = playdate.datastore.read() or {}
local progress = save.crankcity or 0          -- highest mission unlocked
local ledger = save.ledger or 0
local cash = save.cash or 0
local upg = save.upg or { engine = 0, tools = 0, tank = 0, nerve = 0 }
local UPGDEF = {
  { key = "engine", name = "ENGINE  (faster car)" },
  { key = "tools",  name = "TOOLS   (easier safes)" },
  { key = "tank",   name = "O2 TANK (more air)" },
  { key = "nerve",  name = "NERVE   (survive heat)" },
}
local hubSel = 1

local state = "intro"        -- intro|title|pre|play|post|fail|ending
local mi, m                  -- mission index, current mission
local DT <const> = 1 / 30
local msg, msgT = "", 0

-- shared world (top-down)
local px, py, pheading, veh, cv, chd
local dest, packages, got, needN, cops, catchT, traffic, heat, heatT
-- sonar
local depth, oxygen, hull, beamAng, haz, sNeed, sGot, nextSpawn
-- safe
local sdial, scombo, sstep, sman, sdacc

local function flash(t) msg = t; msgT = 1.8 end
local function circd(a, b) local d = math.abs(a - b) % 100; return math.min(d, 100 - d) end
local function persist() playdate.datastore.write({ crankcity = progress, ledger = ledger, cash = cash, upg = upg }) end

-- forward declarations (defined later, used in beginPlay)
local buildingAt, snapRoad, roadPoint

-- ---------- mode setup ----------
local function startMission(i)
  mi = i; m = MISSIONS[i]
  if not m then state = "ending"; return end
  state = "pre"; Cut.start(m.pre or {})
end

local function beginPlay()
  local t = m.type
  px, py, pheading = 0, 0, 0
  veh = (t == "drive" or t == "chase"); cv = 0; chd = 0
  packages, got, cops, catchT = {}, 0, {}, 0
  traffic = {}; heat = 1; heatT = 0
  if veh then for k = 1, 7 do
    local x, y = roadPoint(); local hor = math.random() < 0.5
    traffic[k] = { x = x, y = y, vx = hor and (math.random(-1,1) ~= 0 and 70 or -70) or 0, vy = hor and 0 or (math.random() < 0.5 and 70 or -70) }
  end end
  if t == "drive" then local dx, dy = snapRoad(m.dest.x, m.dest.y); dest = { x = dx, y = dy }
  elseif t == "chase" then local dx, dy = snapRoad(-480, 460); dest = { x = dx, y = dy }
    for k = 1, 4 do local a = k * 1.6; cops[k] = { x = math.cos(a) * 300, y = math.sin(a) * 300 } end
  elseif t == "foot" or t == "port" then
    needN = m.collect or 3
    for k = 1, needN do local x, y; repeat x, y = roadPoint() until (x * x + y * y) > 120 * 120; packages[k] = { x = x, y = y, got = false } end
    if t == "port" then for k = 1, 3 do cops[k] = { x = math.random(-220, 220), y = math.random(-220, 220) } end end
  elseif t == "sonar" then
    depth, hull, beamAng = 0, 3, 0; oxygen = 100 + upg.tank * 25; haz = {}; sNeed = m.collect or 3; sGot = 0; nextSpawn = 80; px = 200
  elseif t == "safe" then
    scombo = {}; for k = 1, 3 do scombo[k] = math.random(0, 99) end; sstep = 1; sman = scombo[1]; sdacc = 0; sdial = scombo[1]
  end
  flash(({drive="DRIVE TO THE MARKER", chase="ESCAPE TO THE HIDEOUT (H)", foot="COLLECT THE PACKAGES",
          port="GRAB ALL CRATES ON THE DOCKS", sonar="DIVE - RECOVER THE CRATES", safe="CRACK THE SAFE"})[t] or "GO")
  state = "play"
end

local function finishMission()
  if m.ledger then ledger = ledger + 1 end
  cash = cash + 180 + mi * 40
  if mi >= progress then progress = mi + 1 end
  persist()
  state = "post"; Cut.start(m.post or {})
end

-- ---------- world helpers ----------
local function w2s(wx, wy) return CXs + (wx - px), CYs + (wy - py) end

function buildingAt(wx, wy)
  local gx = math.floor(wx / CELL); local gy = math.floor(wy / CELL)
  return (gx % 3 ~= 0) and (gy % 3 ~= 0)
end
function snapRoad(wx, wy)
  local gx = math.floor(wx / CELL); local gy = math.floor(wy / CELL)
  if (gx % 3 == 0) or (gy % 3 == 0) then return wx, wy end
  local nvx = math.floor(gx / 3 + 0.5) * 3
  local nhy = math.floor(gy / 3 + 0.5) * 3
  if math.abs(nvx - gx) <= math.abs(nhy - gy) then return nvx * CELL + CELL / 2, wy
  else return wx, nhy * CELL + CELL / 2 end
end
function roadPoint()
  if math.random() < 0.5 then
    return (math.random(-6, 6) * 3) * CELL + CELL / 2, math.random(-7, 7) * CELL + CELL / 2
  else
    return math.random(-7, 7) * CELL + CELL / 2, (math.random(-6, 6) * 3) * CELL + CELL / 2
  end
end

local function drawCity()
  local ccx, ccy = math.floor(px / CELL), math.floor(py / CELL)
  gfx.setColor(gfx.kColorWhite)
  for gx = ccx - 4, ccx + 4 do for gy = ccy - 3, ccy + 3 do
    if (gx % 3 ~= 0) and (gy % 3 ~= 0) then
      local bx, by = w2s(gx * CELL + 4, gy * CELL + 4)
      gfx.setLineWidth(1); gfx.drawRect(bx, by, CELL - 8, CELL - 8)
    end
  end end
end

local function drawMarker(wx, wy, ch)
  local mx, my = w2s(wx, wy)
  if mx < 8 or mx > SW - 8 or my < 8 or my > SH - 8 then
    local ang = math.atan(my - CYs, mx - CXs)
    mx = CXs + math.cos(ang) * 150; my = CYs + math.sin(ang) * 100
    gfx.setColor(gfx.kColorWhite); gfx.fillCircleAtPoint(mx, my, 9)
    gfx.setImageDrawMode(gfx.kDrawModeFillBlack); gfx.drawText(ch, mx - 3, my - 8); gfx.setImageDrawMode(gfx.kDrawModeCopy)
  else
    gfx.setColor(gfx.kColorWhite); gfx.drawCircleAtPoint(mx, my, 14)
    gfx.setImageDrawMode(gfx.kDrawModeFillWhite); gfx.drawText(ch, mx - 3, my - 8); gfx.setImageDrawMode(gfx.kDrawModeCopy)
  end
end

local function drawPlayer()
  gfx.setColor(gfx.kColorWhite)
  if veh then
    gfx.fillRect(CXs - 12, CYs - 7, 24, 14)
    gfx.setColor(gfx.kColorBlack); gfx.fillRect(CXs + math.cos(chd) * 8 - 2, CYs + math.sin(chd) * 8 - 2, 4, 4)
  else
    gfx.fillCircleAtPoint(CXs, CYs, 8)
    gfx.setColor(gfx.kColorBlack); gfx.fillRect(CXs - 3, CYs - 2, 2, 2); gfx.fillRect(CXs + 1, CYs - 2, 2, 2)
  end
  gfx.setColor(gfx.kColorWhite)
end

-- ---------- mode updates (return 'run'/'done'/'fail') ----------
local function updWorld()
  if veh then
    local thr = 0
    if playdate.buttonIsPressed(playdate.kButtonUp) then thr = 1 end
    if playdate.buttonIsPressed(playdate.kButtonDown) then thr = -0.6 end
    local ck = playdate.isCrankDocked() and 0 or (playdate.getCrankChange() * 0.05)
    if ck > 0 then thr = math.max(thr, math.min(1, ck)) end
    if playdate.buttonIsPressed(playdate.kButtonLeft) then chd = chd - 2.6 * DT end
    if playdate.buttonIsPressed(playdate.kButtonRight) then chd = chd + 2.6 * DT end
    cv = (cv + thr * 360 * DT) * 0.96; cv = math.max(-120, math.min(240 + upg.engine * 30, cv))
    local nx = px + math.cos(chd) * cv * DT
    local ny = py + math.sin(chd) * cv * DT
    if buildingAt(nx, py) then nx = px; cv = cv * 0.25 end
    if buildingAt(px, ny) then ny = py; cv = cv * 0.25 end
    px, py = nx, ny
  else
    local mx, my = 0, 0
    if playdate.buttonIsPressed(playdate.kButtonLeft) then mx = -1 end
    if playdate.buttonIsPressed(playdate.kButtonRight) then mx = 1 end
    if playdate.buttonIsPressed(playdate.kButtonUp) then my = -1 end
    if playdate.buttonIsPressed(playdate.kButtonDown) then my = 1 end
    local nx = px + mx * 100 * DT
    local ny = py + my * 100 * DT
    if not buildingAt(nx, py) then px = nx end
    if not buildingAt(px, ny) then py = ny end
  end

  -- civilian traffic (drive/chase)
  for _, car in ipairs(traffic) do
    car.x = car.x + car.vx * DT; car.y = car.y + car.vy * DT
    if (car.x - px) ^ 2 + (car.y - py) ^ 2 > 520 * 520 then local x, y = roadPoint(); car.x = px + (x % 400) - 200; car.y = py + (y % 400) - 200 end
    if veh and (car.x - px) ^ 2 + (car.y - py) ^ 2 < 20 ^ 2 then cv = cv * 0.2; flash("WATCH IT!") end
  end

  local t = m.type
  if t == "drive" then
    if (px - dest.x) ^ 2 + (py - dest.y) ^ 2 < 40 ^ 2 then return "done" end
  elseif t == "chase" then
    heatT = heatT + DT
    if heatT > 6 and heat < 6 then heat = heat + 1; heatT = 0
      local a = math.random() * 6.28; cops[#cops + 1] = { x = px + math.cos(a) * 320, y = py + math.sin(a) * 320 } end
    local spd = 140 + heat * 9
    for _, c in ipairs(cops) do
      local dx, dy = px - c.x, py - c.y; local d = math.sqrt(dx * dx + dy * dy)
      if d > 1 then c.x = c.x + dx / d * spd * DT; c.y = c.y + dy / d * spd * DT end
      if d < 22 then catchT = catchT + DT else catchT = math.max(0, catchT - DT * 0.5) end
    end
    if catchT > 2.4 + upg.nerve * 0.6 then return "fail" end
    if (px - dest.x) ^ 2 + (py - dest.y) ^ 2 < 44 ^ 2 then return "done" end
  elseif t == "foot" or t == "port" then
    for _, p in ipairs(packages) do
      if not p.got and (px - p.x) ^ 2 + (py - p.y) ^ 2 < 18 ^ 2 then p.got = true; got = got + 1; flash("CRATE " .. got .. "/" .. needN) end
    end
    if t == "port" then
      for _, c in ipairs(cops) do
        local dx, dy = px - c.x, py - c.y; local d = math.sqrt(dx * dx + dy * dy)
        if d > 1 then c.x = c.x + dx / d * 62 * DT; c.y = c.y + dy / d * 62 * DT end
        if d < 18 then catchT = catchT + DT else catchT = math.max(0, catchT - DT * 0.4) end
      end
      if catchT > 0.5 then flash("PATROL ON YOU!") end
      if catchT > 2.0 + upg.nerve * 0.5 then return "fail" end
    end
    if got >= needN then return "done" end
  end
  return "run"
end

local function drawWorldMode()
  gfx.clear(gfx.kColorBlack)
  drawCity()
  local t = m.type
  if t == "drive" then drawMarker(dest.x, dest.y, "!")
  elseif t == "chase" then drawMarker(dest.x, dest.y, "H")
  elseif t == "foot" or t == "port" then
    local nb, nd
    for _, p in ipairs(packages) do if not p.got then
      local sx, sy = w2s(p.x, p.y); gfx.setColor(gfx.kColorWhite); gfx.fillRect(sx-5, sy-4, 10, 8); gfx.setColor(gfx.kColorBlack); gfx.drawRect(sx-5, sy-4, 10, 8); gfx.setColor(gfx.kColorWhite)
      local dd = (p.x-px)^2 + (p.y-py)^2; if not nd or dd < nd then nd = dd; nb = p end
    end end
    if nb then drawMarker(nb.x, nb.y, "#") end
  end
  for _, car in ipairs(traffic) do local sx, sy = w2s(car.x, car.y)
    if sx > -20 and sx < SW + 20 and sy > -20 and sy < SH + 20 then gfx.setColor(gfx.kColorWhite); gfx.drawRect(sx - 9, sy - 5, 18, 10) end end
  for _, c in ipairs(cops) do local sx, sy = w2s(c.x, c.y); gfx.setColor(gfx.kColorWhite); gfx.fillCircleAtPoint(sx, sy, 7); gfx.setColor(gfx.kColorBlack); gfx.fillCircleAtPoint(sx, sy, 3); gfx.setColor(gfx.kColorWhite) end
  drawPlayer()
  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  gfx.drawText("$" .. cash, 6, 6)
  if t == "foot" or t == "port" then gfx.drawText("CRATES " .. got .. "/" .. needN, 6, 22) end
  if t == "chase" then gfx.drawText("WANTED " .. string.rep("*", heat), SW - 130, 6) end
  if (t == "chase" or t == "port") and catchT > 0 then gfx.drawText("!! THEY'VE GOT YOU !!", CXs - 70, 24) end
  if msgT > 0 then local w = gfx.getTextSize(msg); gfx.drawText(msg, CXs - w / 2, SH - 22) end
  gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

-- sonar mode
local function updSonar()
  if playdate.buttonIsPressed(playdate.kButtonLeft) then px = px - 130 * DT end
  if playdate.buttonIsPressed(playdate.kButtonRight) then px = px + 130 * DT end
  px = math.max(16, math.min(SW - 16, px))
  local vs = 40; if playdate.buttonIsPressed(playdate.kButtonDown) then vs = 95 elseif playdate.buttonIsPressed(playdate.kButtonUp) then vs = 16 end
  depth = depth + vs * DT
  beamAng = playdate.isCrankDocked() and (beamAng + 90 * DT) % 360 or playdate.getCrankPosition()
  oxygen = oxygen - 3 * DT; if oxygen <= 0 then return "fail" end
  nextSpawn = nextSpawn - vs * DT
  if nextSpawn <= 0 then
    local r = math.random(); local ty = (sGot < sNeed and r < 0.34) and "loot" or (r < 0.5 and "air" or (r < 0.78 and "rock" or "mine"))
    haz[#haz + 1] = { x = 24 + math.random() * (SW - 48), wy = depth + 250, t = ty, rad = ty == "rock" and 16 or 9 }
    nextSpawn = 80 + math.random() * 70
  end
  for i = #haz, 1, -1 do
    local h = haz[i]; local hy = 96 + (h.wy - depth)
    if hy > SH + 40 then table.remove(haz, i)
    elseif (h.x - px) ^ 2 + (hy - 96) ^ 2 < (h.rad + 8) ^ 2 then
      if h.t == "air" then oxygen = math.min(100, oxygen + 28); table.remove(haz, i)
      elseif h.t == "loot" then sGot = sGot + 1; flash("CRATE " .. sGot .. "/" .. sNeed); table.remove(haz, i)
      else hull = hull - 1; table.remove(haz, i); if hull <= 0 then return "fail" end end
    end
  end
  if sGot >= sNeed then return "done" end
  return "run"
end

local function litSonar(hx, hy)
  local dx, dy = hx - px, hy - 96; local dist = math.sqrt(dx * dx + dy * dy)
  if dist < 42 then return true end
  if dist > 170 then return false end
  local a = math.rad(beamAng); return (dx / dist * math.sin(a) + dy / dist * -math.cos(a)) > math.cos(math.rad(34))
end

local function drawSonar()
  gfx.clear(gfx.kColorBlack); gfx.setColor(gfx.kColorWhite); gfx.setLineWidth(1)
  local a = math.rad(beamAng)
  for s = -1, 1, 2 do local e = a + s * math.rad(34); gfx.drawLine(px, 96, px + math.sin(e) * 170, 96 - math.cos(e) * 170) end
  for _, h in ipairs(haz) do local hy = 96 + (h.wy - depth)
    if hy > -20 and hy < SH + 20 and litSonar(h.x, hy) then
      if h.t == "rock" then gfx.fillCircleAtPoint(h.x, hy, h.rad)
      elseif h.t == "mine" then gfx.drawCircleAtPoint(h.x, hy, h.rad)
      elseif h.t == "air" then gfx.drawCircleAtPoint(h.x, hy, 7)
      else gfx.fillRect(h.x - 7, hy - 5, 14, 10) end
    end
  end
  gfx.fillRect(px - 12, 96 - 7, 24, 14); gfx.drawCircleAtPoint(px, 96, 42)
  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  gfx.drawText("CRATES " .. sGot .. "/" .. sNeed, 6, 6)
  gfx.drawText("HULL " .. string.rep("#", math.max(0, hull)), 6, SH - 20)
  gfx.setImageDrawMode(gfx.kDrawModeCopy)
  gfx.drawRect(SW - 110, 8, 100, 10); gfx.fillRect(SW - 110, 8, math.max(0, oxygen), 10)
end

-- safe mode
local function updSafe()
  local change = 0
  if playdate.isCrankDocked() then
    if playdate.buttonJustPressed(playdate.kButtonRight) then sman = (sman + 1) % 100; change = 3.6 end
    if playdate.buttonJustPressed(playdate.kButtonLeft) then sman = (sman - 1) % 100; change = -3.6 end
    sdial = sman
  else change = playdate.getCrankChange(); sdial = math.floor(playdate.getCrankPosition() / 3.6) % 100 end
  sdacc = sdacc + change
  local dir = sdacc > 6 and 1 or (sdacc < -6 and -1 or 0)
  if playdate.buttonJustPressed(playdate.kButtonA) then
    local need = (sstep % 2 == 1) and 1 or -1
    if circd(sdial, scombo[sstep]) <= 2 + upg.tools and dir == need then
      sstep = sstep + 1; sdacc = 0; flash("CLICK!")
      if sstep > #scombo then return "done" end
    else sdacc = 0; flash("clunk!") end
  end
  return "run"
end

local function drawSafe()
  gfx.clear(gfx.kColorBlack)
  local DCX, DCY, DR = 120, 120, 80
  gfx.setColor(gfx.kColorWhite); gfx.setLineWidth(2); gfx.drawCircleAtPoint(DCX, DCY, DR)
  for i = 0, 99 do local a = i / 100 * math.pi * 2 - math.pi / 2; local r2 = (i % 5 == 0) and DR - 14 or DR - 10
    gfx.drawLine(DCX + math.cos(a) * (DR - 4), DCY + math.sin(a) * (DR - 4), DCX + math.cos(a) * r2, DCY + math.sin(a) * r2) end
  gfx.fillTriangle(DCX - 5, DCY - DR - 2, DCX + 5, DCY - DR - 2, DCX, DCY - DR + 8)
  local pa = sdial / 100 * math.pi * 2 - math.pi / 2
  gfx.setLineWidth(3); gfx.drawLine(DCX, DCY, DCX + math.cos(pa) * (DR - 20), DCY + math.sin(pa) * (DR - 20))
  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  local ns = string.format("%02d", sdial); local w, h = gfx.getTextSize(ns); gfx.drawText(ns, DCX - w / 2, DCY - h / 2)
  gfx.drawText("CRACK THE SAFE", 232, 30)
  for i = 1, #scombo do local mk = (i < sstep) and "OK " or (i == sstep and "-> " or "   ")
    gfx.drawText(mk .. ((i % 2 == 1) and "R" or "L") .. " " .. ((i <= sstep) and string.format("%02d", scombo[i]) or "??"), 232, 54 + (i - 1) * 20) end
  local close = math.max(0, 1 - circd(sdial, scombo[sstep] or scombo[#scombo]) / 18)
  gfx.drawText(close > 0.85 and "FEEL: on it!" or (close > 0.5 and "FEEL: close" or "FEEL: ..."), 232, 132)
  if msgT > 0 then local ww = gfx.getTextSize(msg); gfx.drawText(msg, DCX - ww / 2, DCY + DR - 2) end
  gfx.setImageDrawMode(gfx.kDrawModeCopy)
  gfx.setColor(gfx.kColorWhite); gfx.setLineWidth(1); gfx.drawRect(232, 116, 150, 8); gfx.fillRect(232, 116, 150 * close, 8)
end

-- ---------- main loop ----------
function playdate.update()
  if msgT > 0 then msgT = msgT - DT end

  if state == "intro" then if Intro.update() then state = "title" end return end

  if state == "title" then
    gfx.clear(gfx.kColorBlack); gfx.setColor(gfx.kColorWhite)
    for i = 1, 40 do gfx.fillRect((i * 83) % SW, (i * 51) % SH, 1, 1) end
    cc("CRANK CITY", 40, 1)
    cc("a Meridian crime story", 66)
    cc(progress > 0 and ("Continue - Mission " .. math.min(progress + 1, #MISSIONS)) or "New game", 120)
    cc("Ledger fragments: " .. ledger .. "/3", 142)
    cc("A = start    B = restart story", 184)
    if playdate.buttonJustPressed(playdate.kButtonA) then startMission(math.min(progress + 1, #MISSIONS)) end
    if playdate.buttonJustPressed(playdate.kButtonB) then progress = 0; ledger = 0; persist(); startMission(1) end
    return
  end

  if state == "pre" then if Cut.update() then beginPlay() end return end
  if state == "post" then if Cut.update() then
      if m.ending then state = "ending" else hubSel = 1; state = "hub" end end return end

  if state == "hub" then
    gfx.clear(gfx.kColorBlack); gfx.setColor(gfx.kColorWhite)
    cc("HIDEOUT", 16, 1)
    cc("$" .. cash .. "    Ledger " .. ledger .. "/3", 40)
    if playdate.buttonJustPressed(playdate.kButtonDown) then hubSel = hubSel % 5 + 1 end
    if playdate.buttonJustPressed(playdate.kButtonUp) then hubSel = (hubSel - 2) % 5 + 1 end
    gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    for i, u in ipairs(UPGDEF) do
      local lvl = upg[u.key]; local cost = 150 * (lvl + 1)
      local y = 66 + (i - 1) * 26
      local sel = (hubSel == i)
      gfx.drawText((sel and "> " or "  ") .. u.name .. "  Lv" .. lvl .. (lvl >= 4 and " MAX" or ("  $" .. cost)), 40, y)
    end
    gfx.drawText((hubSel == 5 and "> " or "  ") .. "CONTINUE  ->  " .. (MISSIONS[mi + 1] and MISSIONS[mi + 1].title or ""), 40, 66 + 4 * 26)
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
    if playdate.buttonJustPressed(playdate.kButtonA) then
      if hubSel == 5 then startMission(mi + 1)
      else
        local u = UPGDEF[hubSel]; local lvl = upg[u.key]; local cost = 150 * (lvl + 1)
        if lvl < 4 and cash >= cost then cash = cash - cost; upg[u.key] = lvl + 1; persist() end
      end
    end
    return
  end

  if state == "ending" then
    gfx.clear(gfx.kColorBlack); gfx.setColor(gfx.kColorWhite)
    cc("THE LEDGER", 50, 1); cc("Meridian goes dark on Helix at dawn.", 90)
    cc("Fragments recovered: " .. ledger .. "/3", 120)
    cc("CRANK SERIES  Vol. 1", 150); cc("A = title", 190)
    if playdate.buttonJustPressed(playdate.kButtonA) then state = "title" end
    return
  end

  if state == "fail" then
    gfx.clear(gfx.kColorBlack); gfx.setColor(gfx.kColorWhite)
    cc("BUSTED", 70, 1); cc(m.title, 100); cc("A = retry   B = title", 140)
    if playdate.buttonJustPressed(playdate.kButtonA) then beginPlay()
    elseif playdate.buttonJustPressed(playdate.kButtonB) then state = "title" end
    return
  end

  -- PLAY
  local t = m.type
  local st
  if t == "sonar" then st = updSonar(); drawSonar()
  elseif t == "safe" then st = updSafe(); drawSafe()
  else st = updWorld(); drawWorldMode() end
  -- objective banner
  gfx.setImageDrawMode(gfx.kDrawModeFillWhite); gfx.drawText(m.title, SW - gfx.getTextSize(m.title) - 6, SH - 20); gfx.setImageDrawMode(gfx.kDrawModeCopy)
  if st == "done" then finishMission() elseif st == "fail" then state = "fail" end
end

function cc(s, y, big)
  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  local w = gfx.getTextSize(s); gfx.drawText(s, 200 - w / 2, y); gfx.setImageDrawMode(gfx.kDrawModeCopy)
end
