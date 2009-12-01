require("tokyocabinet")

-- create the object
bdb = tokyocabinet.bdbnew()

-- open the database
if not bdb:open("casket.tcb", bdb.OWRITER + bdb.OCREAT) then
   ecode = bdb:ecode()
   print("open error: " .. bdb:errmsg(ecode))
end

-- store records
if not bdb:put("foo", "hop")
   or not bdb:put("bar", "step")
   or not bdb:put("baz", "jump") then
   ecode = bdb:ecode()
   print("put error: " .. bdb:errmsg(ecode))
end

-- retrieve records
value = bdb:get("foo")
if value then
   print(value)
else
   ecode = bdb:ecode()
   print("get error: " .. bdb:errmsg(ecode))
end

-- traverse records
cur = tokyocabinet.bdbcurnew(bdb)
cur:first()
while true do
   key = cur:key()
   if not key then break end
   value = cur:val()
   if value then
      print(key .. ":" .. value)
   end
   cur:next()
end

-- table-like usage
bdb["quux"] = "touchdown"
print(bdb["quux"])
for key, value in bdb:pairs() do
   print(key .. ":" .. value)
end

-- close the database
if not bdb:close() then
   ecode = bdb:ecode()
   print("close error: " .. bdb:errmsg(ecode))
end
