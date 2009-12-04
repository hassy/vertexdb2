
mkdir := """
{
    "1": {"action": "mkdir", "path": "/tests"}
}
"""

write := """{
    "1": {"action": "write", "path": "/tests", "key": "_name", "value": "vertexdb"}
}"""

read := """
{
    "1": {"action": "read", "path": "/tests", "key": "_name"}
}
"""

assertEquals := method(a, b, 
	if(a != b, 
		Exception raise(call message argAt(0) .. " == " .. a .. " instead of " .. b)
	)
)

request := method(json,
    URL with("http://localhost:8080") post(json)
)

assertEquals(request(mkdir), """{"1":[]}""")
assertEquals(request(write), """{"1":[]}""")
assertEquals(request(read),  """{"1":{"result":"vertexdb"}}""")