#! /usr/bin/lua

require("tokyocabinet")

function memoryusage()
   local tmpname = os.tmpname()
   os.execute("cat /proc/$PPID/status > " .. tmpname)
   local fh = io.open(tmpname)
   if fh then
      for line in fh:lines() do
         if string.find(line, "VmRSS:") == 1 then
            local num = string.gsub(line, "%w+:%s*(%d+).*", "%1")
            return tonumber(num) / 1024
         end
      end
      fh:close()
   end
   os.remove(tmpname)
end

rnum = 1000000;
if #arg > 0 then
   rnum = tonumber(arg[1])
end

if #arg > 1 then
   hash = tokyocabinet.adbnew()
   if not hash:open(arg[2]) then
      error("open failed")
   end
else
   hash = {}
end

stime = tokyocabinet.time()
for i = 1, rnum do
  buf = string.format("%08d", i)
  hash[buf] = buf
end
etime = tokyocabinet.time()

print(string.format("Time: %.3f sec.", etime - stime))
print(string.format("Usage: %.3f MB", memoryusage()))
