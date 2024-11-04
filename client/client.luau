--AccelRanger

task.wait(2)

local remoteFolder = script.folder.Value.session.folder.Value

local remotes = {
	effects = remoteFolder.direct.effects,
	faders = remoteFolder.direct.faders,
	pyrotechnics = remoteFolder.direct.pyrotechnics,
	status = remoteFolder.direct.status,
	functions = remoteFolder.call.functions
}

local compressModule = require(game.ReplicatedStorage.AccelSystemsFKTC.lib.ColourModule)

local function processShowfile(showfile)
	for _, event in ipairs(showfile) do
		local eventType = event.eventType
		local arg1 = event.Function
		local arg2 = event.Arguments
		local arg3 = event.ExternalArgument
		local arg4 = event.FunctionsExpand
		local arg5 = event.ColorCompressed

		--print("waiting:",event.Delay)
		task.wait(event.Delay)
		if remotes[eventType] then
			if eventType == "functions" or eventType == "pyrotechnics" then
				if arg4 == nil then
					remotes[eventType]:FireServer(arg1, arg2, arg3)
				else
					local compressedColor = compressModule.decompressColor3String(arg5)
					
					remotes[eventType]:FireServer(arg1, arg2, arg3, arg4, compressedColor)
				end
			else
				remotes[eventType]:FireServer(arg1, arg2)
			end
		else
			warn("No remote found for event type: " .. eventType)
		end
	end
end

local function tableToString(tbl)
	return game:GetService("HttpService"):JSONEncode(tbl)
end

local function stringToTable(tbl)
	return game:GetService("HttpService"):JSONDecode(tbl)
end

script.Parent.MouseButton1Up:Connect(function()
	local showfile = script.showfile.Value.Value
	processShowfile(stringToTable(showfile))
end)
