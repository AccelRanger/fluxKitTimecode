local whitelisted = {
	["userIds"] = {
		0;
	};
	["usernames"] = {
		"AccelRanger";
		"streetlanterns"
	};
	["groups"] = {
		["groupID"] = 1;
		["minRank"] = 1;
	}
}

return function(player)
	if player.UserId == game.CreatorId then return true end
	
	if table.find(whitelisted.userIds, player.UserId) or table.find(whitelisted.usernames, player.Name) or player:GetRankInGroup(whitelisted.groups.groupID) >= whitelisted.groups.minRank then
		return true
	else
		return false
	end
end
