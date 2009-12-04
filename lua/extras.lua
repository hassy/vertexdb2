--print(BDB)
require("tokyocabinet")

function showTable(t, tab)
	for k,v in pairs(t) do 
		if type(v) == "table" then
			print(tab, k, ":") 
			showTable(v, tab .. "  ")
		else
			print(tab, k, ":", v)
		end
	end
end

function lines(str)
	local t = {}
	local function helper(line) table.insert(t, line) return "" end
	helper((str:gsub("(.-)\r?\n", helper)))
	return t
end

function pathComponents(str)
	local t = {}
	local function helper(line) table.insert(t, line) return "" end
	helper((str:gsub("(.-)\r?/", helper)))
	table.remove(t, 1)
	return t
end

--for i, v in pairs(pathComponents("/a/b/c")) do
--	print("component: " .. i .. " : " .. v)
--end