#include "authentication.h"
#include "common.h"
#include "balancer.h"

void *_ortc_saveAuthentication(void *ptr){
  ortc_authenticationParams *p = (ortc_authenticationParams*)ptr;
  char *response, *url, *appKey;

  if(p->isExtended){
    if(p->isCluster){
      if(_ortc_getBalancer(p->url, &url)<0){
	p->callback(p->context, url, NULL);
	free(url);
	url = NULL;
      }
    } else {
      url = p->url;
    }
    appKey = p->appKey;    
  } else {
    url = p->context->server;
    appKey = p->context->appKey;
  }
  if(url){
    int ret = _ortc_saveAuthRest(url, p->authToken, p->isPrivate, appKey, p->ttl, p->privateKey, p->permissions, p->sizeOfChannelPermissions, &response);
    switch(ret){
    case 1:
      p->callback(p->context, NULL, response);
      break;
    default:
      p->callback(p->context, response, NULL);
    }
    free(response);
  }
  free(p);
  pthread_detach(pthread_self());
  return 0;
}

int _ortc_saveAuthRest(char* url, char* authToken, int isPrivate, char* appKey, int ttl, char* prvKey, ortc_channelPermissions *permissions, int sizeOfChannelPermissions, char** response) {
  int i;
  char body[2048], aUrl[128];
  char *temp;
  CURL *curl;
  long httpCode = 0;
  CURLcode res;
  ortc_RestString *s = (ortc_RestString *)malloc(sizeof(ortc_RestString));
  
  if(s==NULL){
    *response = strdup("malloc() failed!");
    return -3;
  }

  snprintf(body, sizeof body, "AT=%s&AK=%s&PK=%s&TTL=%d&PVT=%d&TP=%d",
	   authToken, appKey, prvKey,
	   ttl, isPrivate, sizeOfChannelPermissions);
  for(i=0; i< sizeOfChannelPermissions; i++){
    temp = (char*)malloc (1 + strlen(body));
    if(temp){
      strcpy(temp, body);
      snprintf(body, sizeof body, "%s&%s=%s", temp, permissions[i].channel, permissions[i].permission);	
    } else {
      *response = strdup("malloc failure!");
      free(s);
      return -3;
    }
    free(temp);
  }

  //prepare url (placed in aUrl)
  if(url[strlen(url)-1] == '/'){
    snprintf(aUrl, sizeof aUrl, "%sauthenticate", url);

  } else {
    snprintf(aUrl, sizeof aUrl, "%s/authenticate", url);
  }
  if(_ortc_initRestString(s)<0){
    *response = strdup("malloc() failed!");
    free(s);
    return -4;
  }


  curl = curl_easy_init();
  if(curl) {

    curl_easy_setopt(curl, CURLOPT_URL, aUrl);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, body);
    //curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, authenticationWriteFunc);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, _ortc_writeRestString);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, s);
    res = curl_easy_perform(curl);
    if(res == CURLE_OK){
      curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &httpCode);
      curl_easy_cleanup(curl);
      *response = strdup(s->ptr);
      free(s->ptr);
      free(s);
      if(httpCode == 201) {
	return 1;
      } else {
	return 0;
      }
    } else {
      *response = strdup("Can not connect with balancer!");
      free(s->ptr);
      free(s);
      return -1;
    }
    
  }
  *response = strdup("Can not init curl!");
  free(s);
  return -2;
}
