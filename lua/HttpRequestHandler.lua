
path = "../../lua/"
dofile(path .. "extras.lua")
dofile(path .. "Json.lua")
dofile(path .. "PDB.lua")
dofile(path .. "Node.lua")
dofile(path .. "Vertex.lua")

print(Json)

HttpResponse = {
	_contentType = "text/html; charset=utf-8";
	_content = "sampleContent\n"; 
	_statusCode = 200;
	_cookie = "";
}

HttpRequest = {
	_params = {};
	_uriPath = "";
	_post = "";
	_response = HttpResponse;
}

function HttpRequest:show()
    print("uriPath: '" .. self._uriPath .. "'")
    print("post: '" .. self._post .. "'")
	showTable(self._params, " ")
end

function HttpHandleParameter(k, v)
	HttpRequest._params[k] = v
end

function HttpHandleRequest(uriPath, post)
	HttpRequest._uriPath = uriPath
	HttpRequest._post = post
	vertex:handleRequest(HttpRequest)
	HttpRequest._params = {}
	return HttpResponse._contentType, HttpResponse._content, HttpResponse._statusCode, HttpResponse._cookie
end

vertex = Vertex:clone():open()