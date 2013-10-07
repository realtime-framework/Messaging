#ifndef libortc_h__balancer
#define libortc_h__balancer

#include <curl/curl.h>
#include <string.h>
#include <stdlib.h>

int _ortc_getBalancer(char* url, char** response);
int _ortc_parseUrl(char* url, char **host, int *port, int *useSSL);
//char* _ortc_resolveCluster(char* url, int isCluster);
#endif  // libortc_h__balancer
