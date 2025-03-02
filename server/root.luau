--AccelRanger

local config = script.Parent.Configuration
local sessiondata = script.Parent.sessionData

game.ReplicatedStorage.AccelSystemsFKTC.session.folder.Value = config.folder.Value
script.Parent.GUI.loader.Parent = game.StarterGui
config.whitelist:Clone().Parent = game.ReplicatedStorage.AccelSystemsFKTC

local config = script.Parent.Configuration
local logTable = {}
local whitelist = require(config.whitelist)
local compressModule = require(game.ReplicatedStorage.AccelSystemsFKTC.lib.ColourModule)
local warnModule = require(game.ReplicatedStorage.AccelSystemsFKTC.lib.WarningModule)
local lastEventTime = os.clock()
local sound = Instance.new("Sound", game.SoundService)
sound.Name = "AccelSystemsFKTC"

local gitVersion = require(84432237552644)()
local ver = "V1.3"

local selectedSong = nil

local showfile = {}

task.wait(2)
print("" .. "\n" .. "--------- AccelSystems FKTC ---------" .."" .. "\n" .. "\n" .. "Booting." .. "\n" .. "Getting Shows" .. "\n" .. "LOADED!" .. "\n" .. "" .. "\n" .. "--------- AccelSystems FKTC ---------")

function init()
	if not config:FindFirstChild("folder") or config.folder.Value == nil then
		warnModule.Warn("exiting server code, returning nil", "ERROR 001","Configuration>folder >> Does not exist, or value is invalid.")
	elseif config:FindFirstChild("compilerDebug").Value == true then
		print("AccelSystems FKTC Compiler Debug State: true")--..config.compilerDebug.Value)
	elseif ver ~= gitVersion then
		warnModule.Warn("Outdated version","ERROR 002", "Please use our newest version, Current version: "..ver.." Published version: "..gitVersion)
	end
end

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
		
		if config.compilerDebug.Value == true then
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

game.Workspace.AccelSystemsFKTC.remotes.getData.OnServerInvoke = function(player)
	return showfile
end

game.Workspace.AccelSystemsFKTC.remotes.clientData.OnServerInvoke = function(player, arg)
	if arg == "showfile" then
		return showfile
	elseif arg == "outputlog" then
		if game.ReplicatedStorage.AccelSystemsFKTC.debug.Value == true then print(logTable) end
		return logTable
	end
end

game.Workspace.AccelSystemsFKTC.remotes.getDataClient.OnServerEvent:Connect(function(player, arg)
	if whitelist(player) == true then
		if arg == "clear" then
			table.clear(showfile)
		elseif arg == "startRecording" then
			script.Parent.sessionData.recording.Value = true
		elseif arg == "stopRecording" then
			script.Parent.sessionData.recording.Value = false
		end
	end
end)

game.Workspace.AccelSystemsFKTC.remotes.getDataServer.Event:Connect(function(arg)
	if arg == "get" then
		game.Workspace.AccelSystemsFKTC.remotes.tableReturn:Fire(showfile)
	elseif arg == "clear" then
		table.clear(showfile)
	elseif arg == "reset" then
		lastEventTime = os.clock()
	end
end)

game.Workspace.AccelSystemsFKTC.remotes.createShow.OnServerEvent:Connect(function(player,name, data)
	if whitelist(player) == true then
		local stringValue = Instance.new("StringValue", game.ReplicatedStorage.AccelSystemsFKTC.shows)
		stringValue.Value = data
		stringValue.Name = name
	end
end)

game.Workspace.AccelSystemsFKTC.remotes.logAction.OnServerEvent:Connect(function(player,action)
	local msg 
	
	if action == "play" then
		msg = player.Name.." has started the playback.."
	elseif action == "startRecording" then
		msg = player.Name.." has started recording showfile."
	elseif action == "stopRecording" then
		msg = player.Name.." has stopped recording showfile."
	elseif action == "clear" then
		msg = player.Name.." has cleared the showfile."
	elseif action == "compress" then
		msg = player.Name.." has compressed the showfile."
	end
 	
	table.insert(logTable, msg)
end)

game.Workspace.AccelSystemsFKTC.remotes.selectSong.OnServerEvent:Connect(function(player, NAME, ID)
	selectedSong = {NAME, ID}
end)

game.Workspace.AccelSystemsFKTC.remotes.soundRemote.OnServerEvent:Connect(function(player, NAME, ID)
	sound.SoundId = "rbxassetid://"..ID
	sound:Play()
end)

game.ServerScriptService.AccelSystemsFKTC.sessionData.recording.Changed:Connect(function(VALUE)
	if VALUE == true and selectedSong ~= nil then
		sound.SoundId = "rbxassetid://"..selectedSong[2]
		sound:Play()
		
		logEvent("functions", selectedSong[1], selectedSong[2], "sound")
		
	elseif VALUE == false then
		sound:Stop()
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
		logEvent("functions", arg1, arg2, arg3, arg4, compressedString) -- colors work
	end
end)

-- initiliaze

init()
