-- Keep the vanilla READ action, book states, callbacks, and effects. Only the
-- timing of a real book read is changed; spellbook casts and other actions
-- using the same state keep their original timing.
local ACTIONS = GLOBAL.ACTIONS
local TimeEvent = GLOBAL.TimeEvent
local FRAMES = GLOBAL.FRAMES

local speed = GetModConfigData("reading_speed")
if speed ~= 2 and speed ~= 3 and speed ~= 5 then
    speed = 3
end

local function IsReadAction(inst)
    local action = inst.bufferedaction
    return action ~= nil and action.action == ACTIONS.READ
end

local function SpeedUpFx(fx)
    if fx ~= nil and fx:IsValid() and fx.AnimState ~= nil then
        fx.AnimState:SetDeltaTimeMultiplier(speed)
    end
end

local function WrapServerBook(graph)
    local pre = graph.states.book
    local reading = graph.states.book2
    if pre == nil or reading == nil or pre.onenter == nil or reading.onenter == nil then
        return
    end

    local original_pre_enter = pre.onenter
    local original_pre_exit = pre.onexit
    pre.onenter = function(inst, ...)
        local fast = IsReadAction(inst)
        original_pre_enter(inst, ...)
        if fast and inst.sg.currentstate == pre then
            inst.sg.statemem.fastbookreading = true
            inst.AnimState:SetDeltaTimeMultiplier(speed)
            SpeedUpFx(inst.sg.statemem.book_fx)
        end
    end
    pre.onexit = function(inst, ...)
        if inst.sg.statemem.fastbookreading then
            inst.AnimState:SetDeltaTimeMultiplier(1)
        end
        if original_pre_exit ~= nil then
            return original_pre_exit(inst, ...)
        end
    end

    local original_read_enter = reading.onenter
    local original_read_exit = reading.onexit
    reading.onenter = function(inst, ...)
        local fast = IsReadAction(inst)
        original_read_enter(inst, ...)
        if not fast or inst.sg.currentstate ~= reading then
            return
        end

        local mem = inst.sg.statemem
        mem.fastbookreading = true
        inst.AnimState:SetDeltaTimeMultiplier(speed)
        SpeedUpFx(mem.book_fx)
        SpeedUpFx(mem.fx_shadow)
        SpeedUpFx(mem.fx_over)
        SpeedUpFx(mem.fx_under)

        -- Vanilla schedules a book-specific layer sound from its animation
        -- frame. Reschedule that one task at the same accelerated frame.
        local action = inst.bufferedaction
        local book = action ~= nil and (action.target or action.invobject) or nil
        local layer = book ~= nil and book.def ~= nil and book.def.layer_sound or nil
        if mem.soundtask ~= nil and layer ~= nil and layer.frame ~= nil and layer.frame > 0 then
            mem.soundtask:Cancel()
            local frameskip = mem.repeatcast and 6 or 0
            mem.soundtask = inst:DoTaskInTime(math.max(0, layer.frame - frameskip) * FRAMES / speed, function(reader)
                if reader.sg.currentstate == reading then
                    reader.sg.statemem.soundtask = nil
                    reader.SoundEmitter:KillSound("book_layer_sound")
                    reader.SoundEmitter:PlaySound(layer.sound, "book_layer_sound")
                end
            end)
        end
    end
    reading.onexit = function(inst, ...)
        if inst.sg.statemem.fastbookreading then
            inst.AnimState:SetDeltaTimeMultiplier(1)
        end
        if original_read_exit ~= nil then
            return original_read_exit(inst, ...)
        end
    end

    -- Stategraph timelines are shared by all players. Keep a vanilla event
    -- for non-READ actions and a faster copy for READ; the state-local flag
    -- remains valid after PerformBufferedAction clears the buffered action.
    local timeline = {}
    for _, event in ipairs(reading.timeline) do
        local callback = event.fn
        timeline[#timeline + 1] = TimeEvent(event.time / speed, function(inst)
            if inst.sg.statemem.fastbookreading then
                return callback(inst)
            end
        end)
        timeline[#timeline + 1] = TimeEvent(event.time, function(inst)
            if not inst.sg.statemem.fastbookreading then
                return callback(inst)
            end
        end)
    end
    table.sort(timeline, function(a, b) return a.time < b.time end)
    reading.timeline = timeline
end

local function WrapClientBook(graph)
    local pre = graph.states.book
    if pre == nil or pre.onenter == nil then
        return
    end
    local original_enter = pre.onenter
    local original_exit = pre.onexit
    pre.onenter = function(inst, ...)
        local fast = IsReadAction(inst)
        original_enter(inst, ...)
        if fast and inst.sg.currentstate == pre then
            inst.sg.statemem.fastbookreading = true
            inst.AnimState:SetDeltaTimeMultiplier(speed)
        end
    end
    pre.onexit = function(inst, ...)
        if inst.sg.statemem.fastbookreading then
            inst.AnimState:SetDeltaTimeMultiplier(1)
        end
        if original_exit ~= nil then
            return original_exit(inst, ...)
        end
    end
end

AddStategraphPostInit("wilson", WrapServerBook)
AddStategraphPostInit("wilson_client", WrapClientBook)
