#ifndef libortc_h__authentication
#define libortc_h__authentication

#include <curl/curl.h>
#include <string.h>
#include <stdlib.h>

#include "libortc.h"

typedef struct{
  ortc_context *context;
  char *privateKey;
  int isCluster;
  int isExtended;
  char *url;
  char *appKey;
  char *authToken;
  int isPrivate;
  int ttl;
  ortc_channelPermissions *permissions;
  int sizeOfChannelPermissions;
  void (*callback)(ortc_context*, char*, char*);
} ortc_authenticationParams;

void *_ortc_saveAuthentication(void *ptr);

int _ortc_saveAuthRest(char* url, char* authToken, int isPrivate, char* appKey, int ttl, char* prvKey, ortc_channelPermissions *permissions, int sizeOfChannelPermissions, char** response);


#endif //libortc_h__authentication
