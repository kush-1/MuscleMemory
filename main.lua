-- ============================================================================
-- MUSCLE MEMORY: FIT HAPPENS - FINAL VERSION
-- A gamified fitness tracker for LOVE2D
-- Combines shape-based graphics with robust progression system
-- ============================================================================

-- ============================================================================
-- GLOBAL STATE & DATA
-- ============================================================================
local STATE = "START" -- START, PICK_PET, HUB, GYM, STATS, LOG, DUNGEON, BADGES, TRADING_CARD
local WINDOW_W, WINDOW_H = 480, 800

-- Player Data
local player = {
    animal = nil, -- "hyrax", "squirrel", "giant_ape", "lizard"
    name = "",
    level = 1,
    totalReps = 0,
    maxLift = 0,
    dungeonProgress = 1,
    health = 100,
    maxHealth = 100
}

-- Workout Log
local workoutLog = {}

-- Gym Input State
local gymWeight = 0
local gymReps = 0

-- Dungeon State
local dungeon = {
    currentStage = 1,
    bossHealth = 0,
    bossMaxHealth = 0,
    combat = false,
    combatTimer = 0,
    won = false,
    lost = false
}

-- Particles System
local particles = {}

-- Screen Shake
local shake = {
    timer = 0,
    intensity = 0,
    offsetX = 0,
    offsetY = 0
}

-- UI State
local nameInput = ""
local nameActive = false

-- Badge collection
local badges = {}

-- Animals Data with colors
local animals = {
    {id="hyrax", name="Hyrax", color={0.7, 0.6, 0.4}},
    {id="squirrel", name="Squirrel", color={0.8, 0.4, 0.2}},
    {id="giant_ape", name="Giant Ape", color={0.3, 0.25, 0.2}},
    {id="lizard", name="Lizard", color={0.3, 0.7, 0.3}}
}

-- Boss Data with names and characteristics
local bosses = {
    {name = "Iron Golem", level = 10, color = {0.5, 0.5, 0.5}},
    {name = "Shadow Beast", level = 20, color = {0.3, 0.2, 0.4}},
    {name = "Fire Dragon", level = 30, color = {0.9, 0.3, 0.1}},
    {name = "Thunder Titan", level = 40, color = {0.8, 0.8, 0.2}},
    {name = "Ice Colossus", level = 50, color = {0.4, 0.7, 0.9}},
    {name = "Ancient Wyrm", level = 60, color = {0.5, 0.8, 0.3}},
    {name = "Chaos Lord", level = 70, color = {0.7, 0.2, 0.7}},
    {name = "Void Emperor", level = 80, color = {0.1, 0.1, 0.2}},
    {name = "Ultimate Champion", level = 90, color = {1, 0.8, 0}},
    {name = "Eternal Overlord", level = 100, color = {0.9, 0.1, 0.1}}
}

-- ============================================================================
-- LOVE2D CALLBACKS
-- ============================================================================
function love.load()
    love.window.setMode(WINDOW_W, WINDOW_H, {resizable=false})
    love.window.setTitle("Muscle Memory: Fit Happens")
    love.graphics.setBackgroundColor(0.1, 0.1, 0.15)
    
    loadGame()
    
    if player.animal then
        STATE = "HUB"
    end
end

function love.update(dt)
    updateParticles(dt)
    updateShake(dt)
    
    if STATE == "DUNGEON" and dungeon.combat then
        updateDungeonCombat(dt)
    end
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(shake.offsetX, shake.offsetY)
    
    if STATE == "START" then
        drawStart()
    elseif STATE == "PICK_PET" then
        drawPickPet()
    elseif STATE == "HUB" then
        drawHub()
    elseif STATE == "GYM" then
        drawGym()
    elseif STATE == "STATS" then
        drawStats()
    elseif STATE == "LOG" then
        drawLog()
    elseif STATE == "DUNGEON" then
        drawDungeon()
    elseif STATE == "BADGES" then
        drawBadges()
    elseif STATE == "TRADING_CARD" then
        drawTradingCard()
    end
    
    drawParticles()
    
    love.graphics.pop()
end

function love.mousepressed(x, y, button)
    if button ~= 1 then return end
    
    if STATE == "START" then
        handleStartClick(x, y)
    elseif STATE == "PICK_PET" then
        handlePickPetClick(x, y)
    elseif STATE == "HUB" then
        handleHubClick(x, y)
    elseif STATE == "GYM" then
        handleGymClick(x, y)
    elseif STATE == "STATS" then
        handleStatsClick(x, y)
    elseif STATE == "LOG" then
        handleLogClick(x, y)
    elseif STATE == "DUNGEON" then
        handleDungeonClick(x, y)
    elseif STATE == "BADGES" then
        handleBadgesClick(x, y)
    elseif STATE == "TRADING_CARD" then
        handleTradingCardClick(x, y)
    end
end

function love.textinput(t)
    if nameActive then
        nameInput = nameInput .. t
    end
end

function love.keypressed(key)
    if nameActive and key == "backspace" then
        nameInput = nameInput:sub(1, -2)
    end
end

-- ============================================================================
-- ANIMAL DRAWING FUNCTIONS
-- ============================================================================
function drawHyrax(x, y, scale)
    scale = scale or 1
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.scale(scale, scale)
    
    -- Body
    love.graphics.ellipse("fill", 0, 10, 40, 35)
    -- Head
    love.graphics.ellipse("fill", 0, -20, 30, 28)
    -- Ears
    love.graphics.ellipse("fill", -20, -35, 8, 12)
    love.graphics.ellipse("fill", 20, -35, 8, 12)
    -- Eyes
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", -10, -22, 3)
    love.graphics.circle("fill", 10, -22, 3)
    -- Nose
    love.graphics.circle("fill", 0, -12, 4)
    
    love.graphics.pop()
end

function drawSquirrel(x, y, scale)
    scale = scale or 1
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.scale(scale, scale)
    
    local c = getAnimalColor("squirrel")
    love.graphics.setColor(c)
    -- Tail
    love.graphics.ellipse("fill", 25, -20, 20, 50)
    -- Body
    love.graphics.ellipse("fill", 0, 5, 35, 40)
    -- Head
    love.graphics.ellipse("fill", 0, -25, 25, 25)
    -- Ears
    love.graphics.ellipse("fill", -15, -40, 7, 12)
    love.graphics.ellipse("fill", 15, -40, 7, 12)
    -- Eyes
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", -8, -27, 3)
    love.graphics.circle("fill", 8, -27, 3)
    -- Nose
    love.graphics.circle("fill", 0, -18, 3)
    
    love.graphics.pop()
end

function drawGiantApe(x, y, scale)
    scale = scale or 1
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.scale(scale, scale)
    
    local c = getAnimalColor("giant_ape")
    love.graphics.setColor(c)
    -- Body
    love.graphics.ellipse("fill", 0, 15, 50, 45)
    -- Head
    love.graphics.ellipse("fill", 0, -20, 40, 38)
    -- Arms
    love.graphics.ellipse("fill", -45, 10, 15, 35)
    love.graphics.ellipse("fill", 45, 10, 15, 35)
    -- Face
    love.graphics.setColor(0.5, 0.4, 0.3)
    love.graphics.ellipse("fill", 0, -15, 30, 25)
    -- Eyes
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", -10, -22, 4)
    love.graphics.circle("fill", 10, -22, 4)
    -- Brow ridge
    love.graphics.setLineWidth(3)
    love.graphics.line(-20, -28, 20, -28)
    love.graphics.setLineWidth(1)
    
    love.graphics.pop()
end

function drawLizard(x, y, scale)
    scale = scale or 1
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.scale(scale, scale)
    
    local c = getAnimalColor("lizard")
    love.graphics.setColor(c)
    -- Body
    love.graphics.ellipse("fill", 0, 0, 45, 30)
    -- Head
    love.graphics.ellipse("fill", 30, -5, 25, 20)
    -- Tail
    love.graphics.polygon("fill", -40, -5, -50, 0, -40, 5)
    -- Spikes
    for i = -30, 20, 15 do
        love.graphics.polygon("fill", i - 3, -15, i, -25, i + 3, -15)
    end
    -- Eye
    love.graphics.setColor(1, 1, 0)
    love.graphics.circle("fill", 35, -8, 6)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", 35, -8, 3)
    
    love.graphics.pop()
end

function drawAnimal(animalId, x, y, scale)
    scale = scale or 1
    local c = getAnimalColor(animalId)
    love.graphics.setColor(c)
    
    if animalId == "hyrax" then
        drawHyrax(x, y, scale)
    elseif animalId == "squirrel" then
        drawSquirrel(x, y, scale)
    elseif animalId == "giant_ape" then
        drawGiantApe(x, y, scale)
    elseif animalId == "lizard" then
        drawLizard(x, y, scale)
    end
    
    love.graphics.setColor(1, 1, 1)
end

-- ============================================================================
-- BOSS DRAWING FUNCTIONS
-- ============================================================================
function drawBoss(x, y, boss, scale)
    scale = scale or 1
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.scale(scale, scale)
    
    love.graphics.setColor(boss.color)
    
    if boss.name == "Iron Golem" then
        love.graphics.rectangle("fill", -50, -40, 100, 120, 5)
        love.graphics.rectangle("fill", -70, 0, 30, 80)
        love.graphics.rectangle("fill", 40, 0, 30, 80)
        love.graphics.rectangle("fill", -40, -60, 80, 25, 5)
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("fill", -15, -45, 8)
        love.graphics.circle("fill", 15, -45, 8)
    elseif boss.name == "Shadow Beast" then
        love.graphics.ellipse("fill", 0, 0, 60, 50)
        love.graphics.ellipse("fill", 30, -20, 35, 30)
        love.graphics.polygon("fill", 10, -50, 20, -70, 30, -50)
        love.graphics.polygon("fill", 35, -50, 45, -70, 55, -50)
        love.graphics.setColor(0.8, 0, 0)
        love.graphics.circle("fill", 25, -25, 6)
        love.graphics.circle("fill", 45, -25, 6)
    elseif boss.name == "Fire Dragon" then
        love.graphics.ellipse("fill", 0, 0, 70, 55)
        love.graphics.ellipse("fill", 40, -15, 40, 35)
        love.graphics.polygon("fill", -60, -30, -30, -10, -20, 20)
        love.graphics.polygon("fill", 60, -30, 30, -10, 20, 20)
        love.graphics.polygon("fill", 30, -45, 35, -65, 40, -45)
        love.graphics.polygon("fill", 50, -45, 55, -65, 60, -45)
        love.graphics.setColor(1, 1, 0)
        love.graphics.circle("fill", 35, -20, 7)
        love.graphics.circle("fill", 55, -20, 7)
    elseif boss.name == "Thunder Titan" then
        love.graphics.ellipse("fill", 0, 10, 55, 70)
        love.graphics.ellipse("fill", 0, -40, 45, 40)
        love.graphics.rectangle("fill", -80, -20, 35, 100)
        love.graphics.rectangle("fill", 45, -20, 35, 100)
        love.graphics.setColor(1, 1, 0.5)
        love.graphics.polygon("fill", -10, -30, 0, -10, -5, -10, 5, 10)
        love.graphics.polygon("fill", 10, -30, 20, -10, 15, -10, 25, 10)
    elseif boss.name == "Ice Colossus" then
        love.graphics.ellipse("fill", 0, 15, 60, 75)
        love.graphics.ellipse("fill", 0, -45, 50, 45)
        love.graphics.rectangle("fill", -90, -10, 40, 90)
        love.graphics.rectangle("fill", 50, -10, 40, 90)
        love.graphics.setColor(0.7, 0.9, 1)
        for i = -30, 30, 20 do
            love.graphics.polygon("fill", i - 5, -20, i, -40, i + 5, -20)
        end
    elseif boss.name == "Ancient Wyrm" then
        for i = 0, 4 do
            local offsetY = math.sin(i * 0.5) * 15
            love.graphics.ellipse("fill", -40 + i * 20, offsetY, 25, 30)
        end
        love.graphics.ellipse("fill", 50, -10, 35, 30)
        love.graphics.setColor(1, 0.5, 0)
        love.graphics.circle("fill", 45, -15, 8)
        love.graphics.circle("fill", 65, -15, 8)
    elseif boss.name == "Chaos Lord" then
        love.graphics.ellipse("fill", 0, 0, 65, 80)
        love.graphics.ellipse("fill", 0, -50, 50, 45)
        love.graphics.polygon("fill", -30, -70, -20, -95, -10, -70)
        love.graphics.polygon("fill", 30, -70, 20, -95, 10, -70)
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("fill", -15, -55, 10)
        love.graphics.circle("fill", 15, -55, 10)
    elseif boss.name == "Void Emperor" then
        love.graphics.circle("fill", 0, 0, 70)
        love.graphics.setColor(0.3, 0.2, 0.5)
        for i = 0, 5 do
            local angle = i * math.pi / 3
            love.graphics.circle("fill", math.cos(angle) * 40, math.sin(angle) * 40, 15)
        end
        love.graphics.setColor(0.5, 0, 0.8)
        love.graphics.circle("fill", 0, -20, 25)
    elseif boss.name == "Ultimate Champion" then
        love.graphics.ellipse("fill", 0, 10, 60, 75)
        love.graphics.ellipse("fill", 0, -40, 45, 40)
        love.graphics.rectangle("fill", -30, -65, 60, 15)
        love.graphics.polygon("fill", -20, -65, -10, -85, 0, -65)
        love.graphics.polygon("fill", 0, -65, 10, -85, 20, -65)
        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.rectangle("fill", 60, -50, 10, 120)
        love.graphics.rectangle("fill", 45, -60, 40, 10)
    else -- Eternal Overlord
        love.graphics.ellipse("fill", 0, 0, 80, 90)
        love.graphics.ellipse("fill", 0, -55, 60, 50)
        love.graphics.ellipse("fill", -50, -40, 30, 35)
        love.graphics.ellipse("fill", 50, -40, 30, 35)
        love.graphics.setColor(1, 0.3, 0)
        for i = -3, 3 do
            love.graphics.polygon("fill", i * 20 - 5, 80, i * 20, 110, i * 20 + 5, 80)
        end
    end
    
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1)
end

function drawBadge(x, y, boss)
    if boss.name == "Iron Golem" then
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.circle("fill", x, y, 28)
        love.graphics.setColor(0.6, 0.6, 0.6)
        love.graphics.circle("fill", x, y, 23)
        for i = 0, 7 do
            local angle = i * math.pi / 4
            love.graphics.rectangle("fill", x + math.cos(angle) * 18 - 2, y + math.sin(angle) * 18 - 3, 4, 6)
        end
        love.graphics.setColor(0.4, 0.4, 0.4)
        love.graphics.circle("fill", x, y, 12)
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.circle("fill", x, y, 6)
    elseif boss.name == "Shadow Beast" then
        love.graphics.setColor(0.1, 0.1, 0.2)
        love.graphics.circle("fill", x, y, 28)
        love.graphics.setColor(0.3, 0.2, 0.4)
        love.graphics.circle("fill", x, y, 23)
        love.graphics.setColor(0.15, 0.1, 0.25)
        love.graphics.circle("fill", x, y + 5, 8)
        love.graphics.circle("fill", x - 6, y - 3, 5)
        love.graphics.circle("fill", x, y - 5, 5)
        love.graphics.circle("fill", x + 6, y - 3, 5)
    elseif boss.name == "Fire Dragon" then
        love.graphics.setColor(0.5, 0.1, 0.05)
        love.graphics.circle("fill", x, y, 28)
        love.graphics.setColor(0.9, 0.3, 0.1)
        love.graphics.circle("fill", x, y, 23)
        love.graphics.setColor(1, 0.6, 0.2)
        love.graphics.polygon("fill", x - 8, y + 10, x - 5, y - 5, x - 2, y + 8)
        love.graphics.polygon("fill", x - 2, y + 8, x, y - 8, x + 2, y + 8)
        love.graphics.polygon("fill", x + 2, y + 8, x + 5, y - 5, x + 8, y + 10)
        love.graphics.setColor(1, 0.9, 0.4)
        love.graphics.polygon("fill", x - 2, y + 5, x, y - 5, x + 2, y + 5)
    elseif boss.name == "Thunder Titan" then
        love.graphics.setColor(0.4, 0.4, 0.1)
        love.graphics.circle("fill", x, y, 28)
        love.graphics.setColor(0.8, 0.8, 0.2)
        love.graphics.circle("fill", x, y, 23)
        love.graphics.setColor(1, 1, 0.5)
        love.graphics.polygon("fill", x - 3, y - 15, x + 5, y - 2, x - 2, y - 2, x + 3, y + 15, x - 5, y + 2, x + 2, y + 2)
    elseif boss.name == "Ice Colossus" then
        love.graphics.setColor(0.2, 0.35, 0.45)
        love.graphics.circle("fill", x, y, 28)
        love.graphics.setColor(0.4, 0.7, 0.9)
        love.graphics.circle("fill", x, y, 23)
        love.graphics.setColor(0.7, 0.9, 1)
        for i = 0, 5 do
            local angle = i * math.pi / 3
            love.graphics.line(x, y, x + math.cos(angle) * 15, y + math.sin(angle) * 15)
            love.graphics.line(x + math.cos(angle) * 10, y + math.sin(angle) * 10, x + math.cos(angle + 0.5) * 13, y + math.sin(angle + 0.5) * 13)
            love.graphics.line(x + math.cos(angle) * 10, y + math.sin(angle) * 10, x + math.cos(angle - 0.5) * 13, y + math.sin(angle - 0.5) * 13)
        end
        love.graphics.circle("fill", x, y, 3)
    elseif boss.name == "Ancient Wyrm" then
        love.graphics.setColor(0.25, 0.4, 0.15)
        love.graphics.circle("fill", x, y, 28)
        love.graphics.setColor(0.5, 0.8, 0.3)
        love.graphics.circle("fill", x, y, 23)
        love.graphics.setColor(0.4, 0.7, 0.25)
        for row = -1, 1 do
            for col = -1, 1 do
                if (row + col) % 2 == 0 then
                    love.graphics.circle("fill", x + col * 8, y + row * 8, 5)
                end
            end
        end
    elseif boss.name == "Chaos Lord" then
        love.graphics.setColor(0.35, 0.1, 0.35)
        love.graphics.circle("fill", x, y, 28)
        love.graphics.setColor(0.7, 0.2, 0.7)
        love.graphics.circle("fill", x, y, 23)
        love.graphics.setColor(0.5, 0.15, 0.5)
        love.graphics.polygon("fill", x - 12, y, x - 8, y - 15, x - 4, y)
        love.graphics.polygon("fill", x + 12, y, x + 8, y - 15, x + 4, y)
        love.graphics.setColor(1, 0.2, 0.2)
        love.graphics.circle("fill", x - 5, y + 3, 3)
        love.graphics.circle("fill", x + 5, y + 3, 3)
    elseif boss.name == "Void Emperor" then
        love.graphics.setColor(0.05, 0.05, 0.1)
        love.graphics.circle("fill", x, y, 28)
        love.graphics.setColor(0.1, 0.1, 0.2)
        love.graphics.circle("fill", x, y, 23)
        love.graphics.setColor(0.4, 0.3, 0.6)
        for i = 0, 6 do
            local angle = i * math.pi * 2 / 7
            local dist = 12 + (i % 2) * 5
            love.graphics.circle("fill", x + math.cos(angle) * dist, y + math.sin(angle) * dist, 2)
        end
        love.graphics.setColor(0.3, 0.2, 0.5)
        love.graphics.circle("fill", x, y, 8)
    elseif boss.name == "Ultimate Champion" then
        love.graphics.setColor(0.6, 0.5, 0.1)
        love.graphics.circle("fill", x, y, 28)
        love.graphics.setColor(1, 0.8, 0)
        love.graphics.circle("fill", x, y, 23)
        love.graphics.setColor(1, 0.9, 0.2)
        love.graphics.rectangle("fill", x - 12, y + 5, 24, 6)
        love.graphics.polygon("fill", x - 12, y + 5, x - 8, y - 8, x - 4, y + 5)
        love.graphics.polygon("fill", x - 4, y + 5, x, y - 10, x + 4, y + 5)
        love.graphics.polygon("fill", x + 4, y + 5, x + 8, y - 8, x + 12, y + 5)
        love.graphics.setColor(1, 0.2, 0.2)
        love.graphics.circle("fill", x - 8, y - 5, 2)
        love.graphics.setColor(0.2, 0.2, 1)
        love.graphics.circle("fill", x, y - 7, 2)
        love.graphics.setColor(0.2, 1, 0.2)
        love.graphics.circle("fill", x + 8, y - 5, 2)
    else -- Eternal Overlord
        love.graphics.setColor(0.45, 0.05, 0.05)
        love.graphics.circle("fill", x, y, 28)
        love.graphics.setColor(0.9, 0.1, 0.1)
        love.graphics.circle("fill", x, y, 23)
        love.graphics.setColor(0.95, 0.95, 0.95)
        love.graphics.ellipse("fill", x, y - 2, 12, 14)
        love.graphics.setColor(0, 0, 0)
        love.graphics.circle("fill", x - 5, y - 4, 3)
        love.graphics.circle("fill", x + 5, y - 4, 3)
        love.graphics.polygon("fill", x - 2, y + 2, x + 2, y + 2, x, y + 5)
        love.graphics.rectangle("fill", x - 6, y + 7, 3, 4)
        love.graphics.rectangle("fill", x - 2, y + 7, 3, 4)
        love.graphics.rectangle("fill", x + 2, y + 7, 3, 4)
    end
    
    love.graphics.setColor(1, 0.85, 0)
    love.graphics.setLineWidth(3)
    love.graphics.circle("line", x, y, 28)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1)
end

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================
function getAnimalColor(animalId)
    for _, animal in ipairs(animals) do
        if animal.id == animalId then
            return animal.color
        end
    end
    return {0.5, 0.5, 0.5}
end

function button(text, x, y, w, h, hovered)
    local color = hovered and {0.3, 0.5, 0.8} or {0.2, 0.3, 0.5}
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", x, y, w, h, 5)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x, y, w, h, 5)
    love.graphics.printf(text, x, y + h/2 - 10, w, "center")
end

function isInside(mx, my, x, y, w, h)
    return mx >= x and mx <= x + w and my >= y and my <= y + h
end

function addParticles(x, y, count, color)
    for i = 1, count do
        table.insert(particles, {
            x = x,
            y = y,
            vx = (math.random() - 0.5) * 200,
            vy = (math.random() - 0.5) * 200 - 100,
            life = 1,
            color = color or {1, 1, 0}
        })
    end
end

function updateParticles(dt)
    for i = #particles, 1, -1 do
        local p = particles[i]
        p.x = p.x + p.vx * dt
        p.y = p.y + p.vy * dt
        p.vy = p.vy + 300 * dt
        p.life = p.life - dt * 2
        if p.life <= 0 then
            table.remove(particles, i)
        end
    end
end

function drawParticles()
    for _, p in ipairs(particles) do
        love.graphics.setColor(p.color[1], p.color[2], p.color[3], p.life)
        love.graphics.circle("fill", p.x, p.y, 3)
    end
    love.graphics.setColor(1, 1, 1)
end

function addShake(intensity)
    shake.timer = 0.2
    shake.intensity = intensity
end

function updateShake(dt)
    if shake.timer > 0 then
        shake.timer = shake.timer - dt
        shake.offsetX = (math.random() - 0.5) * shake.intensity
        shake.offsetY = (math.random() - 0.5) * shake.intensity
    else
        shake.offsetX = 0
        shake.offsetY = 0
    end
end

function calculateLevel()
    return math.floor(((player.totalReps / 100)) + ((player.maxLift / 100)))
end

function updatePlayerLevel()
    local oldLevel = player.level
    player.level = calculateLevel()
    player.maxHealth = 100 + (player.level - 1) * 20 
    player.health = player.maxHealth
    
    if player.level > oldLevel then
        addParticles(WINDOW_W/2, WINDOW_H/2, 30, {1, 1, 0})
        addShake(8)
    end
end

function getPlayerAttack()
    return 10 + player.level * 3
end

function getBossHealth(stage)
    return 100 + stage * 50
end

function getBossAttack(stage)
    return 5 + stage * 2
end

-- ============================================================================
-- SAVE/LOAD
-- ============================================================================
function saveGame()
    local data = {
        animal = player.animal,
        name = player.name,
        level = player.level,
        totalReps = player.totalReps,
        maxLift = player.maxLift,
        dungeonProgress = player.dungeonProgress,
        health = player.health,
        maxHealth = player.maxHealth,
        workoutLog = workoutLog,
        badges = badges
    }
    
    local str = ""
    str = str .. "animal=" .. (data.animal or "") .. "\n"
    str = str .. "name=" .. (data.name or "") .. "\n"
    str = str .. "level=" .. data.level .. "\n"
    str = str .. "totalReps=" .. data.totalReps .. "\n"
    str = str .. "maxLift=" .. data.maxLift .. "\n"
    str = str .. "dungeonProgress=" .. data.dungeonProgress .. "\n"
    str = str .. "health=" .. data.health .. "\n"
    str = str .. "maxHealth=" .. data.maxHealth .. "\n"
    
    for _, log in ipairs(data.workoutLog) do
        str = str .. "log=" .. log.date .. "," .. log.weight .. "," .. log.reps .. "\n"
    end
    
    for _, badge in ipairs(data.badges) do
        str = str .. "badge=" .. badge.boss .. "," .. badge.date .. "\n"
    end
    
    love.filesystem.write("save.txt", str)
end

function loadGame()
    if not love.filesystem.getInfo("save.txt") then return end
    
    local content = love.filesystem.read("save.txt")
    for line in content:gmatch("[^\n]+") do
        local key, value = line:match("([^=]+)=(.+)")
        if key == "animal" and value ~= "" then
            player.animal = value
        elseif key == "name" then
            player.name = value
        elseif key == "level" then
            player.level = tonumber(value)
        elseif key == "totalReps" then
            player.totalReps = tonumber(value)
        elseif key == "maxLift" then
            player.maxLift = tonumber(value)
        elseif key == "dungeonProgress" then
            player.dungeonProgress = tonumber(value)
        elseif key == "health" then
            player.health = tonumber(value)
        elseif key == "maxHealth" then
            player.maxHealth = tonumber(value)
        elseif key == "log" then
            local date, weight, reps = value:match("([^,]+),([^,]+),(.+)")
            table.insert(workoutLog, {
                date = date,
                weight = tonumber(weight),
                reps = tonumber(reps)
            })
        elseif key == "badge" then
            local bossNum, date = value:match("([^,]+),(.+)")
            table.insert(badges, {
                boss = tonumber(bossNum),
                date = date
            })
        end
    end
end

-- ============================================================================
-- SCREEN: START
-- ============================================================================
function drawStart()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("MUSCLE MEMORY", 0, 250, WINDOW_W, "center")
    love.graphics.printf("Fit Happens", 0, 290, WINDOW_W, "center")
    
    local mx, my = love.mouse.getPosition()
    local startBtn = {x=140, y=450, w=200, h=60}
    button("START", startBtn.x, startBtn.y, startBtn.w, startBtn.h, 
           isInside(mx, my, startBtn.x, startBtn.y, startBtn.w, startBtn.h))
end

function handleStartClick(x, y)
    if isInside(x, y, 140, 450, 200, 60) then
        STATE = "PICK_PET"
        addParticles(WINDOW_W/2, 480, 15, {0, 1, 1})
    end
end

-- ============================================================================
-- SCREEN: PICK PET
-- ============================================================================
function drawPickPet()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Choose Your Gym Buddy", 0, 40, WINDOW_W, "center")
    
    local mx, my = love.mouse.getPosition()
    local y = 120
    for i, animal in ipairs(animals) do
        local x = WINDOW_W/2
        
        -- Draw animal
        drawAnimal(animal.id, x, y, 1)
        
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(animal.name, 0, y + 70, WINDOW_W, "center")
        
        if isInside(mx, my, x - 60, y - 60, 120, 120) then
            love.graphics.setColor(1, 1, 0, 0.3)
            love.graphics.rectangle("fill", x - 60, y - 60, 120, 120, 5)
            love.graphics.setColor(1, 1, 1)
        end
        
        y = y + 140
    end
    
    if player.animal then
        love.graphics.printf("Name your buddy:", 0, 640, WINDOW_W, "center")
        love.graphics.setColor(0.2, 0.2, 0.3)
        love.graphics.rectangle("fill", 120, 675, 240, 35, 5)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", 120, 675, 240, 35, 5)
        love.graphics.printf(nameInput, 120, 683, 240, "center")
        
        if nameInput ~= "" then
            button("CONFIRM", 170, 730, 140, 50, isInside(mx, my, 170, 730, 140, 50))
        end
    end
end

function handlePickPetClick(x, y)
    local py = 120
    for i, animal in ipairs(animals) do
        local px = WINDOW_W/2
        if isInside(x, y, px - 60, py - 60, 120, 120) then
            player.animal = animal.id
            nameActive = true
            addParticles(px, py, 20, {1, 0.5, 0})
            return
        end
        py = py + 140
    end
    
    if player.animal and nameInput ~= "" and isInside(x, y, 170, 730, 140, 50) then
        player.name = nameInput
        nameActive = false
        updatePlayerLevel()
        saveGame()
        STATE = "HUB"
        addParticles(WINDOW_W/2, 755, 25, {0, 1, 0})
    end
end

-- ============================================================================
-- SCREEN: HUB
-- ============================================================================
function drawHub()
    love.graphics.setColor(1, 1, 1)
    
    drawAnimal(player.animal, WINDOW_W/2, 150, 1.2)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(player.name, 0, 240, WINDOW_W, "center")
    love.graphics.printf("Level " .. player.level, 0, 270, WINDOW_W, "center")
    
    local barW = 280
    local barH = 25
    local barX = (WINDOW_W - barW) / 2
    local barY = 310
    love.graphics.setColor(0.3, 0.1, 0.1)
    love.graphics.rectangle("fill", barX, barY, barW, barH, 3)
    love.graphics.setColor(0.8, 0.2, 0.2)
    local healthPercent = player.health / player.maxHealth
    love.graphics.rectangle("fill", barX, barY, barW * healthPercent, barH, 3)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", barX, barY, barW, barH, 3)
    love.graphics.printf(math.floor(player.health) .. "/" .. player.maxHealth, barX, barY + 5, barW, "center")
    
    local mx, my = love.mouse.getPosition()
    local btns = {
        {text="GYM", y=380},
        {text="DUNGEON", y=450},
        {text="STATS", y=520},
        {text="LOG", y=590},
        {text="BADGES", y=660},
        {text="CARD", y=730}
    }
    
    for _, btn in ipairs(btns) do
        button(btn.text, 170, btn.y, 140, 50, isInside(mx, my, 170, btn.y, 140, 50))
    end
end

function handleHubClick(x, y)
    local btns = {
        {text="GYM", y=380, state="GYM"},
        {text="DUNGEON", y=450, state="DUNGEON"},
        {text="STATS", y=520, state="STATS"},
        {text="LOG", y=590, state="LOG"},
        {text="BADGES", y=660, state="BADGES"},
        {text="CARD", y=730, state="TRADING_CARD"}
    }
    
    for _, btn in ipairs(btns) do
        if isInside(x, y, 170, btn.y, 140, 50) then
            if btn.state == "DUNGEON" then
                startDungeon()
            else
                STATE = btn.state
            end
            addParticles(240, btn.y + 25, 10, {0, 0.7, 1})
            return
        end
    end
end

-- ============================================================================
-- SCREEN: GYM
-- ============================================================================
function drawGym()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("GYM", 0, 30, WINDOW_W, "center")
    
    love.graphics.printf("Weight (lbs):", 40, 100, 280, "left")
    love.graphics.setColor(0.2, 0.2, 0.3)
    love.graphics.rectangle("fill", 40, 130, 280, 40, 5)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 40, 130, 280, 40, 5)
    love.graphics.printf(tostring(gymWeight), 40, 142, 280, "center")
    
    local mx, my = love.mouse.getPosition()
    
    local wBtns = {
        {text="-10", x=40, y=180, w=55, h=35},
        {text="-1", x=105, y=180, w=55, h=35},
        {text="+1", x=200, y=180, w=55, h=35},
        {text="+10", x=265, y=180, w=55, h=35}
    }
    
    for _, btn in ipairs(wBtns) do
        button(btn.text, btn.x, btn.y, btn.w, btn.h, isInside(mx, my, btn.x, btn.y, btn.w, btn.h))
    end
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Reps:", 40, 240, 280, "left")
    love.graphics.setColor(0.2, 0.2, 0.3)
    love.graphics.rectangle("fill", 40, 270, 280, 40, 5)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 40, 270, 280, 40, 5)
    love.graphics.printf(tostring(gymReps), 40, 282, 280, "center")
    
    local rBtns = {
        {text="-100", x=40, y=320, w=60, h=35},
        {text="-10", x=110, y=320, w=55, h=35},
        {text="-1", x=175, y=320, w=45, h=35},
        {text="+1", x=230, y=320, w=45, h=35},
        {text="+10", x=40, y=365, w=55, h=35},
        {text="+100", x=105, y=365, w=60, h=35}
    }
    
    for _, btn in ipairs(rBtns) do
        button(btn.text, btn.x, btn.y, btn.w, btn.h, isInside(mx, my, btn.x, btn.y, btn.w, btn.h))
    end
    
    if gymReps > 0 and gymWeight > 0 then
        button("LOG WORKOUT", 80, 430, 200, 50, isInside(mx, my, 80, 430, 200, 50))
    end
    
    button("BACK", 110, 550, 140, 45, isInside(mx, my, 110, 550, 140, 45))
end

function handleGymClick(x, y)
    local wBtns = {
        {text="-10", x=40, y=180, w=55, h=35, val=-10},
        {text="-1", x=105, y=180, w=55, h=35, val=-1},
        {text="+1", x=200, y=180, w=55, h=35, val=1},
        {text="+10", x=265, y=180, w=55, h=35, val=10}
    }
    
    for _, btn in ipairs(wBtns) do
        if isInside(x, y, btn.x, btn.y, btn.w, btn.h) then
            gymWeight = math.max(0, gymWeight + btn.val)
            addParticles(btn.x + btn.w/2, btn.y + btn.h/2, 5, {0.5, 0.5, 1})
            return
        end
    end
    
    local rBtns = {
        {text="-100", x=40, y=320, w=60, h=35, val=-100},
        {text="-10", x=110, y=320, w=55, h=35, val=-10},
        {text="-1", x=175, y=320, w=45, h=35, val=-1},
        {text="+1", x=230, y=320, w=45, h=35, val=1},
        {text="+10", x=40, y=365, w=55, h=35, val=10},
        {text="+100", x=105, y=365, w=60, h=35, val=100}
    }
    
    for _, btn in ipairs(rBtns) do
        if isInside(x, y, btn.x, btn.y, btn.w, btn.h) then
            gymReps = math.max(0, gymReps + btn.val)
            addParticles(btn.x + btn.w/2, btn.y + btn.h/2, 8, {1, 0.8, 0})
            addShake(3)
            return
        end
    end
    
    if gymReps > 0 and gymWeight > 0 and isInside(x, y, 80, 430, 200, 50) then
        player.totalReps = player.totalReps + gymReps
        player.maxLift = math.max(player.maxLift, gymWeight)
        
        table.insert(workoutLog, 1, {
            date = os.date("%Y-%m-%d %H:%M"),
            weight = gymWeight,
            reps = gymReps
        })
        
        updatePlayerLevel()
        addParticles(WINDOW_W/2, 455, 40, {0, 1, 0})
        addShake(10)
        
        gymReps = 0
        gymWeight = 0
        saveGame()
        return
    end
    
    if isInside(x, y, 110, 550, 140, 45) then
        STATE = "HUB"
        addParticles(180, 572, 10, {1, 0.5, 0})
    end
end

-- ============================================================================
-- SCREEN: STATS
-- ============================================================================
function drawStats()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("STATS", 0, 30, WINDOW_W, "center")
    
    drawAnimal(player.animal, WINDOW_W/2, 100, 0.8)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(player.name .. " - Level " .. player.level, 0, 170, WINDOW_W, "center")
    
    local stats = {
        "Total Reps: " .. player.totalReps,
        "Max Lift: " .. player.maxLift .. " lbs",
        "Attack Power: " .. getPlayerAttack(),
        "Max Health: " .. player.maxHealth,
        "Dungeon Progress: " .. player.dungeonProgress .. "/10",
        "Badges: " .. #badges .. "/10"
    }
    
    local y = 220
    for _, stat in ipairs(stats) do
        love.graphics.printf(stat, 40, y, 280, "left")
        y = y + 35
    end
    
    local mx, my = love.mouse.getPosition()
    button("BACK", 110, 550, 140, 45, isInside(mx, my, 110, 550, 140, 45))
end

function handleStatsClick(x, y)
    if isInside(x, y, 110, 550, 140, 45) then
        STATE = "HUB"
        addParticles(180, 572, 10, {1, 0.5, 0})
    end
end

-- ============================================================================
-- SCREEN: LOG
-- ============================================================================
function drawLog()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("WORKOUT LOG", 0, 30, WINDOW_W, "center")
    
    if #workoutLog == 0 then
        love.graphics.printf("No workouts logged yet!", 0, 200, WINDOW_W, "center")
    else
        local y = 80
        for i = 1, math.min(10, #workoutLog) do
            local log = workoutLog[i]
            love.graphics.setColor(0.2, 0.2, 0.3)
            love.graphics.rectangle("fill", 20, y, 320, 50, 5)
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line", 20, y, 320, 50, 5)
            love.graphics.printf(log.date, 30, y + 5, 300, "left")
            love.graphics.printf(log.weight .. " lbs x " .. log.reps .. " reps", 30, y + 25, 300, "left")
            y = y + 60
        end
    end
    
    local mx, my = love.mouse.getPosition()
    button("BACK", 110, 580, 140, 45, isInside(mx, my, 110, 580, 140, 45))
end

function handleLogClick(x, y)
    if isInside(x, y, 110, 580, 140, 45) then
        STATE = "HUB"
        addParticles(180, 602, 10, {1, 0.5, 0})
    end
end

-- ============================================================================
-- SCREEN: BADGES
-- ============================================================================
function drawBadges()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("BADGE COLLECTION", 0, 30, WINDOW_W, "center")
    love.graphics.printf("Badges: " .. #badges .. " / " .. #bosses, 0, 55, WINDOW_W, "center")
    
    for i = 1, #bosses do
        local col = (i - 1) % 3
        local row = math.floor((i - 1) / 3)
        local x = 90 + col * 90
        local y = 110 + row * 110
        
        local boss = bosses[i]
        local earned = false
        
        for _, badge in ipairs(badges) do
            if badge.boss == i then
                earned = true
                break
            end
        end
        
        if earned then
            drawBadge(x, y, boss)
        else
            love.graphics.setColor(0.3, 0.3, 0.3)
            love.graphics.circle("fill", x, y, 28)
            love.graphics.setColor(0.4, 0.4, 0.4)
            love.graphics.circle("fill", x, y, 23)
            love.graphics.setColor(0.5, 0.5, 0.5)
            love.graphics.setLineWidth(3)
            love.graphics.circle("line", x, y, 28)
            love.graphics.setLineWidth(1)
            love.graphics.setColor(0.6, 0.6, 0.6)
            love.graphics.rectangle("fill", x - 6, y + 2, 12, 10, 2)
            love.graphics.arc("line", "open", x, y - 2, 6, math.pi, 2 * math.pi)
        end
        
        love.graphics.setColor(1, 1, 1)
        love.graphics.setNewFont(9)
        love.graphics.printf(boss.name, x - 40, y + 35, 80, "center")
        love.graphics.setNewFont(14)
    end
    
    local mx, my = love.mouse.getPosition()
    button("BACK", 110, 580, 140, 40, isInside(mx, my, 110, 580, 140, 40))
end

function handleBadgesClick(x, y)
    if isInside(x, y, 110, 580, 140, 40) then
        STATE = "HUB"
        addParticles(180, 600, 10, {1, 0.5, 0})
    end
end

-- ============================================================================
-- SCREEN: TRADING CARD
-- ============================================================================
function drawTradingCard()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("TRADING CARD", 0, 20, WINDOW_W, "center")
    
    local cardX, cardY = 30, 70
    local cardW, cardH = 300, 500
    
    love.graphics.setColor(0.1, 0.1, 0.1, 0.3)
    love.graphics.rectangle("fill", cardX + 5, cardY + 5, cardW, cardH, 15)
    
    love.graphics.setColor(0.8, 0.7, 0.2)
    love.graphics.rectangle("fill", cardX, cardY, cardW, cardH, 15)
    
    local c = getAnimalColor(player.animal)
    love.graphics.setColor(c[1] * 0.3, c[2] * 0.3, c[3] * 0.3)
    love.graphics.rectangle("fill", cardX + 8, cardY + 8, cardW - 16, cardH - 16, 12)
    
    love.graphics.setColor(0.98, 0.98, 0.95)
    love.graphics.rectangle("fill", cardX + 15, cardY + 15, cardW - 30, cardH - 30, 10)
    
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.setNewFont(22)
    love.graphics.printf(player.name, cardX + 15, cardY + 25, cardW - 30, "center")
    love.graphics.setNewFont(14)
    
    drawAnimal(player.animal, cardX + cardW/2, cardY + 100, 1.2)
    
    love.graphics.setColor(c)
    love.graphics.circle("fill", cardX + cardW/2, cardY + 185, 25)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setNewFont(12)
    love.graphics.printf("LV", cardX + cardW/2 - 25, cardY + 170, 50, "center")
    love.graphics.setNewFont(18)
    love.graphics.printf(player.level, cardX + cardW/2 - 25, cardY + 183, 50, "center")
    love.graphics.setNewFont(14)
    
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.setNewFont(16)
    love.graphics.print("Stats", cardX + 30, cardY + 230)
    love.graphics.setNewFont(11)
    
    local xpNeeded = player.level * 100
    local stats = {
        "XP: " .. (player.totalReps % 100) .. " / " .. xpNeeded,
        "Badges: " .. #badges .. " / " .. #bosses,
        "Workouts: " .. #workoutLog,
        "Max Lift: " .. player.maxLift .. " lbs"
    }
    
    local y = cardY + 255
    for _, stat in ipairs(stats) do
        love.graphics.print(stat, cardX + 30, y)
        y = y + 20
    end
    
    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.rectangle("fill", cardX + 25, cardY + 345, cardW - 50, 2)
    
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.setNewFont(16)
    love.graphics.print("Recent Lifts", cardX + 30, cardY + 355)
    love.graphics.setNewFont(10)
    
    y = cardY + 380
    if #workoutLog == 0 then
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.print("No lifts yet", cardX + 30, y)
    else
        for i = 1, math.min(4, #workoutLog) do
            local log = workoutLog[i]
            love.graphics.setColor(0.2, 0.2, 0.2)
            local text = log.weight .. " lbs x " .. log.reps
            love.graphics.print(text, cardX + 30, y)
            y = y + 18
        end
    end
    
    love.graphics.setColor(c)
    love.graphics.rectangle("fill", cardX + 15, cardY + cardH - 30, cardW - 30, 15, 5)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setNewFont(9)
    love.graphics.printf("MUSCLE MEMORY", cardX + 15, cardY + cardH - 27, cardW - 30, "center")
    love.graphics.setNewFont(14)
    
    local mx, my = love.mouse.getPosition()
    button("BACK", 110, 585, 140, 40, isInside(mx, my, 110, 585, 140, 40))
end

function handleTradingCardClick(x, y)
    if isInside(x, y, 110, 585, 140, 40) then
        STATE = "HUB"
        addParticles(180, 605, 10, {1, 0.5, 0})
    end
end

-- ============================================================================
-- SCREEN: DUNGEON
-- ============================================================================
function startDungeon()
    dungeon.currentStage = 1
    dungeon.bossMaxHealth = getBossHealth(dungeon.currentStage)
    dungeon.bossHealth = dungeon.bossMaxHealth
    dungeon.combat = false
    dungeon.won = false
    dungeon.lost = false
    STATE = "DUNGEON"
end

function updateDungeonCombat(dt)
    dungeon.combatTimer = dungeon.combatTimer + dt
    
    if dungeon.combatTimer >= 1 then
        dungeon.combatTimer = 0
        
        local playerDmg = getPlayerAttack()
        dungeon.bossHealth = dungeon.bossHealth - playerDmg
        addParticles(WINDOW_W/2, 200, 15, {1, 0.3, 0})
        addShake(5)
        
        if dungeon.bossHealth <= 0 then
            dungeon.combat = false
            dungeon.won = true
            player.dungeonProgress = math.max(player.dungeonProgress, dungeon.currentStage + 1)
            
            local alreadyHasBadge = false
            for _, badge in ipairs(badges) do
                if badge.boss == dungeon.currentStage then
                    alreadyHasBadge = true
                    break
                end
            end
            
            if not alreadyHasBadge then
                table.insert(badges, {
                    boss = dungeon.currentStage,
                    date = os.date("%Y-%m-%d")
                })
            end
            
            addParticles(WINDOW_W/2, WINDOW_H/2, 50, {1, 1, 0})
            addShake(12)
            saveGame()
            return
        end
        
        local bossDmg = getBossAttack(dungeon.currentStage)
        player.health = player.health - bossDmg
        addParticles(WINDOW_W/2, 500, 15, {0.8, 0, 0})
        addShake(6)
        
        if player.health <= 0 then
            dungeon.combat = false
            dungeon.lost = true
            player.health = 0
            addShake(15)
            
            player.totalReps = 0
            player.level = 1
            player.dungeonProgress = 1
            updatePlayerLevel()
            saveGame()
        end
    end
end

function drawDungeon()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("DUNGEON - Stage " .. dungeon.currentStage, 0, 30, WINDOW_W, "center")
    
    if not dungeon.combat and not dungeon.won and not dungeon.lost then
        local boss = bosses[dungeon.currentStage]
        
        drawBoss(WINDOW_W/2, 200, boss, 0.7)
        
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(boss.name, 0, 310, WINDOW_W, "center")
        love.graphics.printf("Level " .. boss.level, 0, 335, WINDOW_W, "center")
        love.graphics.printf("HP: " .. getBossHealth(dungeon.currentStage), 0, 360, WINDOW_W, "center")
        love.graphics.printf("ATK: " .. getBossAttack(dungeon.currentStage), 0, 385, WINDOW_W, "center")
        
        local mx, my = love.mouse.getPosition()
        
        if dungeon.currentStage <= player.dungeonProgress then
            button("FIGHT", 170, 430, 140, 50, isInside(mx, my, 170, 430, 140, 50))
        else
            love.graphics.setColor(0.5, 0.5, 0.5)
            love.graphics.printf("LOCKED - Defeat previous stage first", 0, 445, WINDOW_W, "center")
            love.graphics.setColor(1, 1, 1)
        end
        
        love.graphics.printf("Select Stage:", 0, 520, WINDOW_W, "center")
        local btnY = 560
        for i = 1, 10 do
            local btnX = 40 + ((i-1) % 5) * 80
            if i > 5 then
                btnY = 630
                btnX = 40 + ((i-6) % 5) * 80
            end
            
            if i <= player.dungeonProgress then
                local hov = isInside(mx, my, btnX, btnY, 70, 45)
                if i == dungeon.currentStage then
                    love.graphics.setColor(0.3, 0.6, 0.3)
                else
                    love.graphics.setColor(hov and {0.3, 0.5, 0.8} or {0.2, 0.3, 0.5})
                end
                love.graphics.rectangle("fill", btnX, btnY, 70, 45, 3)
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle("line", btnX, btnY, 70, 45, 3)
                love.graphics.printf(tostring(i), btnX, btnY + 15, 70, "center")
            else
                love.graphics.setColor(0.3, 0.3, 0.3)
                love.graphics.rectangle("fill", btnX, btnY, 70, 45, 3)
                love.graphics.setColor(0.6, 0.6, 0.6)
                love.graphics.rectangle("line", btnX, btnY, 70, 45, 3)
                love.graphics.printf("?", btnX, btnY + 15, 70, "center")
            end
            
            if i == 5 then
                btnY = 630
            end
        end
        
        love.graphics.setColor(1, 1, 1)
        button("BACK", 170, 720, 140, 50, isInside(mx, my, 170, 720, 140, 50))
    elseif dungeon.combat then
        local boss = bosses[dungeon.currentStage]
        
        drawBoss(WINDOW_W/2, 200, boss, 0.6)
        
        local barW = 350
        local barH = 30
        local barX = (WINDOW_W - barW) / 2
        local barY = 320
        love.graphics.setColor(0.3, 0.1, 0.1)
        love.graphics.rectangle("fill", barX, barY, barW, barH, 3)
        love.graphics.setColor(0.8, 0.2, 0.2)
        local bossPercent = dungeon.bossHealth / dungeon.bossMaxHealth
        love.graphics.rectangle("fill", barX, barY, barW * bossPercent, barH, 3)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", barX, barY, barW, barH, 3)
        love.graphics.printf(math.floor(dungeon.bossHealth) .. "/" .. dungeon.bossMaxHealth, barX, barY + 7, barW, "center")
        
        drawAnimal(player.animal, WINDOW_W/2, 520, 1)
        
        barY = 630
        love.graphics.setColor(0.3, 0.1, 0.1)
        love.graphics.rectangle("fill", barX, barY, barW, barH, 3)
        love.graphics.setColor(0.2, 0.8, 0.2)
        local healthPercent = player.health / player.maxHealth
        love.graphics.rectangle("fill", barX, barY, barW * healthPercent, barH, 3)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", barX, barY, barW, barH, 3)
        love.graphics.printf(math.floor(player.health) .. "/" .. player.maxHealth, barX, barY + 7, barW, "center")
        
        love.graphics.printf("FIGHTING...", 0, 700, WINDOW_W, "center")
    elseif dungeon.won then
        love.graphics.printf("VICTORY!", 0, 300, WINDOW_W, "center")
        love.graphics.printf("Stage " .. dungeon.currentStage .. " Complete!", 0, 340, WINDOW_W, "center")
        
        local mx, my = love.mouse.getPosition()
        
        if dungeon.currentStage < 10 then
            button("NEXT STAGE", 140, 420, 200, 50, isInside(mx, my, 140, 420, 200, 50))
        else
            love.graphics.printf("All Stages Complete!", 0, 435, WINDOW_W, "center")
        end
        
        button("BACK TO HUB", 140, 520, 200, 50, isInside(mx, my, 140, 520, 200, 50))
    elseif dungeon.lost then
        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.printf("DEFEATED!", 0, 250, WINDOW_W, "center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Your buddy has fallen...", 0, 300, WINDOW_W, "center")
        love.graphics.printf("PERMADEATH ACTIVATED", 0, 340, WINDOW_W, "center")
        love.graphics.printf("Reset to Level 1", 0, 380, WINDOW_W, "center")
        
        local mx, my = love.mouse.getPosition()
        button("RETURN", 170, 480, 140, 50, isInside(mx, my, 170, 480, 140, 50))
    end
end

function handleDungeonClick(x, y)
    if not dungeon.combat and not dungeon.won and not dungeon.lost then
        local boss = bosses[dungeon.currentStage]
        
        if dungeon.currentStage <= player.dungeonProgress and isInside(x, y, 170, 430, 140, 50) then
            dungeon.combat = true
            dungeon.combatTimer = 0
            addParticles(240, 455, 20, {1, 0, 0})
            addShake(8)
            return
        end
        
        local btnY = 560
        for i = 1, 10 do
            local btnX = 40 + ((i-1) % 5) * 80
            if i > 5 then
                btnY = 630
                btnX = 40 + ((i-6) % 5) * 80
            end
            
            if i <= player.dungeonProgress and isInside(x, y, btnX, btnY, 70, 45) then
                dungeon.currentStage = i
                dungeon.bossMaxHealth = getBossHealth(i)
                dungeon.bossHealth = dungeon.bossMaxHealth
                addParticles(btnX + 35, btnY + 22, 8, {0, 1, 1})
                return
            end
            
            if i == 5 then
                btnY = 630
            end
        end
        
        if isInside(x, y, 170, 720, 140, 50) then
            STATE = "HUB"
            addParticles(240, 745, 10, {1, 0.5, 0})
        end
    elseif dungeon.won then
        if dungeon.currentStage < 10 and isInside(x, y, 140, 420, 200, 50) then
            dungeon.currentStage = dungeon.currentStage + 1
            dungeon.bossMaxHealth = getBossHealth(dungeon.currentStage)
            dungeon.bossHealth = dungeon.bossMaxHealth
            dungeon.combat = false
            dungeon.won = false
            addParticles(240, 445, 15, {0, 0.8, 1})
            return
        end
        
        if isInside(x, y, 140, 520, 200, 50) then
            STATE = "HUB"
            addParticles(240, 545, 15, {0, 1, 0})
        end
    elseif dungeon.lost then
        if isInside(x, y, 170, 480, 140, 50) then
            STATE = "HUB"
            addParticles(240, 505, 20, {0.5, 0.5, 0.5})
        end
    end
end
