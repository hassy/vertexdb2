
PDB = {
	_tc = nil;
	_path = "default.tc";
	_rootNode = nil;
}

function PDB:clone()
    local instance = setmetatable({}, { __index = PDB })
	instance:init()
	return instance
end

function PDB:init()
	self._tc = tokyocabinet.bdbnew()
	self._rootNode = Node:clone():setPdb(self):setPid(0)
end

function PDB:setPath(path)
	self._path = path
end

function PDB:showError()
   local ecode = self._tc:ecode()
   print("error: " .. bdb:errmsg(ecode))
end

function PDB:createRootNodeIfNeeded()
	if self._rootNode:exists() then
		print("PDB root node found")
	else
		print("PDB creating root node")
		self._rootNode:setSize(0)
		self._tc:sync()
	end
end

function PDB:open()
	if not self._tc:open(self._path, self._tc.OWRITER + self._tc.OCREAT) then
	   self:showError()
	end
	self:createRootNodeIfNeeded()
end

function PDB:close()
	if not self._tc:close() then
	   self:showError()
	end
end

function PDB:at(k)
	return self._tc[k]
end

function PDB:atPut(k, v)
	self._tc[k] = v
	return self
end

function PDB:removeAt(k)
	self._tc[k] = nil
	return self
end

function PDB:nodeAtPath(path)
	return self._rootNode:nodeAtPath(path)
end

function PDB:begin()
	self._tc:tranbegin()
	return self
end

function PDB:commit()
	self._tc:trancommit()
	return self
end

function PDB:abort()
	self._tc:tranabort()
	return self
end

function PDB:newCursor()
	return tokyocabinet.bdbcurnew(self._tc)
end






