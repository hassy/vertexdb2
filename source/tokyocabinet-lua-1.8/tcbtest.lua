#! /usr/bin/lua

--------------------------------------------------------------------------------------------------
-- The test cases of the B+ tree database API
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
   printf("%s: test cases of the B+ tree database API\n", progname)
   printf("\n")
   printf("usage:\n")
   printf("  %s write [-tl] [-td|-tb|-tt] [-nl|-nb] path rnum" ..
          " [lmemb [nmemb [bnum [apow [fpow]]]]]\n", progname)
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


-- print error message of B+ tree database
function eprint(bdb, func)
   local path = bdb:path()
   if not path then path = "-" end
   printf("%s: %s: %s: %s\n", progname, path, func, bdb:errmsg())
end


-- parse arguments of write command
function runwrite()
   local bdb = tokyocabinet.bdbnew()
   local path = nil
   local rnum = nil
   local lmemb = nil
   local nmemb = nil
   local bnum = nil
   local apow = nil
   local fpow = nil
   local opts = 0
   local omode = 0
   for i = 2, #arg do
      if not path and string.match(arg[i], "^-") then
         if arg[i] == "-tl" then
            opts = opts + bdb.TLARGE
         elseif arg[i] == "-td" then
            opts = opts + bdb.TDEFLATE
         elseif arg[i] == "-tb" then
            opts = opts + bdb.TBZIP
         elseif arg[i] == "-tt" then
            opts = opts + bdb.TTCBS
         elseif arg[i] == "-nl" then
            omode = omode + bdb.ONOLCK
         elseif arg[i] == "-nb" then
            omode = omode + bdb.OLCKNB
         else
            usage()
         end
      elseif not path then
         path = arg[i]
      elseif not rnum then
         rnum = tonumber(arg[i])
      elseif not lmemb then
         lmemb = tonumber(arg[i])
      elseif not nmemb then
         nmemb = tonumber(arg[i])
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
   if not lmemb then lmemb = -1 end
   if not nmemb then nmemb = -1 end
   if not bnum then bnum = -1 end
   if not apow then apow = -1 end
   if not fpow then fpow = -1 end
   local rv = procwrite(bdb, path, rnum, lmemb, nmemb, bnum, apow, fpow, opts, omode)
   return rv
end


-- parse arguments of read command
function runread()
   local bdb = tokyocabinet.bdbnew()
   local path = nil
   local omode = 0
   for i = 2, #arg do
      if not path and string.match(arg[i], "^-") then
         if arg[i] == "-nl" then
            omode = omode + bdb.ONOLCK
         elseif arg[i] == "-nb" then
            omode = omode + bdb.OLCKNB
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
   local rv = procread(bdb, path, omode)
   return rv
end


-- parse arguments of remove command
function runremove()
   local bdb = tokyocabinet.bdbnew()
   local path = nil
   local omode = 0
   for i = 2, #arg do
      if not path and string.match(arg[i], "^-") then
         if arg[i] == "-nl" then
            omode = omode + bdb.ONOLCK
         elseif arg[i] == "-nb" then
            omode = omode + bdb.OLCKNB
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
   local rv = procremove(bdb, path, omode)
   return rv
end


-- parse arguments of misc command
function runmisc()
   local bdb = tokyocabinet.bdbnew()
   local path = nil
   local rnum = nil
   local opts = 0
   local omode = 0
   for i = 2, #arg do
      if not path and string.match(arg[i], "^-") then
         if arg[i] == "-tl" then
            opts = opts + bdb.TLARGE
         elseif arg[i] == "-td" then
            opts = opts + bdb.TDEFLATE
         elseif arg[i] == "-tb" then
            opts = opts + bdb.TBZIP
         elseif arg[i] == "-tt" then
            opts = opts + bdb.TTCBS
         elseif arg[i] == "-nl" then
            omode = omode + bdb.ONOLCK
         elseif arg[i] == "-nb" then
            omode = omode + bdb.OLCKNB
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
   local rv = procmisc(bdb, path, rnum, opts, omode)
   return rv
end


-- perform write command
function procwrite(bdb, path, rnum, lmemb, nmemb, bnum, apow, fpow, opts, omode)
   printf("<Writing Test>\n  path=%s  rnum=%d  lmemb=%d  nmemb=%d  bnum=%d  apow=%d  fpow=%d"
          .. "  opts=%d  omode=%d\n\n",
       path, rnum, lmemb, nmemb, bnum, apow, fpow, opts, omode, as)
   local err = false
   local stime = tokyocabinet.time()
   if not bdb:tune(lmemb, nmemb, bnum, apow, fpow, opts) then
      eprint(bdb, "tune")
      err = true
   end
   if not bdb:open(path, bdb.OWRITER + bdb.OCREAT + bdb.OTRUNC + omode) then
      eprint(bdb, "open")
      err = true
   end
   for i = 1, rnum do
      local buf = string.format("%08d", i)
      if as then
         if not bdb:putasync(buf, buf) then
            eprint(bdb, "putasync")
            err = true
            break
         end
      else
         if not bdb:put(buf, buf) then
            eprint(bdb, "put")
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
   printf("record number: %d\n", bdb:rnum())
   printf("size: %d\n", bdb:fsiz())
   if not bdb:close() then
      eprint(bdb, "close")
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
function procread(bdb, path, omode)
   printf("<Reading Test>\n  path=%s  omode=%d\n\n", path, omode)
   local err = false
   local stime = tokyocabinet.time()
   if not bdb:open(path, bdb.OREADER + omode) then
      eprint(bdb, "open")
      err = true
   end
   local rnum = bdb:rnum()
   for i = 1, rnum do
      local buf = string.format("%08d", i)
      if not bdb:get(buf) then
         eprint(bdb, "get")
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
   printf("record number: %d\n", bdb:rnum())
   printf("size: %d\n", bdb:fsiz())
   if not bdb:close() then
      eprint(bdb, "close")
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
function procremove(bdb, path, omode)
   printf("<Removing Test>\n  path=%s  omode=%d\n\n", path, omode)
   local err = false
   local stime = tokyocabinet.time()
   if not bdb:open(path, bdb.OWRITER + omode) then
      eprint(bdb, "open")
      err = true
   end
   local rnum = bdb:rnum()
   for i = 1, rnum do
      local buf = string.format("%08d", i)
      if not bdb:out(buf) then
         eprint(bdb, "out")
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
   printf("record number: %d\n", bdb:rnum())
   printf("size: %d\n", bdb:fsiz())
   if not bdb:close() then
      eprint(bdb, "close")
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
function procmisc(bdb, path, rnum, opts, omode)
   printf("<Miscellaneous Test>\n  path=%s  rnum=%d  opts=%d  omode=%d\n\n",
          path, rnum, opts, omode)
   local err = false
   local stime = tokyocabinet.time()
   if not bdb:tune(10, 10, rnum / 50, 2, -1, opts) then
      eprint(bdb, "tune")
      err = true
   end
   if not bdb:setcache(128, 256) then
      eprint(bdb, "setcache")
      err = true
   end
   if not bdb:setxmsiz(rnum * 4) then
      eprint(bdb, "setxmsiz")
      err = true
   end
   if not bdb:setdfunit(8) then
      eprint(bdb, "setdfunit")
      err = true
   end
   if not bdb:open(path, bdb.OWRITER + bdb.OCREAT + bdb.OTRUNC + omode) then
      eprint(bdb, "open")
      err = true
   end
   printf("writing:\n")
   for i = 1, rnum do
      local buf = string.format("%08d", i)
      if not bdb:put(buf, buf) then
         eprint(bdb, "put")
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
      if not bdb:get(buf) then
         eprint(bdb, "get")
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
      if math.random(2) == 1 and not bdb:out(buf) then
         eprint(bdb, "out")
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
   printf("checking cursor:\n")
   local cur = tokyocabinet.bdbcurnew(bdb)
   if not cur:first() and bdb:ecode() ~= bdb.ENOREC then
      eprint(bdb, "cur:first")
      err = true
   end
   local inum = 0
   while true do
      local key = cur:key()
      if not key then break end
      local value = cur:val()
      if not value then
         eprint(bdb, "cur:val")
         err = true
      end
      cur:next()
      if inum > 0 and rnum > 250 and inum % (rnum / 250) == 0 then
         printf(".")
         if inum == rnum or inum % (rnum / 10) == 0 then
            printf(" (%08d)\n", inum)
         end
      end
      inum = inum + 1
   end
   if rnum > 250 then printf(" (%08d)\n", inum) end
   if bdb:ecode() ~= bdb.ENOREC or inum ~= bdb:rnum() then
      eprint(bdb, "(validation)")
      err = true
   end
   local keys = bdb:fwmkeys("0", 10)
   if bdb:rnum() >= 10 and #keys ~= 10 then
      eprint(bdb, "fwmkeys")
      err = true
   end
   printf("checking counting:\n")
   for i = 1, rnum do
      local buf = string.format("[%d]", math.random(rnum))
      if math.random(2) == 1 then
         if not bdb:addint(buf, 1) and bdb:ecode() ~= bdb.EKEEP then
            eprint(bdb, "addint")
            err = true
            break
         end
      else
         if not bdb:adddouble(buf, 1) and bdb:ecode() ~= bdb.EKEEP then
            eprint(bdb, "adddouble")
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
   if not bdb:sync() then
      eprint(bdb, "sync")
      err = true
   end
   if not bdb:optimize() then
      eprint(bdb, "optimize")
      err = true
   end
   local npath = path .. "-tmp"
   if not bdb:copy(npath) then
      eprint(bdb, "copy")
      err = true
   end
   os.remove(npath)
   if not bdb:vanish() then
      eprint(bdb, "vanish")
      err = true
   end
   printf("random writing:\n")
   for i = 1, rnum do
      local buf = string.format("%08d", math.random(i))
      if not bdb:putdup(buf, buf) then
         eprint(bdb, "adddouble")
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
   printf("cursor updating:\n")
   for i = 1, rnum do
      local buf = string.format("%08d", math.random(i))
      cur:jump(buf)
      for j = 1, 10 do
         local key = cur:key()
         if not key then break end
         if math.random(3) == 1 then
            cur:out()
         else
            local cpmode = cur.CPCURRENT + math.random(3)
            cur:put(buf, cpmode)
         end
         cur:next()
      end
      if rnum > 250 and i % (rnum / 250) == 0 then
         printf(".")
         if i == rnum or i % (rnum / 10) == 0 then
            printf(" (%08d)\n", i)
         end
      end
   end
   if not bdb:tranbegin() then
      eprint(bdb, "tranbegin")
      err = true
   end
   bdb:putdup("::1", "1")
   bdb:putdup("::2", "2a")
   bdb:putdup("::2", "2b")
   bdb:putdup("::3", "3")
   cur:jump("::2")
   cur:put("2A")
   cur:put("2-", cur.CPBEFORE)
   cur:put("2+")
   cur:next()
   cur:next()
   cur:put("mid", cur.CPBEFORE)
   cur:put("2C", cur.CPAFTER)
   cur:prev()
   cur:out()
   local vals = bdb:getlist("::2")
   if not vals or #vals ~= 4 then
      eprint(bdb, "getlist")
      err = true
   end
   local pvals = { "hop", "step", "jump" }
   if not bdb:putlist("::1", pvals) then
      eprint(bdb, "putlist")
      err = true
   end
   if not bdb:outlist("::1") then
      eprint(bdb, "outlist")
      err = true
   end
   if not bdb:trancommit() then
      eprint(bdb, "trancommit")
      err = true
   end
   if not bdb:tranbegin() or not bdb:tranabort() then
      eprint(bdb, "tranbegin")
      err = true
   end
   printf("checking table-like updating:\n")
   for i = 1, rnum do
      local buf = string.format("[%d]", math.random(rnum))
      if math.random(2) == 1 then
         bdb[buf] = buf
      else
         local value = bdb[buf]
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
   bdb:foreach(iterfunc)
   if rnum > 250 then printf(" (%08d)\n", cnt) end
   if cnt ~= bdb:rnum() then
      eprint(bdb, "(validation)")
      err = true
   end
   printf("record number: %d\n", bdb:rnum())
   printf("size: %d\n", bdb:fsiz())
   if not bdb:close() then
      eprint(bdb, "close")
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
