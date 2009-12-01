--
-- refine the document
--

INDEXFILE = "doc/index.html"
TMPFILE = INDEXFILE .. "~"
OVERVIEWFILE = "overview.html"

ofd = io.open(TMPFILE, "wb")

first = true
for line in io.lines(INDEXFILE) do
   if first and string.match(line, "<h2> *Modules *</h2>") then
      for tline in io.lines(OVERVIEWFILE) do
         ofd:write(tline .. "\n")
      end
      first = false
   end
   ofd:write(line .. "\n")
end

ofd:close()

os.remove(INDEXFILE)
os.rename(TMPFILE, INDEXFILE)
