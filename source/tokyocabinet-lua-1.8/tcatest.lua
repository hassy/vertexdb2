#! /usr/bin/lua

--------------------------------------------------------------------------------------------------
-- The test cases of the hash database API
--                                                      Copyright (C) 2006-2009 Mikio Hirabayashi
-- This file is part of Tokyo Cabinet.
-- Tokyo Cabinet is free software; you can redistribute it and/or modify it under the terms of
-- the GNU Lesser General Public License as published by the Free Software Foundation; either
-- version 2.1 of the License or any later version.  Tokyo Cabinet is distributed in the hope
-- that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
-- License for more details.
-- You should have received a copy of the GNU Lesser General Public License along with Tokyo
-- Cabinet; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
-- Boston, MA 02111-1307 USA.
--------------------------------------------------------------------------------------------------


require("tokyocabinet")


-- main routine
function main()
   if #arg < 1 then usage() end
   local rv
   if arg[1] == "write" then
      rv = runwrite()
   elseif arg[1] == "read" then
      rv = runread()
   elseif arg[1] == "remove" then
      rv = runremove()
   elseif arg[1] == "misc" then
      rv = runmisc()
   else
      usage()
   end
   collectgarbage("collect")
   return rv
end


-- print the usage and exit
function usage()
   printf("%s: test cases of the abstract database API\n", progname)
   printf("\n")
   printf("usage:\n")
   printf("  %s write name rnum\n", progname)
   printf("  %s read name\n", progname)
   printf("  %s remove name\n", progname)
   printf("  %s misc name rnum\n", progname)
   printf("\n")
   os.exit(1)
end


-- perform formatted output
function printf(format, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p)
   if type(a) ~= "number" then a = tostring(a) end
   if type(b) ~= "number" then b = tostring(b) end
   if type(c) ~= "number" then c = tostring(c) end
   if type(d) ~= "number" then d = tostring(d) end
   if type(e) ~= "number" then e = tostring(e) end
   if type(f) ~= "number" then f = tostring(f) end
   if type(g) ~= "number" then g = tostring(g) end
   if type(h) ~= "number" then h = tostring(h) end
   if type(i) ~= "number" then i = tostring(i) end
   if type(j) ~= "number" then j = tostring(j) end
   if type(k) ~= "number" then k = tostring(k) end
   if type(l) ~= "number" then l = tostring(l) end
   if type(m) ~= "number" then m = tostring(m) end
   if type(n) ~= "number" then n = tostring(n) end
   if type(o) ~= "number" then o = tostring(o) end
   if type(p) ~= "number" then p = tostring(p) end
   io.stdout:write(string.format(format, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p))
end


-- print error message of hash database
function eprint(adb, func)
   local path = adb:path()
   if not path then path = "-" end
   printf("%s: %s: %s: %s\n", progname, path, func)
end


-- parse arguments of write command
function runwrite()
   local adb = tokyocabinet.adbnew()
   local name = nil
   local rnum = nil
   for i = 2, #arg do
      if not name and string.match(arg[i], "^-") then
         usage()
      elseif not name then
         name = arg[i]
      elseif not rnum then
         rnum = tonumber(arg[i])
      else
         usage()
      end
   end
   if not name or not rnum or rnum < 1 then usage() end
   local rv = procwrite(adb, name, rnum)
   return rv
end


-- parse arguments of read command
function runread()
   local adb = tokyocabinet.adbnew()
   local name = nil
   for i = 2, #arg do
      if not name and string.match(arg[i], "^-") then
         usage()
      elseif not name then
         name = arg[i]
      else
         usage()
      end
   end
   if not name then usage() end
   local rv = procread(adb, name)
   return rv
end


-- parse arguments of remove command
function runremove()
   local adb = tokyocabinet.adbnew()
   local name = nil
   for i = 2, #arg do
      if not name and string.match(arg[i], "^-") then
         usage()
      elseif not name then
         name = arg[i]
      else
         usage()
      end
   end
   if not name then usage() end
   local rv = procremove(adb, name)
   return rv
end


-- parse arguments of misc command
function runmisc()
   local adb = tokyocabinet.adbnew()
   local name = nil
   local rnum = nil
   for i = 2, #arg do
      if not name and string.match(arg[i], "^-") then
         usage()
      elseif not name then
         name = arg[i]
      elseif not rnum then
         rnum = tonumber(arg[i])
      else
         usage()
      end
   end
   if not name or not rnum or rnum < 1 then usage() end
   local rv = procmisc(adb, name, rnum)
   return rv
end


-- perform write command
function procwrite(adb, name, rnum)
   printf("<Writing Test>\n  name=%s  rnum=%d\n\n", name, rnum)
   local err = false
   local stime = tokyocabinet.time()
   if not adb:open(name) then
      eprint(adb, "open")
      err = true
   end
   for i = 1, rnum do
      local buf = string.format("%08d", i)
      if not adb:put(buf, buf) then
         eprint(adb, "put")
         err = true
         break
      end
      if rnum > 250 and i % (rnum / 250) == 0 then
         printf(".")
         if i == rnum or i % (rnum / 10) == 0 then
            printf(" (%08d)\n", i)
         end
      end
   end
   printf("record number: %d\n", adb:rnum())
   printf("size: %d\n", adb:size())
   if not adb:close() then
      eprint(adb, "close")
      err = true
   end
   printf("time: %.3f\n", tokyocabinet.time() - stime)
   local rv = 0
   if err then
      printf("err\n\n")
      rv = 1
   else
      printf("ok\n\n")
   end
   return rv
end


-- perform read command
function procread(adb, name)
   printf("<Reading Test>\n  name=%s\n\n", name)
   local err = false
   local stime = tokyocabinet.time()
   if not adb:open(name) then
      eprint(adb, "open")
      err = true
   end
   local rnum = adb:rnum()
   for i = 1, rnum do
      local buf = string.format("%08d", i)
      if not adb:get(buf) then
         eprint(adb, "get")
         err = true
         break
      end
      if rnum > 250 and i % (rnum / 250) == 0 then
         printf(".")
         if i == rnum or i % (rnum / 10) == 0 then
            printf(" (%08d)\n", i)
         end
      end
   end
   printf("record number: %d\n", adb:rnum())
   printf("size: %d\n", adb:size())
   if not adb:close() then
      eprint(adb, "close")
      err = true
   end
   printf("time: %.3f\n", tokyocabinet.time() - stime)
   local rv = 0
   if err then
      printf("err\n\n")
      rv = 1
   else
      printf("ok\n\n")
   end
   return rv
end


-- perform remove command
function procremove(adb, name)
   printf("<Removing Test>\n  name=%s\n\n", name)
   local err = false
   local stime = tokyocabinet.time()
   if not adb:open(name) then
      eprint(adb, "open")
      err = true
   end
   local rnum = adb:rnum()
   for i = 1, rnum do
      local buf = string.format("%08d", i)
      if not adb:out(buf) then
         eprint(adb, "out")
         err = true
         break
      end
      if rnum > 250 and i % (rnum / 250) == 0 then
         printf(".")
         if i == rnum or i % (rnum / 10) == 0 then
            printf(" (%08d)\n", i)
         end
      end
   end
   printf("record number: %d\n", adb:rnum())
   printf("size: %d\n", adb:size())
   if not adb:close() then
      eprint(adb, "close")
      err = true
   end
   printf("time: %.3f\n", tokyocabinet.time() - stime)
   local rv = 0
   if err then
      printf("err\n\n")
      rv = 1
   else
      printf("ok\n\n")
   end
   return rv
end


-- perform misc command
function procmisc(adb, name, rnum)
   printf("<Miscellaneous Test>\n  name=%s  rnum=%d\n\n", name, rnum)
   local err = false
   local stime = tokyocabinet.time()
   if not adb:open(name) then
      eprint(adb, "open")
      err = true
   end
   printf("writing:\n")
   for i = 1, rnum do
      local buf = string.format("%08d", i)
      if not adb:put(buf, buf) then
         eprint(adb, "put")
         err = true
         break
      end
      if rnum > 250 and i % (rnum / 250) == 0 then
         printf(".")
         if i == rnum or i % (rnum / 10) == 0 then
            printf(" (%08d)\n", i)
         end
      end
   end
   printf("reading:\n")
   for i = 1, rnum do
      local buf = string.format("%08d", i)
      if not adb:get(buf) then
         eprint(adb, "get")
         err = true
         break
      end
      if rnum > 250 and i % (rnum / 250) == 0 then
         printf(".")
         if i == rnum or i % (rnum / 10) == 0 then
            printf(" (%08d)\n", i)
         end
      end
   end
   printf("removing:\n")
   for i = 1, rnum do
      local buf = string.format("%08d", i)
      if math.random(2) == 1 and not adb:out(buf) then
         eprint(adb, "out")
         err = true
         break
      end
      if rnum > 250 and i % (rnum / 250) == 0 then
         printf(".")
         if i == rnum or i % (rnum / 10) == 0 then
            printf(" (%08d)\n", i)
         end
      end
   end
   printf("iterator checking:\n")
   if not adb:iterinit() then
      eprint(adb, "iterinit")
      err = true
   end
   local inum = 0
   while true do
      local key = adb:iternext()
      if not key then break end
      local value = adb:get(key)
      if not value then
         eprint(adb, "get")
         err = true
      end
      if inum > 0 and rnum > 250 and inum % (rnum / 250) == 0 then
         printf(".")
         if inum == rnum or inum % (rnum / 10) == 0 then
            printf(" (%08d)\n", inum)
         end
      end
      inum = inum + 1
   end
   if rnum > 250 then printf(" (%08d)\n", inum) end
   if inum ~= adb:rnum() then
      eprint(adb, "(validation)")
      err = true
   end
   local keys = adb:fwmkeys("0", 10)
   if adb:rnum() >= 10 and #keys ~= 10 then
      eprint(adb, "fwmkeys")
      err = true
   end
   printf("checking counting:\n")
   for i = 1, rnum do
      local buf = string.format("[%d]", math.random(rnum))
      if math.random(2) == 1 then
         adb:addint(buf, 1)
      else
         adb:adddouble(buf, 1)
      end
      if rnum > 250 and i % (rnum / 250) == 0 then
         printf(".")
         if i == rnum or i % (rnum / 10) == 0 then
            printf(" (%08d)\n", i)
         end
      end
   end
   if not adb:sync() then
      eprint(adb, "sync")
      err = true
   end
   if not adb:optimize() then
      eprint(adb, "optimize")
      err = true
   end
   local npath = adb:path() .. "-tmp"
   if not adb:copy(npath) then
      eprint(adb, "copy")
      err = true
   end
   os.remove(npath)
   if not adb:vanish() then
      eprint(adb, "vanish")
      err = true
   end
   printf("checking transaction commit:\n")
   if not adb:tranbegin() then
      eprint(adb, "tranbegin")
      err = true
   end
   for i = 1, rnum do
      local buf = string.format("%d", i)
      if math.random(2) == 1 then
         if not adb:putcat(buf, buf) then
            eprint(adb, "putcat")
            err = true
            break
         end
      else
         adb:out(buf)
      end
      if rnum > 250 and i % (rnum / 250) == 0 then
         printf(".")
         if i == rnum or i % (rnum / 10) == 0 then
            printf(" (%08d)\n", i)
         end
      end
   end
   if not adb:trancommit() then
      eprint(adb, "trancommit")
      err = true
   end
   printf("checking transaction abort:\n")
   ornum = adb:rnum()
   osize = adb:size()
   if not adb:tranbegin() then
      eprint(adb, "tranbegin")
      err = true
   end
   for i = 1, rnum do
      local buf = string.format("%d", i)
      if math.random(2) == 1 then
         if not adb:putcat(buf, buf) then
            eprint(adb, "putcat")
            err = true
            break
         end
      else
         adb:out(buf)
      end
      if rnum > 250 and i % (rnum / 250) == 0 then
         printf(".")
         if i == rnum or i % (rnum / 10) == 0 then
            printf(" (%08d)\n", i)
         end
      end
   end
   if not adb:tranabort() then
      eprint(adb, "tranabort")
      err = true
   end
   if adb:rnum() ~= ornum or adb:size() ~= osize then
      eprint(adb, "(validation)")
      err = true
   end
   printf("checking table-like updating:\n")
   for i = 1, rnum do
      local buf = string.format("[%d]", math.random(rnum))
      if math.random(2) == 1 then
         adb[buf] = buf
      else
         local value = adb[buf]
      end
      if rnum > 250 and i % (rnum / 250) == 0 then
         printf(".")
         if i == rnum or i % (rnum / 10) == 0 then
            printf(" (%08d)\n", i)
         end
      end
   end
   printf("checking foreach method:\n")
   local cnt = 0
   function iterfunc(key, value)
      cnt = cnt + 1
      if rnum > 250 and cnt % (rnum / 250) == 0 then
         printf(".")
         if cnt == rnum or cnt % (rnum / 10) == 0 then
            printf(" (%08d)\n", cnt)
         end
      end
      return true
   end
   adb:foreach(iterfunc)
   if rnum > 250 then printf(" (%08d)\n", cnt) end
   if cnt ~= adb:rnum() then
      eprint(adb, "(validation)")
      err = true
   end
   printf("record number: %d\n", adb:rnum())
   printf("size: %d\n", adb:size())
   if not adb:close() then
      eprint(adb, "close")
      err = true
   end
   printf("time: %.3f\n", tokyocabinet.time() - stime)
   local rv = 0
   if err then
      printf("err\n\n")
      rv = 1
   else
      printf("ok\n\n")
   end
   return rv
end


-- execute main
io.stdout:setvbuf("no")
progname = string.gsub(arg[0], ".*/", "")
math.randomseed(os.time())
os.exit(main())



-- END OF FILE
