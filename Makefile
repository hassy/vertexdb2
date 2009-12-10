# Install Lua and Yajl from source. Then install other dependencies with MacPorts:
#   sudo port install libevent
#   sudo port install tokyocabinet
#   sudo port install libzip
#
# Build and install tokyocabinet-lua-1.8 first (see notes.txt). Then use this Makefile.

INCLUDES = -I /opt/local/include -I/usr/local/include -I source -I source/basekit/source -I source/basekit/source/simd_cph/include -I source/httpserver
LD_FLAGS = -L/usr/local/lib/lua/5.1 -L/usr/local/lib -L/opt/local/lib
LIBS = -levent -llua -lbz2 -lzip -lz -lyajl -lm
SOURCES = source/httpserver/*.c source/basekit/source/*.c source/*.c

CC = gcc
CC_FLAGS = -O0 -g

all:
	if [ ! -d "build" ]; then mkdir build; fi
	$(CC) $(CC_FLAGS) $(INCLUDES) $(LD_FLAGS) $(SOURCES) $(LIBS) -o build/vertexdb
