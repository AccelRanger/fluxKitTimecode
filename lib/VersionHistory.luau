--[[


░█████╗░░█████╗░░█████╗░███████╗██╗░░░░░░██████╗██╗░░░██╗░██████╗████████╗███████╗███╗░░░███╗░██████╗
██╔══██╗██╔══██╗██╔══██╗██╔════╝██║░░░░░██╔════╝╚██╗░██╔╝██╔════╝╚══██╔══╝██╔════╝████╗░████║██╔════╝
███████║██║░░╚═╝██║░░╚═╝█████╗░░██║░░░░░╚█████╗░░╚████╔╝░╚█████╗░░░░██║░░░█████╗░░██╔████╔██║╚█████╗░
██╔══██║██║░░██╗██║░░██╗██╔══╝░░██║░░░░░░╚═══██╗░░╚██╔╝░░░╚═══██╗░░░██║░░░██╔══╝░░██║╚██╔╝██║░╚═══██╗
██║░░██║╚█████╔╝╚█████╔╝███████╗███████╗██████╔╝░░░██║░░░██████╔╝░░░██║░░░███████╗██║░╚═╝░██║██████╔╝
╚═╝░░╚═╝░╚════╝░░╚════╝░╚══════╝╚══════╝╚═════╝░░░░╚═╝░░░╚═════╝░░░░╚═╝░░░╚══════╝╚═╝░░░░░╚═╝╚═════╝░


Scripted by: AccelRanger

Core: Version Fetcher
Description: Gets the current version

--]]

-- AccelRanger / VERSION UPDATER

return function()
	-- Get module version async
	local HttpService = game:GetService("HttpService")
	local Endpoint = "https://raw.githubusercontent.com/AccelRanger/fluxKitTimecode/refs/heads/main/version.txt"
	local success, result = pcall(function()
		return HttpService:GetAsync(Endpoint)
	end)

	if success then
		return result
	else
		warn("Failed to retrieve data from the endpoint: " .. result)
	end
end
