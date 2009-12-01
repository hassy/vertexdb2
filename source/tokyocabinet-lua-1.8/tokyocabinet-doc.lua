-- Ruby binding of Tokyo Cabinet
--                                                       Copyright (C) 2006-2009 Mikio Hirabayashi
--  This file is part of Tokyo Cabinet.
--  Tokyo Cabinet is free software; you can redistribute it and/or modify it under the terms of
--  the GNU Lesser General Public License as published by the Free Software Foundation; either
--  version 2.1 of the License or any later version.  Tokyo Cabinet is distributed in the hope
--  that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
--  License for more details.
--  You should have received a copy of the GNU Lesser General Public License along with Tokyo
--  Cabinet; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
--  Boston, MA 02111-1307 USA.


--- The Lua binding of Tokyo Cabinet.
module("tokyocabinet")
tokyocabinet = {}
hdb = {}
bdb = {}
bdbcur = {}
fdb = {}
tdb = {}
tdbqry = {}
adb = {}


--- Create a hash database object.
-- Hash database is a file containing a hash table and is handled with the hash database API.  Before operations to store or retrieve records, it is necessary to open a database file and connect the hash database object to it.  To avoid data missing or corruption, it is important to close every database file when it is no longer in use.  It is forbidden for multible database objects in a process to open the same database at the same time.
-- @return the new hash database object.
function tokyocabinet.hdbnew()
   -- (native code)
end

--- Create a B+ tree database object.
-- B+ tree database is a file containing a B+ tree and is handled with the B+ tree database API.  Before operations to store or retrieve records, it is necessary to open a database file and connect the B+ tree database object to it.  To avoid data missing or corruption, it is important to close every database file when it is no longer in use.  It is forbidden for multible database objects in a process to open the same database at the same time.
-- @return the new B+ tree database object.
function tokyocabinet.bdbnew()
   -- (native code)
end

--- Create a cursor object of a B+ tree database object.
-- Cursor is a mechanism to access each record of B+ tree database in ascending or descending order.  The cursor is available only after initialization with the `cur:first' or the `cur:jump' methods and so on.  Moreover, the position of the cursor will be indefinite when the database is updated after the initialization of the cursor.
-- @param bdb the B+ tree database object.
function tokyocabinet.bdbcurnew(bdb)
   -- (native code)
end

--- Create a fixed-length database object.
-- Fixed-Length database is a file containing a fixed-length table and is handled with the fixed-length database API.  Before operations to store or retrieve records, it is necessary to open a database file and connect the fixed-length database object to it.  To avoid data missing or corruption, it is important to close every database file when it is no longer in use.  It is forbidden for multible database objects in a process to open the same database at the same time.
-- @return the new fixed-length database object.
function tokyocabinet.fdbnew()
   -- (native code)
end

--- Create a table database object.
-- Table database is a file containing records composed of the primary keys and arbitrary columns and is handled with the table database API.  Before operations to store or retrieve records, it is necessary to open a database file and connect the table database object to it.  To avoid data missing or corruption, it is important to close every database file when it is no longer in use.  It is forbidden for multible database objects in a process to open the same database at the same time.
-- @return the new table database object.
function tokyocabinet.tdbnew()
   -- (native code)
end

--- Create a query object of a table database object.
-- Query is a mechanism to search for and retrieve records corresponding conditions from table database.
-- @param tdb the table database object.
function tokyocabinet.tdbqrynew(tdb)
   -- (native code)
end

--- Create an abstract database object.
-- Abstract database is a set of interfaces to use on-memory hash database, on-memory tree database, hash database, B+ tree database, fixed-length database, and table database with the same API.  Before operations to store or retrieve records, it is necessary to connect the abstract database object to the concrete one.  The method `open' is used to open a concrete database and the method `close' is used to close the database.  To avoid data missing or corruption, it is important to close every database instance when it is no longer in use.  It is forbidden for multible database objects in a process to open the same database at the same time.
-- @return the new abstract database object.
function tokyocabinet.adbnew()
   -- (native code)
end

--- Create a table with specifying the number of array elements and the number of hash records.
-- @param anum the expected number of array elements.  If it is not defined, 0 is specified.
-- @param rnum the expected number of hash records.  If it is not defined, 0 is specified.
-- @return the created empty table.
function tokyocabinet.tablenew(anum, rnum)
   -- (native code)
end

--- Serialize an array of numbers into a string.
-- @param format the format string.  It should be composed of conversion characters; `c' for int8_t, `C' for uint8_t, `s' for int16_t, `S' for uint16_t, `i' for int32_t, `I' for uint32_t, `l' for int64_t, `L' for uint64_t, `f' for float, `d' for double, `n' for uint16_t in network byte order, `N' for uint32_t in network byte order, `M' for uint64_t in network byte order, and `w' for BER encoding.  They can be trailed by a numeric expression standing for the iteration count or by `*' for the rest all iteration.
-- @param ary the array of numbers.  It can be trailed optional arguments, which are treated as additional elements of the array.
-- @return the serialized string.
function tokyocabinet.pack(format, ary, ...)
   -- (native code)
end

--- Deserialize a binary string into an array of numbers.
-- @param format the format string.  It should be composed of conversion characters as with `tokyocabinet.pack'.
-- @param str the binary string.
-- @return the deserialized array.
function tokyocabinet.unpack(format, str)
   -- (native code)
end

--- Split a string into substrings.
-- @param str the string
-- @param delims a string including separator characters.  If it is not defined, the zero code is specified.
-- @return an array of substrings.
function tokyocabinet.split(str, delims)
   -- (native code)
end

--- Encode or decode a string.
-- @param mode the encoding method; "url" for URL encoding, "~url" for URL decoding, "base" for Base64 encoding, "~base" for Base64 decoding, "hex" for hexadecimal encoding, "~hex" for hexadecimal decoding, "pack" for PackBits encoding, "~pack" for PackBits decoding, "tcbs" for TCBS encoding, "~tcbs" for TCBS decoding, "deflate" for Deflate encoding, "~deflate" for Deflate decoding, "gzip" for GZIP encoding, "~gzip" for GZIP decoding, "bzip" for BZIP2 encoding, "~bzip" for BZIP2 decoding, "xml" for XML escaping, "~xml" for XML unescaping.
-- @param str the string.
-- @return the encoded or decoded string.
function tokyocabinet.codec(mode, str)
   -- (native code)
end

--- Get the hash value of a string.
-- @param mode the hash method; "md5" for MD5 in hexadecimal format, "md5raw" for MD5 in raw format, "crc32" for CRC32 checksum number.
-- @param str the string.
-- @return the hash value.
function tokyocabinet.hash(mode, str)
   -- (native code)
end

--- Perform bit operation of an integer.
-- @param mode the operator; "and" for bitwise-and operation, "or" for bitwise-or operation, "xor" for bitwise-xor operation, "not" for bitwise-not operation, "left" for left shift operation, "right" for right shift operation.
-- @param num the integer, which is treated as an unsigned 32-bit integer.
-- @param aux the auxiliary operand for some operators.
-- @return the result value.
function tokyocabinet.bit(mode, num, aux)
   -- (native code)
end

--- Perform pattern matching or replacement with regular expressions.
-- @param str the source string.
-- @param pattern the pattern of regular expressions.
-- @param alt the alternative string corresponding for the pattern.  If it is not defined, matching check is performed.
-- @return If the alternative string is specified, the converted string is returned.  If the alternative string is not specified, the boolean value of whether the source string matches the pattern is returned.
function tokyocabinet.regex(str, pattern, alt)
   -- (native code)
end

--- Convert a UTF-8 string into a UCS-2 array or its inverse.
-- @param data the target data.  If it is a string, convert it into a UCS-array.  If it is an array, convert it into a UTF-8 string.
-- @return the result data.
function tokyocabinet.ucs(data)
   -- (native code)
end

--- Calculate the edit distance of two UTF-8 strings.
-- @param astr a string.
-- @param bstr the other string.
-- @param isutf whether to calculate cost by Unicode character.  If it is not defined, false is specified and calculate cost by ASCII character.
-- @return the edit distance which is known as the Levenshtein distance.
function tokyocabinet.dist(astr, bstr, isutf)
   -- (native code)
end

--- Calculate the intersection set of arrays.
-- @param ary the arrays.  Arbitrary number of arrays can be specified as the parameter list.
-- @return the array of the intersection set.
function tokyocabinet.isect(ary, ...)
   -- (native code)
end

--- Calculate the union set of arrays.
-- @param ary the arrays.  Arbitrary number of arrays can be specified as the parameter list.
-- @return the array of the union set.
function tokyocabinet.union(ary, ...)
   -- (native code)
end

--- Get the time of day in seconds.
-- @return the time of day in seconds.  The accuracy is in microseconds.
function tokyocabinet.time()
   -- (native code)
end

--- Suspend execution for the specified interval.
-- @param sec the interval in seconds.
-- @return If successful, it is true, else, it is false.
function tokyocabinet.sleep(sec)
   -- (native code)
end

--- Get the status of a file.
-- @param path the path of the file.
-- @return If successful, it is a table containing status, else, it is `nil'.  There are keys of status name; "dev", "ino", "mode", "nlink", "uid", "gid", "rdev", "size", "blksize", "blocks", "atime", "mtime", "ctime", which have same meanings of the POSIX "stat" call.  Additionally, "_regular" for whether the file is a regular file, "_directory" for whether the file is a directory, "_readable" for whether the file is readable by the process, "_writable" for whether the file is writable by the process, "_executable" for whether the file is executable by the process, "_realpath" for the real path of the file, are supported.
function tokyocabinet.stat(path)
   -- (native code)
end

--- Find pathnames matching a pattern.
-- @param pattern the matching pattern.  "?" and "*" are meta characters.
-- @return an array of matched paths.  If no path is matched, an empty array is returned.
function tokyocabinet.glob(pattern)
   -- (native code)
end

--- Remove a file or a directory and its sub ones recursively.
-- @param path the path of the link.
-- @return If successful, it is true, else, it is false.
function tokyocabinet.remove(path)
   -- (native code)
end

--- Create a directory.
-- @param path the path of the directory.
-- @return If successful, it is true, else, it is false.
function tokyocabinet.mkdir(path)
   -- (native code)
end

--- Change the current working directory.
-- @param path the path of the directory.
-- @return If successful, it is true, else, it is false.
function tokyocabinet.chdir(path)
   -- (native code)
end

--- Get the message string corresponding to an error code.
-- @param ecode the error code.  If it is not defined or negative, the last happened error code is specified.
-- @return the message string of the error code.
function hdb:errmsg(ecode)
   -- (native code)
end

--- Get the last happened error code.
-- @return the last happened error code.  The following error codes are defined: `hdb.ESUCCESS' for success, `hdb.ETHREAD' for threading error, `hdb.EINVALID' for invalid operation, `hdb.ENOFILE' for file not found, `hdb.ENOPERM' for no permission, `hdb.EMETA' for invalid meta data, `hdb.ERHEAD' for invalid record header, `hdb.EOPEN' for open error, `hdb.ECLOSE' for close error, `hdb.ETRUNC' for trunc error, `hdb.ESYNC' for sync error, `hdb.ESTAT' for stat error, `hdb.ESEEK' for seek error, `hdb.EREAD' for read error, `hdb.EWRITE' for write error, `hdb.EMMAP' for mmap error, `hdb.ELOCK' for lock error, `hdb.EUNLINK' for unlink error, `hdb.ERENAME' for rename error, `hdb.EMKDIR' for mkdir error, `hdb.ERMDIR' for rmdir error, `hdb.EKEEP' for existing record, `hdb.ENOREC' for no record found, and `hdb.EMISC' for miscellaneous error.
function hdb:ecode()
   -- (native code)
end

--- Set the tuning parameters.
-- The tuning parameters of the database should be set before the database is opened.
-- @param bnum the number of elements of the bucket array.  If it is not defined or not more than 0, the default value is specified.  The default value is 131071.  Suggested size of the bucket array is about from 0.5 to 4 times of the number of all records to be stored.
-- @param apow the size of record alignment by power of 2.  If it is not defined or negative, the default value is specified.  The default value is 4 standing for 2^4=16.
-- @param fpow the maximum number of elements of the free block pool by power of 2.  If it is not defined or negative, the default value is specified.  The default value is 10 standing for 2^10=1024.
-- @param opts options by bitwise-or: `hdb.TLARGE' specifies that the size of the database can be larger than 2GB by using 64-bit bucket array, `hdb.TDEFLATE' specifies that each record is compressed with Deflate encoding, `hdb.TBZIP' specifies that each record is compressed with BZIP2 encoding, `hdb.TTCBS' specifies that each record is compressed with TCBS encoding.  If it is not defined, no option is specified.
-- @return If successful, it is true, else, it is false.
function hdb:tune(bnum, apow, fpow, opts)
   -- (native code)
end

--- Set the caching parameters.
-- The caching parameters of the database should be set before the database is opened.
-- @param rcnum the maximum number of records to be cached.  If it is not defined or not more than 0, the record cache is disabled.  It is disabled by default.
-- @return If successful, it is true, else, it is false.
function hdb:setcache(rcnum)
   -- (native code)
end

--- Set the size of the extra mapped memory.
-- The mapping parameters should be set before the database is opened.
-- @param xmsiz the size of the extra mapped memory.  If it is not defined or not more than 0, the extra mapped memory is disabled.  The default size is 67108864.
-- @return If successful, it is true, else, it is false.
function hdb:setxmsiz(xmsiz)
   -- (native code)
end

--- Set the unit step number of auto defragmentation.
-- @param dfunit the unit step number.  If it is not more than 0, the auto defragmentation is disabled.  It is disabled by default.
-- @return If successful, it is true, else, it is false.
function hdb:setdfunit(dfunit)
   -- (native code)
end

--- Open a database file.
-- @param path the path of the database file.
-- @param omode the connection mode: `hdb.OWRITER' as a writer, `hdb.OREADER' as a reader.  If the mode is `hdb.OWRITER', the following may be added by bitwise-or: `hdb.OCREAT', which means it creates a new database if not exist, `hdb.OTRUNC', which means it creates a new database regardless if one exists, `hdb.OTSYNC', which means every transaction synchronizes updated contents with the device.  Both of `hdb.OREADER' and `hdb.OWRITER' can be added to by bitwise-or: `hdb.ONOLCK', which means it opens the database file without file locking, or `hdb.OLCKNB', which means locking is performed without blocking.  If it is not defined, `hdb.OREADER' is specified.
-- @return If successful, it is true, else, it is false.
function hdb:open(path, omode)
   -- (native code)
end

--- Close the database file.
-- Update of a database is assured to be written when the database is closed.  If a writer opens a database but does not close it appropriately, the database will be broken.
-- @return If successful, it is true, else, it is false.
function hdb:close()
   -- (native code)
end

--- Store a record.
-- If a record with the same key exists in the database, it is overwritten.
-- @param key the key.
-- @param value the value.
-- @return If successful, it is true, else, it is false.
function hdb:put(key, value)
   -- (native code)
end

--- Store a new record.
-- If a record with the same key exists in the database, this method has no effect.
-- @param key the key.
-- @param value the value.
-- @return If successful, it is true, else, it is false.
function hdb:putkeep(key, value)
   -- (native code)
end

--- Concatenate a value at the end of the existing record.
-- If there is no corresponding record, a new record is created.
-- @param key the key.
-- @param value the value.
-- @return If successful, it is true, else, it is false.
function hdb:putcat(key, value)
   -- (native code)
end

--- Store a record in asynchronous fashion.
-- If a record with the same key exists in the database, it is overwritten.  Records passed to this method are accumulated into the inner buffer and wrote into the file at a blast.
-- @param key the key.
-- @param value the value.
-- @return If successful, it is true, else, it is false.
function hdb:putasync(key, value)
   -- (native code)
end

--- Remove a record.
-- @param key the key.
-- @return If successful, it is true, else, it is false.
function hdb:out(key)
   -- (native code)
end

--- Retrieve a record.
-- @param key the key.
-- @return If successful, it is the value of the corresponding record.  `nil' is returned if no record corresponds.
function hdb:get(key)
   -- (native code)
end

--- Get the size of the value of a record.
-- @param key the key.
-- @return If successful, it is the size of the value of the corresponding record, else, it is -1.
function hdb:vsiz(key)
   -- (native code)
end

--- Initialize the iterator.
-- The iterator is used in order to access the key of every record stored in a database.
-- @return If successful, it is true, else, it is false.
function hdb:iterinit()
   -- (native code)
end

--- Get the next key of the iterator.
-- It is possible to access every record by iteration of calling this method.  It is allowed to update or remove records whose keys are fetched while the iteration.  However, it is not assured if updating the database is occurred while the iteration.  Besides, the order of this traversal access method is arbitrary, so it is not assured that the order of storing matches the one of the traversal access.
-- @return If successful, it is the next key, else, it is `nil'.  `nil' is returned when no record is to be get out of the iterator.
function hdb:iternext()
   -- (native code)
end

--- Get forward matching keys.
-- This function may be very slow because every key in the database is scanned.
-- @param prefix the prefix of the corresponding keys.
-- @param max the maximum number of keys to be fetched.  If it is negative, no limit is specified.
-- @return an array of the keys of the corresponding records.  This method does never fail.  It returns an empty array even if no record corresponds.
function hdb:fwmkeys(prefix, max)
   -- (native code)
end

--- Add an integer to a record.
-- If the corresponding record exists, the value is treated as an integer and is added to.  If no record corresponds, a new record of the additional value is stored.
-- @param key the key.
-- @param num the additional value.
-- @return If successful, it is the summation value, else, it is `nil'.
function hdb:addint(key, num)
   -- (native code)
end

--- Add a real number to a record.
-- If the corresponding record exists, the value is treated as a real number and is added to.  If no record corresponds, a new record of the additional value is stored.
-- @param key the key.
-- @param num the additional value.
-- @return If successful, it is the summation value, else, it is `nil'.
function hdb:adddouble(key, num)
   -- (native code)
end

--- Synchronize updated contents with the file and the device.
-- This method is useful when another process connects the same database file.
-- @return If successful, it is true, else, it is false.
function hdb:sync()
   -- (native code)
end

--- Optimize the database file.
-- This method is useful to reduce the size of the database file with data fragmentation by successive updating.
-- @param bnum the number of elements of the bucket array.  If it is not defined or not more than 0, the default value is specified.  The default value is two times of the number of records.
-- @param apow the size of record alignment by power of 2.  If it is not defined or negative, the current setting is not changed.
-- @param fpow the maximum number of elements of the free block pool by power of 2.  If it is not defined or negative, the current setting is not changed.
-- @param opts options by bitwise-or: `hdb.TLARGE' specifies that the size of the database can be larger than 2GB by using 64-bit bucket array, `hdb.TDEFLATE' specifies that each record is compressed with Deflate encoding, `hdb.TBZIP' specifies that each record is compressed with BZIP2 encoding, `hdb.TTCBS' specifies that each record is compressed with TCBS encoding.  If it is not defined or 0xff, the current setting is not changed.
-- @return If successful, it is true, else, it is false.
function hdb:optimize(bnum, apow, fpow, opts)
   -- (native code)
end

--- Remove all records.
-- @return If successful, it is true, else, it is false.
function hdb:vanish()
   -- (native code)
end

--- Copy the database file.
-- The database file is assured to be kept synchronized and not modified while the copying or executing operation is in progress.  So, this method is useful to create a backup file of the database file.
-- @param path the path of the destination file.  If it begins with `@', the trailing substring is executed as a command line.
-- @return If successful, it is true, else, it is false.  False is returned if the executed command returns non-zero code.
function hdb:copy(path)
   -- (native code)
end

--- Begin the transaction.
-- The database is locked by the thread while the transaction so that only one transaction can be activated with a database object at the same time.  Thus, the serializable isolation level is assumed if every database operation is performed in the transaction.  All updated regions are kept track of by write ahead logging while the transaction.  If the database is closed during transaction, the transaction is aborted implicitly.
-- @return If successful, it is true, else, it is false.
function hdb:tranbegin()
   -- (native code)
end

--- Commit the transaction.
-- Update in the transaction is fixed when it is committed successfully.
-- @return If successful, it is true, else, it is false.
function hdb:trancommit()
   -- (native code)
end

--- Abort the transaction.
-- Update in the transaction is discarded when it is aborted.  The state of the database is rollbacked to before transaction.
-- @return If successful, it is true, else, it is false.
function hdb:tranabort()
   -- (native code)
end

--- Get the path of the database file.
-- @return the path of the database file or `nil' if the object does not connect to any database file.
function hdb:path()
   -- (native code)
end

--- Get the number of records.
-- @return the number of records or 0 if the object does not connect to any database file.
function hdb:rnum()
   -- (native code)
end

--- Get the size of the database file.
-- @return the size of the database file or 0 if the object does not connect to any database file.
function hdb:fsiz()
   -- (native code)
end

--- Process each record atomically.
-- @param func the iterator function called for each record.  It receives two parameters of the key and the value, and returns true to continue iteration or false to stop iteration.
-- @return If successful, it is true, else, it is false.
function hdb:foreach(func)
   -- (native code)
end

--- Get the iterator for generic "for" loop.
-- @return plural values; the iterator to retrieve the key and the value of the next record, the table itself, and nil.
function hdb:pairs()
   -- (native code)
end

--- Get the message string corresponding to an error code.
-- @param ecode the error code.  If it is not defined or negative, the last happened error code is specified.
-- @return the message string of the error code.
function bdb:errmsg(ecode)
   -- (native code)
end

--- Get the last happened error code.
-- @return the last happened error code.  The following error codes are defined: `bdb.ESUCCESS' for success, `bdb.ETHREAD' for threading error, `bdb.EINVALID' for invalid operation, `bdb.ENOFILE' for file not found, `bdb.ENOPERM' for no permission, `bdb.EMETA' for invalid meta data, `bdb.ERHEAD' for invalid record header, `bdb.EOPEN' for open error, `bdb.ECLOSE' for close error, `bdb.ETRUNC' for trunc error, `bdb.ESYNC' for sync error, `bdb.ESTAT' for stat error, `bdb.ESEEK' for seek error, `bdb.EREAD' for read error, `bdb.EWRITE' for write error, `bdb.EMMAP' for mmap error, `bdb.ELOCK' for lock error, `bdb.EUNLINK' for unlink error, `bdb.ERENAME' for rename error, `bdb.EMKDIR' for mkdir error, `bdb.ERMDIR' for rmdir error, `bdb.EKEEP' for existing record, `bdb.ENOREC' for no record found, and `bdb.EMISC' for miscellaneous error.
function bdb:ecode()
   -- (native code)
end

--- Set the custom comparison function.
-- The default comparison function compares keys of two records by lexical order.  The constants `bdb.CMPLEXICAL' (dafault), `bdb.CMPDECIMAL', `bdb.CMPINT32', and `bdb.CMPINT64' are built-in.  Note that the comparison function should be set before the database is opened.  Moreover, user-defined comparison functions should be set every time the database is being opened.
-- @param cmp the custom comparison function.
-- @return If successful, it is true, else, it is false.
function bdb:setcmpfunc(cmp)
   -- (native code)
end

--- Set the tuning parameters.
-- The tuning parameters of the database should be set before the database is opened.
-- @param lmemb the number of members in each leaf page.  If it is not defined or not more than 0, the default value is specified.  The default value is 128.
-- @param nmemb the number of members in each non-leaf page.  If it is not defined or not more than 0, the default value is specified.  The default value is 256.
-- @param bnum the number of elements of the bucket array.  If it is not defined or not more than 0, the default value is specified.  The default value is 32749.  Suggested size of the bucket array is about from 1 to 4 times of the number of all pages to be stored.
-- @param apow the size of record alignment by power of 2.  If it is not defined or negative, the default value is specified.  The default value is 4 standing for 2^8=256.
-- @param fpow the maximum number of elements of the free block pool by power of 2.  If it is not defined or negative, the default value is specified.  The default value is 10 standing for 2^10=1024.
-- @param opts options by bitwise-or: `bdb.TLARGE' specifies that the size of the database can be larger than 2GB by using 64-bit bucket array, `bdb.TDEFLATE' specifies that each record is compressed with Deflate encoding, `bdb.TBZIP' specifies that each record is compressed with BZIP2 encoding, `bdb.TTCBS' specifies that each record is compressed with TCBS encoding.  If it is not defined, no option is specified.
-- @return If successful, it is true, else, it is false.
function bdb:tune(lmemb, nmemb, bnum, apow, fpow, opts)
   -- (native code)
end

--- Set the caching parameters.
-- The tuning parameters of the database should be set before the database is opened.
-- @param lcnum the maximum number of leaf nodes to be cached.  If it is not defined or not more than 0, the default value is specified.  The default value is 1024.
-- @param ncnum the maximum number of non-leaf nodes to be cached.  If it is not defined or not more than 0, the default value is specified.  The default value is 512.
-- @return If successful, it is true, else, it is false.
function bdb:setcache(lcnum, ncnum)
   -- (native code)
end

--- Set the size of the extra mapped memory.
-- The mapping parameters should be set before the database is opened.
-- @param xmsiz the size of the extra mapped memory.  If it is not defined or not more than 0, the extra mapped memory is disabled.  It is disabled by default.
-- @return If successful, it is true, else, it is false.
function bdb:setxmsiz(xmsiz)
   -- (native code)
end

--- Set the unit step number of auto defragmentation.
-- @param dfunit the unit step number.  If it is not more than 0, the auto defragmentation is disabled.  It is disabled by default.
-- @return If successful, it is true, else, it is false.
function bdb:setdfunit(dfunit)
   -- (native code)
end

--- Open a database file.
-- @param path the path of the database file.
-- @param omode the connection mode: `bdb.OWRITER' as a writer, `bdb.OREADER' as a reader.  If the mode is `bdb.OWRITER', the following may be added by bitwise-or: `bdb.OCREAT', which means it creates a new database if not exist, `bdb.OTRUNC', which means it creates a new database regardless if one exists, `bdb.OTSYNC', which means every transaction synchronizes updated contents with the device.  Both of `bdb.OREADER' and `bdb.OWRITER' can be added to by bitwise-or: `bdb.ONOLCK', which means it opens the database file without file locking, or `bdb.OLCKNB', which means locking is performed without blocking.  If it is not defined or `bdb.OREADER' is specified.
-- @return If successful, it is true, else, it is false.
function bdb:open(path, omode)
   -- (native code)
end

--- Close the database file.
-- Update of a database is assured to be written when the database is closed.  If a writer opens a database but does not close it appropriately, the database will be broken.
-- @return If successful, it is true, else, it is false.
function bdb:close()
   -- (native code)
end

--- Store a record.
-- If a record with the same key exists in the database, it is overwritten.
-- @param key the key.
-- @param value the value.
-- @return If successful, it is true, else, it is false.
function bdb:put(key, value)
   -- (native code)
end

--- Store a new record.
-- If a record with the same key exists in the database, this method has no effect.
-- @param key the key.
-- @param value the value.
-- @return If successful, it is true, else, it is false.
function bdb:putkeep(key, value)
   -- (native code)
end

--- Concatenate a value at the end of the existing record.
-- If there is no corresponding record, a new record is created.
-- @param key the key.
-- @param value the value.
-- @return If successful, it is true, else, it is false.
function bdb:putcat(key, value)
   -- (native code)
end

--- Store a record with allowing duplication of keys.
-- If a record with the same key exists in the database, the new record is placed after the existing one.
-- @param key the key.
-- @param value the value.
-- @return If successful, it is true, else, it is false.
function bdb:putdup(key, value)
   -- (native code)
end

--- Store records with allowing duplication of keys.
-- If a record with the same key exists in the database, the new records are placed after the existing one.
-- @param key the key.
-- @param values an array of the values.
-- @return If successful, it is true, else, it is false.
function bdb:putlist(key, values)
   -- (native code)
end

--- Remove a record.
-- If the key of duplicated records is specified, the first one is selected.
-- @param key the key.
-- @return If successful, it is true, else, it is false.
function bdb:out(key)
   -- (native code)
end

--- Remove records.
-- If the key of duplicated records is specified, all of them are removed.
-- @param key the key.
-- @return If successful, it is true, else, it is false.
function bdb:outlist(key)
   -- (native code)
end

--- Retrieve a record.
-- If the key of duplicated records is specified, the first one is selected.
-- @param key the key.
-- @return If successful, it is the value of the corresponding record.  `nil' is returned if no record corresponds.
function bdb:get(key)
   -- (native code)
end

--- Retrieve records.
-- @param key the key.
-- @return If successful, it is an array of the values of the corresponding records.  `nil' is returned if no record corresponds.
function bdb:getlist(key)
   -- (native code)
end

--- Get the number of records corresponding a key.
-- @param key the key.
-- @return If successful, it is the number of the corresponding records, else, it is 0.
function bdb:vnum(key)
   -- (native code)
end

--- Get the size of the value of a record.
-- If the key of duplicated records is specified, the first one is selected.
-- @param key the key.
-- @return If successful, it is the size of the value of the corresponding record, else, it is -1.
function bdb:vsiz(key)
   -- (native code)
end

--- Get keys of ranged records.
-- @param bkey the key of the beginning border.  If it is not defined, the first record is specified.
-- @param binc whether the beginning border is inclusive or not.  If it is not defined, false is specified.
-- @param ekey the key of the ending border.  If it is not defined, the last record is specified.
-- @param einc whether the ending border is inclusive or not.  If it is not defined, false is specified.
-- @param max the maximum number of keys to be fetched.  If it is not defined or negative, no limit is specified.
-- @return an array of the keys of the corresponding records.  This method does never fail.  It returns an empty array even if no record corresponds.
function bdb:range(bkey, binc, ekey, einc, max)
   -- (native code)
end

--- Get forward matching keys.
-- @param prefix the prefix of the corresponding keys.
-- @param max the maximum number of keys to be fetched.  If it is not defined or negative, no limit is specified.
-- @return an array of the keys of the corresponding records.  This method does never fail.  It returns an empty array even if no record corresponds.
function bdb:fwmkeys(prefix, max)
   -- (native code)
end

--- Add an integer to a record.
-- If the corresponding record exists, the value is treated as an integer and is added to.  If no record corresponds, a new record of the additional value is stored.
-- @param key the key.
-- @param num the additional value.
-- @return If successful, it is the summation value, else, it is `nil'.
function bdb:addint(key, num)
   -- (native code)
end

--- Add a real number to a record.
-- If the corresponding record exists, the value is treated as a real number and is added to.  If no record corresponds, a new record of the additional value is stored.
-- @param key the key.
-- @param num the additional value.
-- @return If successful, it is the summation value, else, it is `nil'.
function bdb:adddouble(key, num)
   -- (native code)
end

--- Synchronize updated contents with the file and the device.
-- This method is useful when another process connects the same database file.
-- @return If successful, it is true, else, it is false.
function bdb:sync()
   -- (native code)
end

--- Optimize the database file.
-- This method is useful to reduce the size of the database file with data fragmentation by successive updating.
-- @param lmemb the number of members in each leaf page.  If it is not defined or not more than 0, the current setting is not changed.
-- @param nmemb the number of members in each non-leaf page.  If it is not defined or not more than 0, the current setting is not changed.
-- @param bnum the number of elements of the bucket array.  If it is not defined or not more than 0, the default value is specified.  The default value is two times of the number of pages.
-- @param apow the size of record alignment by power of 2.  If it is not defined or negative, the current setting is not changed.
-- @param fpow the maximum number of elements of the free block pool by power of 2.  If it is not defined or negative, the current setting is not changed.
-- @param opts options by bitwise-or: `bdb.TLARGE' specifies that the size of the database can be larger than 2GB by using 64-bit bucket array, `bdb.TDEFLATE' specifies that each record is compressed with Deflate encoding, `bdb.TBZIP' specifies that each record is compressed with BZIP2 encoding, `bdb.TTCBS' specifies that each record is compressed with TCBS encoding.  If it is not defined or 0xff, the current setting is not changed.
-- @return If successful, it is true, else, it is false.
function bdb:optimize(lmemb, nmemb, bnum, apow, fpow, opts)
   -- (native code)
end

--- Remove all records.
-- @return If successful, it is true, else, it is false.
function bdb:vanish()
   -- (native code)
end

--- Copy the database file.
-- The database file is assured to be kept synchronized and not modified while the copying or executing operation is in progress.  So, this method is useful to create a backup file of the database file.
-- @param path the path of the destination file.  If it begins with `@', the trailing substring is executed as a command line.
-- @return If successful, it is true, else, it is false.  False is returned if the executed command returns non-zero code.
function bdb:copy(path)
   -- (native code)
end

--- Begin the transaction.
-- The database is locked by the thread while the transaction so that only one transaction can be activated with a database object at the same time.  Thus, the serializable isolation level is assumed if every database operation is performed in the transaction.  Because all pages are cached on memory while the transaction, the amount of referred records is limited by the memory capacity.  If the database is closed during transaction, the transaction is aborted implicitly.
-- @return If successful, it is true, else, it is false.
function bdb:tranbegin()
   -- (native code)
end

--- Commit the transaction.
-- Update in the transaction is fixed when it is committed successfully.
-- @return If successful, it is true, else, it is false.
function bdb:trancommit()
   -- (native code)
end

--- Abort the transaction.
-- Update in the transaction is discarded when it is aborted.  The state of the database is rollbacked to before transaction.
-- @return If successful, it is true, else, it is false.
function bdb:tranabort()
   -- (native code)
end

--- Get the path of the database file.
-- @return the path of the database file or `nil' if the object does not connect to any database file.
function bdb:path()
   -- (native code)
end

--- Get the number of records.
-- @return the number of records or 0 if the object does not connect to any database file.
function bdb:rnum()
   -- (native code)
end

--- Get the size of the database file.
-- @return the size of the database file or 0 if the object does not connect to any database
-- file.
function bdb:fsiz()
   -- (native code)
end

--- Process each record atomically.
-- @param func the iterator function called for each record.  It receives two parameters of the key and the value, and returns true to continue iteration or false to stop iteration.
-- @return If successful, it is true, else, it is false.
function bdb:foreach(func)
   -- (native code)
end

--- Get the iterator for generic "for" loop.
-- @return plural values; the iterator to retrieve the key and the value of the next record, the cursor for iteration, and nil.
function bdb:pairs()
   -- (native code)
end

--- Move the cursor to the first record.
-- @return If successful, it is true, else, it is false.  False is returned if there is no record in the database.
function bdbcur:first()
   -- (native code)
end

--- Move the cursor to the last record.
-- @return If successful, it is true, else, it is false.  False is returned if there is no record in the database.
function bdbcur:last()
   -- (native code)
end

--- Move the cursor to the front of records corresponding a key.
-- The cursor is set to the first record corresponding the key or the next substitute if completely matching record does not exist.
-- @param key the key.
-- @return If successful, it is true, else, it is false.  False is returned if there is no record corresponding the condition.
function bdbcur:jump(key)
   -- (native code)
end

--- Move the cursor to the previous record.
-- @return If successful, it is true, else, it is false.  False is returned if there is no previous record.
function bdbcur:prev()
   -- (native code)
end

--- Move the cursor to the next record.
-- @return If successful, it is true, else, it is false.  False is returned if there is no next record.
function bdbcur:next()
   -- (native code)
end

--- Insert a record around the cursor.
-- After insertion, the cursor is moved to the inserted record.
-- @param value the value.
-- @param cpmode detail adjustment: `bdbcur.CPCURRENT', which means that the value of the current record is overwritten, `bdbcur.CPBEFORE', which means that the new record is inserted before the current record, `bdbcur.CPAFTER', which means that the new record is inserted after the current record.
-- @return If successful, it is true, else, it is false.  False is returned when the cursor is at invalid position.
function bdbcur:put(value, cpmode)
   -- (native code)
end

--- Remove the record where the cursor is.
-- After deletion, the cursor is moved to the next record if possible.
-- @return If successful, it is true, else, it is false.  False is returned when the cursor is
-- at invalid position.
function bdbcur:out()
   -- (native code)
end

--- Get the key of the record where the cursor is.
-- @return If successful, it is the key, else, it is `null'.  'null' is returned when the
-- cursor is at invalid position.
function bdbcur:key()
   -- (native code)
end

--- Get the value of the record where the cursor is.
-- @return If successful, it is the value, else, it is `null'.  'null' is returned when the
-- cursor is at invalid position.
function bdbcur:val()
   -- (native code)
end

--- Get the message string corresponding to an error code.
-- @param ecode the error code.  If it is not defined or negative, the last happened error code is specified.
-- @return the message string of the error code.
function fdb:errmsg(ecode)
   -- (native code)
end

--- Get the last happened error code.
-- @return the last happened error code.  The following error codes are defined: `fdb.ESUCCESS' for success, `fdb.ETHREAD' for threading error, `fdb.EINVALID' for invalid operation, `fdb.ENOFILE' for file not found, `fdb.ENOPERM' for no permission, `fdb.EMETA' for invalid meta data, `fdb.ERHEAD' for invalid record header, `fdb.EOPEN' for open error, `fdb.ECLOSE' for close error, `fdb.ETRUNC' for trunc error, `fdb.ESYNC' for sync error, `fdb.ESTAT' for stat error, `fdb.ESEEK' for seek error, `fdb.EREAD' for read error, `fdb.EWRITE' for write error, `fdb.EMMAP' for mmap error, `fdb.ELOCK' for lock error, `fdb.EUNLINK' for unlink error, `fdb.ERENAME' for rename error, `fdb.EMKDIR' for mkdir error, `fdb.ERMDIR' for rmdir error, `fdb.EKEEP' for existing record, `fdb.ENOREC' for no record found, and `fdb.EMISC' for miscellaneous error.
function fdb:ecode()
   -- (native code)
end

--- Set the tuning parameters.
-- The tuning parameters of the database should be set before the database is opened.
-- @param width the width of the value of each record.  If it is not defined or not more than 0, the default value is specified.  The default value is 255.
-- @param limsiz the limit size of the database file.  If it is not defined or not more than 0, the default value is specified.  The default value is 268435456.
-- @return If successful, it is true, else, it is false.
function fdb:tune(width, limsiz)
   -- (native code)
end

--- Open a database file.
-- @param path the path of the database file.
-- @param omode the connection mode: `fdb.OWRITER' as a writer, `fdb.OREADER' as a reader.  If the mode is `fdb.OWRITER', the following may be added by bitwise-or: `fdb.OCREAT', which means it creates a new database if not exist, `fdb.OTRUNC', which means it creates a new database regardless if one exists.  Both of `fdb.OREADER' and `fdb.OWRITER' can be added to by bitwise-or: `fdb.ONOLCK', which means it opens the database file without file locking, or `fdb.OLCKNB', which means locking is performed without blocking.  If it is not defined, `bdb.OREADER' is specified.
-- @return If successful, it is true, else, it is false.
function fdb:open(path, omode)
   -- (native code)
end

--- Close the database file.
-- Update of a database is assured to be written when the database is closed.  If a writer opens a database but does not close it appropriately, the database will be broken.
-- @return If successful, it is true, else, it is false.
function fdb:close()
   -- (native code)
end

--- Store a record.
-- If a record with the same key exists in the database, it is overwritten.
-- @param key the key.  It should be more than 0.  If it is "min", the minimum ID number of existing records is specified.  If it is "prev", the number less by one than the minimum ID number of existing records is specified.  If it is "max", the maximum ID number of existing records is specified.  If it is "next", the number greater by one than the maximum ID number of existing records is specified.
-- @param value the value.
-- @return If successful, it is true, else, it is false.
function fdb:put(key, value)
   -- (native code)
end

--- Store a new record.
-- If a record with the same key exists in the database, this method has no effect.
-- @param key the key.  It should be more than 0.  If it is "min", the minimum ID number of existing records is specified.  If it is "prev", the number less by one than the minimum ID number of existing records is specified.  If it is "max", the maximum ID number of existing records is specified.  If it is "next", the number greater by one than the maximum ID number of existing records is specified.
-- @param value the value.
-- @return If successful, it is true, else, it is false.
function fdb:putkeep(key, value)
   -- (native code)
end

--- Concatenate a value at the end of the existing record.
-- If there is no corresponding record, a new record is created.
-- @param key the key.  It should be more than 0.  If it is "min", the minimum ID number of existing records is specified.  If it is "prev", the number less by one than the minimum ID number of existing records is specified.  If it is "max", the maximum ID number of existing records is specified.  If it is "next", the number greater by one than the maximum ID number of existing records is specified.
-- @param value the value.
-- @return If successful, it is true, else, it is false.
function fdb:putcat(key, value)
   -- (native code)
end

--- Remove a record.
-- @param key the key.  It should be more than 0.  If it is "min", the minimum ID number of existing records is specified.  If it is "max", the maximum ID number of existing records is specified.
-- @return If successful, it is true, else, it is false.
function fdb:out(key)
   -- (native code)
end

--- Retrieve a record.
-- @param key the key.  It should be more than 0.  If it is "min", the minimum ID number of existing records is specified.  If it is "max", the maximum ID number of existing records is specified.
-- @return If successful, it is the value of the corresponding record.  `nil' is returned if no record corresponds.
function fdb:get(key)
   -- (native code)
end

--- Get the size of the value of a record.
-- @param key the key.  It should be more than 0.  If it is "min", the minimum ID number of existing records is specified.  If it is "max", the maximum ID number of existing records is specified.
-- @return If successful, it is the size of the value of the corresponding record, else, it is -1.
function fdb:vsiz(key)
   -- (native code)
end

--- Initialize the iterator.
-- The iterator is used in order to access the key of every record stored in a database.
-- @return If successful, it is true, else, it is false.
function fdb:iterinit()
   -- (native code)
end

--- Get the next key of the iterator.
-- It is possible to access every record by iteration of calling this function.  It is allowed to update or remove records whose keys are fetched while the iteration.  The order of this traversal access method is ascending of the ID number.
-- @return If successful, it is the next key, else, it is `nil'.  `nil' is returned when no record is to be get out of the iterator.
function fdb:iternext()
   -- (native code)
end

--- Get keys with an interval notation.
-- @param interval the interval notation.
-- @param max the maximum number of keys to be fetched.  If it is not defined or negative, no limit is specified.
-- @return a array of the keys of the corresponding records.  This method does never fail.  It returns an empty array even if no record corresponds.
function fdb:range(interval, max)
   -- (native code)
end

--- Add an integer to a record.
-- If the corresponding record exists, the value is treated as an integer and is added to.  If no record corresponds, a new record of the additional value is stored.
-- @param key the key.  It should be more than 0.  If it is "min", the minimum ID number of existing records is specified.  If it is "prev", the number less by one than the minimum ID number of existing records is specified.  If it is "max", the maximum ID number of existing records is specified.  If it is "next", the number greater by one than the maximum ID number of existing records is specified.
-- @param num the additional value.
-- @return If successful, it is the summation value, else, it is `nil'.
function fdb:addint(key, num)
   -- (native code)
end

--- Add a real number to a record.
-- If the corresponding record exists, the value is treated as a real number and is added to.  If no record corresponds, a new record of the additional value is stored.
-- @param key the key.  It should be more than 0.  If it is "min", the minimum ID number of existing records is specified.  If it is "prev", the number less by one than the minimum ID number of existing records is specified.  If it is "max", the maximum ID number of existing records is specified.  If it is "next", the number greater by one than the maximum ID number of existing records is specified.
-- @param num the additional value.
-- @return If successful, it is the summation value, else, it is `nil'.
function fdb:adddouble(key, num)
   -- (native code)
end

--- Synchronize updated contents with the file and the device.
-- This method is useful when another process connects the same database file.
-- @return If successful, it is true, else, it is false.
function fdb:sync()
   -- (native code)
end

--- Optimize the database file.
-- @param width the width of the value of each record.  If it is not defined or not more than 0, the current setting is not changed.
-- @param limsiz the limit size of the database file.  If it is not defined or not more than 0, the current setting is not changed.
-- @return If successful, it is true, else, it is false.
function fdb:optimize(width, limsiz)
   -- (native code)
end

--- Remove all records.
-- @return If successful, it is true, else, it is false.
function fdb:vanish()
   -- (native code)
end

--- Copy the database file.
-- The database file is assured to be kept synchronized and not modified while the copying or executing operation is in progress.  So, this method is useful to create a backup file of the database file.
-- @param path the path of the destination file.  If it begins with `@', the trailing substring is executed as a command line.
-- @return If successful, it is true, else, it is false.  False is returned if the executed command returns non-zero code.
function fdb:copy(path)
   -- (native code)
end

--- Begin the transaction.
-- The database is locked by the thread while the transaction so that only one transaction can be activated with a database object at the same time.  Thus, the serializable isolation level is assumed if every database operation is performed in the transaction.  All updated regions are kept track of by write ahead logging while the transaction.  If the database is closed during transaction, the transaction is aborted implicitly.
-- @return If successful, it is true, else, it is false.
function fdb:tranbegin()
   -- (native code)
end

--- Commit the transaction.
-- Update in the transaction is fixed when it is committed successfully.
-- @return If successful, it is true, else, it is false.
function fdb:trancommit()
   -- (native code)
end

--- Abort the transaction.
-- Update in the transaction is discarded when it is aborted.  The state of the database is rollbacked to before transaction.
-- @return If successful, it is true, else, it is false.
function fdb:tranabort()
   -- (native code)
end

--- Get the path of the database file.
-- @return the path of the database file or `nil' if the object does not connect to any database file.
function fdb:path()
   -- (native code)
end

--- Get the number of records.
-- @return the number of records or 0 if the object does not connect to any database file.
function fdb:rnum()
   -- (native code)
end

--- Get the size of the database file.
-- @return the size of the database file or 0 if the object does not connect to any database file.
function fdb:fsiz()
   -- (native code)
end

--- Process each record atomically.
-- @param func the iterator function called for each record.  It receives two parameters of the key and the value, and returns true to continue iteration or false to stop iteration.
-- @return If successful, it is true, else, it is false.
function fdb:foreach(func)
   -- (native code)
end

--- Get the iterator for generic "for" loop.
-- @return plural values; the iterator to retrieve the key and the value of the next record, the table itself, and nil.
function fdb:pairs()
   -- (native code)
end

--- Get the message string corresponding to an error code.
-- @param ecode the error code.  If it is not defined or negative, the last happened error code is specified.
-- @return the message string of the error code.
function tdb:errmsg(ecode)
   -- (native code)
end

--- Get the last happened error code.
-- @return the last happened error code.  The following error codes are defined: `tdb.ESUCCESS' for success, `tdb.ETHREAD' for threading error, `tdb.EINVALID' for invalid operation, `tdb.ENOFILE' for file not found, `tdb.ENOPERM' for no permission, `tdb.EMETA' for invalid meta data, `tdb.ERHEAD' for invalid record header, `tdb.EOPEN' for open error, `tdb.ECLOSE' for close error, `tdb.ETRUNC' for trunc error, `tdb.ESYNC' for sync error, `tdb.ESTAT' for stat error, `tdb.ESEEK' for seek error, `tdb.EREAD' for read error, `tdb.EWRITE' for write error, `tdb.EMMAP' for mmap error, `tdb.ELOCK' for lock error, `tdb.EUNLINK' for unlink error, `tdb.ERENAME' for rename error, `tdb.EMKDIR' for mkdir error, `tdb.ERMDIR' for rmdir error, `tdb.EKEEP' for existing record, `tdb.ENOREC' for no record found, and `tdb.EMISC' for miscellaneous error.
function tdb:ecode()
   -- (native code)
end

--- Set the tuning parameters.
-- The tuning parameters of the database should be set before the database is opened.
-- @param bnum the number of elements of the bucket array.  If it is not defined or not more than 0, the default value is specified.  The default value is 131071.  Suggested size of the bucket array is about from 0.5 to 4 times of the number of all records to be stored.
-- @param apow the size of record alignment by power of 2.  If it is not defined or negative, the default value is specified.  The default value is 4 standing for 2^4=16.
-- @param fpow the maximum number of elements of the free block pool by power of 2.  If it is not defined or negative, the default value is specified.  The default value is 10 standing for 2^10=1024.
-- @param opts options by bitwise-or: `tdb.TLARGE' specifies that the size of the database can be larger than 2GB by using 64-bit bucket array, `tdb.TDEFLATE' specifies that each record is compressed with Deflate encoding, `tdb.TBZIP' specifies that each record is compressed with BZIP2 encoding, `tdb.TTCBS' specifies that each record is compressed with TCBS encoding.  If it is not defined, no option is specified.
-- @return If successful, it is true, else, it is false.
function tdb:tune(bnum, apow, fpow, opts)
   -- (native code)
end

--- Set the caching parameters.
-- The caching parameters of the database should be set before the database is opened.
-- @param rcnum the maximum number of records to be cached.  If it is not defined or not more than 0, the record cache is disabled.  It is disabled by default.
-- @param lcnum the maximum number of leaf nodes to be cached.  If it is not defined or not more than 0, the default value is specified.  The default value is 1024.
-- @param ncnum the maximum number of non-leaf nodes to be cached.  If it is not defined or not more than 0, the default value is specified.  The default value is 512.
-- @return If successful, it is true, else, it is false.
function tdb:setcache(rcnum, lcnum, ncnum)
   -- (native code)
end

--- Set the size of the extra mapped memory.
-- The mapping parameters should be set before the database is opened.
-- @param xmsiz the size of the extra mapped memory.  If it is not defined or not more than 0, the extra mapped memory is disabled.  The default size is 67108864.
-- @return If successful, it is true, else, it is false.
function tdb:setxmsiz(xmsiz)
   -- (native code)
end

--- Set the unit step number of auto defragmentation.
-- @param dfunit the unit step number.  If it is not more than 0, the auto defragmentation is disabled.  It is disabled by default.
-- @return If successful, it is true, else, it is false.
function tdb:setdfunit(dfunit)
   -- (native code)
end

--- Open a database file.
-- @param path the path of the database file.
-- @param omode the connection mode: `tdb.OWRITER' as a writer, `tdb.OREADER' as a reader.  If the mode is `tdb.OWRITER', the following may be added by bitwise-or: `tdb.OCREAT', which means it creates a new database if not exist, `tdb.OTRUNC', which means it creates a new database regardless if one exists, `tdb.OTSYNC', which means every transaction synchronizes updated contents with the device.  Both of `tdb.OREADER' and `tdb.OWRITER' can be added to by bitwise-or: `tdb.ONOLCK', which means it opens the database file without file locking, or `tdb.OLCKNB', which means locking is performed without blocking.  If it is not defined, `tdb.OREADER' is specified.
-- @return If successful, it is true, else, it is false.
function tdb:open(path, omode)
   -- (native code)
end

--- Close the database file.
-- Update of a database is assured to be written when the database is closed.  If a writer opens a database but does not close it appropriately, the database will be broken.
-- @return If successful, it is true, else, it is false.
function tdb:close()
   -- (native code)
end

--- Store a record.
-- If a record with the same key exists in the database, it is overwritten.
-- @param pkey the primary key.
-- @param cols a table containing columns.
-- @return If successful, it is true, else, it is false.
function tdb:put(pkey, cols)
   -- (native code)
end

--- Store a new record.
-- If a record with the same key exists in the database, this method has no effect.
-- @param pkey the primary key.
-- @param cols a table containing columns.
-- @return If successful, it is true, else, it is false.
function tdb:putkeep(pkey, cols)
   -- (native code)
end

--- Concatenate columns of the existing record.
-- If there is no corresponding record, a new record is created.
-- @param pkey the primary key.
-- @param cols a table containing columns.
-- @return If successful, it is true, else, it is false.
function tdb:putcat(pkey, cols)
   -- (native code)
end

--- Remove a record.
-- @param pkey the primary key.
-- @return If successful, it is true, else, it is false.
function tdb:out(pkey)
   -- (native code)
end

--- Retrieve a record.
-- @param pkey the primary key.
-- @return If successful, it is a table of the columns of the corresponding record.  `nil' is returned if no record corresponds.
function tdb:get(pkey)
   -- (native code)
end

--- Get the size of the value of a record.
-- @param pkey the primary key.
-- @return If successful, it is the size of the value of the corresponding record, else, it is -1.
function tdb:vsiz(pkey)
   -- (native code)
end

--- Initialize the iterator.
-- The iterator is used in order to access the primary key of every record stored in a database.
-- @return If successful, it is true, else, it is false.
function tdb:iterinit()
   -- (native code)
end

--- Get the next primary key of the iterator.
-- It is possible to access every record by iteration of calling this method.  It is allowed to update or remove records whose keys are fetched while the iteration.  However, it is not assured if updating the database is occurred while the iteration.  Besides, the order of this traversal access method is arbitrary, so it is not assured that the order of storing matches the one of the traversal access.
-- @return If successful, it is the next primary key, else, it is `nil'.  `nil' is returned when no record is to be get out of the iterator.
function tdb:iternext()
   -- (native code)
end

--- Get forward matching primary keys.
-- This function may be very slow because every key in the database is scanned.
-- @param prefix the prefix of the corresponding keys.
-- @param max the maximum number of keys to be fetched.  If it is negative, no limit is specified.
-- @return an array of the keys of the corresponding records.  This method does never fail.  It returns an empty array even if no record corresponds.
function tdb:fwmkeys(prefix, max)
   -- (native code)
end

--- Add an integer to a record.
-- The additional value is stored as a decimal string value of a column whose name is "_num".  If no record corresponds, a new record with the additional value is stored.
-- @param pkey the primary key.
-- @param num the additional value.
-- @return If successful, it is the summation value, else, it is `nil'.
function tdb:addint(pkey, num)
   -- (native code)
end

--- Add a real number to a record.
-- The additional value is stored as a decimal string value of a column whose name is "_num".  If no record corresponds, a new record with the additional value is stored.
-- @param pkey the primary key.
-- @param num the additional value.
-- @return If successful, it is the summation value, else, it is `nil'.
function tdb:adddouble(pkey, num)
   -- (native code)
end

--- Synchronize updated contents with the file and the device.
-- This method is useful when another process connects the same database file.
-- @return If successful, it is true, else, it is false.
function tdb:sync()
   -- (native code)
end

--- Optimize the database file.
-- This method is useful to reduce the size of the database file with data fragmentation by successive updating.
-- @param bnum the number of elements of the bucket array.  If it is not defined or not more than 0, the default value is specified.  The default value is two times of the number of records.
-- @param apow the size of record alignment by power of 2.  If it is not defined or negative, the current setting is not changed.
-- @param fpow the maximum number of elements of the free block pool by power of 2.  If it is not defined or negative, the current setting is not changed.
-- @param opts options by bitwise-or: `tdb.TLARGE' specifies that the size of the database can be larger than 2GB by using 64-bit bucket array, `tdb.TDEFLATE' specifies that each record is compressed with Deflate encoding, `tdb.TBZIP' specifies that each record is compressed with BZIP2 encoding, `tdb.TTCBS' specifies that each record is compressed with TCBS encoding.  If it is not defined or 0xff, the current setting is not changed.
-- @return If successful, it is true, else, it is false.
function tdb:optimize(bnum, apow, fpow, opts)
   -- (native code)
end

--- Remove all records.
-- @return If successful, it is true, else, it is false.
function tdb:vanish()
   -- (native code)
end

--- Copy the database file.
-- The database file is assured to be kept synchronized and not modified while the copying or executing operation is in progress.  So, this method is useful to create a backup file of the database file.
-- @param path the path of the destination file.  If it begins with `@', the trailing substring is executed as a command line.
-- @return If successful, it is true, else, it is false.  False is returned if the executed command returns non-zero code.
function tdb:copy(path)
   -- (native code)
end

--- Begin the transaction.
-- The database is locked by the thread while the transaction so that only one transaction can be activated with a database object at the same time.  Thus, the serializable isolation level is assumed if every database operation is performed in the transaction.  All updated regions are kept track of by write ahead logging while the transaction.  If the database is closed during transaction, the transaction is aborted implicitly.
-- @return If successful, it is true, else, it is false.
function tdb:tranbegin()
   -- (native code)
end

--- Commit the transaction.
-- Update in the transaction is fixed when it is committed successfully.
-- @return If successful, it is true, else, it is false.
function tdb:trancommit()
   -- (native code)
end

--- Abort the transaction.
-- Update in the transaction is discarded when it is aborted.  The state of the database is rollbacked to before transaction.
-- @return If successful, it is true, else, it is false.
function tdb:tranabort()
   -- (native code)
end

--- Get the path of the database file.
-- @return the path of the database file or `nil' if the object does not connect to any database file.
function tdb:path()
   -- (native code)
end

--- Get the number of records.
-- @return the number of records or 0 if the object does not connect to any database file.
function tdb:rnum()
   -- (native code)
end

--- Get the size of the database file.
-- @return the size of the database file or 0 if the object does not connect to any database file.
function tdb:fsiz()
   -- (native code)
end

--- Set a column index.
-- @param name the name of a column.  If the name of an existing index is specified, the index is rebuilt.  An empty string means the primary key.
-- @param type the index type: `tdb.ITLEXICAL' for lexical string, `tdb.ITDECIMAL' for decimal string, `tdb.ITTOKEN' for token inverted index, `tdb.ITQGRAM' for q-gram inverted index.  If it is `tdb.ITOPT', the index is optimized.  If it is `tdb.ITVOID', the index is removed.  If `tdb.ITKEEP' is added by bitwise-or and the index exists, this method merely returns failure.
-- @return If successful, it is true, else, it is false.
function tdb:setindex(name, type)
   -- (native code)
end

--- Generate a unique ID number.
-- @return the new unique ID number or -1 on failure.
function tdb:genuid()
   -- (native code)
end

--- Process each record atomically.
-- @param func the iterator function called for each record.  It receives two parameters of the key and a table of columns, and returns true to continue iteration or false to stop iteration.
-- @return If successful, it is true, else, it is false.
function tdb:foreach(func)
   -- (native code)
end

--- Get the iterator for generic "for" loop.
-- @return plural values; the iterator to retrieve the key and the columns of the next record, the table itself, and nil.
function tdb:pairs()
   -- (native code)
end

--- Add a narrowing condition.
-- @param name the name of a column.  An empty string means the primary key.
-- @param op an operation type: `tdbqry.QCSTREQ' for string which is equal to the expression, `tdbqry.QCSTRINC' for string which is included in the expression, `tdbqry.QCSTRBW' for string which begins with the expression, `tdbqry.QCSTREW' for string which ends with the expression, `tdbqry.QCSTRAND' for string which includes all tokens in the expression, `tdbqry.QCSTROR' for string which includes at least one token in the expression, `tdbqry.QCSTROREQ' for string which is equal to at least one token in the expression, `tdbqry.QCSTRRX' for string which matches regular expressions of the expression, `tdbqry.QCNUMEQ' for number which is equal to the expression, `tdbqry.QCNUMGT' for number which is greater than the expression, `tdbqry.QCNUMGE' for number which is greater than or equal to the expression, `tdbqry.QCNUMLT' for number which is less than the expression, `tdbqry.QCNUMLE' for number which is less than or equal to the expression, `tdbqry.QCNUMBT' for number which is between two tokens of the expression, `tdbqry.QCNUMOREQ' for number which is equal to at least one token in the expression, `tdbqry.QCFTSPH' for full-text search with the phrase of the expression, `tdbqry.QCFTSAND' for full-text search with all tokens in the expression, `tdbqry.QCFTSOR' for full-text search with at least one token in the expression, `tdbqry.QCFTSEX' for full-text search with the compound expression.  All operations can be flagged by bitwise-or: `tdbqry.QCNEGATE' for negation, `tdbqry.QCNOIDX' for using no index.
-- @param expr an operand exression.
function tdbqry:addcond(name, op, expr)
  -- (native code)
end

--- Set the order of the result.
-- @param name the name of a column.  An empty string means the primary key.
-- @param type the order type: `tdbqry.QOSTRASC' for string ascending, `tdbqry.QOSTRDESC' for string descending, `tdbqry.QONUMASC' for number ascending, `tdbqry.QONUMDESC' for number descending.  If it is not defined, `tdbqry.QOSTRASC' is specified.
function tdbqry:setorder(name, type)
  -- (native code)
end

--- Set the maximum number of records of the result.
-- @param max the maximum number of records of the result.  If it is not defined or negative, no limit is specified.
-- @param skip the maximum number of records of the result.  If it is not defined or not more than 0, no record is skipped.
function tdbqry:setlimit(max, skip)
  -- (native code)
end

--- Execute the search.
-- @return an array of the primary keys of the corresponding records.  This method does never fail.  It returns an empty array even if no record corresponds.
function tdbqry:search()
  -- (native code)
end

--- Remove each corresponding record.
-- @return If successful, it is true, else, it is false.
function tdbqry:searchout()
  -- (native code)
end

--- Process each corresponding record.
-- This method needs a block parameter of the iterator called for each record.  The block receives two parameters.  The first parameter is the primary key.  The second parameter is a table containing columns.  It returns flags of the post treatment by bitwise-or: `tdbqry.QPPUT' to modify the record, `tdbqry.QPOUT' to remove the record, `tdbqry.QPSTOP' to stop the iteration.
-- @return If successful, it is true, else, it is false.
function tdbqry:proc()
  -- (native code)
end

--- Get the hint of a query object.
-- @return the hint string.
function tdbqry:hint()
  -- (native code)
end

--- Retrieve records with multiple query objects and get the set of the result.
-- @param others an array of the query objects except for the self object.
-- @param type a set operation type: `tdbqry.MSUNION' for the union set, `tdbqry.MSISECT' for the intersection set, `tdbqry.MSDIFF' for the difference set.  If it is not defined, `tdbqry.MSUNION' is specified.
--@return an array of the primary keys of the corresponding records.  This method does never fail.  It returns an empty array even if no record corresponds.
-- If the first query object has the order setting, the result array is sorted by the order.
function tdbqry:metasearch(others, type)
  -- (native code)
end

--- Generate keyword-in-context strings.
-- @param cols a table containing columns.
-- @param name the name of a column.  If it is not defined, the first column of the query is specified.
-- @param width the width of strings picked up around each keyword.  If it is not defined or negative, the whole text is picked up.
-- @param opts options by bitwise-or: `tdbqry.KWMUTAB' specifies that each keyword is marked up between two tab characters, `tdbqry.KWMUCTRL' specifies that each keyword is marked up by the STX (0x02) code and the ETX (0x03) code, `tdbqry.KWMUBRCT' specifies that each keyword is marked up by the two square brackets, `tdbqry.KWNOOVER' specifies that each context does not overlap, `tdbqry.KWPULEAD' specifies that the lead string is picked up forcibly.  If it is not defined, no option is specified.
-- @return an array of strings around keywords.
function tdbqry:kwic(cols, name, width, opts)
  -- (native code)
end

--- Open a database.
-- @param name the name of the database.  If it is "*", the database will be an on-memory hash database.  If it is "+", the database will be an on-memory tree database.  If its suffix is ".tch", the database will be a hash database.  If its suffix is ".tcb", the database will be a B+ tree database.  If its suffix is ".tcf", the database will be a fixed-length database.  If its suffix is ".tct", the database will be a table database.  Otherwise, this method fails.  Tuning parameters can trail the name, separated by "#".  Each parameter is composed of the name and the value, separated by "=".  On-memory hash database supports "bnum", "capnum", and "capsiz".  On-memory tree database supports "capnum" and "capsiz".  Hash database supports "mode", "bnum", "apow", "fpow", "opts", "rcnum", and "xmsiz".  B+ tree database supports "mode", "lmemb", "nmemb", "bnum", "apow", "fpow", "opts", "lcnum", "ncnum", and "xmsiz".  Fixed-length database supports "mode", "width", and "limsiz".  Table database supports "mode", "bnum", "apow", "fpow", "opts", "rcnum", "lcnum", "ncnum", "xmsiz", and "idx".  The tuning parameter "capnum" specifies the capacity number of records.  "capsiz" specifies the capacity size of using memory.  Records spilled the capacity are removed by the storing order.  "mode" can contain "w" of writer, "r" of reader, "c" of creating, "t" of truncating, "e" of no locking, and "f" of non-blocking lock.  The default mode is relevant to "wc".  "opts" can contains "l" of large option, "d" of Deflate option, "b" of BZIP2 option, and "t" of TCBS option.  "idx" specifies the column name of an index and its type separated by ":".  For example, "casket.tch#bnum=1000000#opts=ld" means that the name of the database file is "casket.tch", and the bucket number is 1000000, and the options are large and Deflate.
-- @return If successful, it is true, else, it is false.
function adb:open(name)
   -- (native code)
end

--- Close the database.
-- Update of a database is assured to be written when the database is closed.  If a writer opens a database but does not close it appropriately, the database will be broken.
-- @return If successful, it is true, else, it is false.
function adb:close()
   -- (native code)
end

--- Store a record.
-- If a record with the same key exists in the database, it is overwritten.
-- @param key the key.
-- @param value the value.
-- @return If successful, it is true, else, it is false.
function adb:put(key, value)
   -- (native code)
end

--- Store a new record.
-- If a record with the same key exists in the database, this method has no effect.
-- @param key the key.
-- @param value the value.
-- @return If successful, it is true, else, it is false.
function adb:putkeep(key, value)
   -- (native code)
end

--- Concatenate a value at the end of the existing record.
-- If there is no corresponding record, a new record is created.
-- @param key the key.
-- @param value the value.
-- @return If successful, it is true, else, it is false.
function adb:putcat(key, value)
   -- (native code)
end

--- Remove a record.
-- @param key the key.
-- @return If successful, it is true, else, it is false.
function adb:out(key)
   -- (native code)
end

--- Retrieve a record.
-- @param key the key.
-- @return If successful, it is the value of the corresponding record.  `nil' is returned if no record corresponds.
function adb:get(key)
   -- (native code)
end

--- Get the size of the value of a record.
-- @param key the key.
-- @return If successful, it is the size of the value of the corresponding record, else, it is -1.
function adb:vsiz(key)
   -- (native code)
end

--- Initialize the iterator.
-- The iterator is used in order to access the key of every record stored in a database.
-- @return If successful, it is true, else, it is false.
function adb:iterinit()
   -- (native code)
end

--- Get the next key of the iterator.
-- It is possible to access every record by iteration of calling this method.  It is allowed to update or remove records whose keys are fetched while the iteration.  However, it is not assured if updating the database is occurred while the iteration.  Besides, the order of this traversal access method is arbitrary, so it is not assured that the order of storing matches the one of the traversal access.
-- @return If successful, it is the next key, else, it is `nil'.  `nil' is returned when no record is to be get out of the iterator.
function adb:iternext()
   -- (native code)
end

--- Get forward matching keys.
-- This function may be very slow because every key in the database is scanned.
-- @param prefix the prefix of the corresponding keys.
-- @param max the maximum number of keys to be fetched.  If it is negative, no limit is specified.
-- @return an array of the keys of the corresponding records.  This method does never fail.  It returns an empty array even if no record corresponds.
function adb:fwmkeys(prefix, max)
   -- (native code)
end

--- Add an integer to a record.
-- If the corresponding record exists, the value is treated as an integer and is added to.  If no record corresponds, a new record of the additional value is stored.
-- @param key the key.
-- @param num the additional value.
-- @return If successful, it is the summation value, else, it is `nil'.
function adb:addint(key, num)
   -- (native code)
end

--- Add a real number to a record.
-- If the corresponding record exists, the value is treated as a real number and is added to.  If no record corresponds, a new record of the additional value is stored.
-- @param key the key.
-- @param num the additional value.
-- @return If successful, it is the summation value, else, it is `nil'.
function adb:adddouble(key, num)
   -- (native code)
end

--- Synchronize updated contents with the file and the device.
-- This method is useful when another process connects the same database file.
-- @return If successful, it is true, else, it is false.
function adb:sync()
   -- (native code)
end

--- Optimize the storage.
-- @param params the string of the tuning parameters, which works as with the tuning of parameters the method `open'.  If it is not defined, it is not used.
-- @return If successful, it is true, else, it is false.
function adb:optimize(params)
   -- (native code)
end

--- Remove all records.
-- @return If successful, it is true, else, it is false.
function adb:vanish()
   -- (native code)
end

--- Copy the database file.
-- The database file is assured to be kept synchronized and not modified while the copying or executing operation is in progress.  So, this method is useful to create a backup file of the database file.
-- @param path the path of the destination file.  If it begins with `@', the trailing substring is executed as a command line.
-- @return If successful, it is true, else, it is false.  False is returned if the executed command returns non-zero code.
function adb:copy(path)
   -- (native code)
end

--- Begin the transaction.
-- The database is locked by the thread while the transaction so that only one transaction can be activated with a database object at the same time.  Thus, the serializable isolation level is assumed if every database operation is performed in the transaction.  All updated regions are kept track of by write ahead logging while the transaction.  If the database is closed during transaction, the transaction is aborted implicitly.
-- @return If successful, it is true, else, it is false.
function adb:tranbegin()
   -- (native code)
end

--- Commit the transaction.
-- Update in the transaction is fixed when it is committed successfully.
-- @return If successful, it is true, else, it is false.
function adb:trancommit()
   -- (native code)
end

--- Abort the transaction.
-- Update in the transaction is discarded when it is aborted.  The state of the database is rollbacked to before transaction.
-- @return If successful, it is true, else, it is false.
function adb:tranabort()
   -- (native code)
end

--- Get the path of the database file.
-- @return the path of the database file or `nil' if the object does not connect to any database file.  "*" stands for on-memory hash database.  "+" stands for on-memory tree database.
function adb:path()
   -- (native code)
end

--- Get the number of records.
-- @return the number of records or 0 if the object does not connect to any database file.
function adb:rnum()
   -- (native code)
end

--- Get the size of the database.
-- @return the size of the database file or 0 if the object does not connect to any database file.
function adb:size()
   -- (native code)
end

--- Process each record atomically.
-- @param func the iterator function called for each record.  It receives two parameters of the key and the value, and returns true to continue iteration or false to stop iteration.
-- @return If successful, it is true, else, it is false.
function adb:foreach(func)
   -- (native code)
end

--- Get the iterator for generic "for" loop.
-- @return plural values; the iterator to retrieve the key and the value of the next record, the table itself, and nil.
function adb:pairs()
   -- (native code)
end



-- END OF FILE
