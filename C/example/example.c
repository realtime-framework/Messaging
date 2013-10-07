#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "libortc.h"

#if defined(WIN32) || defined(_WIN32) || defined(__WIN32) && !defined(__CYGWIN__)
#include "Windows.h"
#endif

#define ORTC_CLUSTER "http://ortc-developers.realtime.co/server/2.1"
#define ORTC_APP_KEY "u0jw13"
#define ORTC_AUTH_TOKEN "dupa"
#define ORTC_PRV_KEY "6aDAL2e7Omb0"
#define DEFAULT_CHANNEL "yellow"


void onConnected(ortc_context *context){
  printf("::Connected!!!\n");
}

void onDisconnected(ortc_context *context){
  printf("::Disconnected!!!\n");
}

void onReconnected(ortc_context *context){
  printf("::Reconnected!!!\n");
}

void onReconnecting(ortc_context *context){
  printf("::Reconnecting!!!\n");
}

void onException(ortc_context *context, char* exception){
  printf("::Exception: %s!!!\n", exception);
}

void onSubscribed(ortc_context *context, char* channel){
  printf("::Subscribed to: %s\n", channel);
}

void onUnsubscribed(ortc_context *context, char* channel){
  printf("::Unubscribed from: %s\n", channel);
}

void onMessage(ortc_context *context, char* channel, char* message){
  printf("::Message (at %s): %s\n", channel, message);
}


void onPresenceCommand(ortc_context *context, char* channel, char* error, char* result){
  printf("::Presence (at %s):\nError: %s\nResult: %s\n", channel, error, result);
}

void onPresence(ortc_context *context, char* channel, char* error, ortc_presenceData* result){
  int i;
  if(error){
    printf("::Error getting presence for channel: %s:\n::Reason: %s\n", channel, error);
  } else {
    printf("::Subscriptions at channel %s: %d\n", channel, result->subscriptions);
    if(result->recordsCount>0){
      printf("::Metadata records:\n");
      for(i = 0; i < result->recordsCount; i++){
	printf(":: - %s (count: %d)\n", result->records[i].metadata, result->records[i].count); 
      }
    }
  }
}

void onAuthentication(ortc_context *context, char* error, char* result){
  if(error)
    printf("Save authentication error: %s\n", error);
  else
    printf("Save authentication result: %s\n", result);
}

void print_help(){
  printf("\n ORTC API C example                                (http://realtime.co)");
  printf("\n q - quit, c - connect, d - disconnect, s - subscribe, u - unscubscribe");
  printf("\n m - send a message, p - get presence, e - get presence ex");
  printf("\n i - is subscribed?, 0 - is connected?, z - get session id");
  printf("\n 1 - enable presence, 3 - enable presence ex, 2 - disable presence");
  printf("\n 2 - disable presence, 4 - disable presence ex, a - save authentication");
  printf("\n 5 - save authentication ex, h - prints this help.\n");
}


int main(void){
  char key = ' ';
  ortc_context *context;
  ortc_channelPermissions chPerm[] = { 
    {"yellow", "rwp"},
    {"blue", "rw"},
    {"black", "w"}
  };

#if _MSC_VER
  SetConsoleOutputCP(65001);
#endif

  context = ortc_create_context();
  ortc_set_cluster(context, ORTC_CLUSTER);
  ortc_set_connection_metadata(context, "api c example metadata");

  ortc_set_onConnected   (context, onConnected);
  ortc_set_onDisconnected(context, onDisconnected);
  ortc_set_onSubscribed  (context, onSubscribed);
  ortc_set_onUnsubscribed(context, onUnsubscribed);
  ortc_set_onException   (context, onException);
  ortc_set_onReconnected (context, onReconnected);
  ortc_set_onReconnecting(context, onReconnecting);

  print_help();
  while(key!='q'){
    key = getchar();
    switch(key) {
    case 'h':
      print_help();
      break;
    case 'c':
      ortc_connect(context, ORTC_APP_KEY, ORTC_AUTH_TOKEN);
      break;
    case 'd':
      ortc_disconnect(context);
      break;
    case 's':
      ortc_subscribe(context, DEFAULT_CHANNEL, 1, onMessage);
      break;
    case 'u':
      ortc_unsubscribe(context, DEFAULT_CHANNEL);
      break;
    case 'm':
      ortc_send(context, DEFAULT_CHANNEL, "api C message");
      break;
    case 'p':
      ortc_presence(context, DEFAULT_CHANNEL, onPresence);
      break;
    case 'e':
      ortc_presence_ex(context, ORTC_CLUSTER, 1, ORTC_APP_KEY, ORTC_AUTH_TOKEN, DEFAULT_CHANNEL, onPresence);
      break;
    case 'i':
      printf("Is subscribed? %s\n", (ortc_is_subscribed(context, DEFAULT_CHANNEL)?"true":"false"));
      break;
    case '1':
      ortc_enable_presence(context, ORTC_PRV_KEY, DEFAULT_CHANNEL, 1, onPresenceCommand);
      break;
    case '0':
      printf("Is connected? %s\n", (ortc_is_connected(context)?"true":"false"));
      break;
    case '2':
      ortc_disable_presence(context, ORTC_PRV_KEY, DEFAULT_CHANNEL, onPresenceCommand);
      break;
    case '3':
      ortc_enable_presence_ex(context, ORTC_CLUSTER, 1, ORTC_APP_KEY, ORTC_PRV_KEY, DEFAULT_CHANNEL, 1, onPresenceCommand);
      break;
    case '4':
      ortc_disable_presence_ex(context, ORTC_CLUSTER, 1, ORTC_APP_KEY, ORTC_PRV_KEY, DEFAULT_CHANNEL, onPresenceCommand);
      break;
    case 'a':
      ortc_save_authentication(context, ORTC_AUTH_TOKEN, 0, 3600, ORTC_PRV_KEY, chPerm, 3, onAuthentication);
      break;
    case '5':
      ortc_save_authentication_ex(context, ORTC_CLUSTER, 1, ORTC_AUTH_TOKEN, 0, ORTC_APP_KEY, 3600, ORTC_PRV_KEY, chPerm, 3, onAuthentication);
      break;
    case 'z':
      printf("Session ID: %s\n", ortc_get_sessionId(context));
      break;
    }
  }
  ortc_free_context(context);
  return 0;
}
