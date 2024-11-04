--AccelRanger

local config = script.Parent.Configuration
local sessiondata = script.Parent.sessionData
--script.AccelSystemsFKTC.Parent = game.ReplicatedStorage

game.Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(msg)
		if msg == "/showpanel" then
			local gui = script.Parent.GUI.showpanel:Clone()
			gui.Parent = player.PlayerGui
		end
	end)
end)

game.ReplicatedStorage.AccelSystemsFKTC.session.folder.Value = config.folder.Value

warn("Loading AccelSystems Flux Kit Decompiler")
task.wait(5)
warn("Loaded succesfully")

local config = script.Parent.Configuration
local whitelist = require(config.whitelist)
local compressModule = require(game.ReplicatedStorage.AccelSystemsFKTC.lib.ColourModule)
local lastEventTime = os.clock()

local showfile = {}

local function logEvent(eventType, arg1, arg2, arg3, arg4, arg5)
	if script.Parent.sessionData.recording.Value == true then
		local currentTime = os.clock()
		local delay = currentTime - lastEventTime
		lastEventTime = currentTime

		table.insert(showfile, {
			eventType = eventType,
			Function = arg1,
			Arguments = arg2,
			ExternalArgument = arg3,
			FunctionsExpand = arg4,
			ColorCompressed = arg5,
			Delay = delay
		})
		
		if arg3 == nil then arg3 = "Returned nil" end;if arg4 == nil then arg4 = "Returned nil" end;if arg5 == nil then arg5 = "Returned nil" end
		
		if config.debug.Value == true then
			warn("--- "..eventType.." ---")
			print(arg1)
			print(arg2)
			print(arg3)
			print(arg4)
			print(arg5)
			print("Delay: " ..delay)
			warn("----------------------------")
		end
	end
end

-- events

game.ReplicatedStorage.AccelSystemsFKTC.getData.OnServerInvoke = function(player)
	return showfile
end

game.ReplicatedStorage.AccelSystemsFKTC.getDataClient.OnServerEvent:Connect(function(player, arg)
	if whitelist(player) == true then
		if arg == "clear" then
			table.clear(showfile)
		end
	end
end)

game.ReplicatedStorage.AccelSystemsFKTC.getDataServer.Event:Connect(function(arg)
	if arg == "get" then
		game.ReplicatedStorage.AccelSystemsFKTC.tableReturn:Fire(showfile)
	elseif arg == "clear" then
		table.clear(showfile)
	elseif arg == "reset" then
		lastEventTime = os.clock()
	end
end)

-- logging

config.folder.Value.direct.effects.OnServerEvent:Connect(function(player, arg1, arg2)
	logEvent("effects", arg1, arg2) -- works
end)

config.folder.Value.direct.faders.OnServerEvent:Connect(function(player, arg1, arg2)
	logEvent("faders", arg1, arg2) -- works
end)

config.folder.Value.direct.pyrotechnics.OnServerEvent:Connect(function(player, arg1, arg2, arg3)
	logEvent("pyrotechnics", arg1, arg2, arg3) -- works
end)

config.folder.Value.direct.status.OnServerEvent:Connect(function(player, arg1, arg2)
	logEvent("status", arg1, arg2) -- works
end)

config.folder.Value.call.functions.OnServerEvent:Connect(function(player, arg1, arg2, arg3, arg4, arg5)
	if arg4 == nil then
		logEvent("functions", arg1, arg2, arg3) -- works
	else
		local compressedString = compressModule.compressColor3Table(arg5)
		logEvent("functions", arg1, arg2, arg3, arg4, compressedString) -- colors dont work
	end
end)

if config.TextChatServiceCommand.Value == true then
	local cmd = Instance.new("TextChatCommand", game.TextChatService)
	cmd.Name = "Showpanel"
	cmd.PrimaryAlias = "showpanel"
end
