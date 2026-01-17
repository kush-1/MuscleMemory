-- main.lua - Workout RPG Game

function love.load()
    love.window.setTitle("Workout RPG")
    love.window.setMode(800, 600)
    
    -- Game state
    state = "menu" -- menu, workout, battle, victory, defeat
    
    -- Player data
    player = {
        name = "Warrior",
        level = 1,
        exp = 0,
        expToNext = 100,
        power = 10,
        maxHP = 100,
        currentHP = 100
    }
    
    -- Workout tracking
    workout = {
        reps = 0,
        inputBuffer = ""
    }
    
    -- Dungeon bosses (scales with player level)
    bosses = {
        {name = "Goblin", levelRange = {1, 3}, powerMult = 0.8},
        {name = "Orc Warrior", levelRange = {3, 6}, powerMult = {0.8, 1.2}},
        {name = "Troll Berserker", levelRange = {5, 9}, powerMult = {0.8, 1.2}},
        {name = "Dark Knight", levelRange = {8, 12}, powerMult = {0.8, 1.2}},
        {name = "Dragon Lord", levelRange = {10, 999}, powerMult = {0.8, 1.2}}
    }
    
    currentBoss = nil
    battleLog = {}
    
    -- UI
    buttons = {}
end

function love.update(dt)
    -- Update player stats based on level
    player.power = 10 + (player.level - 1) * 5
    player.maxHP = 100 + (player.level - 1) * 20
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    
    if state == "menu" then
        drawMenu()
    elseif state == "workout" then
        drawWorkout()
    elseif state == "battle" then
        drawBattle()
    elseif state == "victory" then
        drawVictory()
    elseif state == "defeat" then
        drawDefeat()
    end
end

function drawMenu()
    love.graphics.printf("WORKOUT RPG", 0, 50, 800, "center")
    love.graphics.setFont(love.graphics.newFont(20))
    
    -- Player stats
    love.graphics.printf("Level: " .. player.level, 0, 150, 800, "center")
    love.graphics.printf("EXP: " .. player.exp .. " / " .. player.expToNext, 0, 180, 800, "center")
    love.graphics.printf("Power: " .. player.power, 0, 210, 800, "center")
    love.graphics.printf("HP: " .. player.currentHP .. " / " .. player.maxHP, 0, 240, 800, "center")
    
    love.graphics.setFont(love.graphics.newFont(16))
    love.graphics.printf("[W] Log Workout", 0, 320, 800, "center")
    love.graphics.printf("[B] Enter Dungeon", 0, 350, 800, "center")
    love.graphics.printf("[H] Heal (Rest)", 0, 380, 800, "center")
end

function drawWorkout()
    love.graphics.printf("LOG YOUR WORKOUT", 0, 50, 800, "center")
    love.graphics.setFont(love.graphics.newFont(18))
    
    love.graphics.printf("Enter number of reps completed:", 0, 150, 800, "center")
    love.graphics.printf(workout.inputBuffer .. "_", 0, 200, 800, "center")
    
    love.graphics.setFont(love.graphics.newFont(14))
    love.graphics.printf("Press ENTER to confirm", 0, 280, 800, "center")
    love.graphics.printf("Press ESC to cancel", 0, 310, 800, "center")
end

function drawBattle()
    love.graphics.printf("DUNGEON BATTLE", 0, 30, 800, "center")
    love.graphics.setFont(love.graphics.newFont(16))
    
    -- Player info
    love.graphics.printf("YOU", 150, 80, 200, "center")
    love.graphics.printf("Level: " .. player.level, 150, 110, 200, "center")
    love.graphics.printf("Power: " .. player.power, 150, 135, 200, "center")
    love.graphics.printf("HP: " .. player.currentHP, 150, 160, 200, "center")
    
    -- Boss info
    love.graphics.printf(currentBoss.name, 450, 80, 200, "center")
    love.graphics.printf("Level: " .. currentBoss.level, 450, 110, 200, "center")
    love.graphics.printf("Power: " .. currentBoss.power, 450, 135, 200, "center")
    love.graphics.printf("HP: " .. currentBoss.hp, 450, 160, 200, "center")
    
    -- Battle log
    love.graphics.setFont(love.graphics.newFont(14))
    love.graphics.printf("Battle Log:", 50, 250, 700, "left")
    for i, log in ipairs(battleLog) do
        love.graphics.printf(log, 50, 270 + (i - 1) * 20, 700, "left")
    end
    
    love.graphics.printf("Press SPACE to fight!", 0, 500, 800, "center")
    love.graphics.printf("Press ESC to flee", 0, 530, 800, "center")
end

function drawVictory()
    love.graphics.printf("VICTORY!", 0, 150, 800, "center")
    love.graphics.setFont(love.graphics.newFont(18))
    
    love.graphics.printf("You defeated " .. currentBoss.name .. "!", 0, 220, 800, "center")
    love.graphics.printf("Gained " .. currentBoss.expReward .. " EXP", 0, 260, 800, "center")
    
    love.graphics.setFont(love.graphics.newFont(14))
    love.graphics.printf("Press ENTER to continue", 0, 350, 800, "center")
end

function drawDefeat()
    love.graphics.printf("DEFEAT...", 0, 150, 800, "center")
    love.graphics.setFont(love.graphics.newFont(18))
    
    love.graphics.printf("You were defeated by " .. currentBoss.name, 0, 220, 800, "center")
    love.graphics.printf("Rest and train harder!", 0, 260, 800, "center")
    
    love.graphics.setFont(love.graphics.newFont(14))
    love.graphics.printf("Press ENTER to return", 0, 350, 800, "center")
end

function love.keypressed(key)
    if state == "menu" then
        if key == "w" then
            state = "workout"
            workout.inputBuffer = ""
        elseif key == "b" then
            startBattle()
        elseif key == "h" then
            player.currentHP = player.maxHP
        end
        
    elseif state == "workout" then
        if key == "return" and workout.inputBuffer ~= "" then
            local reps = tonumber(workout.inputBuffer)
            if reps and reps > 0 then
                addExperience(reps)
                state = "menu"
            end
        elseif key == "escape" then
            state = "menu"
        elseif key == "backspace" then
            workout.inputBuffer = workout.inputBuffer:sub(1, -2)
        elseif tonumber(key) then
            workout.inputBuffer = workout.inputBuffer .. key
        end
        
    elseif state == "battle" then
        if key == "space" then
            executeBattle()
        elseif key == "escape" then
            state = "menu"
            player.currentHP = math.max(1, player.currentHP - 10)
        end
        
    elseif state == "victory" or state == "defeat" then
        if key == "return" then
            state = "menu"
        end
    end
end

function addExperience(reps)
    local expGained = reps * 2 -- 2 exp per rep
    player.exp = player.exp + expGained
    
    -- Level up check
    while player.exp >= player.expToNext do
        player.exp = player.exp - player.expToNext
        player.level = player.level + 1
        player.expToNext = math.floor(player.expToNext * 1.5)
        player.currentHP = player.maxHP
    end
end

function startBattle()
    -- Find appropriate boss for player level
    local availableBosses = {}
    for _, boss in ipairs(bosses) do
        if player.level >= boss.levelRange[1] and player.level <= boss.levelRange[2] then
            table.insert(availableBosses, boss)
        end
    end
    
    -- Pick highest tier available boss
    local bossTemplate = availableBosses[#availableBosses] or bosses[#bosses]
    
    -- Create boss instance
    local bossLevel = math.max(1, player.level + math.random(-1, 2))
    currentBoss = {
        name = bossTemplate.name,
        level = bossLevel,
        power = math.floor((10 + (bossLevel - 1) * 5) * bossTemplate.powerMult),
        hp = 100 + (bossLevel - 1) * 20,
        expReward = bossLevel * 50
    }
    
    battleLog = {}
    state = "battle"
end

function executeBattle()
    battleLog = {}
    
    -- Calculate total power (level + power + HP)
    local playerTotal = player.level + player.power + player.currentHP
    local bossTotal = currentBoss.level + currentBoss.power + currentBoss.hp
    
    table.insert(battleLog, "You charge at " .. currentBoss.name .. "!")
    table.insert(battleLog, "Your total power: " .. playerTotal)
    table.insert(battleLog, "Enemy total power: " .. bossTotal)
    
    -- Higher number wins
    if playerTotal > bossTotal then
        table.insert(battleLog, "Your superior strength overwhelms the enemy!")
        player.exp = player.exp + currentBoss.expReward
        
        -- Level up check
        while player.exp >= player.expToNext do
            player.exp = player.exp - player.expToNext
            player.level = player.level + 1
            player.expToNext = math.floor(player.expToNext * 1.5)
            player.currentHP = player.maxHP
            table.insert(battleLog, "LEVEL UP! You are now level " .. player.level)
        end
        
        state = "victory"
    else
        table.insert(battleLog, "The enemy's power is too great!")
        player.currentHP = math.max(1, math.floor(player.currentHP * 0.5))
        state = "defeat"
    end
end