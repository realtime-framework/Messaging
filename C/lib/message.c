#include "message.h"
#include "common.h"
#include "libwebsockets.h"
#include "channel.h"
#include "connection.h"

#include <string.h>

#if defined(WIN32) || defined(_WIN32) || defined(__WIN32) && !defined(__CYGWIN__)
#include <Winsock2.h>
#else
#include <netinet/tcp.h>
#endif

#if __APPLE__
#include <sys/socket.h>
#endif

void _ortc_fire_onMessage(ortc_context *context, char *channel, char *message){
  char *messageR1, *messageR2;
  ortc_dnode* t = _ortc_dlist_search(context->channels, channel);
  messageR1 = _ortc_replace(message, "\\\\\"", "\"");
  messageR2 = _ortc_replace(messageR1, "\\\\n", "\n");
  if(t != NULL){
    if(t->callback != NULL)
      t->callback(context, channel, messageR2);
  }
  free(messageR1);
  free(messageR2);
}

void _ortc_check_if_got_all_parts(ortc_context *context, char* messageId, int iMessageTotal){
  int i, size, pos;	
  char *ret, *channel;
  ortc_dnode **aNodes = malloc(sizeof(ortc_dnode*) * (iMessageTotal + 1));

  if(aNodes==NULL){
    fprintf(stderr, "malloc() failed in ortc check if got all parts\n");
    exit(EXIT_FAILURE);
  }

  for(i = 1; i<= iMessageTotal; i++){
    ortc_dnode *t = _ortc_dlist_searchEx(context->multiparts, messageId, i);
    if(t != NULL) {
      aNodes[(i-1)] = t;
    } else {
      free(aNodes);
      return;    
    }
  }
  size = 0;
  for(i = 0; i< iMessageTotal; i++){
    size += strlen(aNodes[i]->val2);
  }
  ret = (char*)malloc(size+1);
  pos = 0;
  channel = (char*)strdup(aNodes[0]->val1);
  for(i = 0; i< iMessageTotal; i++){
    int len = strlen(aNodes[i]->val2);
    memcpy(ret + pos, aNodes[i]->val2, len);
    pos += len;
    _ortc_dlist_deleteEx(context->multiparts, messageId, i+1);
  }
  ret[size] = '\0';
  _ortc_fire_onMessage(context, channel, ret);
  free(channel);
  free(ret);
  free(aNodes);
}

void _ortc_parse_message(ortc_context *context, char *message){
  char *messageId, *messageCount, *messageTotal, *messagePart, *channelNameStr, *messageStr, *params, *permissionsStr, *exceptionStr, *validateString;
  size_t     nmatch = 3, nmatch2 = 5;
  regmatch_t pmatch[3],  pmatch2[5];
  int iMessageTotal, wsSock, opt, len;
  ortc_dnode *ch;

  if(message[0] == 'a') {
    if (0 == regexec(&context->reMessage, message, nmatch, pmatch, 0)) {         //is message   
      channelNameStr = _ortc_get_from_regmatch(message, pmatch[1]);
      messageStr = _ortc_get_from_regmatch(message, pmatch[2]);
      if(0 == regexec(&context->reMultipart, messageStr, nmatch2, pmatch2, 0)){
	messageId =  _ortc_get_from_regmatch(messageStr, pmatch2[1]);
	messageCount =  _ortc_get_from_regmatch(messageStr, pmatch2[2]);
	messageTotal =  _ortc_get_from_regmatch(messageStr, pmatch2[3]);
	messagePart =  _ortc_get_from_regmatch(messageStr, pmatch2[4]);
	iMessageTotal = atoi(messageTotal);
	if(iMessageTotal > 1){ //multipart message
	  _ortc_dlist_insert(context->multiparts, messageId, channelNameStr, messagePart, atoi(messageCount), NULL);
	  _ortc_check_if_got_all_parts(context, messageId, iMessageTotal);
	} else {
	  _ortc_fire_onMessage(context, channelNameStr, messagePart);
	}
	free(messageId);
	free(messageCount);
	free(messageTotal);
	free(messagePart);
      }
      free(channelNameStr);
      free(messageStr);
    } else if (0 == regexec(&context->reOperation, message, nmatch, pmatch, 0)) { //is operation
      params = _ortc_get_from_regmatch(message, pmatch[2]);
      if(strncmp(&message[pmatch[1].rm_so], "ortc-validated", 14)==0){
	if(0 == regexec(&context->rePermissions, params, nmatch2, pmatch2, 0)){
	  permissionsStr = _ortc_get_from_regmatch(params, pmatch2[1]); 
	  _ortc_save_permissions(context, permissionsStr);
	  free(permissionsStr);
	}
	context->isConnected = 1;
	context->isConnecting = 0;
	if(context->reconnecting_loop_active){
	  context->reconnecting_loop_active = 0;
	  if(context->onReconnected != NULL){
	    context->onReconnected(context);
	  }
	  _ortc_subscribeOnReconnected(context);
	} else {
	  if(context->onConnected != NULL){
	    context->onConnected(context);
	  }
	}
      } else if(strncmp(&message[pmatch[1].rm_so], "ortc-subscribed", 15)==0){
	if(0 == regexec(&context->reChannel, params, nmatch2, pmatch2, 0)){
	  channelNameStr = _ortc_get_from_regmatch(params, pmatch2[1]);
	  ch = _ortc_dlist_search(context->channels, channelNameStr);
	  if(ch != NULL)
	    ch->num += 2; //isSubscribed
	  if(context->onSubscribed != NULL)
	    context->onSubscribed(context, channelNameStr);	  
	  free(channelNameStr);
	}
      } else if(strncmp(&message[pmatch[1].rm_so], "ortc-unsubscribed", 17)==0){
	if(0 == regexec(&context->reChannel, params, nmatch2, pmatch2, 0)){
	  channelNameStr = _ortc_get_from_regmatch(params, pmatch2[1]);
	  _ortc_dlist_delete(context->channels, channelNameStr);
	  if(context->onUnsubscribed != NULL)
	    context->onUnsubscribed(context, channelNameStr);
	  free(channelNameStr);
	}
      } else if(strncmp(&message[pmatch[1].rm_so], "ortc-error", 10)==0){
	if(0 == regexec(&context->reException, params, nmatch2, pmatch2, 0)){
	  exceptionStr = _ortc_get_from_regmatch(params, pmatch2[1]);
	  _ortc_exception(context, exceptionStr);
	  free(exceptionStr);
	}
      }
      free(params);
    }

  } else if(message[0] == 'o' && strlen(message)==1){
    wsSock = libwebsocket_get_socket_fd(context->wsi);
    opt = ORTC_SNDBUF_SIZE;
    setsockopt(wsSock, SOL_SOCKET, SO_SNDBUF, (const char*)&opt, sizeof(opt));

    len = 17 + strlen(context->appKey) +  strlen(context->authToken) + strlen(context->announcementSubChannel) + strlen(context->sessionId) + strlen(context->metadata);
    validateString = malloc(len+1);
    if(validateString == NULL){
      _ortc_exception(context, "malloc() failed in ortc parese message");
      return;
    }
    snprintf(validateString, len, "\"validate;%s;%s;%s;%s;%s;\"", context->appKey, context->authToken, context->announcementSubChannel, context->sessionId, context->metadata);
    _ortc_send_command(context, validateString);
  }
}
