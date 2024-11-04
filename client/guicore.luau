local shows = game.ReplicatedStorage.AccelSystemsFKTC.shows
local player = game.Players.LocalPlayer

script.Parent.main.close.MouseButton1Up:Connect(function()
	script.Parent:Destroy()
end)

for _,v in pairs(shows:GetChildren()) do
	local clone = script.templates.template:Clone()
	clone.name.Text = v.Name
	clone.run.client.showfile.Value = v
	clone.Parent = script.Parent.main.load
end
