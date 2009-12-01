--print(BDB)

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

showTable(BDB, "  ")

root = {}

function slotName()
	return tostring(math.floor(math.random()*100))
end

for i=1,1000000 do 
	local row = {}
	for i=1, 10 do
		if math.random() > .5 then
			row[slotName()] = tostring(math.random())
		else
			row[slotName()] = root
		end
	end

	root[math.random()] = row
end



function HttpHandleRequest(uriPath, post)
	return 'Hello World from Lua5.1 ' .. arg
end