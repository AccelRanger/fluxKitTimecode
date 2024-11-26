task.wait(2)

if require(game.ReplicatedStorage.AccelSystemsFKTC.whitelist)(game.Players.LocalPlayer) == true then
	for _,v in pairs(game.Workspace:FindFirstChild("AccelSystemsFKTC").panels:GetChildren()) do
		v.load:Destroy()
		
		local clone = script.gui:Clone()
		clone.Adornee = v
		clone.Parent = script.loadedGUI
		clone.root.Enabled = true
	end
else
	script:Destroy()
end
