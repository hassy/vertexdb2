require("tokyocabinet")

-- create the object
hdb = tokyocabinet.hdbnew()

-- open the database
if not hdb:open("casket.tch", hdb.OWRITER + hdb.OCREAT) then
   ecode = hdb:ecode()
   print("open error: " .. hdb:errmsg(ecode))
end

-- store records
if not hdb:put("foo", "hop")
   or not hdb:put("bar", "step")
   or not hdb:put("baz", "jump") then
   ecode = hdb:ecode()
   print("put error: " .. hdb:errmsg(ecode))
end

-- retrieve records
value = hdb:get("foo")
if value then
   print(value)
else
   ecode = hdb:ecode()
   print("get error: " .. hdb:errmsg(ecode))
end

-- traverse records
hdb:iterinit()
while true do
   key = hdb:iternext()
   if not key then break end
   value = hdb:get(key)
   if value then
      print(key .. ":" .. value)
   end
end

-- table-like usage
hdb["quux"] = "touchdown"
print(hdb["quux"])
for key, value in hdb:pairs() do
   print(key .. ":" .. value)
end

-- close the database
if not hdb:close() then
   ecode = hdb:ecode()
   print("close error: " .. hdb:errmsg(ecode))
end
