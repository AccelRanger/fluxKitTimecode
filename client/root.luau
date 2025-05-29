--[[


░█████╗░░█████╗░░█████╗░███████╗██╗░░░░░░██████╗██╗░░░██╗░██████╗████████╗███████╗███╗░░░███╗░██████╗
██╔══██╗██╔══██╗██╔══██╗██╔════╝██║░░░░░██╔════╝╚██╗░██╔╝██╔════╝╚══██╔══╝██╔════╝████╗░████║██╔════╝
███████║██║░░╚═╝██║░░╚═╝█████╗░░██║░░░░░╚█████╗░░╚████╔╝░╚█████╗░░░░██║░░░█████╗░░██╔████╔██║╚█████╗░
██╔══██║██║░░██╗██║░░██╗██╔══╝░░██║░░░░░░╚═══██╗░░╚██╔╝░░░╚═══██╗░░░██║░░░██╔══╝░░██║╚██╔╝██║░╚═══██╗
██║░░██║╚█████╔╝╚█████╔╝███████╗███████╗██████╔╝░░░██║░░░██████╔╝░░░██║░░░███████╗██║░╚═╝░██║██████╔╝
╚═╝░░╚═╝░╚════╝░░╚════╝░╚══════╝╚══════╝╚═════╝░░░░╚═╝░░░╚═════╝░░░░╚═╝░░░╚══════╝╚═╝░░░░░╚═╝╚═════╝░


Scripted by: AccelRanger

Core: Client GUI
Description: Client Panel handler

--]]

task.wait(1)
local shows = game.ReplicatedStorage.AccelSystemsFKTC.shows
local songs = game.ReplicatedStorage.AccelSystemsFKTC.songs
local localPlayer = game.Players.LocalPlayer
local show = 1
local logTable = {}

print("" .. "\n" .. "--------- AccelSystems FKTC ---------" .. "\n" .. "" .. "\n" .. "Running client/root" .. "\n" .. "Extracting GUI" .. "\n" .. "Processing whitelist" .. "\n" .. "UserID: "..game.Players.LocalPlayer.UserId .. "\n" .. "User: "..game.Players.LocalPlayer.Name .. "\n" .. "" .. "\n" .."--------- AccelSystems FKTC ---------")

local showRunning = false

local remoteFolder = game.ReplicatedStorage:FindFirstChild("AccelSystemsFKTC").session.folder.Value
local compressModule = require(game.ReplicatedStorage.AccelSystemsFKTC.lib.ColourModule)

local remotes = {
	effects = remoteFolder.direct.effects,
	faders = remoteFolder.direct.faders,
	pyrotechnics = remoteFolder.direct.pyrotechnics,
	status = remoteFolder.direct.status,
	functions = remoteFolder.call.functions
}

local gui = script.Parent.main
local templates = script.templates
local showGUI = gui.core.shows
local songGUI = gui.core.songs
local outputGUI = gui.core.output

local clickSound = Instance.new("Sound")
clickSound.Parent = game:GetService("SoundService")
clickSound.SoundId = "rbxassetid://6976440355"
clickSound.Name = "FKTC_UI_SOUNDS_C"

local playSound = Instance.new("Sound")
playSound.Parent = game:GetService("SoundService")
playSound.SoundId = "rbxassetid://97367190838793"
playSound.Name = "FKTC_UI_SOUNDS_P"

local errorSound = Instance.new("Sound")
errorSound.Parent = game:GetService("SoundService")
errorSound.SoundId = "rbxassetid://3429876367"
errorSound.Name = "FKTC_UI_SOUNDS_E"

--functions
local function processShowfile(showfile)
	print("running stack: processShowfile")
	for _, event in pairs(showfile) do
		local eventType = event.eventType
		local arg1 = event.Function
		local arg2 = event.Arguments
		local arg3 = event.ExternalArgument
		local arg4 = event.FunctionsExpand
		local arg5 = event.ColorCompressed

		if game.ReplicatedStorage.AccelSystemsFKTC.debug.Value == true then print("waiting: "..event.Delay) end
		task.wait(event.Delay)

		if remotes[eventType] then
			if eventType == "functions" or eventType == "pyrotechnics" then
				if arg4 == nil then
					if arg3 == "sound" then
						game.Workspace.AccelSystemsFKTC.remotes.soundRemote:FireServer(arg1, arg2)
					else
						remotes[eventType]:FireServer(arg1, arg2, arg3)
					end
				else
					local compressedColor = compressModule.decompressColor3String(arg5)
					remotes[eventType]:FireServer(arg1, arg2, arg3, arg4, compressedColor)
				end
			else
				remotes[eventType]:FireServer(arg1, arg2)
			end
		else
			warn("No remote found for event type: "..eventType)
		end
	end
	--showRunning = true
end

--[[

Arg1> sound name
Arg2> sound id
Arg3> type

--]]

local function tableToString(tbl)
	return game:GetService("HttpService"):JSONEncode(tbl)
end

local function stringToTable(tbl)
	return game:GetService("HttpService"):JSONDecode(tbl)
end

local function logAction(action)
	game.Workspace.AccelSystemsFKTC.remotes.logAction:FireServer(action)
end

local function createShow(name, data)
	game.Workspace.AccelSystemsFKTC.remotes.createShow:FireServer(name, data)
end

local function selectSong(name, id)
	game.Workspace.AccelSystemsFKTC.remotes.selectSong:FireServer(name, id)
	gui.core.songSelected.Text = "Song Selected: "..name
end

local function userWarning(header,text)
	--warn(header, text)
	script.Parent.main.top.msg.Text = header..": "..text
	task.wait(3)
	script.Parent.main.top.msg.Text = "Flux Kit Timecode System"
end

local function changeFrame(frame)
	clickSound:Play()
	for _,v in pairs(gui.core:GetChildren()) do
		if v:IsA("Frame") then
			if v.Name == frame then
				v.Visible = true
			else
				v.Visible = false
			end
		end
	end

	if frame == "output" then
		for _,v in pairs(outputGUI.frame:GetChildren()) do
			if v:IsA("Frame") and v.Name ~= "spacer" then
				v:Destroy()
			end
		end

		for _,v in pairs(game.Workspace.AccelSystemsFKTC.remotes.clientData:InvokeServer("outputlog")) do
			local clone = templates.logTemplate:Clone()
			clone.log.Text = v
			clone.Parent = outputGUI.frame
		end
	elseif frame == "shows" then
		for _,v in pairs(showGUI.frame:GetChildren()) do
			if v:IsA("Frame") and v.Name ~= "spacer" then
				v:Destroy()
			end
		end

		for _,v in pairs(shows:GetChildren()) do
			local clone = templates.showTemplate:Clone()
			clone.Name = v.Name
			clone.showName.Text = v.Name
			clone.Parent = showGUI.frame
		end

		for _,v in pairs(showGUI.frame:GetChildren()) do
			if v:IsA("Frame") then
				if v.Name ~= "spacer" then
					v.playShow.MouseButton1Up:Connect(function()
						for _,value in pairs(shows:GetChildren()) do
							if v.Name == value.Name then
								playSound:Play()
								coroutine.wrap(function()
									userWarning("Playback System", "Running showfile / If not started run the show again.")
								end)()

								logAction("play")

								local showfileProcessed = stringToTable(value.Value)
								coroutine.wrap(function()
									userWarning("Playback System", "Decompressing table, this might take a while.")
								end)()
								errorSound:Play()
								processShowfile(showfileProcessed) -- runs the show
							end
						end
					end)
				end
			end
		end
	end

	gui.core.selected.Text = "Selected: "..frame
end

--setup
for _,v in pairs(shows:GetChildren()) do --shows
	local clone = templates.showTemplate:Clone()
	clone.Name = v.Name
	clone.showName.Text = v.Name
	clone.Parent = showGUI.frame
end

for _,v in pairs(songs:GetChildren()) do --songs
	local clone = templates.songTemplate:Clone()
	clone.Name = v.Name
	clone.songName.Text = v.Name
	clone.Parent = songGUI.frame
end

--logic

gui.core.outputBT.MouseButton1Up:Connect(function() changeFrame("output") end)
gui.core.showsBT.MouseButton1Up:Connect(function() changeFrame("shows") end)
gui.core.songsBT.MouseButton1Up:Connect(function() changeFrame("songs") end)

--shows
for _,v in pairs(showGUI.frame:GetChildren()) do
	if v:IsA("Frame") then
		if v.Name ~= "spacer" then
			v.playShow.MouseButton1Up:Connect(function()
				clickSound:Play()
				for _,value in pairs(shows:GetChildren()) do
					if v.Name == value.Name then
						userWarning("Playback System", "Started showfile playback.")
						logAction("play")

						local showfileProcessed = stringToTable(value.Value)
						processShowfile(showfileProcessed)
					end
				end
			end)
		end
	end
end

--songs
for _,v in pairs(songGUI.frame:GetChildren()) do
	if v:IsA("Frame") then
		if v.Name ~= "spacer" then
			v.selectSong.MouseButton1Up:Connect(function()
				clickSound:Play()
				for _,value in pairs(songs:GetChildren()) do
					if v.Name == value.Name then
						if showRunning == false then
							selectSong(value.Name, value.Value)
						else
							userWarning("Sound System", "Showfile is running!")
						end
					end
				end
			end)
		end
	end
end

gui.core.compress.MouseButton1Up:Connect(function()
	clickSound:Play()
	local data = game.Workspace.AccelSystemsFKTC.remotes.clientData:InvokeServer("showfile")
	local func = tableToString(data)
	createShow("SHOW"..show.."COMPRESSED", func)
	logAction("compress")
	show += 1
end)

gui.core.startRecording.MouseButton1Up:Connect(function()
	clickSound:Play()
	game.Workspace.AccelSystemsFKTC.remotes.getDataClient:FireServer("startRecording")
	logAction("startRecording")
end)

gui.core.stopRecording.MouseButton1Up:Connect(function()
	clickSound:Play()
	game.Workspace.AccelSystemsFKTC.remotes.getDataClient:FireServer("stopRecording")
	logAction("stopRecording")
end)

gui.core.clear.MouseButton1Up:Connect(function()
	clickSound:Play()
	game.Workspace.AccelSystemsFKTC.remotes.getDataClient:FireServer("clear")
	logAction("clear")
end)
