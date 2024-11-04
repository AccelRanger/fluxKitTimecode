script.Parent.MouseClick:Connect(function()
	game.ServerScriptService.AccelSystemsFKTC.sessionData.recording.Value = true
	game.ReplicatedStorage.AccelSystemsFKTC.getDataServer:Fire("reset")
end)
