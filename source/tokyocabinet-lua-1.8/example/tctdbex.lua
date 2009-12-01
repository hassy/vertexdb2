require("tokyocabinet")

-- create the object
tdb = tokyocabinet.tdbnew()

-- open the database
if not tdb:open("casket.tct", tdb.OWRITER + tdb.OCREAT) then
   ecode = tdb:ecode()
   print("open error: " .. tdb:errmsg(ecode))
end

-- store a record
pkey = tdb:genuid()
cols = { name = "mikio", age = "30", lang = "ja,en,c" }
if not tdb:put(pkey, cols) then
   ecode = tdb:ecode()
   print("get error: " .. tdb:errmsg(ecode))
end

-- store another record
cols = { name = "falcon", age = "31", lang = "ja", skill = "cook,blog" }
if not tdb:put("x12345", cols) then
   ecode = tdb:ecode()
   print("get error: " .. tdb.errmsg(ecode))
end

-- search for records
qry = tokyocabinet.tdbqrynew(tdb)
qry:addcond("age", qry.QCNUMGE, "20")
qry:addcond("lang", qry.QCSTROR, "ja,en")
qry:setorder("name", qry.QOSTRASC)
qry:setlimit(10)
res = qry:search()
for i = 1, #res do
   rcols = tdb:get(res[i])
   print("name:" .. rcols.name)
end

-- table-like usage
tdb.joker = { name = "ozma", lang = "en", skill = "song,dance" }
print(tdb.joker.name)
for pkey, cols in tdb:pairs() do
   print(pkey .. ":" .. cols.name)
end

-- close the database
if not tdb:close() then
   ecode = tdb:ecode()
   print("close error: " .. tdb:errmsg(ecode))
end
