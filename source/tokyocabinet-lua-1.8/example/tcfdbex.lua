require("tokyocabinet")

-- create the object
fdb = tokyocabinet.fdbnew()

-- open the database
if not fdb:open("casket.tcf", fdb.OWRITER + fdb.OCREAT) then
   ecode = fdb:ecode()
   print("open error: " .. fdb:errmsg(ecode))
end

-- store records
if not fdb:put(1, "one")
   or not fdb:put(12, "twelve")
   or not fdb:put(144, "one forty four") then
   ecode = fdb:ecode()
   print("put error: " .. fdb:errmsg(ecode))
end

-- retrieve records
value = fdb:get(1)
if value then
   print(value)
else
   ecode = fdb:ecode()
   print("get error: " .. fdb:errmsg(ecode))
end

-- traverse records
fdb:iterinit()
while true do
   key = fdb:iternext()
   if not key then break end
   value = fdb:get(key)
   if value then
      print(key .. ":" .. value)
   end
end

-- table-like usage
fdb[1728] = "touchdown"
print(fdb[1728])
for key, value in fdb:pairs() do
   print(key .. ":" .. value)
end

-- close the database
if not fdb:close() then
   ecode = fdb:ecode()
   print("close error: " .. fdb:errmsg(ecode))
end
