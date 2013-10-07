#include <stdio.h>
#include "libortc.h"

#if defined(WIN32) || defined(_WIN32) || defined(__WIN32) && !defined(__CYGWIN__)
#include "Windows.h"
#endif

#define ORTC_CLUSTER "http://ortc-developers.realtime.co/server/2.1"
#define ORTC_APP_KEY "u0jw13"
#define ORTC_AUTH_TOKEN "anonymous"

int isWaiting;

void onMessage(ortc_context *context, char* channel, char* message){
  printf("::Message (at %s): %s\n", channel, message);
  isWaiting = 0;
}

void onConnected(ortc_context *context){
  printf("::Connected!!!\n");
  ortc_subscribe(context, "yellow", 1, onMessage);
}

void onDisconnected(ortc_context *context){
  printf("::Disconnected!!!\n");
}

void onSubscribed(ortc_context *context, char* channel){
  printf("::Subscribed to: %s\n", channel);
  ortc_send(context, "yellow", "Message from simple.c");
}


int main(void){
  ortc_context *context;

  isWaiting = 1;

  context = ortc_create_context();
  ortc_set_cluster(context, ORTC_CLUSTER);

  ortc_set_onConnected   (context, onConnected);
  ortc_set_onDisconnected(context, onDisconnected);
  ortc_set_onSubscribed  (context, onSubscribed);

  ortc_connect(context, ORTC_APP_KEY, ORTC_AUTH_TOKEN);

  while(isWaiting)
#if defined(WIN32) || defined(_WIN32) || defined(__WIN32) && !defined(__CYGWIN__)
	Sleep(1000);
#else
	sleep(1);
#endif

  ortc_free_context(context);
}
