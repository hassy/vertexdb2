#! /usr/bin/lua

--------------------------------------------------------------------------------------------------
-- The test cases of the table database API
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

MASKIP = tokyocabinet.bit("left", 1, 0)
MASKIS = tokyocabinet.bit("left", 1, 1)
MASKIN = tokyocabinet.bit("left", 1, 2)
MASKIT = tokyocabinet.bit("left", 1, 3)
MASKIF = tokyocabinet.bit("left", 1, 4)
MASKIX = tokyocabinet.bit("left", 1, 5)


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
   printf("%s: test cases of the table database API\n", progname)
   printf("\n")
   printf("usage:\n")
   printf("  %s write [-tl] [-td|-tb|-tt] [-ip|-is|-in|-it|-if|-ix] [-nl|-nb]" ..
          " path rnum [bnum [apow [fpow]]]\n", progname)
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
function eprint(tdb, func)
   local path = tdb:path()
   if not path then path = "-" end
   printf("%s: %s: %s: %s\n", progname, path, func, tdb:errmsg())
end


-- parse arguments of write command
function runwrite()
   local tdb = tokyocabinet.tdbnew()
   local path = nil
   local rnum = nil
   local bnum = nil
   local apow = nil
   local fpow = nil
   local opts = 0
   local iflags = 0
   local omode = 0
   for i = 2, #arg do
      if not path and string.match(arg[i], "^-") then
         if arg[i] == "-tl" then
            opts = opts + tdb.TLARGE
         elseif arg[i] == "-td" then
            opts = opts + tdb.TDEFLATE
         elseif arg[i] == "-tb" then
            opts = opts + tdb.TBZIP
         elseif arg[i] == "-tt" then
            opts = opts + tdb.TTCBS
         elseif arg[i] == "-ip" then
            iflags = iflags + MASKIP
         elseif arg[i] == "-is" then
            iflags = iflags + MASKIS
         elseif arg[i] == "-in" then
            iflags = iflags + MASKIN
         elseif arg[i] == "-it" then
            iflags = iflags + MASKIT
         elseif arg[i] == "-if" then
            iflags = iflags + MASKIF
         elseif arg[i] == "-ix" then
            iflags = iflags + MASKIX
         elseif arg[i] == "-nl" then
            omode = omode + tdb.ONOLCK
         elseif arg[i] == "-nb" then
            omode = omode + tdb.OLCKNB
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
   local rv = procwrite(tdb, path, rnum, bnum, apow, fpow, opts, iflags, omode)
   return rv
end


-- parse arguments of read command
function runread()
   local tdb = tokyocabinet.tdbnew()
   local path = nil
   local omode = 0
   for i = 2, #arg do
      if not path and string.match(arg[i], "^-") then
         if arg[i] == "-nl" then
            omode = omode + tdb.ONOLCK
         elseif arg[i] == "-nb" then
            omode = omode + tdb.OLCKNB
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
   local rv = procread(tdb, path, omode)
   return rv
end


-- parse arguments of remove command
function runremove()
   local tdb = tokyocabinet.tdbnew()
   local path = nil
   local omode = 0
   for i = 2, #arg do
      if not path and string.match(arg[i], "^-") then
         if arg[i] == "-nl" then
            omode = omode + tdb.ONOLCK
         elseif arg[i] == "-nb" then
            omode = omode + tdb.OLCKNB
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
   local rv = procremove(tdb, path, omode)
   return rv
end


-- parse arguments of misc command
function runmisc()
   local tdb = tokyocabinet.tdbnew()
   local path = nil
   local rnum = nil
   local opts = 0
   local omode = 0
   for i = 2, #arg do
      if not path and string.match(arg[i], "^-") then
         if arg[i] == "-tl" then
            opts = opts + tdb.TLARGE
         elseif arg[i] == "-td" then
            opts = opts + tdb.TDEFLATE
         elseif arg[i] == "-tb" then
            opts = opts + tdb.TBZIP
         elseif arg[i] == "-tt" then
            opts = opts + tdb.TTCBS
         elseif arg[i] == "-nl" then
            omode = omode + tdb.ONOLCK
         elseif arg[i] == "-nb" then
            omode = omode + tdb.OLCKNB
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
   local rv = procmisc(tdb, path, rnum, opts, omode)
   return rv
end


-- perform write command
function procwrite(tdb, path, rnum, bnum, apow, fpow, opts, iflags, omode)
   printf("<Writing Test>\n  path=%s  rnum=%d  bnum=%d  apow=%d  fpow=%d  opts=%d" ..
          "  iflags=%d  omode=%d\n\n", path, rnum, bnum, apow, fpow, opts, iflags, omode)
   local err = false
   local stime = tokyocabinet.time()
   if not tdb:tune(bnum, apow, fpow, opts) then
      eprint(tdb, "tune")
      err = true
   end
   if not tdb:open(path, tdb.OWRITER + tdb.OCREAT + tdb.OTRUNC + omode) then
      eprint(tdb, "open")
      err = true
   end
   if tokyocabinet.bit("and", iflags, MASKIP) > 0 and not tdb:setindex("", tdb.ITDECIMAL) then
      eprint(tdb, "setindex")
      err = true
   end
   if tokyocabinet.bit("and", iflags, MASKIS) > 0 and not tdb:setindex("str", tdb.ITLEXICAL) then
      eprint(tdb, "setindex")
      err = true
   end
   if tokyocabinet.bit("and", iflags, MASKIN) > 0 and not tdb:setindex("num", tdb.ITDECIMAL) then
      eprint(tdb, "setindex")
      err = true
   end
   if tokyocabinet.bit("and", iflags, MASKIT) > 0 and not tdb:setindex("type", tdb.ITDECIMAL) then
      eprint(tdb, "setindex")
      err = true
   end
   if tokyocabinet.bit("and", iflags, MASKIF) > 0 and not tdb:setindex("flag", tdb.ITTOKEN) then
      eprint(tdb, "setindex")
      err = true
   end
   if tokyocabinet.bit("and", iflags, MASKIX) > 0 and not tdb:setindex("text", tdb.ITQGRAM) then
      eprint(tdb, "setindex")
      err = true
   end
   for i = 1, rnum do
      local id = tdb:genuid()
      local cols = {
         str = id,
         num = math.random(id) + 1,
         type = math.random(32) + 1,
      }
      local vbuf = ""
      local num = math.random(5)
      local pt = 0
      for j = 1, num do
         pt = pt + math.random(5)
         if #vbuf > 0 then
            vbuf = vbuf .. ","
         end
         vbuf = vbuf .. pt
      end
      if #vbuf > 0 then
         cols.flag = vbuf
         cols.text = vbuf
      end
      if not tdb:put(id, cols) then
         eprint(tdb, "put")
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
   printf("record number: %d\n", tdb:rnum())
   printf("size: %d\n", tdb:fsiz())
   if not tdb:close() then
      eprint(tdb, "close")
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
function procread(tdb, path, omode)
   printf("<Reading Test>\n  path=%s  omode=%d\n\n", path, omode)
   local err = false
   local stime = tokyocabinet.time()
   if not tdb:open(path, tdb.OREADER + omode) then
      eprint(tdb, "open")
      err = true
   end
   local rnum = tdb:rnum()
   for i = 1, rnum do
      if not tdb:get(i) then
         eprint(tdb, "get")
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
   printf("record number: %d\n", tdb:rnum())
   printf("size: %d\n", tdb:fsiz())
   if not tdb:close() then
      eprint(tdb, "close")
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
function procremove(tdb, path, omode)
   printf("<Removing Test>\n  path=%s  omode=%d\n\n", path, omode)
   local err = false
   local stime = tokyocabinet.time()
   if not tdb:open(path, tdb.OWRITER + omode) then
      eprint(tdb, "open")
      err = true
   end
   local rnum = tdb:rnum()
   for i = 1, rnum do
      if not tdb:out(i) then
         eprint(tdb, "out")
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
   printf("record number: %d\n", tdb:rnum())
   printf("size: %d\n", tdb:fsiz())
   if not tdb:close() then
      eprint(tdb, "close")
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
function procmisc(tdb, path, rnum, opts, omode)
   printf("<Miscellaneous Test>\n  path=%s  rnum=%d  opts=%d  omode=%d\n\n",
          path, rnum, opts, omode)
   local err = false
   local stime = tokyocabinet.time()
   if not tdb:tune(rnum / 50, 2, -1, opts) then
      eprint(tdb, "tune")
      err = true
   end
   if not tdb:setcache(rnum / 10, 128, 256) then
      eprint(tdb, "setcache")
      err = true
   end
   if not tdb:setxmsiz(rnum * 4) then
      eprint(tdb, "setxmsiz")
      err = true
   end
   if not tdb:setdfunit(8) then
      eprint(tdb, "setdfunit")
      err = true
   end
   if not tdb:open(path, tdb.OWRITER + tdb.OCREAT + tdb.OTRUNC + omode) then
      eprint(tdb, "open")
      err = true
   end
   if not tdb:setindex("", tdb.ITDECIMAL) then
      eprint(tdb, "setindex")
      err = true
   end
   if not tdb:setindex("str", tdb.ITLEXICAL) then
      eprint(tdb, "setindex")
      err = true
   end
   if not tdb:setindex("num", tdb.ITDECIMAL) then
      eprint(tdb, "setindex")
      err = true
   end
   if not tdb:setindex("type", tdb.ITDECIMAL) then
      eprint(tdb, "setindex")
      err = true
   end
   if not tdb:setindex("flag", tdb.ITTOKEN) then
      eprint(tdb, "setindex")
      err = true
   end
   if not tdb:setindex("text", tdb.ITQGRAM) then
      eprint(tdb, "setindex")
      err = true
   end
   printf("writing:\n")
   for i = 1, rnum do
      local id = tdb:genuid()
      local cols = {
         str = id,
         num = math.random(id) + 1,
         type = math.random(32) + 1,
      }
      local vbuf = ""
      local num = math.random(5)
      local pt = 0
      for j = 1, num do
         pt = pt + math.random(5)
         if #vbuf > 0 then
            vbuf = vbuf .. ","
         end
         vbuf = vbuf .. pt
      end
      if #vbuf > 0 then
         cols.flag = vbuf
         cols.text = vbuf
      end
      if not tdb:put(id, cols) then
         eprint(tdb, "put")
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
      if not tdb:get(i) then
         eprint(tdb, "get")
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
      if math.random(2) == 1 and not tdb:out(i) then
         eprint(tdb, "out")
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
   if not tdb:iterinit() then
      eprint(tdb, "iterinit")
      err = true
   end
   local inum = 0
   while true do
      local pkey = tdb:iternext()
      if not pkey then break end
      local cols = tdb:get(pkey)
      if not cols then
         eprint(tdb, "get")
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
   if tdb:ecode() ~= tdb.ENOREC or inum ~= tdb:rnum() then
      eprint(tdb, "(validation)")
      err = true
   end
   local pkeys = tdb:fwmkeys("1", 10)
   printf("checking counting:\n")
   for i = 1, rnum do
      local buf = string.format("i:%d", math.random(rnum))
      if math.random(2) == 1 then
         if not tdb:addint(buf, 1) and tdb:ecode() ~= tdb.EKEEP then
            eprint(tdb, "addint")
            err = true
            break
         end
      else
         if not tdb:adddouble(buf, 1) and tdb:ecode() ~= tdb.EKEEP then
            eprint(tdb, "adddouble")
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
   if not tdb:sync() then
      eprint(tdb, "sync")
      err = true
   end
   if not tdb:optimize() then
      eprint(tdb, "optimize")
      err = true
   end
   local npath = path .. "-tmp"
   if not tdb:copy(npath) then
      eprint(tdb, "copy")
      err = true
   end
   local tpaths = tokyocabinet.glob(npath .. ".idx.*")
   for i = 1, #tpaths do
      os.remove(tpaths[i])
   end
   os.remove(npath)
   printf("searching:\n")
   local qry = tokyocabinet.tdbqrynew(tdb)
   local names = { "", "str", "num", "type", "flag", "text", "c1" }
   local ops = { qry.QCSTREQ, qry.QCSTRINC, qry.QCSTRBW, qry.QCSTREW, qry.QCSTRAND,
                 qry.QCSTROR, qry.QCSTROREQ, qry.QCSTRRX, qry.QCNUMEQ, qry.QCNUMGT,
                 qry.QCNUMGE, qry.QCNUMLT, qry.QCNUMLE, qry.QCNUMBT, qry.QCNUMOREQ }
   local ftsops = { qry.QCFTSPH, qry.QCFTSAND, qry.QCFTSOR, qry.QCFTSEX }
   local types = { qry.QOSTRASC, qry.QOSTRDESC, qry.QONUMASC, qry.QONUMDESC }
   for i = 1, rnum do
      if math.random(10) > 0 then
         qry = tokyocabinet.tdbqrynew(tdb)
      end
      local cnum = math.random(4)
      for j = 1, cnum do
         local name = names[math.random(#names)]
         local op = ops[math.random(#ops)]
         if math.random(10) == 1 then
            op = ftsops[math.random(#ftsops)]
         end
         if math.random(20) == 1 then
            op = op + qry.QCNEGATE
         end
         if math.random(20) == 1 then
            op = op + qry.QCNOIDX
         end
         local expr = math.random(i)
         if math.random(10) == 1 then
            expr = expr .. "," .. math.random(i)
         end
         if math.random(10) == 1 then
            expr = expr .. "," .. math.random(i)
         end
         qry:addcond(name, op, expr)
      end
      if math.random(3) ~= 1 then
         local name = names[math.random(#names)]
         local type = types[math.random(#types)]
         qry:setorder(name, type)
      end
      if math.random(3) ~= 1 then
         qry:setlimit(math.random(i), math.random(10))
      end
      local res = qry:search()
      if rnum > 250 and i % (rnum / 250) == 0 then
         printf(".")
         if i == rnum or i % (rnum / 10) == 0 then
            printf(" (%08d)\n", i)
         end
      end
   end
   qry = tokyocabinet.tdbqrynew(tdb)
   qry:addcond("", qry.QCSTRBW, "i:")
   qry:setorder("_num", qry.QONUMDESC)
   local ires = qry:search()
   local irnum = #ires
   local itnum = tdb:rnum()
   local icnt = 0
   function procfunc(pkey, cols)
      icnt = icnt + 1
      cols.icnt = icnt
      return qry.QPPUT
   end
   if not qry:proc(procfunc) then
      eprint(tdb, "qry::proc")
      err = true
   end
   qry:addcond("icnt", qry.QCNUMGT, 0)
   local mures = qry:metasearch({ qry, qry }, qry.MSUNION)
   if #mures ~= irnum then
      eprint(tdb, "qry::metasearch")
      err = true
   end
   qry:addcond("icnt", qry.QCNUMGT, 0)
   local mires = qry:metasearch({ qry, qry }, qry.MSISECT)
   if #mires ~= irnum then
      eprint(tdb, "qry::metasearch")
      err = true
   end
   qry:addcond("icnt", qry.QCNUMGT, 0)
   local mdres = qry:metasearch({ qry, qry }, qry.MSDIFF)
   if #mdres ~= 0 then
      eprint(tdb, "qry::metasearch")
      err = true
   end
   if not qry:searchout() then
      eprint(tdb, "qry::searchout")
      err = true
   end
   if tdb:rnum() ~= itnum - irnum then
      eprint(tdb, "(validation)")
      err = true
   end
   qry = tokyocabinet.tdbqrynew(tdb)
   qry:addcond("text", qry.QCSTRBW, "1")
   qry:setlimit(100, 1)
   local res = qry:search()
   for i = 1, #res do
      local cols = tdb:get(res[i])
      if cols then
         local texts = qry:kwic(cols, "text", -1, qry.KWMUBRCT)
         if #texts > 0 then
            for j = 1, #texts do
               if not string.find(texts[j], "1") then
                  eprint(tdb, "(validation)")
                  err = true
                  break
               end
            end
         else
            eprint(tdb, "(validation)")
            err = true
            break
         end
      else
         eprint(tdb, "get")
         err = true
         break
      end
   end
   if not tdb:vanish() then
      eprint(tdb, "vanish")
      err = true
   end
   printf("checking transaction commit:\n")
   if not tdb:tranbegin() then
      eprint(tdb, "tranbegin")
      err = true
   end
   for i = 1, rnum do
      local id = math.random(rnum)
      if math.random(2) == 1 then
         if not tdb:addint(id, 1) then
            eprint(tdb, "addint")
            err = true
            break
         end
      else
         if not tdb:out(id) and tdb:ecode() ~= tdb.ENOREC then
            eprint(tdb, "out")
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
   if not tdb:trancommit() then
      eprint(tdb, "trancommit")
      err = true
   end
   printf("checking transaction abort:\n")
   local ornum = tdb:rnum()
   local ofsiz = tdb:fsiz()
   if not tdb:tranbegin() then
      eprint(tdb, "tranbegin")
      err = true
   end
   for i = 1, rnum do
      local id = math.random(rnum)
      if math.random(2) == 1 then
         if not tdb:addint(id, 1) then
            eprint(tdb, "addint")
            err = true
            break
         end
      else
         if not tdb:out(id) and tdb:ecode() ~= tdb.ENOREC then
            eprint(tdb, "out")
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
   if not tdb:tranabort() then
      eprint(tdb, "tranabort")
      err = true
   end
   if tdb:rnum() ~= ornum or tdb:fsiz() ~= ofsiz then
      eprint(tdb, "(validation)")
      err = true
   end
   printf("checking table-like updating:\n")
   for i = 1, rnum do
      local buf = string.format("[%d]", math.random(rnum))
      if math.random(2) == 1 then
         tdb[buf] = { name = buf }
      else
         local cols = tdb[buf]
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
   tdb:foreach(iterfunc)
   if rnum > 250 then printf(" (%08d)\n", cnt) end
   if cnt ~= tdb:rnum() then
      eprint(tdb, "(validation)")
      err = true
   end
   printf("record number: %d\n", tdb:rnum())
   printf("size: %d\n", tdb:fsiz())
   if not tdb:close() then
      eprint(tdb, "close")
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
