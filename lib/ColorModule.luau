--[[


░█████╗░░█████╗░░█████╗░███████╗██╗░░░░░░██████╗██╗░░░██╗░██████╗████████╗███████╗███╗░░░███╗░██████╗
██╔══██╗██╔══██╗██╔══██╗██╔════╝██║░░░░░██╔════╝╚██╗░██╔╝██╔════╝╚══██╔══╝██╔════╝████╗░████║██╔════╝
███████║██║░░╚═╝██║░░╚═╝█████╗░░██║░░░░░╚█████╗░░╚████╔╝░╚█████╗░░░░██║░░░█████╗░░██╔████╔██║╚█████╗░
██╔══██║██║░░██╗██║░░██╗██╔══╝░░██║░░░░░░╚═══██╗░░╚██╔╝░░░╚═══██╗░░░██║░░░██╔══╝░░██║╚██╔╝██║░╚═══██╗
██║░░██║╚█████╔╝╚█████╔╝███████╗███████╗██████╔╝░░░██║░░░██████╔╝░░░██║░░░███████╗██║░╚═╝░██║██████╔╝
╚═╝░░╚═╝░╚════╝░░╚════╝░╚══════╝╚══════╝╚═════╝░░░░╚═╝░░░╚═════╝░░░░╚═╝░░░╚══════╝╚═╝░░░░░╚═╝╚═════╝░


Scripted by: AccelRanger

Core: Colour Compression
Description: Compresses Color3 information into a special type

--]]

--AccelRanger / If your reading this confi I had to make this because of you :)
local module = {}

function module.compressColor3Table(tbl)
	local result = {}
	for _, color in pairs(tbl) do
		table.insert(result, color.R)
		table.insert(result, color.G)
		table.insert(result, color.B)
	end
	return table.concat(result, ",")
end

-- compressColor3Table(table) -- Output: "0,0,0,0,0,0"

function module.decompressColor3String(str)
	local result = {}
	local values = {}
	for value in string.gmatch(str, "([^,]+)") do
		table.insert(values, tonumber(value))
	end

	local index = 1
	for i = 1, #values, 3 do
		result[index] = Color3.new(values[i], values[i+1], values[i+2])
		index = index + 1
	end
	return result
end

--decompressColor3String(string) -- Output {[1] = 0,0,0, [2] = 0,0,0}

return module
