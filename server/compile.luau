--AccelRanger / Compression
local show = 1

task.wait(3)

script.Parent.MouseClick:Connect(function()
	game.ReplicatedStorage.AccelSystemsFKTC.getDataServer:Fire("get")
end)

local function tableToString(tbl)
	return game:GetService("HttpService"):JSONEncode(tbl)
end

local function stringToTable(tbl)
	return game:GetService("HttpService"):JSONDecode(tbl)
end

game.ReplicatedStorage.AccelSystemsFKTC.tableReturn.Event:Connect(function(data)
	local func = tableToString(data)
	script.Parent.Parent.SurfaceGui.Frame.TextLabel.Text = func
	
	local stringValue = Instance.new("StringValue", game.ReplicatedStorage.AccelSystemsFKTC.shows)
	stringValue.Value = func
	stringValue.Name = "SHOW"..show.."COMPRESSED"
	
	--[[
	local stringValue2 = Instance.new("StringValue", game.ReplicatedStorage.AccelSystemsFKTC.session)
	stringValue2.Value = require(game.ReplicatedStorage.AccelSystemsFKTC.Compression):compress(tableToString(data))
	stringValue2.Name = "SHOW"..show.."COMPRESSED"
	]]
	show += 1
end)
