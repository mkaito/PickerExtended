--[vehicle.lua]] -- Vehicle related scripts.

local Player = require("stdlib.event.player")

local HONK_COOLDOWN = 120

local honk_states = {
    [defines.train_state.on_the_path] = true,
    [defines.train_state.arrive_station] = true,
    [defines.train_state.arrive_signal] = true
}

local ts = {
    wait_station = defines.train_state.wait_station,
    no_path = defines.train_state.no_path,
    no_schedule = defines.train_state.no_schedule,
    manual = defines.train_state.manual_control
}

local available_ts = {
    [defines.train_state.no_schedule] = true,
    [defines.train_state.no_path] = true
}

-- Is the train available for automatic to manual control.
local function available_train(train)
    return available_ts[train.state] or (train.state == ts.wait_station and #train.schedule.records == 1)
end

-- When entering a train if it is in automatic and waiting at a station, or has no schedule or path
-- then set to manual mode.
local function on_player_driving_changed_state(event)
    local player = game.players[event.player_index]
    if player.vehicle and player.vehicle.train and player.mod_settings["picker-auto-manual-train"].value then
        local train = player.vehicle.train
        --Set train to manual
        if #train.passengers == 1 and available_train(train) then
            player.vehicle.train.manual_mode = true
            player.vehicle.surface.create_entity {
                name = "flying-text",
                text = {"vehicles.manual-mode"},
                position = player.vehicle.position,
                color = defines.color.green
            }
        end
    end
end
Event.register(defines.events.on_player_driving_changed_state, on_player_driving_changed_state)

-- Hotkey for toggling a train between automatic and manual.
local function toggle_train_control(event)
    local player = game.players[event.player_index]
    if player.vehicle and player.vehicle.train and not (player.selected and player.selected.type == "train-stop") then
        player.vehicle.train.manual_mode = not player.vehicle.train.manual_mode
        local text = player.vehicle.train.manual_mode and {"vehicles.manual-mode"} or {"vehicles.automatic-mode"}
        player.vehicle.surface.create_entity {
            name = "flying-text",
            text = text,
            position = player.vehicle.position,
            color = defines.color.green
        }
    end
end
Event.register("picker-toggle-train-control", toggle_train_control)

-- Hotkey while selecting a station will tell the train to go to that station if
-- the train has 1 or fewer stations.
local function goto_station(event)
    local player = game.players[event.player_index]
    if player.selected and player.selected.type == "train-stop" then
        local train = player.vehicle and player.vehicle.train
        local stop = player.selected
        if train and (train.schedule and #train.schedule.records or 0) <= 1 then
            train.schedule = {
                current = 1,
                records = {
                    [1] = {time_to_wait = 999, station = stop.backer_name}
                }
            }
            train.manual_mode = false
        end
    end
end
Event.register("picker-goto-station", goto_station)

-- Create a custom alert to help find the last car you were in.
local function wheres_my_car(event)
    local player, pdata = Player.get(event.player_index)
    if not event.input and player.vehicle and player.vehicle.type == "car" then
        pdata.last_car = player.vehicle
    elseif player.selected and player.selected.type == "car" then
        pdata.last_car = player.selected
    elseif event.input_name and pdata.last_car and pdata.last_car.valid then
        player.add_custom_alert(
            pdata.last_car,
            {type = "item", name = pdata.last_car.name},
            {"vehicles.dude-wheres-my-car"},
            true
        )
    end
end
Event.register({"picker-dude-wheres-my-car", defines.events.on_player_driving_changed_state}, wheres_my_car)

-- Trains honk when in automatic mode when starting or stopping.
local function attempt_honk(event)
    if honk_states[event.train.state] and settings.global["picker-train-honk"].value then
        local honk = event.name == defines.train_state.on_the_path and "deltic-start" or "deltic-stop"
        local entity
        if (global.recently_honked[event.train.id] or event.tick) <= event.tick then
            if event.train.speed >= 0 and #event.train.locomotives.front_movers > 0 then
                entity = event.train.locomotives.front_movers[1]
            elseif event.train.speed <= 0 and #event.train.locomotives.back_movers > 0 then
                entity = event.train.locomotives.back_movers[#event.train.locomotives.back_movers]
            end
            global.recently_honked[event.train.id] = event.tick + HONK_COOLDOWN
            if entity then
                return entity.surface.play_sound {
                    path = honk,
                    position = entity.position,
                    volume = 1
                }
            end
        end
    end
end
Event.register(defines.events.on_train_changed_state, attempt_honk)

-- Hotkey for manually honking a vehicle train.
local function manual_honk(event)
    local player = game.players[event.player_index]
    if player.vehicle then
        if player.vehicle.type == "locomotive" and player.vehicle.train.manual_mode then
            local train = player.vehicle.train
            local loco = player.vehicle
            if train.speed == 0 then
                loco.surface.play_sound {
                    path = "deltic-start",
                    position = loco.position,
                    volume = 1
                }
            else
                loco.surface.play_sound {
                    path = "deltic-stop",
                    position = loco.position,
                    volume = 1
                }
            end
        else
            local veh = player.vehicle
            if veh.name:find("tank") then
                veh.surface.play_sound {
                    path = "train-long",
                    position = veh.position,
                    volume = 1
                }
            else
                veh.surface.play_sound {
                    path = "car-horn",
                    position = veh.position,
                    volume = 1
                }
            end
        end
    end
end
Event.register("picker-honk", manual_honk)

local function init()
    global.recently_honked = global.recently_honked or {}
end
Event.register(Event.core_events.init_and_config, init)
