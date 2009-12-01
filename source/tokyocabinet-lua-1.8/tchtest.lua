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
   printf("%s: test cases of the hash database API\n", progname)
   printf("\n")
   printf("usage:\n")
   printf("  %s write [-tl] [-td|-tb|-tt] [-nl|-nb] [-as] path rnum [bnum [apow [fpow]]]\n",
          progname)
   printf("  %s read [-nl|-nb] path\n", progname)
   printf("  %s remove [-nl|-nb] path\n", progname)
   printf("  %s misc [-tl] [-td|-tb|-tt] [-nl|-nb] path rnum\n", progname)
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
function eprint(hdb, func)
   local path = hdb:path()
   if not path then path = "-" end
   printf("%s: %s: %s: %s\n", progname, path, func, hdb:errmsg())
end


-- parse arguments of write command
function runwrite()
   local hdb = tokyocabinet.hdbnew()
   local path = nil
   local rnum = nil
   local bnum = nil
   local apow = nil
   local fpow = nil
   local opts = 0
   local omode = 0
   local as = false
   for i = 2, #arg do
      if not path and string.match(arg[i], "^-") then
         if arg[i] == "-tl" then
            opts = opts + hdb.TLARGE
         elseif arg[i] == "-td" then
            opts = opts + hdb.TDEFLATE
         elseif arg[i] == "-tb" then
            opts = opts + hdb.TBZIP
         elseif arg[i] == "-tt" then
            opts = opts + hdb.TTCBS
         elseif arg[i] == "-nl" then
            omode = omode + hdb.ONOLCK
         elseif arg[i] == "-nb" then
            omode = omode + hdb.OLCKNB
         elseif arg[i] == "-as" then
            as = true
         else
            usage()
         end
      elseif not path then
         path = arg[i]
      elseif not rnum then
         rnum = tonumber(arg[i])
      elseif not bnum then
         bnum = tonumber(arg[i])
      elseif not apow then
         apow = tonumber(arg[i])
      elseif not fpow then
         fpow = tonumber(arg[i])
      else
         usage()
      end
   end
   if not path or not rnum or rnum < 1 then usage() end
   if not bnum then bnum = -1 end
   if not apow then apow = -1 end
   if not fpow then fpow = -1 end
   local rv = procwrite(hdb, path, rnum, bnum, apow, fpow, opts, omode, as)
   return rv
end


-- parse arguments of read command
function runread()
   local hdb = tokyocabinet.hdbnew()
   local path = nil
   local omode = 0
   for i = 2, #arg do
      if not path and string.match(arg[i], "^-") then
         if arg[i] == "-nl" then
            omode = omode + hdb.ONOLCK
         elseif arg[i] == "-nb" then
            omode = omode + hdb.OLCKNB
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
   local rv = procread(hdb, path, omode)
   return rv
end


-- parse arguments of remove command
function runremove()
   local hdb = tokyocabinet.hdbnew()
   local path = nil
   local omode = 0
   for i = 2, #arg do
      if not path and string.match(arg[i], "^-") then
         if arg[i] == "-nl" then
            omode = omode + hdb.ONOLCK
         elseif arg[i] == "-nb" then
            omode = omode + hdb.OLCKNB
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
   local rv = procremove(hdb, path, omode)
   return rv
end


-- parse arguments of misc command
function runmisc()
   local hdb = tokyocabinet.hdbnew()
   local path = nil
   local rnum = nil
   local opts = 0
   local omode = 0
   for i = 2, #arg do
      if not path and string.match(arg[i], "^-") then
         if arg[i] == "-tl" then
            opts = opts + hdb.TLARGE
         elseif arg[i] == "-td" then
            opts = opts + hdb.TDEFLATE
         elseif arg[i] == "-tb" then
            opts = opts + hdb.TBZIP
         elseif arg[i] == "-tt" then
            opts = opts + hdb.TTCBS
         elseif arg[i] == "-nl" then
            omode = omode + hdb.ONOLCK
         elseif arg[i] == "-nb" then
            omode = omode + hdb.OLCKNB
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
   local rv = procmisc(hdb, path, rnum, opts, omode)
   return rv
end


-- perform write command
function procwrite(hdb, path, rnum, bnum, apow, fpow, opts, omode, as)
   printf("<Writing Test>\n  path=%s  rnum=%d  bnum=%d  apow=%d  fpow=%d  opts=%d" ..
          "  omode=%d  as=%s\n\n", path, rnum, bnum, apow, fpow, opts, omode, as)
   local err = false
   local stime = tokyocabinet.time()
   if not hdb:tune(bnum, apow, fpow, opts) then
      eprint(hdb, "tune")
      err = true
   end
   if not hdb:open(path, hdb.OWRITER + hdb.OCREAT + hdb.OTRUNC + omode) then
      eprint(hdb, "open")
      err = true
   end
   for i = 1, rnum do
      local buf = string.format("%08d", i)
      if as then
         if not hdb:putasync(buf, buf) then
            eprint(hdb, "putasync")
            err = true
            break
         end
      else
         if not hdb:put(buf, buf) then
            eprint(hdb, "put")
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
   printf("record number: %d\n", hdb:rnum())
   printf("size: %d\n", hdb:fsiz())
   if not hdb:close() then
      eprint(hdb, "close")
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
function procread(hdb, path, omode)
   printf("<Reading Test>\n  path=%s  omode=%d\n\n", path, omode)
   local err = false
   local stime = tokyocabinet.time()
   if not hdb:open(path, hdb.OREADER + omode) then
      eprint(hdb, "open")
      err = true
   end
   local rnum = hdb:rnum()
   for i = 1, rnum do
      local buf = string.format("%08d", i)
      if not hdb:get(buf) then
         eprint(hdb, "get")
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
   printf("record number: %d\n", hdb:rnum())
   printf("size: %d\n", hdb:fsiz())
   if not hdb:close() then
      eprint(hdb, "close")
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
function procremove(hdb, path, omode)
   printf("<Removing Test>\n  path=%s  omode=%d\n\n", path, omode)
   local err = false
   local stime = tokyocabinet.time()
   if not hdb:open(path, hdb.OWRITER + omode) then
      eprint(hdb, "open")
      err = true
   end
   local rnum = hdb:rnum()
   for i = 1, rnum do
      local buf = string.format("%08d", i)
      if not hdb:out(buf) then
         eprint(hdb, "out")
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
   printf("record number: %d\n", hdb:rnum())
   printf("size: %d\n", hdb:fsiz())
   if not hdb:close() then
      eprint(hdb, "close")
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
function procmisc(hdb, path, rnum, opts, omode)
   printf("<Miscellaneous Test>\n  path=%s  rnum=%d  opts=%d  omode=%d\n\n",
          path, rnum, opts, omode)
   local err = false
   local stime = tokyocabinet.time()
   if not hdb:tune(rnum / 50, 2, -1, opts) then
      eprint(hdb, "tune")
      err = true
   end
   if not hdb:setcache(rnum / 10) then
      eprint(hdb, "setcache")
      err = true
   end
   if not hdb:setxmsiz(rnum * 4) then
      eprint(hdb, "setxmsiz")
      err = true
   end
   if not hdb:setdfunit(8) then
      eprint(hdb, "setdfunit")
      err = true
   end
   if not hdb:open(path, hdb.OWRITER + hdb.OCREAT + hdb.OTRUNC + omode) then
      eprint(hdb, "open")
      err = true
   end
   printf("writing:\n")
   for i = 1, rnum do
      local buf = string.format("%08d", i)
      if not hdb:put(buf, buf) then
         eprint(hdb, "put")
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
      if not hdb:get(buf) then
         eprint(hdb, "get")
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
      if math.random(2) == 1 and not hdb:out(buf) then
         eprint(hdb, "out")
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
   if not hdb:iterinit() then
      eprint(hdb, "iterinit")
      err = true
   end
   local inum = 0
   while true do
      local key = hdb:iternext()
      if not key then break end
      local value = hdb:get(key)
      if not value then
         eprint(hdb, "get")
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
   if hdb:ecode() ~= hdb.ENOREC or inum ~= hdb:rnum() then
      eprint(hdb, "(validation)")
      err = true
   end
   local keys = hdb:fwmkeys("0", 10)
   if hdb:rnum() >= 10 and #keys ~= 10 then
      eprint(hdb, "fwmkeys")
      err = true
   end
   printf("checking counting:\n")
   for i = 1, rnum do
      local buf = string.format("[%d]", math.random(rnum))
      if math.random(2) == 1 then
         if not hdb:addint(buf, 1) and hdb:ecode() ~= hdb.EKEEP then
            eprint(hdb, "addint")
            err = true
            break
         end
      else
         if not hdb:adddouble(buf, 1) and hdb:ecode() ~= hdb.EKEEP then
            eprint(hdb, "adddouble")
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
   if not hdb:sync() then
      eprint(hdb, "sync")
      err = true
   end
   if not hdb:optimize() then
      eprint(hdb, "optimize")
      err = true
   end
   local npath = path .. "-tmp"
   if not hdb:copy(npath) then
      eprint(hdb, "copy")
      err = true
   end
   os.remove(npath)
   if not hdb:vanish() then
      eprint(hdb, "vanish")
      err = true
   end
   printf("checking transaction commit:\n")
   if not hdb:tranbegin() then
      eprint(hdb, "tranbegin")
      err = true
   end
   for i = 1, rnum do
      local buf = string.format("%d", i)
      if math.random(2) == 1 then
         if not hdb:putcat(buf, buf) then
            eprint(hdb, "putcat")
            err = true
            break
         end
      else
         if not hdb:out(buf) and hdb:ecode() ~= hdb.ENOREC then
            eprint(hdb, "out")
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
   if not hdb:trancommit() then
      eprint(hdb, "trancommit")
      err = true
   end
   printf("checking transaction abort:\n")
   ornum = hdb:rnum()
   ofsiz = hdb:fsiz()
   if not hdb:tranbegin() then
      eprint(hdb, "tranbegin")
      err = true
   end
   for i = 1, rnum do
      local buf = string.format("%d", i)
      if math.random(2) == 1 then
         if not hdb:putcat(buf, buf) then
            eprint(hdb, "putcat")
            err = true
            break
         end
      else
         if not hdb:out(buf) and hdb:ecode() ~= hdb.ENOREC then
            eprint(hdb, "out")
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
   if not hdb:tranabort() then
      eprint(hdb, "tranabort")
      err = true
   end
   if hdb:rnum() ~= ornum or hdb:fsiz() ~= ofsiz then
      eprint(hdb, "(validation)")
      err = true
   end
   printf("checking table-like updating:\n")
   for i = 1, rnum do
      local buf = string.format("[%d]", math.random(rnum))
      if math.random(2) == 1 then
         hdb[buf] = buf
      else
         local value = hdb[buf]
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
   hdb:foreach(iterfunc)
   if rnum > 250 then printf(" (%08d)\n", cnt) end
   if cnt ~= hdb:rnum() then
      eprint(hdb, "(validation)")
      err = true
   end
   printf("record number: %d\n", hdb:rnum())
   printf("size: %d\n", hdb:fsiz())
   if not hdb:close() then
      eprint(hdb, "close")
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
