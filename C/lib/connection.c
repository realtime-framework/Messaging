#include "connection.h"
#include "balancer.h"
#include "channel.h"
#include "message.h"
#include "common.h"
#include "dlist.h"

#include "libwebsockets.h"

#include <pthread.h>
#include <regex.h>
#include <string.h>

#if defined(WIN32) || defined(_WIN32) || defined(__WIN32) && !defined(__CYGWIN__)
#include <Winsock2.h>
#else
#include <netinet/in.h>
#include <netinet/tcp.h>
#endif


#define MAX_ORTC_PAYLOAD 1800


static int ortc_callback(struct libwebsocket_context *lws_context,
			 struct libwebsocket *wsi,
			 enum libwebsocket_callback_reasons reason,
			 void *user, 
 			 void *in, 
			 size_t len)
{
  ortc_context *context = (ortc_context *) user;
  ortc_dnode *t;
  char *messageToSend;
  unsigned char buf[LWS_SEND_BUFFER_PRE_PADDING + MAX_ORTC_PAYLOAD + LWS_SEND_BUFFER_POST_PADDING];
  int tret;
  switch (reason) {
  case LWS_CALLBACK_CLIENT_WRITEABLE:{
    if(context->throttleCounter>=2000){
      return 0;
    }
    if(context->ortcCommands->count>0){
      while(context->ortcCommands->isBlocked);
      context->ortcCommands->isBlocked = 1;
      t = (ortc_dnode*)_ortc_dlist_take_first(context->ortcCommands);
      if(t!=NULL){
	messageToSend = t->id;
	sprintf((char *)&buf[LWS_SEND_BUFFER_PRE_PADDING], "%s", messageToSend);
	libwebsocket_write(context->wsi, &buf[LWS_SEND_BUFFER_PRE_PADDING], strlen(messageToSend), LWS_WRITE_TEXT);
	_ortc_dlist_free_dnode(t);
	context->throttleCounter++;
      }
      context->ortcCommands->isBlocked = 0;
    } else if(context->isConnected){
      while(context->messagesToSend->isBlocked);
      context->messagesToSend->isBlocked = 1;
      t = (ortc_dnode*)_ortc_dlist_take_first(context->messagesToSend);
      if(t!=NULL){
	char* messageToSend = t->id;
	sprintf((char *)&buf[LWS_SEND_BUFFER_PRE_PADDING], "%s", messageToSend);
	libwebsocket_write(context->wsi, &buf[LWS_SEND_BUFFER_PRE_PADDING], strlen(messageToSend), LWS_WRITE_TEXT);
	_ortc_dlist_free_dnode(t);
	context->throttleCounter++;
      } 
      context->messagesToSend->isBlocked = 0;
    }
    if(context->messagesToSend->count>0 || context->ortcCommands->count>0){	
      libwebsocket_callback_on_writable(context->lws_context, context->wsi);	
    }
    break;
  }
  case LWS_CALLBACK_CLIENT_RECEIVE:{
    char * message = (char *) in;
    context->heartbeat_counter = 0;
    _ortc_parse_message(context, message);
    break;
  }
  case LWS_CALLBACK_CLOSED:{
    if(!context->isReconnecting){
      _ortc_stop_loops(context);
      if(context->onDisconnected != NULL)
	context->onDisconnected(context);     

      if(!context->isDisconnecting){
	context->reconnecting_loop_active = 1;
	tret = pthread_create(&context->reconnectingThread, NULL, _ortc_reconnecting_loop, context);
	if(tret!=0){
	  _ortc_exception(context, "Error creating reconnecting thread!");	  
	}
      }
    }
    context->isConnecting = 0;
    context->isConnected = 0;
    context->isDisconnecting = 0;
    break;
  }
  }
  return 0;
}

static struct libwebsocket_protocols ortc_protocols[] = {
  {"ortc-protocol", ortc_callback, 0, 4096},
  { NULL, NULL, 0, 0}
};

void *_ortc_connection_loop(void *ptr){
  int c = 0;
  ortc_context *context;
  context = (ortc_context *) ptr;
  while(context->connection_loop_active){
    libwebsocket_service(context->lws_context, 10);
    if(c == 50){
      c = 0;
      if(context->lws_context && context->wsi)
	libwebsocket_callback_on_writable(context->lws_context, context->wsi);
    }
    c++;
  }
  pthread_detach(pthread_self());
  return 0;
}

void *_ortc_throttle_loop(void *ptr){
  ortc_context *context;
  context = (ortc_context *) ptr;
  context->throttleCounter = 0;
  while(context->connection_loop_active){
#if defined(WIN32) || defined(_WIN32) || defined(__WIN32) && !defined(__CYGWIN__)
    Sleep(1000);
#else
    sleep(1);
#endif
    context->throttleCounter = 0;
  }
  pthread_detach(pthread_self());
  return 0;
}

void _ortc_stop_loops(ortc_context* context){
  if(context->connection_loop_active){
    context->connection_loop_active = 0;
  }
  if(context->heartbeat_loop_active){
    context->heartbeat_loop_active = 0;
  }
  if(context->reconnecting_loop_active){
    context->reconnecting_loop_active = 0;
  }
}

void *_ortc_reconnecting_loop(void *ptr){
  ortc_context *context;
  context = (ortc_context *) ptr;
  context->isReconnecting = 1;
  while(context->reconnecting_loop_active){
    if(context->reconnecting_loop_active){
      if(!context->isConnected){
	if(context->onReconnecting != NULL)
	  context->onReconnecting(context);	
	_ortc_connect(context);
      } else
	break;      
    }
#if defined(WIN32) || defined(_WIN32) || defined(__WIN32) && !defined(__CYGWIN__)
    Sleep(ORTC_RECONNECT_INTERVAL*1000);
#else
    sleep(ORTC_RECONNECT_INTERVAL);
#endif
  }
  context->isReconnecting = 0;
  pthread_detach(pthread_self());
  return 0;
}

void *_ortc_heartbeat_loop(void *ptr){
  int tret;
  ortc_context *context;
  context = (ortc_context *) ptr;
  while(context->heartbeat_loop_active){
#if defined(WIN32) || defined(_WIN32) || defined(__WIN32) && !defined(__CYGWIN__)
    Sleep(1000);
#else
    sleep(1);
#endif
    context->heartbeat_counter++;
    if(context->heartbeat_counter > ORTC_HEARTBEAT_TIMEOUT){
      context->connection_loop_active = 0;            
      context->isConnected = 0;
      if(!context->isReconnecting){
	if(context->onDisconnected != NULL)
	  context->onDisconnected(context);
	context->reconnecting_loop_active = 1;
	tret = pthread_create(&context->reconnectingThread, NULL, _ortc_reconnecting_loop, context);
	if(tret!=0){
	  _ortc_exception(context, "Error creating reconnecting thread!");
	}	
      }
      context->heartbeat_loop_active = 0;
      pthread_detach(pthread_self());
      return 0;
    }
  }
  context->heartbeat_loop_active = 0;
  pthread_detach(pthread_self());
  return 0;
}

void _ortc_connect(ortc_context* context){
  struct lws_context_creation_info info;
  char *balancerResponse = NULL, *path = NULL;
  int tret;

  if(context->isConnecting)
    return;
  if(context->isConnected)
    return;
  if(context->lws_context)
    libwebsocket_context_destroy(context->lws_context);
  context->lws_context = NULL;
  if(context->host)
    free(context->host);
  context->host = NULL;
  if(context->server)
    free(context->server);
  context->server = NULL;
  context->isConnecting = 1;  
  memset(&info, 0, sizeof info);
  info.port = CONTEXT_PORT_NO_LISTEN;
  info.gid = -1;
  info.uid = -1;
  info.protocols = ortc_protocols;
  info.ssl_cipher_list = "RC4-MD5:RC4-SHA:AES128-SHA:AES256-SHA:HIGH:!DSS:!aNULL";

  info.ka_time = 0;
  info.ka_interval = 0;
  info.ka_probes = 0;
  
  context->lws_context = libwebsocket_create_context(&info);
  if (context->lws_context == NULL) {
    _ortc_exception(context,  "Creating libwebsocket context failed!");
    context->isConnecting = 0;
    return;
  }

  if(!context->url){//get the url from balancer    
    if(_ortc_getBalancer(context->cluster, &balancerResponse)!=0){
      _ortc_exception(context, balancerResponse);
      free(balancerResponse);
      context->isConnecting = 0;
      return;
    }
    context->server = strdup(balancerResponse);
    if(_ortc_parseUrl(balancerResponse, &context->host, &context->port, &context->useSSL) < 0){
      _ortc_exception(context, "malloc() failed!");
      free(balancerResponse);
      context->isConnecting = 0;
      return;
    }
    free(balancerResponse);
  } else {//use url provided by user
    context->server = strdup(context->url);
    if(_ortc_parseUrl(context->url, &context->host, &context->port, &context->useSSL) < 0){
      _ortc_exception(context, "malloc() failed!");
      context->isConnecting = 0;
      return;
    }
  }
  path = _ortc_prepareConnectionPath();
 
  context->wsi = libwebsocket_client_connect_extended(context->lws_context, context->host, context->port, context->useSSL, path, "", "", "ortc-protocol", -1, context);
  free(path);
  if(context->wsi == NULL){
    _ortc_exception(context,  "Creating websocket failed!");
    context->isConnecting = 0;
    return;
  }
#if !defined(WIN32) && !defined(_WIN32) && !defined(__APPLE__)
  int wsSock = libwebsocket_get_socket_fd(context->wsi);
  int opt = 1;
  setsockopt(wsSock, IPPROTO_TCP, TCP_CORK, &opt, sizeof(opt));
#endif

  context->connection_loop_active = 1;
  tret = pthread_create(&context->connectionThread, NULL, _ortc_connection_loop, context);
  if(tret!=0){
    _ortc_exception(context,  "Error creating connection thread!");
    context->isConnecting = 0;
    return;
  }
  tret = pthread_create(&context->throttleThread, NULL, _ortc_throttle_loop, context);
  if(tret!=0){    
    _ortc_exception(context,  "Error creating throttle thread!");
    context->isConnecting = 0;
    return;
  }
  context->heartbeat_loop_active = 1;
  context->heartbeat_counter = 0;
  tret = pthread_create(&context->heartbeatThread, NULL, _ortc_heartbeat_loop, context);
  if(tret!=0){    
    _ortc_exception(context,  "Error creating heartbeat thread!");
    context->isConnecting = 0;
    return;
  }
}

void _ortc_send_command(ortc_context *context, char *message){
  while(context->ortcCommands->isBlocked);
  context->ortcCommands->isBlocked = 1;
  _ortc_dlist_insert(context->ortcCommands, message, NULL, NULL, 0, NULL);
  context->ortcCommands->isBlocked = 0;
  free(message);
  libwebsocket_callback_on_writable(context->lws_context, context->wsi);
}

void _ortc_send_message(ortc_context *context, char *message){
  while(context->messagesToSend->isBlocked);
  context->messagesToSend->isBlocked = 1;
  _ortc_dlist_insert(context->messagesToSend, message, NULL, NULL, 0, NULL);
  context->messagesToSend->isBlocked = 0;
  free(message);
  libwebsocket_callback_on_writable(context->lws_context, context->wsi);
}

void _ortc_send(ortc_context* context, char* channel, char* message){
  int i, len;
  char *hash = _ortc_get_channel_permission(context, channel);
  char messageId[9], sParts[15], sMessageCount[15];
  int totalParts = 1, messageCount = 0;
  char* messagePart, *m;
  int parts = strlen(message) / ORTC_MAX_MESSAGE_SIZE;

  _ortc_random_string(messageId, 9);
  if(strlen(message) % ORTC_MAX_MESSAGE_SIZE > 0)
    parts++;
  sprintf(sParts, "%d", parts);

  for(i=0; i<parts; i++){
    int messageSize;
    char *messageR1, *messageR2;
    messageSize = strlen(message) - i * ORTC_MAX_MESSAGE_SIZE;
    if(messageSize > ORTC_MAX_MESSAGE_SIZE)
      messageSize = ORTC_MAX_MESSAGE_SIZE;
    
    messageCount = i + 1;    
    
    sprintf(sMessageCount, "%d", messageCount);

    messagePart = (char*)malloc(messageSize+1);
    if(messagePart==NULL){
      _ortc_exception(context, "malloc() failed in ortc send!");
      return;
    }
    memcpy(messagePart, message + i * ORTC_MAX_MESSAGE_SIZE, messageSize);
    messagePart[messageSize] = '\0';

    messageR1 = _ortc_replace(messagePart, "\"", "\\\"");
    messageR2 = _ortc_replace(messageR1, "\n", "\\n");
    //messageR = messageR1;
    //printf("messR: %s\n", messageR1);
    //len = 15 + strlen(context->appKey) + strlen(context->authToken) + strlen(channel) + strlen(hash) + strlen(messageId) + strlen(sParts) + strlen(sMessageCount) + messageSize;
    len = 15 + strlen(context->appKey) + strlen(context->authToken) + strlen(channel) + strlen(hash) + strlen(messageId) + strlen(sParts) + strlen(sMessageCount) + strlen(messageR2); 
    m = (char*)malloc(len + 1);
    if(m == NULL){
      _ortc_exception(context, "malloc() failed in ortc send!");
      free(messagePart);
      free(messageR1);
      free(messageR2);
      return;
    }
    snprintf(m, len, "\"send;%s;%s;%s;%s;%s_%d-%d_%s\"", context->appKey, context->authToken, channel, hash, messageId, messageCount, parts, messageR2);
    free(messagePart);
    free(messageR1);
    free(messageR2);
    _ortc_send_message(context, m);
  }
}

void _ortc_disconnect(ortc_context *context){
  _ortc_stop_loops(context);
  context->isConnected = 0;
  context->isConnecting = 0;
  
  if(context->lws_context)
    libwebsocket_context_destroy(context->lws_context);
  context->lws_context = NULL;
  context->wsi = NULL;
  
  _ortc_dlist_clear(context->multiparts);
  _ortc_dlist_clear(context->channels);
  _ortc_dlist_clear(context->permissions);
  _ortc_dlist_clear(context->messagesToSend);
  _ortc_dlist_clear(context->ortcCommands);
}
