#! /usr/bin/lua

--------------------------------------------------------------------------------------------------
-- The test cases of the utility API
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
   if arg[1] == "misc" then
      rv = runmisc()
   else
      usage()
   end
   collectgarbage("collect")
   return rv
end


-- print the usage and exit
function usage()
   printf("%s: test cases of the utility API\n", progname)
   printf("\n")
   printf("usage:\n")
   printf("  %s misc rnum\n", progname)
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


-- print error message
function eprint(func)
   printf("%s: error: %s\n", progname, func)
end


-- parse arguments of misc command
function runmisc()
   local rnum = nil
   for i = 2, #arg do
      if not rnum and string.match(arg[i], "^-") then
         usage()
      elseif not rnum then
         rnum = tonumber(arg[i])
      else
         usage()
      end
   end
   if not rnum or rnum < 1 then usage() end
   local rv = procmisc(rnum)
   return rv
end


-- perform misc command
function procmisc(rnum)
   printf("<Miscellaneous Test>\n  rnum=%d\n\n", rnum)
   local err = false
   local stime = tokyocabinet.time()
   printf("checking:\n")
   local format = "cCsSiIlLfdnNMwc5C5s5S5i5I5l5L5f5d5n5N5M5w*"
   local cmodes = { "url", "base", "hex", "pack", "tcbs", "deflate", "gzip", "bzip", "xml" }
   local hmodes = { "md5", "md5raw", "crc32" }
   local bitops = { "and", "or", "xor", "not", "left", "right" }
   for i = 1, rnum do
      tokyocabinet.tablenew(math.random(1000), math.random(1000))
      if tokyocabinet.time() < 1 then
         eprint("time")
         err = true
      end
      if math.random(100) == 1 then
         tokyocabinet.sleep(10 / rnum)
      end
      local len = math.random(256) - 1
      if math.random(rnum / 5 + 1) == 1 then
         len = len * math.random(512)
      end
      local ary = {}
      for j = 1, len do
         ary[j] = math.random() * 4294967296 - math.random() * 4294967296
      end
      local off = math.random(#format - 3)
      local myfmt = string.sub(format, off, off + math.random(#format / 3))
      local str = tokyocabinet.pack(myfmt, ary)
      if not str then
         eprint("pack")
         err = true
      end
      local nary = tokyocabinet.unpack(myfmt, str)
      if not nary then
         eprint("unpack")
         err = true
      end
      local cmode = cmodes[math.random(#cmodes)]
      local enc = tokyocabinet.codec(cmode, str)
      local dec = tokyocabinet.codec("~" .. cmode, enc)
      if not enc or not dec then
         eprint("codec")
         err = true
      end
      if dec ~= str and cmode ~= "xml" then
         eprint("(validation:" .. cmode .. ")")
         err = true
      end
      local hmode = hmodes[math.random(#hmodes)]
      if not tokyocabinet.hash(hmode, str) then
         eprint("hash")
         err = true
      end
      local bitop = bitops[math.random(#bitops)]
      if not tokyocabinet.bit(bitop, math.random(0x7fffffff), math.random(0x7fffffff)) then
         eprint("bit")
         err = true
      end
      local rstr = math.random(rnum);
      if not tokyocabinet.regex(rstr, rstr) then
         eprint("regex")
         err = true
      end
      local alt = tostring(math.random(rnum))
      if tokyocabinet.regex(rstr, "^" .. rstr .. "$", alt) ~= alt then
         eprint("regex")
         err = true
      end
      local ucs = {}
      for j = 1, len do
         table.insert(ucs, 0x3042 + math.random(50) - 1)
      end
      local utf = tokyocabinet.ucs(ucs)
      local udec = tokyocabinet.ucs(utf)
      if #udec ~= #ucs then
         eprint("(validation:ucs:enc)")
         err = true
      end
      local uenc = tokyocabinet.ucs(udec)
      if utf ~= uenc then
         eprint("(validation:ucs:dec)")
         err = true
      end
      local umode = true
      if math.random(2) == 1 then
         umode = false
      end
      if tokyocabinet.dist(utf, uenc, umode) ~= 0 then
         eprint("(validation:dist)")
         err = true
      end
      if not tokyocabinet.stat("/") then
         eprint("stat")
         err = true
      end
      if not tokyocabinet.glob("/") then
         eprint("glob")
         err = true
      end
      if i % 100 == 1 then
         local t1 = {}
         len = math.random(10)
         for j = 1, len do
            table.insert(t1, math.random(10))
         end
         local t2 = {}
         len = math.random(10)
         for j = 1, len do
            table.insert(t2, math.random(10))
         end
         local t3 = {}
         len = math.random(10)
         for j = 1, len do
            table.insert(t3, math.random(10))
         end
         tokyocabinet.isect(t1)
         tokyocabinet.isect(t1, t2)
         tokyocabinet.isect({t1, t2, t3})
         tokyocabinet.union(t1)
         tokyocabinet.union(t1, t2)
         tokyocabinet.union({t1, t2, t3})
      end
      if rnum > 250 and i % (rnum / 250) == 0 then
         printf(".")
         if i == rnum or i % (rnum / 10) == 0 then
            printf(" (%08d)\n", i)
         end
      end
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
