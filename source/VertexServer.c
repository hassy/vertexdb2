

#include "VertexServer.h"
#include "Log.h"
#include <sys/types.h>
#include <sys/time.h>
#include <sys/queue.h>
#include <stdlib.h>
#include <math.h>
#include <limits.h>
#include <signal.h>
#include <unistd.h>

#include <stdbool.h>
#include <stdint.h>
#include <string.h>

#include "Date.h"
#include "Socket.h"


static VertexServer *globalVertexServer = 0x0;

// ----------------------------------------------------------
VertexServer *VertexServer_new(void)
{
	VertexServer *self = calloc(1, sizeof(VertexServer));
	globalVertexServer = self;
	srand((clock() % INT_MAX));
	
	self->httpServer = HttpServer_new();
	HttpServer_setPort_(self->httpServer, 8080);
	HttpServer_setHost_(self->httpServer, "127.0.0.1");
	HttpServer_setDelegate_(self->httpServer, self);
	HttpServer_setRequestCallback_(self->httpServer, VertexServer_requestHandler);

	self->httpRequest = HttpServer_request(self->httpServer);
	HttpRequest_setDelegate_(self->httpRequest, self); 
	HttpRequest_setRequestParameterCallback_(self->httpRequest, VertexServer_handleRequestParameter);
	
	self->httpResponse = HttpServer_response(self->httpServer);
	self->result = HttpResponse_content(self->httpResponse);

	return self;
}

void VertexServer_free(VertexServer *self)
{
	HttpServer_free(self->httpServer);
	Pool_freeGlobalPool();
	free(self);
}


void VertexServer_setPort_(VertexServer *self, int port)
{
	HttpServer_setPort_(self->httpServer, port);
}

void VertexServer_setErrorCString_(VertexServer *self, const char *s)
{
	HttpResponse_setContentCString_(self->httpResponse, s);
	HttpResponse_setStatusCode_(self->httpResponse, 500);
}

void VertexServer_appendError_(VertexServer *self, Datum *d)
{
	HttpResponse_appendContent_(self->httpResponse, d);
}

int VertexServer_process(VertexServer *self)
{	
	lua_getglobal(self->luaState,"HttpHandleRequest");
	const char *uri = Datum_data(HttpRequest_uriPath(self->httpRequest));
	const char *post = Datum_data(HttpRequest_postData(self->httpRequest)); 

	lua_pushstring(self->luaState, uri);
	lua_pushstring(self->luaState, post); 

    lua_call(self->luaState, 2, 4);
	
    const char *contentType = lua_tostring(self->luaState, -4);
    const char *content		= lua_tostring(self->luaState, -3);
    int statusCode			= lua_tonumber(self->luaState, -2);
    const char *cookie		= lua_tostring(self->luaState, -1);

	if(contentType)
	{
		HttpResponse_setContentType_(self->httpResponse, contentType);
	}
	
	if(content)
	{
		HttpResponse_setContentCString_(self->httpResponse, content);
	}
	
	if(statusCode)
	{
		HttpResponse_setStatusCode_(self->httpResponse, statusCode);
	}
		
	if(strlen(cookie)) 
	{
		HttpResponse_setCookie_(self->httpResponse, Datum_poolNewWithCString_(cookie));
	}
	
    lua_pop(self->luaState, 4);
	//HttpResponse_setHeader_to_(self->httpResponse, headerKey, headerValue);
	//VertexServer_setErrorCString_(self, "invalid action");

	return -1;
}

void VertexServer_handleRequestParameter(void *arg, Datum *k, Datum *v)
{
	VertexServer *self = (VertexServer *)arg;

	lua_getglobal(self->luaState, "HttpHandleParameter");

	lua_pushstring(self->luaState, Datum_data(k));
	lua_pushstring(self->luaState, Datum_data(v)); 
    lua_call(self->luaState, 2, 0);
	
    /*{
        printf("%s\n", lua_tostring(self->luaState , -1));
	}
	*/
		
	/*
	lua_getfield(self->luaState, LUA_GLOBALSINDEX, "httpRequestParams");  
	lua_pushstring(self->luaState, Datum_data(k));
	lua_pushstring(self->luaState, Datum_data(k));

	void lua_settable(self->luaState, int index);
	*/

}

void VertexServer_requestHandler(void *arg)  
{  
	VertexServer *self = (VertexServer *)arg;
	
	HttpResponse_setContentType_(self->httpResponse, "application/json;charset=utf-8");

	int result = VertexServer_process(self);
	Datum *content = HttpResponse_content(self->httpResponse);
	
	if (result == 0)
	{
		if (!Datum_size(content)) 
		{
			Datum_setCString_(content, "null");
		}
		Datum_nullTerminate(content); 
	}
	else
	{
		if (!Datum_size(content)) 
		{
			Datum_setCString_(content, "\"unknown error\"");
		}
		Datum_nullTerminate(content); 

		if(self->debug) { Log_Printf_("REQUEST ERROR: %s\n", Datum_data(content)); }
	}
}

int VertexServer_api_shutdown(VertexServer *self)
{
	HttpServer_shutdown(self->httpServer);
	return 0;
}

void VertexServer_SignalHandler(int s)
{
	if(s == SIGPIPE) 
	{
		Log_Printf("received signal SIGPIPE - ignoring\n");
		return;
	}
	
	Log_Printf_("received signal %i\n", s);
	VertexServer_api_shutdown(globalVertexServer);
}

void VertexServer_registerSignals(VertexServer *self)
{
	signal(SIGABRT, VertexServer_SignalHandler);
	signal(SIGINT,  VertexServer_SignalHandler);
	signal(SIGTERM, VertexServer_SignalHandler);
	signal(SIGPIPE, VertexServer_SignalHandler);
}

void VertexServer_setLogPath_(VertexServer *self, const char *path)
{
	Log_setPath_(path);
}

void VertexServer_setPidPath_(VertexServer *self, const char *path)
{
	self->pidPath = path;
}

void VertexServer_setIsDaemon_(VertexServer *self, int isDaemon)
{
	self->isDaemon = isDaemon;
}

void VertexServer_setDebug_(VertexServer *self, int aBool)
{
	self->debug = aBool;
}

void VertexServer_writePidFile(VertexServer *self)
{
	FILE *pidFile = fopen(self->pidPath, "w");
	
	if (!pidFile)
	{
		Log_Printf_("Unable to open pid file for writing: %s\n", self->pidPath);
		exit(-1);
	}
	else
	{
		if (fprintf(pidFile, "%i", getpid()) < 0)
		{
			Log_Printf("Error writing to pid file\n");
			exit(-1);
		}
		
		if (fclose(pidFile))
		{
			Log_Printf("Error closing pid file\n");
			exit(-1);
		}
	}
}

void VertexServer_removePidFile(VertexServer *self)
{
	if (self->pidPath)
	{
		if (unlink(self->pidPath))
		{
			Log_Printf("Error removing pid file\n");
		}
	}
}

int VertexServer_openLog(VertexServer *self)
{
	Log_open();
	return 0;
}

int luaopen_tokyocabinet(lua_State *lua);

int VertexServer_run(VertexServer *self)
{  	
    self->luaState = lua_open();
	luaL_openlibs(self->luaState);

	/*
	luaopen_base(self->luaState); 
	luaopen_table(self->luaState);
	//luaopen_io(self->luaState);
	luaopen_string(self->luaState);
	luaopen_math(self->luaState);
	luaopen_loadlib(self->luaState);
	*/
	
	//luaopen_tokyocabinet(self->luaState);
	
    if (luaL_dofile(self->luaState , "../../lua/HttpRequestHandler.lua"))
    {
        printf("%s\n", lua_tostring(self->luaState , -1));
    }
	
	//Socket_SetDescriptorLimitToMax();
	VertexServer_openLog(self);
	Log_Printf("VertexServer_run\n");
	
	if (self->isDaemon)
	{
		Log_Printf("Running as Daemon\n");
		daemon(0, 0);
		
		if (self->pidPath)
		{
			VertexServer_writePidFile(self);
		}
		else
		{
			Log_Printf("-pid is required when running as daemon\n");
			exit(-1);
		}
	}
	
	VertexServer_registerSignals(self);

	HttpServer_run(self->httpServer);	
	VertexServer_removePidFile(self);
	
	Log_Printf("shutdown\n\n");
	Log_close();
	
 	lua_close(self->luaState);
	return 0;  
}
