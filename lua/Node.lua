
Node = {
	_pdb = nil;
	_pid = 0;
	_parentNode = nil;
}

function Node:clone()
    local instance = setmetatable({}, { __index = Node })
	instance:init()
	return instance
end

function Node:init()
	self._pdb = nil;
	self._pid = 0;
	self._cursor = nil;
end

function Node:cursor()
	if self._cursor == nil then
		self._cursor = self._pdb:newCursor()
	end
	return self._cursor
end

function Node:slotKey(k) 
	return tostring(self._pid) .. "/s/" .. k 
end

function Node:metaKey(k) 
	return tostring(self._pid) .. "/m/" .. k 
end

function Node:setPdb(pdb)
	self._pdb = pdb
	return self
end

function Node:setPid(pid)
	self._pid = pid
	return self
end

function Node:pid()
	return self._pid
end

function Node:setParentNode(node)
	self._parentNode = node
	return self
end

function Node:parentNode()
	return self._parentNode
end

function Node:nodeAt(k)
	local pid = self._pdb:at(self:slotKey(k))
	if pid then
		return Node:clone():setPdb(self._pdb):setPid(pid):setParentNode(self)
	end
	return nil
end

function Node:createNodeAt(k)
	local node = self:nodeAt(k)
	if node == nil then
		node = Node:clone():setPdb(self._pdb):create()
		self:write(k, node:pid())
	end
	return node
end

function Node:nodeAtPath(path)
	local node = self
	if path == "" then
		return node
	end
	
	for i, k in pairs(pathComponents(path)) do
		if k then
			local nextNode = self:nodeAt(k)
			if nextNode == nil then 
				return nil 
			end
			node = nextNode
		end
	end
	
	return node
end

function Node:createNodeAtPath(path)
	local node = self

	for i, k in pairs(pathComponents(path)) do
		if k then
		    local nextNode = self:nodeAt(k)
			if nextNode == nil then 
				nextNode = self:createNodeAt(k)
				
			end
			node = nextNode
		end
	end
	
	return node
end


function Node:newPid()
	local maxPid = math.pow(2, 30)
	while 1 do
		self._pid = math.floor(math.random(maxPid))
		if self._pdb:at(self:metaKey("size")) == nil then
			break
		end
	end
end

function Node:exists()
	return self._pdb:at(self:metaKey("size")) ~= nil
end

function Node:create()
	self:newPid()
	self._pdb:atPut(self:metaKey("size"), "0")
	return self
end

function Node:remove(k)
	self._pdb:removeAt(self:slotKey(k))
end

function Node:size()
	local size = self._pdb:at(self:metaKey("size"))
	if size then
	    return tonumber(size)
	end
	return nil
end

function Node:setSize(size)
	if size >=0 then
		self._pdb:atPut(self:metaKey("size"), tostring(size))
	else
		print("Node error: attempt to set negative size")
	end
	return self
end

function Node:incrementSize()
	self:setSize(self:size() + 1)
	return self
end

function Node:decrementSize()
	self:setSize(self:size() - 1)
end

function Node:link(k, toPath)
	local node = self._pdb:nodeAtPath(toPath)
	
	if node then
		self._pdb:atPut(self:metaKey(k), node:pid())
		return self
	end
	
	return nil
end

function Node:read(k)
	return self._pdb:at(self:slotKey(k))
end

function Node:hasKey(k)
	return (self:read(k) ~= nil)
end

function Node:write(k, v)
	local hadKey = self:hasKey(k)
	
	self._pdb:atPut(self:slotKey(k), tostring(v))
	
	if hadKey then 
		self:incrementSize() 
	end
end

function Node:removeAt(k)
	local hadKey = self:hasKey(k)
	self._pdb:removeAt(self:slotKey(k))
	
	if hadKey then
		self:decrementSize()
	end
	
	return self
end

function Node:first()
	self:cursor():jump(self:metaKey(""))
end

function Node:jump(k)
	self:cursor():jump(self:slotKey(k))
end

function Node:next()
	self:cursor():next()
end

function Node:previous()
	self:cursor():prev()
end

function Node:key()
	local k = self:cursor():key()
	local prefix = self._pid .. "/s/"
	
	if string.find(k, prefix) == 1 then
		return string.sub(k, string.len(prefix))
	end
	
	return nil
end

function Node:value()
	self:cursor():val()
end

