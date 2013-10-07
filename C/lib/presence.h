#ifndef libortc_h__presence
#define libortc_h__presence

#include <curl/curl.h>
#include <string.h>
#include <stdlib.h>

#include "libortc.h"



typedef struct{
  ortc_context *context;
  char *privateKey;
  char *channel;
  int metadata;
  int isCluster;
  int isExtended;
  char *url;
  char *appKey;
  char *authToken;
  void (*callbackCmd)(ortc_context*, char*, char*, char*);
  void (*callbackGet)(ortc_context*, char*, char*, ortc_presenceData*);
} ortc_presenceParams;

void *_ortc_enablePresence(void *ptr);
void *_ortc_disablePresence(void *ptr);
void *_ortc_presence(void *ptr);

int _ortc_enablePresenceRest(char* url, char* applicationKey, char* privateKey, char* channel, int metadata, char **response);
int _ortc_disablePresenceRest(char* url, char* applicationKey, char* privateKey, char* channel, char **response);
int _ortc_presenceRest(char* url, char* applicationKey, char* authenticationToken, char* channel, char **response);
ortc_presenceData* _ortc_parsePresence(char *p);
void _ortc_freePresence(ortc_presenceData *p);

#endif //libortc_h__presence
