-- ============================================================================
-- MUSCLE MEMORY: FIT HAPPENS
-- A gamified fitness tracker made with LOVE2D
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
local gymName = ""
local gymNameActive = false

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

-- Particle types for different effects
local PARTICLE_TYPES = {
    STANDARD = "standard",
    CONFETTI = "confetti",
    STAR = "star",
    EXPLOSION = "explosion"
}

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
    {name = "Shadow Beast", level = 30, color = {0.3, 0.2, 0.4}},
    {name = "Fire Dragon", level = 50, color = {0.9, 0.3, 0.1}},
    {name = "Thunder Titan", level = 100, color = {0.8, 0.8, 0.2}},
    {name = "Ice Colossus", level = 175, color = {0.4, 0.7, 0.9}},
    {name = "Ancient Wyrm", level = 275, color = {0.5, 0.8, 0.3}},
    {name = "Chaos Lord", level = 400, color = {0.7, 0.2, 0.7}},
    {name = "Void Emperor", level = 550, color = {0.1, 0.1, 0.2}},
    {name = "Ultimate Champion", level = 725, color = {1, 0.8, 0}},
    {name = "Eternal Overlord", level = 1000, color = {0.9, 0.1, 0.1}}
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
    elseif gymNameActive and #gymName < 50 then
        gymName = gymName .. t
    end
end

function love.keypressed(key)
    if nameActive and key == "backspace" then
        nameInput = nameInput:sub(1, -2)
    elseif gymNameActive and key == "backspace" then
        gymName = gymName:sub(1, -2)
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
    
    -- Add glow effect on hover
    if hovered then
        love.graphics.setColor(0.4, 0.6, 1, 0.3)
        love.graphics.rectangle("fill", x - 2, y - 2, w + 4, h + 4, 6)
    end
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x, y, w, h, 5)
    love.graphics.printf(text, x, y + h/2 - 10, w, "center")
end

function isInside(mx, my, x, y, w, h)
    return mx >= x and mx <= x + w and my >= y and my <= y + h
end

function addParticles(x, y, count, color, ptype)
    ptype = ptype or PARTICLE_TYPES.STANDARD
    
    for i = 1, count do
        local size = math.random(2, 5)
        local speed = math.random(100, 300)
        local angle = math.random() * math.pi * 2
        
        if ptype == PARTICLE_TYPES.CONFETTI then
            -- Confetti shoots upward and outward
            table.insert(particles, {
                x = x,
                y = y,
                vx = (math.random() - 0.5) * 300,
                vy = -math.random(150, 400),
                life = math.random(10, 20) / 10,
                color = color or {math.random(), math.random(), math.random()},
                size = math.random(3, 7),
                rotation = math.random() * math.pi * 2,
                rotSpeed = (math.random() - 0.5) * 10,
                type = ptype
            })
        elseif ptype == PARTICLE_TYPES.STAR then
            -- Stars sparkle and float
            table.insert(particles, {
                x = x + (math.random() - 0.5) * 100,
                y = y + (math.random() - 0.5) * 100,
                vx = (math.random() - 0.5) * 150,
                vy = -math.random(50, 150),
                life = math.random(15, 25) / 10,
                color = color or {1, 1, math.random(0.5, 1)},
                size = math.random(4, 8),
                rotation = 0,
                rotSpeed = math.random(5, 10),
                type = ptype
            })
        elseif ptype == PARTICLE_TYPES.EXPLOSION then
            -- Explosions radiate outward
            table.insert(particles, {
                x = x,
                y = y,
                vx = math.cos(angle) * speed * 1.5,
                vy = math.sin(angle) * speed * 1.5,
                life = math.random(10, 20) / 10,
                color = color or {math.random(0.8, 1), math.random(0.3, 0.6), math.random(0, 0.3)},
                size = math.random(5, 12),
                rotation = angle,
                rotSpeed = (math.random() - 0.5) * 8,
                type = ptype
            })
        else
            -- Standard particles
            table.insert(particles, {
                x = x,
                y = y,
                vx = (math.random() - 0.5) * 200,
                vy = (math.random() - 0.5) * 200 - 100,
                life = 1,
                color = color or {1, 1, 0},
                size = size,
                rotation = 0,
                rotSpeed = 0,
                type = ptype
            })
        end
    end
end

function updateParticles(dt)
    for i = #particles, 1, -1 do
        local p = particles[i]
        p.x = p.x + p.vx * dt
        p.y = p.y + p.vy * dt
        
        -- Apply gravity
        if p.type == PARTICLE_TYPES.CONFETTI or p.type == PARTICLE_TYPES.STAR then
            p.vy = p.vy + 400 * dt
        else
            p.vy = p.vy + 300 * dt
        end
        
        -- Update rotation
        p.rotation = p.rotation + p.rotSpeed * dt
        
        -- Decay life
        local decayRate = p.type == PARTICLE_TYPES.STAR and 0.8 or 2
        p.life = p.life - dt * decayRate
        
        if p.life <= 0 then
            table.remove(particles, i)
        end
    end
end

function drawParticles()
    for _, p in ipairs(particles) do
        love.graphics.push()
        love.graphics.translate(p.x, p.y)
        love.graphics.rotate(p.rotation)
        
        love.graphics.setColor(p.color[1], p.color[2], p.color[3], p.life)
        
        if p.type == PARTICLE_TYPES.STAR then
            -- Draw star shape
            local points = 5
            local outerRadius = p.size
            local innerRadius = p.size * 0.4
            local verts = {}
            for i = 0, points * 2 - 1 do
                local angle = (i * math.pi / points) - math.pi / 2
                local radius = (i % 2 == 0) and outerRadius or innerRadius
                table.insert(verts, math.cos(angle) * radius)
                table.insert(verts, math.sin(angle) * radius)
            end
            love.graphics.polygon("fill", verts)
        elseif p.type == PARTICLE_TYPES.CONFETTI then
            -- Draw rectangle confetti
            love.graphics.rectangle("fill", -p.size/2, -p.size/2, p.size, p.size * 1.5)
        else
            -- Draw circle
            love.graphics.circle("fill", 0, 0, p.size)
        end
        
        love.graphics.pop()
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
    return math.floor(player.totalReps / 10)
end

function updatePlayerLevel()
    local oldLevel = player.level
    player.level = calculateLevel()
    player.maxHealth = (player.level) * math.floor(player.maxLift / 100)
    player.health = player.maxHealth
    
    if player.level > oldLevel then
        addParticles(WINDOW_W/2, WINDOW_H/2, 50, {1, 1, 0}, PARTICLE_TYPES.STAR)
        addShake(8)
    end
end

function getPlayerAttack()
    return 10 + player.level * 5
end

function getBossHealth(stage)
    return 100 + bosses[stage].level * (stage + 3)
end

function getBossAttack(stage)
    return 5 + stage * math.floor((bosses[stage].level / 10))
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
        str = str .. "log=" .. (log.name or "Workout") .. "," .. log.date .. "," .. log.weight .. "," .. log.reps .. "\n"
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
            local name, date, weight, reps = value:match("([^,]+),([^,]+),([^,]+),(.+)")
            table.insert(workoutLog, {
                name = name,
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
    local startBtn = {x=(WINDOW_W - 200)/2, y=450, w=200, h=60}
    button("START", startBtn.x, startBtn.y, startBtn.w, startBtn.h, 
           isInside(mx, my, startBtn.x, startBtn.y, startBtn.w, startBtn.h))
end

function handleStartClick(x, y)
    if isInside(x, y, (WINDOW_W - 200)/2, 450, 200, 60) then
        STATE = "PICK_PET"
        addParticles(WINDOW_W/2, 480, 30, {0, 1, 1}, PARTICLE_TYPES.STAR)
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
        local inputX = (WINDOW_W - 240) / 2
        love.graphics.rectangle("fill", inputX, 675, 240, 35, 5)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", inputX, 675, 240, 35, 5)
        love.graphics.printf(nameInput, inputX, 683, 240, "center")
        
        if nameInput ~= "" then
            button("CONFIRM", (WINDOW_W - 140)/2, 730, 140, 50, isInside(mx, my, (WINDOW_W - 140)/2, 730, 140, 50))
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
            addParticles(px, py, 40, {1, 0.5, 0}, PARTICLE_TYPES.CONFETTI)
            return
        end
        py = py + 140
    end
    
    if player.animal and nameInput ~= "" and isInside(x, y, (WINDOW_W - 140)/2, 730, 140, 50) then
        player.name = nameInput
        nameActive = false
        updatePlayerLevel()
        saveGame()
        STATE = "HUB"
        addParticles(WINDOW_W/2, 755, 50, {0, 1, 0}, PARTICLE_TYPES.STAR)
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
        button(btn.text, (WINDOW_W - 140)/2, btn.y, 140, 50, isInside(mx, my, (WINDOW_W - 140)/2, btn.y, 140, 50))
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
        if isInside(x, y, (WINDOW_W - 140)/2, btn.y, 140, 50) then
            if btn.state == "DUNGEON" then
                startDungeon()
            else
                STATE = btn.state
            end
            addParticles(WINDOW_W/2, btn.y + 25, 10, {0, 0.7, 1})
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
    
    love.graphics.printf("Workout Name:", 0, 70, WINDOW_W, "center")
    love.graphics.setColor(0.2, 0.2, 0.3)
    local inputX = (WINDOW_W - 280) / 2
    love.graphics.rectangle("fill", inputX, 100, 280, 40, 5)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", inputX, 100, 280, 40, 5)
    local displayName = gymName ~= "" and gymName or "Workout"
    love.graphics.printf(displayName, inputX, 112, 280, "center")
    
    love.graphics.printf("Weight (lbs):", 0, 160, WINDOW_W, "center")
    love.graphics.setColor(0.2, 0.2, 0.3)
    love.graphics.rectangle("fill", inputX, 190, 280, 40, 5)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", inputX, 190, 280, 40, 5)
    love.graphics.printf(tostring(gymWeight), inputX, 202, 280, "center")
    
    local mx, my = love.mouse.getPosition()
    
    local wBtns = {
        {text="-10", x=(WINDOW_W - 280)/2, y=240, w=55, h=35},
        {text="-1", x=(WINDOW_W - 280)/2 + 65, y=240, w=55, h=35},
        {text="+1", x=(WINDOW_W - 280)/2 + 160, y=240, w=55, h=35},
        {text="+10", x=(WINDOW_W - 280)/2 + 225, y=240, w=55, h=35}
    }
    
    for _, btn in ipairs(wBtns) do
        button(btn.text, btn.x, btn.y, btn.w, btn.h, isInside(mx, my, btn.x, btn.y, btn.w, btn.h))
    end
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Reps:", 0, 300, WINDOW_W, "center")
    love.graphics.setColor(0.2, 0.2, 0.3)
    love.graphics.rectangle("fill", inputX, 330, 280, 40, 5)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", inputX, 330, 280, 40, 5)
    love.graphics.printf(tostring(gymReps), inputX, 342, 280, "center")
    
    local rBtns = {
        {text="-100", x=(WINDOW_W - 280)/2, y=380, w=60, h=35},
        {text="-10", x=(WINDOW_W - 280)/2 + 70, y=380, w=55, h=35},
        {text="-1", x=(WINDOW_W - 280)/2 + 135, y=380, w=45, h=35},
        {text="+1", x=(WINDOW_W - 280)/2 + 190, y=380, w=45, h=35},
        {text="+10", x=(WINDOW_W - 280)/2, y=425, w=55, h=35},
        {text="+100", x=(WINDOW_W - 280)/2 + 65, y=425, w=60, h=35}
    }
    
    for _, btn in ipairs(rBtns) do
        button(btn.text, btn.x, btn.y, btn.w, btn.h, isInside(mx, my, btn.x, btn.y, btn.w, btn.h))
    end
    
    if gymReps > 0 and gymWeight > 0 then
        button("LOG WORKOUT", (WINDOW_W - 200)/2, 490, 200, 50, isInside(mx, my, (WINDOW_W - 200)/2, 490, 200, 50))
    end
    
    button("BACK", (WINDOW_W - 140)/2, 610, 140, 45, isInside(mx, my, (WINDOW_W - 140)/2, 610, 140, 45))
end

function handleGymClick(x, y)
    -- Check if clicking on workout name input
    local inputX = (WINDOW_W - 280) / 2
    if isInside(x, y, inputX, 100, 280, 40) then
        gymNameActive = true
        return
    else
        gymNameActive = false
    end
    
    local wBtns = {
        {text="-10", x=(WINDOW_W - 280)/2, y=240, w=55, h=35, val=-10},
        {text="-1", x=(WINDOW_W - 280)/2 + 65, y=240, w=55, h=35, val=-1},
        {text="+1", x=(WINDOW_W - 280)/2 + 160, y=240, w=55, h=35, val=1},
        {text="+10", x=(WINDOW_W - 280)/2 + 225, y=240, w=55, h=35, val=10}
    }
    
    for _, btn in ipairs(wBtns) do
        if isInside(x, y, btn.x, btn.y, btn.w, btn.h) then
            gymWeight = math.max(0, gymWeight + btn.val)
            addParticles(btn.x + btn.w/2, btn.y + btn.h/2, 10, {0.5, 0.5, 1})
            return
        end
    end
    
    local rBtns = {
        {text="-100", x=(WINDOW_W - 280)/2, y=380, w=60, h=35, val=-100},
        {text="-10", x=(WINDOW_W - 280)/2 + 70, y=380, w=55, h=35, val=-10},
        {text="-1", x=(WINDOW_W - 280)/2 + 135, y=380, w=45, h=35, val=-1},
        {text="+1", x=(WINDOW_W - 280)/2 + 190, y=380, w=45, h=35, val=1},
        {text="+10", x=(WINDOW_W - 280)/2, y=425, w=55, h=35, val=10},
        {text="+100", x=(WINDOW_W - 280)/2 + 65, y=425, w=60, h=35, val=100}
    }
    
    for _, btn in ipairs(rBtns) do
        if isInside(x, y, btn.x, btn.y, btn.w, btn.h) then
            gymReps = math.max(0, gymReps + btn.val)
            addParticles(btn.x + btn.w/2, btn.y + btn.h/2, 15, {1, 0.8, 0}, PARTICLE_TYPES.STAR)
            addShake(3)
            return
        end
    end
    
    if gymReps > 0 and gymWeight > 0 and isInside(x, y, (WINDOW_W - 200)/2, 490, 200, 50) then
        player.totalReps = player.totalReps + gymReps
        player.maxLift = math.max(player.maxLift, gymWeight)
        
        local workoutName = gymName ~= "" and gymName or "Workout"
        table.insert(workoutLog, 1, {
            name = workoutName,
            date = os.date("%Y-%m-%d %H:%M"),
            weight = gymWeight,
            reps = gymReps
        })
        
        updatePlayerLevel()
        addParticles(WINDOW_W/2, 515, 80, {0, 1, 0}, PARTICLE_TYPES.CONFETTI)
        addShake(10)
        
        gymReps = 0
        gymWeight = 0
        gymName = ""
        gymNameActive = false
        saveGame()
        return
    end
    
    if isInside(x, y, (WINDOW_W - 140)/2, 610, 140, 45) then
        STATE = "HUB"
        gymNameActive = false
        addParticles(WINDOW_W/2, 632, 10, {1, 0.5, 0})
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
        love.graphics.printf(stat, 0, y, WINDOW_W, "center")
        y = y + 35
    end
    
    local mx, my = love.mouse.getPosition()
    button("BACK", (WINDOW_W - 140)/2, 550, 140, 45, isInside(mx, my, (WINDOW_W - 140)/2, 550, 140, 45))
end

function handleStatsClick(x, y)
    if isInside(x, y, (WINDOW_W - 140)/2, 550, 140, 45) then
        STATE = "HUB"
        addParticles(WINDOW_W/2, 572, 10, {1, 0.5, 0})
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
        local logX = (WINDOW_W - 400) / 2
        for i = 1, math.min(10, #workoutLog) do
            local log = workoutLog[i]
            love.graphics.setColor(0.2, 0.2, 0.3)
            love.graphics.rectangle("fill", logX, y, 400, 60, 5)
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line", logX, y, 400, 60, 5)
            love.graphics.printf(log.name or "Workout", logX + 10, y + 5, 380, "left")
            love.graphics.printf(log.date, logX + 10, y + 22, 380, "left")
            love.graphics.printf(log.weight .. " lbs x " .. log.reps .. " reps", logX + 10, y + 39, 380, "left")
            y = y + 70
        end
    end
    
    local mx, my = love.mouse.getPosition()
    button("BACK", (WINDOW_W - 140)/2, 720, 140, 45, isInside(mx, my, (WINDOW_W - 140)/2, 720, 140, 45))
end

function handleLogClick(x, y)
    if isInside(x, y, (WINDOW_W - 140)/2, 720, 140, 45) then
        STATE = "HUB"
        addParticles(WINDOW_W/2, 742, 10, {1, 0.5, 0})
    end
end

-- ============================================================================
-- SCREEN: BADGES
-- ============================================================================
function drawBadges()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("BADGE COLLECTION", 0, 30, WINDOW_W, "center")
    love.graphics.printf("Badges: " .. #badges .. " / " .. #bosses, 0, 55, WINDOW_W, "center")
    
    -- Center the badge grid - 3 columns of badges at 120px spacing
    local totalGridWidth = 3 * 90 -- 3 badges per row, each taking ~90px of space
    local gridStartX = (WINDOW_W - totalGridWidth) / 2
    
    for i = 1, #bosses do
        local col = (i - 1) % 3
        local row = math.floor((i - 1) / 3)
        local x = gridStartX + col * 120 + 45 -- 45 is half the badge spacing to center each badge
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
        love.graphics.printf(boss.name, x - 50, y + 35, 100, "center")
        love.graphics.setNewFont(14)
    end
    
    local mx, my = love.mouse.getPosition()
    button("BACK", (WINDOW_W - 140)/2, 720, 140, 50, isInside(mx, my, (WINDOW_W - 140)/2, 720, 140, 50))
end

function handleBadgesClick(x, y)
    if isInside(x, y, (WINDOW_W - 140)/2, 720, 140, 50) then
        STATE = "HUB"
        addParticles(WINDOW_W/2, 745, 10, {1, 0.5, 0})
    end
end

-- ============================================================================
-- SCREEN: TRADING CARD
-- ============================================================================
function drawTradingCard()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("TRADING CARD", 0, 20, WINDOW_W, "center")
    
    local cardW, cardH = 300, 500
    local cardX = (WINDOW_W - cardW) / 2
    local cardY = 70
    
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
    
    local xpNeeded = player.level * 80
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
    love.graphics.print("Recent Workouts", cardX + 30, cardY + 355)
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
    button("BACK", (WINDOW_W - 140)/2, 650, 140, 50, isInside(mx, my, (WINDOW_W - 140)/2, 650, 140, 50))
end

function handleTradingCardClick(x, y)
    if isInside(x, y, (WINDOW_W - 140)/2, 650, 140, 50) then
        STATE = "HUB"
        addParticles(WINDOW_W/2, 675, 10, {1, 0.5, 0})
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
            player.maxLift = 0
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
            button("FIGHT", (WINDOW_W - 140)/2, 430, 140, 50, isInside(mx, my, (WINDOW_W - 140)/2, 430, 140, 50))
        else
            love.graphics.setColor(0.5, 0.5, 0.5)
            love.graphics.printf("LOCKED - Defeat previous stage first", 0, 445, WINDOW_W, "center")
            love.graphics.setColor(1, 1, 1)
        end
        
        love.graphics.printf("Select Stage:", 0, 520, WINDOW_W, "center")
        
        -- Center the stage selection grid - 5 columns of 70px buttons with proper spacing
        local totalGridWidth = 5 * 70 + 4 * 10 -- 5 buttons at 70px + 4 gaps of 10px
        local gridStartX = (WINDOW_W - totalGridWidth) / 2
        local btnY = 560
        for i = 1, 10 do
            local btnX = gridStartX + ((i-1) % 5) * 80
            if i > 5 then
                btnY = 630
                btnX = gridStartX + ((i-6) % 5) * 80
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
        button("BACK", (WINDOW_W - 140)/2, 720, 140, 50, isInside(mx, my, (WINDOW_W - 140)/2, 720, 140, 50))
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
            button("NEXT STAGE", (WINDOW_W - 200)/2, 420, 200, 50, isInside(mx, my, (WINDOW_W - 200)/2, 420, 200, 50))
        else
            love.graphics.printf("All Stages Complete!", 0, 435, WINDOW_W, "center")
        end
        
        button("BACK TO HUB", (WINDOW_W - 200)/2, 520, 200, 50, isInside(mx, my, (WINDOW_W - 200)/2, 520, 200, 50))
    elseif dungeon.lost then
        love.graphics.setColor(1, 0.3, 0.3)
        love.graphics.printf("DEFEATED!", 0, 250, WINDOW_W, "center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Your buddy has fallen...", 0, 300, WINDOW_W, "center")
        love.graphics.printf("PERMADEATH ACTIVATED", 0, 340, WINDOW_W, "center")
        love.graphics.printf("Reset to Level 1", 0, 380, WINDOW_W, "center")
        
        local mx, my = love.mouse.getPosition()
        button("RETURN", (WINDOW_W - 140)/2, 480, 140, 50, isInside(mx, my, (WINDOW_W - 140)/2, 480, 140, 50))
    end
end

function handleDungeonClick(x, y)
    if not dungeon.combat and not dungeon.won and not dungeon.lost then
        local boss = bosses[dungeon.currentStage]
        
        if dungeon.currentStage <= player.dungeonProgress and isInside(x, y, (WINDOW_W - 140)/2, 430, 140, 50) then
            dungeon.combat = true
            dungeon.combatTimer = 0
            addParticles(WINDOW_W/2, 455, 20, {1, 0, 0})
            addShake(8)
            return
        end
        
        local totalGridWidth = 5 * 70 + 4 * 10
        local gridStartX = (WINDOW_W - totalGridWidth) / 2
        local btnY = 560
        for i = 1, 10 do
            local btnX = gridStartX + ((i-1) % 5) * 80
            if i > 5 then
                btnY = 630
                btnX = gridStartX + ((i-6) % 5) * 80
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
        
        if isInside(x, y, (WINDOW_W - 140)/2, 720, 140, 50) then
            STATE = "HUB"
            addParticles(WINDOW_W/2, 745, 10, {1, 0.5, 0})
        end
    elseif dungeon.won then
        if dungeon.currentStage < 10 and isInside(x, y, (WINDOW_W - 200)/2, 420, 200, 50) then
            dungeon.currentStage = dungeon.currentStage + 1
            dungeon.bossMaxHealth = getBossHealth(dungeon.currentStage)
            dungeon.bossHealth = dungeon.bossMaxHealth
            dungeon.combat = false
            dungeon.won = false
            addParticles(WINDOW_W/2, 445, 15, {0, 0.8, 1})
            return
        end
        
        if isInside(x, y, (WINDOW_W - 200)/2, 520, 200, 50) then
            STATE = "HUB"
            addParticles(WINDOW_W/2, 545, 15, {0, 1, 0})
        end
    elseif dungeon.lost then
        if isInside(x, y, (WINDOW_W - 140)/2, 480, 140, 50) then
            STATE = "HUB"
            addParticles(WINDOW_W/2, 505, 20, {0.5, 0.5, 0.5})
        end
    end
end