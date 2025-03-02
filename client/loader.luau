--AccelRanger / main loader for panels

task.wait(2)

if require(game.ReplicatedStorage.AccelSystemsFKTC.whitelist)(game.Players.LocalPlayer) == true then
	for _, v in pairs(game.Workspace:FindFirstChild("AccelSystemsFKTC").panels:GetChildren()) do
		if v:FindFirstChild("load") then
			v.load:Destroy()
		end

		local clone = script.gui:Clone()
		clone.Adornee = v
		clone.Parent = script.loadedGUI
		clone.root.Enabled = true
	end
else
	for _,v in pairs(game.Workspace.AccelSystemsFKTC:GetDescendants()) do
		if v:HasTag("FKTC_PANEL") then
			v.load.main.core.txt1.Text = "AccelSystems: Flux Kit Timecode System" -- You can change this / heading of error message
			v.load.main.core.txt2.Text = "User is not whitelisted." -- You can change this / description of error message
		end
	end
	script:Destroy()
end
