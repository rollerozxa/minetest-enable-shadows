
local S = core.get_translator('enable_shadows')
local storage = core.get_mod_storage()

local default_intensity = tonumber(core.settings:get("enable_shadows_default_intensity") or 0.33)
local intensity = tonumber(storage:get("intensity") or default_intensity)

core.register_on_joinplayer(function(player)
	player:set_lighting({
		shadows = { intensity = intensity }
	})
end)

core.register_chatcommand("shadow_intensity", {
	params = "<shadow_intensity>",
	description = S("Set shadow intensity for the current world."),
	func = function(name, param)
		local new_intensity
		if param ~= "" then
			new_intensity = tonumber(param) or nil
		else
			new_intensity = tonumber(default_intensity) or nil
		end

		if new_intensity < 0 or new_intensity > 1 or new_intensity == nil then
			core.chat_send_player(name, core.colorize("#ff0000", S("Invalid intensity.")))
			return true
		end

		if new_intensity ~= default_intensity then
			core.chat_send_player(name, S("Set intensity to @1.", new_intensity))
			storage:set_float("intensity", new_intensity)
		else
			core.chat_send_player(name, S("Set intensity to default value (@1).", default_intensity))
			storage:set_string("intensity", "")
		end

		intensity = new_intensity
		for _,player in pairs(core.get_connected_players()) do
			player:set_lighting({
				shadows = { intensity = new_intensity }
			})
		end
	end
})
