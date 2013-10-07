#include <stdio.h>
#include <stdlib.h>
//#include <unistd.h>
//#include <getopt.h>
#include <string.h>
//#include <signal.h>
//#include <time.h>
#include <malloc.h>

#include "libwebsockets.h"
#include "libortc.h"
#include "connection.h"
#include "presence.h"
#include "common.h"
#include "authentication.h"
#include "channel.h"

ortc_context* ortc_create_context(void){
  int rc;

  ortc_context *context = (ortc_context*)malloc(sizeof(ortc_context));
  if(context == NULL){
    fprintf(stderr, "malloc ortc_context failed\n");
    exit(EXIT_FAILURE);
  } 
  context->appKey = NULL;
  context->authToken = NULL;
  context->metadata = "";
  context->announcementSubChannel = "";
  _ortc_random_string(context->sessionId, 17);
  context->cluster = NULL;
  context->url = NULL;
  context->server = NULL;
  context->host = NULL;
  context->port = 0;
  context->useSSL = 0;
  context->connection_loop_active = 0;
  context->reconnecting_loop_active = 0;
  context->heartbeat_loop_active = 0;
  context->heartbeat_counter = 0;
  context->lws_context = NULL;
 
  context->multiparts = _ortc_dlist_init();
  context->channels = _ortc_dlist_init();
  context->permissions = _ortc_dlist_init();
  context->messagesToSend = _ortc_dlist_init();
  context->ortcCommands = _ortc_dlist_init();

  context->onConnected = NULL;
  context->onDisconnected = NULL;
  context->onSubscribed = NULL;
  context->onUnsubscribed = NULL;
  context->onException = NULL;
  context->onReconnecting = NULL;
  context->onReconnected = NULL;
  
  context->isConnected = 0;
  context->isConnecting = 0;
  context->isDisconnecting = 0;
  context->isReconnecting = 0;
  context->throttleCounter = 0;

  if (0 != (rc = regcomp(&context->reOperation, ORTC_OPERATION_PATTERN, 0))) {
    fprintf(stderr, "regcomp() failed, returning nonzero (%d) for pattern: %s\n", rc, ORTC_OPERATION_PATTERN);
    exit(EXIT_FAILURE);
  }
  if (0 != (rc = regcomp(&context->rePermissions, ORTC_PERMISSIONS_PATTERN, 0))) {
    fprintf(stderr, "regcomp() failed, returning nonzero (%d) for pattern: %s\n", rc, ORTC_PERMISSIONS_PATTERN);
    exit(EXIT_FAILURE);
  }
  if (0 != (rc = regcomp(&context->reChannel, ORTC_CHANNEL_PATTERN, 0))) {
    fprintf(stderr, "regcomp() failed, returning nonzero (%d) for pattern: %s\n", rc, ORTC_CHANNEL_PATTERN);
    exit(EXIT_FAILURE);
  }
  if (0 != (rc = regcomp(&context->reMessage, ORTC_MESSAGE_PATTERN, 0))) {
    fprintf(stderr, "regcomp() failed, returning nonzero (%d) for pattern: %s\n", rc, ORTC_MESSAGE_PATTERN);
    exit(EXIT_FAILURE);
  }
  if (0 != (rc = regcomp(&context->reMultipart, ORTC_MULTIPART_PATTERN, 0))) {
    fprintf(stderr, "regcomp() failed, returning nonzero (%d) for pattern: %s\n", rc, ORTC_MULTIPART_PATTERN);
    exit(EXIT_FAILURE);
  }
  if (0 != (rc = regcomp(&context->reException, ORTC_EXCEPTION_PATTERN, 0))) {
    fprintf(stderr, "regcomp() failed, returning nonzero (%d) for pattern: %s\n", rc, ORTC_EXCEPTION_PATTERN);
    exit(EXIT_FAILURE);
  }
  if (0 != (rc = regcomp(&context->reValidUrl, ORTC_VALID_URL_PATTERN, 0))) {
    fprintf(stderr, "regcomp() failed, returning nonzero (%d) for pattern: %s\n", rc, ORTC_VALID_URL_PATTERN);
    exit(EXIT_FAILURE);
  }
  if (0 != (rc = regcomp(&context->reValidInput, ORTC_VALID_INPUT_PATTERN, 0))) {
    fprintf(stderr, "regcomp() failed, returning nonzero (%d) for pattern: %s\n", rc, ORTC_VALID_INPUT_PATTERN);
    exit(EXIT_FAILURE);
  }

  curl_global_init(CURL_GLOBAL_ALL);

  lws_set_log_level(0, NULL);

  return context;
}

void ortc_free_context(ortc_context* context){  
  _ortc_stop_loops(context);
  regfree(&context->reOperation);
  regfree(&context->rePermissions);
  regfree(&context->reChannel);
  regfree(&context->reMessage);
  regfree(&context->reMultipart);
  regfree(&context->reException);
  regfree(&context->reValidUrl);
  regfree(&context->reValidInput);
  if(context->host)
    free(context->host);
  if(context->server)
    free(context->server);
  _ortc_dlist_free(context->multiparts);
  _ortc_dlist_free(context->channels);
  _ortc_dlist_free(context->permissions);
  _ortc_dlist_free(context->messagesToSend);
  _ortc_dlist_free(context->ortcCommands);
  context->isDisconnecting = 1;
  if(context->lws_context != NULL)
    libwebsocket_context_destroy(context->lws_context);
  context->lws_context = NULL;
  curl_global_cleanup(); 
  free(context);
}

void ortc_set_cluster(ortc_context* context, char* cluster){
  context->cluster = cluster;
}
char* ortc_get_cluster(ortc_context* context){
  return context->cluster;
}
void ortc_set_url(ortc_context* context, char* url){
  context->url = url;
}
char* ortc_get_url(ortc_context* context){
  return context->url;
}
void ortc_set_connection_metadata(ortc_context* context, char* connection_metadata){
  context->metadata = connection_metadata;
}
char* ortc_get_connection_metadata(ortc_context* context){
  return context->metadata;
}
void ortc_set_announcementSubChannel(ortc_context* context, char* announcementSubChannel){
  context->announcementSubChannel = announcementSubChannel;
}
char* ortc_get_announcementSubChannel(ortc_context* context){
  return context->announcementSubChannel;
}
char* ortc_get_sessionId(ortc_context* context){
  return context->sessionId;
}
int ortc_is_connected(ortc_context* context){
  return context->isConnected;
}
int ortc_is_subscribed(ortc_context* context, char* channel){
  ortc_dnode *t = _ortc_dlist_search(context->channels, channel);
  if(t){
    if(t->num>1)
      return 1;
  }
  return 0;
}

void ortc_set_onConnected(ortc_context* context, void (*onConnected)(ortc_context*)){
  context->onConnected = onConnected;
}

void ortc_set_onDisconnected(ortc_context* context, void (*onDisconnected)(ortc_context*)){
  context->onDisconnected = onDisconnected;
}

void ortc_set_onReconnected(ortc_context* context, void (*onReconnected)(ortc_context*)){
  context->onReconnected = onReconnected;
}

void ortc_set_onReconnecting(ortc_context* context, void (*onReconnecting)(ortc_context*)){
  context->onReconnecting = onReconnecting;
}

void ortc_set_onException(ortc_context* context, void (*onException)(ortc_context*, char*)){
  context->onException = onException;
}

void ortc_set_onSubscribed(ortc_context* context, void (*onSubscribed)(ortc_context*, char*)){
  context->onSubscribed = onSubscribed;
}

void ortc_set_onUnsubscribed(ortc_context* context, void (*onUnsubscribed)(ortc_context*, char*)){
  context->onUnsubscribed = onUnsubscribed;
}

void ortc_connect(ortc_context* context, char* applicationKey, char* authenticationToken){
  if(context->isConnected){
    _ortc_exception(context, "Already connected");
  } else if (!context->url && !context->cluster){
    _ortc_exception(context, "URL and Cluster URL are null or empty");
  } else if (!applicationKey || strlen(applicationKey)==0) {
    _ortc_exception(context, "Application Key is null or empty");
  } else if (!authenticationToken || strlen(authenticationToken)==0) {
    _ortc_exception(context, "Authentication Token is null or empty");    
  } else if (context->url && !_ortc_isValidUrl(context, context->url)) { 
    _ortc_exception(context, "Invalid URL");
  } else if (context->cluster && !_ortc_isValidUrl(context, context->cluster)) {
    _ortc_exception(context, "Invalid Cluster URL");
  } else if (!_ortc_isValidInput(context, applicationKey)) {
    _ortc_exception(context, "Application Key has invalid characters");
  } else if (!_ortc_isValidInput(context, authenticationToken)) {
    _ortc_exception(context, "Authentication Token has invalid characters");
  } else if (!_ortc_isValidInput(context, context->announcementSubChannel)) {
    _ortc_exception(context, "Announcement Subchannel has invalid characters");
  } else if (strlen(context->metadata) > ORTC_CONNECTION_METADATA_MAX_SIZE){
    _ortc_exception(context, "Connection metadata size exceeds the limit");
  } else {
    context->appKey = applicationKey;
    context->authToken = authenticationToken;
    _ortc_connect(context);
  }
}

void ortc_disconnect(ortc_context* context){
  if(context->isConnected==0){
    _ortc_exception(context,  "Not connected!");
  } else {
    context->isDisconnecting = 1;
    _ortc_disconnect(context);
  }
}

void ortc_subscribe(ortc_context* context, 
		    char *channel, 
		    int subscribeOnReconnected, 
		    void (*onMessage)(ortc_context*, char*, char*)){
  if(!context->isConnected){
    _ortc_exception(context, "Not connected");
  } else if(!channel || strlen(channel)==0){
    _ortc_exception(context, "Channel is null or empty");
  } else if(!_ortc_isValidInput(context, channel)) {
    _ortc_exception(context, "Channel has invalid characters");
  } else if(_ortc_is_subscribing(context, channel)){
    _ortc_exception(context, "Already trying to subscribe this channel");
  } else if(ortc_is_subscribed(context, channel)){
    _ortc_exception(context, "Already subscribed to this channel");
  } else if(strlen(channel) > ORTC_CHANNEL_MAX_SIZE){
    _ortc_exception(context, "Channel size exceeds the limit of characters");
  } else if(!onMessage){
    _ortc_exception(context, "The argument \"onMessage\" must point to a function");
  } else {
    _ortc_subscribe(context, channel, subscribeOnReconnected, 1, onMessage);
  }
}

void ortc_unsubscribe(ortc_context* context, char *channel){
  if(!context->isConnected){
    _ortc_exception(context, "Not connected");
  } else if(!channel || strlen(channel)==0){
    _ortc_exception(context, "Channel is null or empty");
  } else if(!_ortc_isValidInput(context, channel)) {
    _ortc_exception(context, "Channel has invalid characters");
  } else if(!ortc_is_subscribed(context, channel)){
    _ortc_exception(context, "Not subscribed to the channel");
  } else if(strlen(channel) > ORTC_CHANNEL_MAX_SIZE){
    _ortc_exception(context, "Channel size exceeds the limit of characters");
  } else {
    _ortc_unsubscribe(context, channel);
  }
}

void ortc_send(ortc_context* context, char *channel, char *message){
  if(!context->isConnected){
    _ortc_exception(context, "Not connected");
  } else if(!channel || strlen(channel)==0){
    _ortc_exception(context, "Channel is null or empty");
  } else if(!_ortc_isValidInput(context, channel)) {
    _ortc_exception(context, "Channel has invalid characters");
  } else if(!message || strlen(message)==0){
    _ortc_exception(context, "Message is null or empty");
  } else if(strlen(channel) > ORTC_CHANNEL_MAX_SIZE){
    _ortc_exception(context, "Channel size exceeds the limit of characters");
  } else {
    _ortc_send(context, channel, message);
  }
}

void ortc_enable_presence(ortc_context* context, 
			  char* privateKey, 
			  char* channel, 
			  int metadata, 
			  void (*callback)(ortc_context*, char*, char*, char*)){
  pthread_t pThread;
  ortc_presenceParams *p;
  int ret;

  if(!context->isConnected){
    _ortc_exception(context, "Not connected");
  } else if(!channel || strlen(channel)==0){
    _ortc_exception(context, "Channel is null or empty");
  } else if(!_ortc_isValidInput(context, channel)) {
    _ortc_exception(context, "Channel has invalid characters");
  } else if(strlen(channel) > ORTC_CHANNEL_MAX_SIZE){
    _ortc_exception(context, "Channel size exceeds the limit of characters");
  } else if(!callback) {
    _ortc_exception(context, "Callback is empty");
  } else if(!privateKey || strlen(privateKey)==0){
    _ortc_exception(context, "Private key is null or empty");
  } else if(!_ortc_isValidInput(context, privateKey)) {
    _ortc_exception(context, "Private key has invalid characters");
  } else {
    metadata = (metadata>0) ? 1 : 0;
    
    p = (ortc_presenceParams*)malloc(sizeof(ortc_presenceParams));  
    if(p == NULL){
      callback(context, channel, "malloc ortc_presenceParams failed!", NULL);
      return;
    }
    p->isExtended = 0;
    p->context = context;
    p->privateKey = privateKey;
    p->channel = channel;
    p->metadata = metadata;
    p->callbackCmd = callback;    
    ret = pthread_create(&pThread, NULL, _ortc_enablePresence, p);
    if(ret!=0){
      callback(context, channel, "Error creating presence thread!", NULL);
      free(p);
    }
  }
}

void ortc_enable_presence_ex(ortc_context* context, 
				   char* url, 
				   int isCluster, 
				   char* appKey, 
				   char* privateKey, 
				   char* channel, 
				   int metadata, 
				   void (*callback)(ortc_context*, char*, char*, char*)){
  pthread_t pThread;
  ortc_presenceParams *p;
  int ret;

  if(!url || strlen(url)==0){
    _ortc_exception(context, "Url is null or empty");
  } else if (url && !_ortc_isValidUrl(context, url)) { 
    _ortc_exception(context, "Invalid URL");
  } else if (!appKey || strlen(appKey)==0) {
    _ortc_exception(context, "Application Key is null or empty");
  } else if (!_ortc_isValidInput(context, appKey)) {
    _ortc_exception(context, "Application Key has invalid characters");
  } else if(!channel || strlen(channel)==0){
    _ortc_exception(context, "Channel is null or empty");
  } else if(!_ortc_isValidInput(context, channel)) {
    _ortc_exception(context, "Channel has invalid characters");
  } else if(strlen(channel) > ORTC_CHANNEL_MAX_SIZE){
    _ortc_exception(context, "Channel size exceeds the limit of characters");
  } else if(!callback) {
    _ortc_exception(context, "Callback is empty");
  } else if(!privateKey || strlen(privateKey)==0){
    _ortc_exception(context, "Private key is null or empty");
  } else if(!_ortc_isValidInput(context, privateKey)) {
    _ortc_exception(context, "Private key has invalid characters");
  } else {
    isCluster = (isCluster>0) ? 1 : 0;
    metadata = (metadata>0) ? 1 : 0;

    p = (ortc_presenceParams *)malloc(sizeof(ortc_presenceParams));  
    if(p == NULL){
      callback(context, channel, "malloc ortc_presenceParams failed!", NULL);
      return;
    }
    p->isExtended = 1;
    p->url = url;
    p->isCluster = isCluster;
    p->appKey = appKey;
    p->context = context;
    p->privateKey = privateKey;
    p->channel = channel;
    p->metadata = metadata;
    p->callbackCmd = callback;    
    ret = pthread_create(&pThread, NULL, _ortc_enablePresence, p);
    if(ret!=0){
      callback(context, channel, "Error creating presence thread!", NULL);
      free(p);
    }
  }
}

void ortc_disable_presence(ortc_context* context, 
			   char* privateKey, 
			   char* channel, 
			   void (*callback)(ortc_context*, char*, char*, char*)){
  pthread_t pThread;
  ortc_presenceParams *p;
  int ret;

  if(!context->isConnected){
    _ortc_exception(context, "Not connected");
  } else if(!channel || strlen(channel)==0){
    _ortc_exception(context, "Channel is null or empty");
  } else if(!_ortc_isValidInput(context, channel)) {
    _ortc_exception(context, "Channel has invalid characters");
  } else if(strlen(channel) > ORTC_CHANNEL_MAX_SIZE){
    _ortc_exception(context, "Channel size exceeds the limit of characters");
  } else if(!callback) {
    _ortc_exception(context, "Callback is empty");
  } else if(!privateKey || strlen(privateKey)==0){
    _ortc_exception(context, "Private key is null or empty");
  } else if(!_ortc_isValidInput(context, privateKey)) {
    _ortc_exception(context, "Private key has invalid characters");
  } else {    
    p = (ortc_presenceParams *)malloc(sizeof(ortc_presenceParams));  
    if(p == NULL){
      callback(context, channel, "malloc ortc_presenceParams failed!", NULL);
      return;
    }
    p->isExtended = 0;
    p->context = context;
    p->privateKey = privateKey;
    p->channel = channel;
    p->callbackCmd = callback;    
    ret = pthread_create(&pThread, NULL, _ortc_disablePresence, p);
    if(ret!=0){
      callback(context, channel, "Error creating presence thread!", NULL);
      free(p);
    }
  }
}

void ortc_disable_presence_ex(ortc_context* context, 
				   char* url, 
				   int isCluster, 
				   char* appKey, 
				   char* privateKey, 
				   char* channel, 
				   void (*callback)(ortc_context*, char*, char*, char*)){
  pthread_t pThread;
  ortc_presenceParams *p;
  int ret;

  if(!url || strlen(url)==0){
    _ortc_exception(context, "Url is null or empty");
  } else if (url && !_ortc_isValidUrl(context, url)) { 
    _ortc_exception(context, "Invalid URL");
  } else if (!appKey || strlen(appKey)==0) {
    _ortc_exception(context, "Application Key is null or empty");
  } else if (!_ortc_isValidInput(context, appKey)) {
    _ortc_exception(context, "Application Key has invalid characters");
  } else if(!channel || strlen(channel)==0){
    _ortc_exception(context, "Channel is null or empty");
  } else if(!_ortc_isValidInput(context, channel)) {
    _ortc_exception(context, "Channel has invalid characters");
  } else if(strlen(channel) > ORTC_CHANNEL_MAX_SIZE){
    _ortc_exception(context, "Channel size exceeds the limit of characters");
  } else if(!callback) {
    _ortc_exception(context, "Callback is empty");
  } else if(!privateKey || strlen(privateKey)==0){
    _ortc_exception(context, "Private key is null or empty");
  } else if(!_ortc_isValidInput(context, privateKey)) {
    _ortc_exception(context, "Private key has invalid characters");
  } else {
    isCluster = (isCluster>0) ? 1 : 0;
    p = (ortc_presenceParams *)malloc(sizeof(ortc_presenceParams));  
    if(p == NULL){
      callback(context, channel, "malloc ortc_presenceParams failed!", NULL);
      return;
    }
    p->isExtended = 1;
    p->url = url;
    p->isCluster = isCluster;
    p->appKey = appKey;
    p->context = context;
    p->privateKey = privateKey;
    p->channel = channel;
    p->callbackCmd = callback;    
    ret = pthread_create(&pThread, NULL, _ortc_disablePresence, p);
    if(ret!=0){
      callback(context, channel, "Error creating presence thread!", NULL);
      free(p);
    }
  }
}

void ortc_presence(ortc_context* context, 
		   char* channel, 
		   void (*callback)(ortc_context*, char*, char*, ortc_presenceData*)){
  pthread_t pThread;
  ortc_presenceParams *p;
  int ret;

  if(!context->isConnected){
    _ortc_exception(context, "Not connected");
  } else if(!channel || strlen(channel)==0){
    _ortc_exception(context, "Channel is null or empty");
  } else if(!_ortc_isValidInput(context, channel)) {
    _ortc_exception(context, "Channel has invalid characters");
  } else if(strlen(channel) > ORTC_CHANNEL_MAX_SIZE){
    _ortc_exception(context, "Channel size exceeds the limit of characters");
  } else if(!callback) {
    _ortc_exception(context, "Callback is empty");
  } else {
    p = (ortc_presenceParams *)malloc(sizeof(ortc_presenceParams));  
    if(p == NULL){
      callback(context, channel, "malloc ortc_presenceParams failed!", NULL);
      return;
    }
    p->isExtended = 0;
    p->context = context;
    p->channel = channel;
    p->callbackGet = callback;    
    ret = pthread_create(&pThread, NULL, _ortc_presence, p);
    if(ret!=0){
      callback(context, channel, "Error creating presence thread!", NULL);
      free(p);
    }
  }
}

void ortc_presence_ex(ortc_context* context, 
			    char* url, 
			    int isCluster, 
			    char* appKey,
			    char* authToken,
			    char* channel, 
			    void (*callback)(ortc_context*, char*, char*, ortc_presenceData*)){
  pthread_t pThread;
  ortc_presenceParams *p;
  int ret;

  if(!url || strlen(url)==0){
    _ortc_exception(context, "Url is null or empty");
  } else if (url && !_ortc_isValidUrl(context, url)) { 
    _ortc_exception(context, "Invalid URL");
  } else if (!appKey || strlen(appKey)==0) {
    _ortc_exception(context, "Application Key is null or empty");
  } else if (!_ortc_isValidInput(context, appKey)) {
    _ortc_exception(context, "Application Key has invalid characters");
  } else if(!channel || strlen(channel)==0){
    _ortc_exception(context, "Channel is null or empty");
  } else if(!_ortc_isValidInput(context, channel)) {
    _ortc_exception(context, "Channel has invalid characters");
  } else if(strlen(channel) > ORTC_CHANNEL_MAX_SIZE){
    _ortc_exception(context, "Channel size exceeds the limit of characters");
  } else if(!callback) {
    _ortc_exception(context, "Callback is empty");
  } else if(!authToken || strlen(authToken)==0){
    _ortc_exception(context, "Authentication token is null or empty");
  } else if(!_ortc_isValidInput(context, authToken)) {
    _ortc_exception(context, "Authentication token has invalid characters");
  } else {
    isCluster = (isCluster>0) ? 1 : 0;
    p = (ortc_presenceParams *)malloc(sizeof(ortc_presenceParams));  
    if(p == NULL){
      callback(context, channel, "malloc ortc_presenceParams failed!", NULL);
      return;
    }
    p->isExtended = 1;
    p->url = url;
    p->isCluster = isCluster;
    p->appKey = appKey;
    p->authToken = authToken;
    p->context = context;
    p->channel = channel;
    p->callbackGet = callback;    
    ret = pthread_create(&pThread, NULL, _ortc_presence, p);
    if(ret!=0){
      callback(context, channel, "Error creating presence thread!", NULL);
      free(p);
    }
  }
}

void ortc_save_authentication(ortc_context *context,
			      char *authToken,
			      int isPrivate,
			      int ttl,
			      char *privateKey,
			      ortc_channelPermissions *permissions,
			      int sizeOfChannelPermissions,
			      void (*callback)(ortc_context*, char*, char*)){
  pthread_t pThread;
  ortc_authenticationParams *p;
  int ret;

  if(!context->isConnected){
    _ortc_exception(context, "Not connected");
  } else if(!permissions){
    _ortc_exception(context, "Channel permissions are empty");
  } else if(!callback) {
    _ortc_exception(context, "Callback is empty");
  } else if(!privateKey || strlen(privateKey)==0){
    _ortc_exception(context, "Private key is null or empty");
  } else if(!_ortc_isValidInput(context, privateKey)) {
    _ortc_exception(context, "Private key has invalid characters");
  } else if(!authToken || strlen(authToken)==0){
    _ortc_exception(context, "Authentication token is null or empty");
  } else if(!_ortc_isValidInput(context, authToken)) {
    _ortc_exception(context, "Authentication token has invalid characters");
  } else {
    isPrivate = (isPrivate>0) ? 1 : 0;
    p = (ortc_authenticationParams *)malloc(sizeof(ortc_authenticationParams));  
    if(p == NULL){
      callback(context, "malloc ortc_authenticationParams failed", NULL);
      return;
    }
    p->isExtended = 0;
    p->context = context;
    p->authToken = authToken;
    p->isPrivate = isPrivate;
    p->ttl = ttl;
    p->privateKey = privateKey;
    p->permissions = permissions;
    p->sizeOfChannelPermissions = sizeOfChannelPermissions;
    p->callback = callback;  
    ret = pthread_create(&pThread, NULL, _ortc_saveAuthentication, p);
    if(ret!=0){
      callback(context, "Error creating authentication thread!", NULL);
      free(p);
    }
  }
}

void ortc_save_authentication_ex(ortc_context *context, char* url, 
				       int isCluster, char* authToken,
				       int isPrivate, char* appKey,
				       int ttl, char *privateKey,
				       ortc_channelPermissions *permissions,
				       int sizeOfChannelPermissions,
				       void (*callback)(ortc_context*, char*, char*)){
  pthread_t pThread;
  ortc_authenticationParams *p;
  int ret;

  if(!permissions){
    _ortc_exception(context, "Channel permissions are empty");
  } else if(!callback) {
    _ortc_exception(context, "Callback is empty");
  } else if(!privateKey || strlen(privateKey)==0){
    _ortc_exception(context, "Private key is null or empty");
  } else if(!_ortc_isValidInput(context, privateKey)) {
    _ortc_exception(context, "Private key has invalid characters");
  } else if(!authToken || strlen(authToken)==0){
    _ortc_exception(context, "Authentication token is null or empty");
  } else if(!_ortc_isValidInput(context, authToken)) {
    _ortc_exception(context, "Authentication token has invalid characters");
  } else if(!appKey || strlen(appKey)==0) {
    _ortc_exception(context, "Application Key is null or empty");
  } else if(!_ortc_isValidInput(context, appKey)) {
    _ortc_exception(context, "Application Key has invalid characters");
  } else if(!url || strlen(url)==0){
    _ortc_exception(context, "Url is null or empty");
  } else if(url && !_ortc_isValidUrl(context, url)) { 
    _ortc_exception(context, "Invalid URL");
  } else {
    isCluster = (isCluster>0) ? 1 : 0;
    isPrivate = (isPrivate>0) ? 1 : 0;
    p = (ortc_authenticationParams *)malloc(sizeof(ortc_authenticationParams));  
    if(p == NULL){
      callback(context, "malloc ortc_authenticationParams failed", NULL);
      return;
    }
    p->isExtended = 1;
    p->context = context;
    p->url = url;
    p->isCluster = isCluster;
    p->appKey = appKey;
    p->authToken = authToken;
    p->isPrivate = isPrivate;
    p->ttl = ttl;
    p->privateKey = privateKey;
    p->permissions = permissions;
    p->sizeOfChannelPermissions = sizeOfChannelPermissions;
    p->callback = callback;  
    ret = pthread_create(&pThread, NULL, _ortc_saveAuthentication, p);
    if(ret!=0){
      callback(context, "Error creating authentication thread!", NULL);
      free(p);
    }
  }
}
