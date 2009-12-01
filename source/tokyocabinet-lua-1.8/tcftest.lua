#! /usr/bin/lua

--------------------------------------------------------------------------------------------------
-- The test cases of the fixed-length database API
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
   printf("%s: test cases of the fixed-length database API\n", progname)
   printf("\n")
   printf("usage:\n")
   printf("  %s write [-nl|-nb] path rnum [width [limsiz]]\n", progname)
   printf("  %s read [-nl|-nb] path\n", progname)
   printf("  %s remove [-nl|-nb] path\n", progname)
   printf("  %s misc [-nl|-nb] path rnum\n", progname)
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


-- print error message of fixed-length database
function eprint(fdb, func)
   local path = fdb:path()
   if not path then path = "-" end
   printf("%s: %s: %s: %s\n", progname, path, func, fdb:errmsg())
end


-- parse arguments of write command
function runwrite()
   local fdb = tokyocabinet.fdbnew()
   local path = nil
   local rnum = nil
   local width = nil
   local limsiz = nil
   local omode = 0
   for i = 2, #arg do
      if not path and string.match(arg[i], "^-") then
         if arg[i] == "-nl" then
            omode = omode + fdb.ONOLCK
         elseif arg[i] == "-nb" then
            omode = omode + fdb.OLCKNB
         else
            usage()
         end
      elseif not path then
         path = arg[i]
      elseif not rnum then
         rnum = tonumber(arg[i])
      elseif not width then
         width = tonumber(arg[i])
      elseif not limsiz then
         limsiz = tonumber(arg[i])
      else
         usage()
      end
   end
   if not path or not rnum or rnum < 1 then usage() end
   if not width then width = -1 end
   if not limsiz then limsiz = -1 end
   if not fpow then fpow = -1 end
   local rv = procwrite(fdb, path, rnum, width, limsiz, omode)
   return rv
end


-- parse arguments of read command
function runread()
   local fdb = tokyocabinet.fdbnew()
   local path = nil
   local omode = 0
   for i = 2, #arg do
      if not path and string.match(arg[i], "^-") then
         if arg[i] == "-nl" then
            omode = omode + fdb.ONOLCK
         elseif arg[i] == "-nb" then
            omode = omode + fdb.OLCKNB
         else
            usage()
         end
      elseif not path then
         path = arg[i]
      else
         usage()
      end
   end
   if not path then usage() end
   local rv = procread(fdb, path, omode)
   return rv
end


-- parse arguments of remove command
function runremove()
   local fdb = tokyocabinet.fdbnew()
   local path = nil
   local omode = 0
   for i = 2, #arg do
      if not path and string.match(arg[i], "^-") then
         if arg[i] == "-nl" then
            omode = omode + fdb.ONOLCK
         elseif arg[i] == "-nb" then
            omode = omode + fdb.OLCKNB
         else
            usage()
         end
      elseif not path then
         path = arg[i]
      else
         usage()
      end
   end
   if not path then usage() end
   local rv = procremove(fdb, path, omode)
   return rv
end


-- parse arguments of misc command
function runmisc()
   local fdb = tokyocabinet.fdbnew()
   local path = nil
   local rnum = nil
   local omode = 0
   for i = 2, #arg do
      if not path and string.match(arg[i], "^-") then
         if arg[i] == "-nl" then
            omode = omode + fdb.ONOLCK
         elseif arg[i] == "-nb" then
            omode = omode + fdb.OLCKNB
         else
            usage()
         end
      elseif not path then
         path = arg[i]
      elseif not rnum then
         rnum = tonumber(arg[i])
      else
         usage()
      end
   end
   if not path or not rnum or rnum < 1 then usage() end
   local rv = procmisc(fdb, path, rnum, omode)
   return rv
end


-- perform write command
function procwrite(fdb, path, rnum, width, limsiz, omode)
   printf("<Writing Test>\n  path=%s  rnum=%d  width=%d  limsiz=%d  omode=%d\n\n",
          path, rnum, width, limsiz, omode)
   local err = false
   local stime = tokyocabinet.time()
   if not fdb:tune(width, limsiz) then
      eprint(fdb, "tune")
      err = true
   end
   if not fdb:open(path, fdb.OWRITER + fdb.OCREAT + fdb.OTRUNC + omode) then
      eprint(fdb, "open")
      err = true
   end
   for i = 1, rnum do
      local buf = string.format("%08d", i)
      if as then
         if not fdb:putasync(buf, buf) then
            eprint(fdb, "putasync")
            err = true
            break
         end
      else
         if not fdb:put(buf, buf) then
            eprint(fdb, "put")
            err = true
            break
         end
      end
      if rnum > 250 and i % (rnum / 250) == 0 then
         printf(".")
         if i == rnum or i % (rnum / 10) == 0 then
            printf(" (%08d)\n", i)
         end
      end
   end
   printf("record number: %d\n", fdb:rnum())
   printf("size: %d\n", fdb:fsiz())
   if not fdb:close() then
      eprint(fdb, "close")
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
function procread(fdb, path, omode)
   printf("<Reading Test>\n  path=%s  omode=%d\n\n", path, omode)
   local err = false
   local stime = tokyocabinet.time()
   if not fdb:open(path, fdb.OREADER + omode) then
      eprint(fdb, "open")
      err = true
   end
   local rnum = fdb:rnum()
   for i = 1, rnum do
      local buf = string.format("%08d", i)
      if not fdb:get(buf) then
         eprint(fdb, "get")
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
   printf("record number: %d\n", fdb:rnum())
   printf("size: %d\n", fdb:fsiz())
   if not fdb:close() then
      eprint(fdb, "close")
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
function procremove(fdb, path, omode)
   printf("<Removing Test>\n  path=%s  omode=%d\n\n", path, omode)
   local err = false
   local stime = tokyocabinet.time()
   if not fdb:open(path, fdb.OWRITER + omode) then
      eprint(fdb, "open")
      err = true
   end
   local rnum = fdb:rnum()
   for i = 1, rnum do
      local buf = string.format("%08d", i)
      if not fdb:out(buf) then
         eprint(fdb, "out")
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
   printf("record number: %d\n", fdb:rnum())
   printf("size: %d\n", fdb:fsiz())
   if not fdb:close() then
      eprint(fdb, "close")
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
function procmisc(fdb, path, rnum, omode)
   printf("<Miscellaneous Test>\n  path=%s  rnum=%d  omode=%d\n\n", path, rnum, omode)
   local err = false
   local stime = tokyocabinet.time()
   if not fdb:tune(10, 1024 + 32 * rnum) then
      eprint(fdb, "tune")
      err = true
   end
   if not fdb:open(path, fdb.OWRITER + fdb.OCREAT + fdb.OTRUNC + omode) then
      eprint(fdb, "open")
      err = true
   end
   printf("writing:\n")
   for i = 1, rnum do
      local buf = string.format("%08d", i)
      if not fdb:put(buf, buf) then
         eprint(fdb, "put")
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
      if not fdb:get(buf) then
         eprint(fdb, "get")
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
      if math.random(2) == 1 and not fdb:out(buf) then
         eprint(fdb, "out")
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
   if not fdb:iterinit() then
      eprint(fdb, "iterinit")
      err = true
   end
   local inum = 0
   while true do
      local key = fdb:iternext()
      if not key then break end
      local value = fdb:get(key)
      if not value then
         eprint(fdb, "get")
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
   if fdb:ecode() ~= fdb.ENOREC or inum ~= fdb:rnum() then
      eprint(fdb, "(validation)")
      err = true
   end
   local keys = fdb:range("[min,max]", 10)
   if fdb:rnum() >= 10 and #keys ~= 10 then
      eprint(fdb, "fwmkeys")
      err = true
   end
   printf("checking counting:\n")
   for i = 1, rnum do
      local buf = string.format("[%d]", math.random(rnum) + 1)
      if math.random(2) == 1 then
         if not fdb:addint(buf, 1) and fdb:ecode() ~= fdb.EKEEP then
            eprint(fdb, "addint")
            err = true
            break
         end
      else
         if not fdb:adddouble(buf, 1) and fdb:ecode() ~= fdb.EKEEP then
            eprint(fdb, "adddouble")
            err = true
            break
         end
      end
      if rnum > 250 and i % (rnum / 250) == 0 then
         printf(".")
         if i == rnum or i % (rnum / 10) == 0 then
            printf(" (%08d)\n", i)
         end
      end
   end
   if not fdb:sync() then
      eprint(fdb, "sync")
      err = true
   end
   if not fdb:optimize() then
      eprint(fdb, "optimize")
      err = true
   end
   local npath = path .. "-tmp"
   if not fdb:copy(npath) then
      eprint(fdb, "copy")
      err = true
   end
   os.remove(npath)
   if not fdb:vanish() then
      eprint(fdb, "vanish")
      err = true
   end
   printf("checking transaction commit:\n")
   if not fdb:tranbegin() then
      eprint(fdb, "tranbegin")
      err = true
   end
   for i = 1, rnum do
      local buf = string.format("%d", i)
      if math.random(2) == 1 then
         if not fdb:putcat(buf, buf) then
            eprint(fdb, "putcat")
            err = true
            break
         end
      else
         if not fdb:out(buf) and fdb:ecode() ~= fdb.ENOREC then
            eprint(fdb, "out")
            err = true
            break
         end
      end
      if rnum > 250 and i % (rnum / 250) == 0 then
         printf(".")
         if i == rnum or i % (rnum / 10) == 0 then
            printf(" (%08d)\n", i)
         end
      end
   end
   if not fdb:trancommit() then
      eprint(fdb, "trancommit")
      err = true
   end
   printf("checking transaction abort:\n")
   ornum = fdb:rnum()
   ofsiz = fdb:fsiz()
   if not fdb:tranbegin() then
      eprint(fdb, "tranbegin")
      err = true
   end
   for i = 1, rnum do
      local buf = string.format("%d", i)
      if math.random(2) == 1 then
         if not fdb:putcat(buf, buf) then
            eprint(fdb, "putcat")
            err = true
            break
         end
      else
         if not fdb:out(buf) and fdb:ecode() ~= fdb.ENOREC then
            eprint(fdb, "out")
            err = true
            break
         end
      end
      if rnum > 250 and i % (rnum / 250) == 0 then
         printf(".")
         if i == rnum or i % (rnum / 10) == 0 then
            printf(" (%08d)\n", i)
         end
      end
   end
   if not fdb:tranabort() then
      eprint(fdb, "tranabort")
      err = true
   end
   if fdb:rnum() ~= ornum or fdb:fsiz() ~= ofsiz then
      eprint(fdb, "(validation)")
      err = true
   end
   printf("checking table-like updating:\n")
   for i = 1, rnum do
      local buf = string.format("[%d]", math.random(rnum))
      if math.random(2) == 1 then
         fdb[buf] = buf
      else
         local value = fdb[buf]
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
   fdb:foreach(iterfunc)
   if rnum > 250 then printf(" (%08d)\n", cnt) end
   if cnt ~= fdb:rnum() then
      eprint(fdb, "(validation)")
      err = true
   end
   printf("record number: %d\n", fdb:rnum())
   printf("size: %d\n", fdb:fsiz())
   if not fdb:close() then
      eprint(fdb, "close")
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
