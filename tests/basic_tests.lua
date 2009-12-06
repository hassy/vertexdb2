-- Install Luasocket for this from:
-- http://www.tecgraf.puc-rio.br/~diego/professional/luasocket/
local http = require("socket.http")
local ltn12 = require("ltn12")
local io = require("io")

dofile("../lua/Json.lua")

local mkdir = {["1"] = {action = "mkdir", path = "/tests"}}
local write = {["1"] = {action = "write", path = "/tests", key = "_name", value = "vertexdb"}}
local read  = {["1"] = {action = "read",  path = "/tests", key = "_name"}}
local commands = {mkdir, write, read}

function post(command)
    local host = "http://localhost:8080"
    local json = Json.Encode(command)
    local contentLength = #json
    body, headers, code = http.request({url = host,
                                        method = "POST",
                                        source = ltn12.source.string(json),
                                        headers = {["content-length"] = contentLength},
                                        sink = ltn12.sink.file(io.stdout) -- output result to stdout
                                       })
    return body, headers, code
end

for i, command in pairs(commands) do
    body, headers, code = post(command)
    print("REQUEST ", i)
    print("body: ", body)
    print("headers: ", headers)
    print("code:")

    for a,b in pairs(code) do
        print(a, " = ", b)
    end 
end