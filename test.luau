local a = script.Parent

a.playerSpawned:Connexct(function(plr)
 for _,v in ipairs(checlpoijts) do
  if v.Name == a.Name return else
   v:Destroy()
end)