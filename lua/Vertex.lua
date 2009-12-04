
Vertex = {
	_pdb = nil;
}

function Vertex:clone()
    local instance = setmetatable({}, { __index = Vertex })
	instance:init()
	return instance
end

function Vertex:init()
	self._pdb = PDB:clone()
end

function Vertex:open()
	self._pdb:open()
	return self
end

function Vertex:close()
	self._pdb:close()
	return self
end

function Vertex:createNodeAtPath(path)
    --return self._pdb:nodeAtPath(path)
    return self._pdb:createNodeAtPath(path)
end

function Vertex:nodeAtPath(path)
	return self._pdb:nodeAtPath(path)
end

function Vertex:handleRequest(httpRequest)

	if httpRequest._post == "" then
		self:api_view(httpRequest)
		return
	end
	
	local requests = Json.Decode(httpRequest._post)
	local results = {}
	
	self._pdb:begin()
	for i, request in pairs(requests) do
		local api_action = "api_" .. request.action
		results[i] = self[api_action](self, request)
	end
	
	httpRequest._response._content = Json.Encode(results)
	httpRequest._response._statusCode = 200
	httpRequest._response._contentType = "application/jsonrequest; charset=utf-8";
	
	self._pdb:commit()
end

function Vertex:api_mkdir(request)
    self:createNodeAtPath(request.path)
	return {}
end

function Vertex:api_rm(request)
	local node = self:nodeAtPath(request.path)
	if node == nil then 
		return {error = "invalid path"}
	end
	node:removeAt(request.key)
	return {}
end

function Vertex:api_size(request)
	local node = self:nodeAtPath(request.path)
	if node == nil then 
		return {error = "invalid path"}
	end
	return { result = node:size() }
end

function Vertex:api_link(request)
	local fromNode = self:nodeAtPath(request.path)
	if node == nil then 
		return { error = "invalid from path" }
	end
	
	local toNode = self:nodeAtPath(request.toPath)
	if node == nil then 
		return { error = "invalid to path" }
	end	
	
	toNode:write(request.key, fromNode:pid())
	return {}
end

function Vertex:api_read(request)
	local node = self:nodeAtPath(request.path)
	if node == nil then 
		return { error = "invalid path" }
	end
	
	return { result = node:read(request.key) }
end

function Vertex:api_write(request)
	local node = self:nodeAtPath(request.path)
	if node == nil then 
		return { error = "invalid path" }
	end
	
	return { result = node:write(request.key, request.value) }
end

function Vertex:api_select()
	
end

function Vertex:api_queuePopTo()
	
end

function Vertex:api_queueExpireTo()
	
end

function Vertex:api_view(httpRequest)	
	local node = self:nodeAtPath(httpRequest._uriPath)
	node:first()
	
	local s = "<html>"
	
	while node:key() do
		s = s .. node:key()  .. ": " .. node:value() .. "<br>"
		node:next()
	end
	
	s = s .. "</html>"
	
	httpRequest._response._content = s
	httpRequest._response._statusCode = 200
	httpRequest._response._contentType = "text/html; charset=utf-8";
end

