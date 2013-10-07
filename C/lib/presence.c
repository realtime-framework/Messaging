#include "presence.h"
#include "common.h"
#include "balancer.h"

void _ortc_call_presence_callback(ortc_context* context, int restCode, char* channel, char* response, void (*callback)(ortc_context*, char*, char*, char*)){
switch(restCode){
 case 1:
   callback(context, channel, NULL, response);
   free(response);
   break;
 case 0:
   callback(context, channel, response, NULL);
   free(response);
   break;
 case -1:
   callback(context, channel, "Can not connect to server!", NULL);
   break;
 case -2:
   callback(context, channel, "Can not init curl!", NULL);
   break;
 case -3:
   callback(context, channel, "Malloc() failed!", NULL);
   break;
  }
}


void *_ortc_enablePresence(void *ptr){
  ortc_presenceParams *p = (ortc_presenceParams*)ptr;
  char *response, *url, *appKey;

  if(p->isExtended){
    if(p->isCluster){
      if(_ortc_getBalancer(p->url, &url)<0){
	p->callbackCmd(p->context, p->channel, url, NULL);
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
    int ret = _ortc_enablePresenceRest(url, appKey, p->privateKey, p->channel, p->metadata, &response);
    _ortc_call_presence_callback(p->context, ret, p->channel, response, p->callbackCmd);
    if(p->isExtended && p->isCluster)
      free(url);
  } 
  free(p);
  pthread_detach(pthread_self());
	return 0;
}

void *_ortc_disablePresence(void *ptr){
  ortc_presenceParams *p = (ortc_presenceParams*)ptr;
  char *response, *url, *appKey;

  if(p->isExtended){
    if(p->isCluster){
      if(_ortc_getBalancer(p->url, &url)<0){
	p->callbackCmd(p->context, p->channel, url, NULL);
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
    int ret = _ortc_disablePresenceRest(url, appKey, p->privateKey, p->channel, &response);
    _ortc_call_presence_callback(p->context, ret, p->channel, response, p->callbackCmd);
    if(p->isExtended && p->isCluster)
      free(url);
  }
  free(p);
  pthread_detach(pthread_self());
  return 0;
}

void *_ortc_presence(void *ptr){
  ortc_presenceParams *p = (ortc_presenceParams*)ptr;
  char *response, *url, *appKey, *authToken;

  if(p->isExtended){
    if(p->isCluster){
      if(_ortc_getBalancer(p->url, &url)<0){
	p->callbackGet(p->context, p->channel, url, NULL);
	free(url);
	url = NULL;
      }
    } else {
      url = p->url;
    }
    appKey = p->appKey;
    authToken = p->authToken;
  } else {
    url = p->context->server;
    appKey = p->context->appKey;
    authToken = p->context->authToken;
  }
  if(url){
    int ret = _ortc_presenceRest(url, appKey, authToken, p->channel, &response);
    if(ret < 1){
      switch(ret){
      case -3:
	p->callbackGet(p->context, p->channel, "malloc() failed!", NULL);
	break;
      case -2:
	p->callbackGet(p->context, p->channel, "Can not init curl!", NULL);
	break;
      case -1:
	p->callbackGet(p->context, p->channel, "Can not connect to server!", NULL);
	break;
      case 0:
	p->callbackGet(p->context, p->channel, response, NULL);
	free(response);
	break;
      }
    } else {
      ortc_presenceData *presence =  _ortc_parsePresence(response);
      if(presence == NULL)
	p->callbackGet(p->context, p->channel, "Error parsing a server response", NULL);
      else {
	p->callbackGet(p->context, p->channel, NULL, presence);
	_ortc_freePresence(presence);
      }
      free(response);
    }    
  }
  free(p);
  pthread_detach(pthread_self());
  return 0;
}

int _ortc_enablePresenceRest(char* url, char* applicationKey, char* privateKey, char* channel, int metadata, char** response){
  char pUrl[256], body[256];
  CURL *curl;
  long httpCode = 0;
  CURLcode res;
  ortc_RestString *s = (ortc_RestString *)malloc(sizeof(ortc_RestString));

  if(s==NULL)
    return -3;
  
  if(url[strlen(url)-1] == '/'){
    snprintf(pUrl, sizeof pUrl, "%spresence/enable/%s/%s", url, applicationKey, channel);
  } else {
    snprintf(pUrl, sizeof pUrl, "%s/presence/enable/%s/%s", url, applicationKey, channel);
  }
  snprintf(body, sizeof body, "privatekey=%s&metadata=%d", privateKey, metadata);


  if(_ortc_initRestString(s)<0){
    free(s);
    return -3;
  }

  curl = curl_easy_init();
  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, pUrl);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, body);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, _ortc_writeRestString);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, s);
    res = curl_easy_perform(curl);
    if(res == CURLE_OK){
      *response = strdup(s->ptr);
      free(s->ptr);
      free(s);
      curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &httpCode);
      curl_easy_cleanup(curl);
      if(httpCode == 200) {
	return 1;
      } else {
	return 0;
      }
    } else {      
      curl_easy_cleanup(curl);
      free(s->ptr);
      free(s);
      return -1;
    }    
  } else {
    free(s);
    return -2;
  }
}

int _ortc_disablePresenceRest(char* url, char* applicationKey, char* privateKey, char* channel, char **response){
  char pUrl[256], body[256];
  CURL *curl;
  long httpCode = 0;
  CURLcode res;
  ortc_RestString *s = (ortc_RestString *)malloc(sizeof(ortc_RestString));

  if(s==NULL)
    return -3;


  if(url[strlen(url)-1] == '/'){
    snprintf(pUrl, sizeof pUrl, "%spresence/disable/%s/%s", url, applicationKey, channel);
  } else {
    snprintf(pUrl, sizeof pUrl, "%s/presence/disable/%s/%s", url, applicationKey, channel);
  }

  snprintf(body, sizeof body, "privatekey=%s", privateKey);

  if(_ortc_initRestString(s)<0){
    free(s);
    return -3;
  }

  curl = curl_easy_init();
  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, pUrl);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, body);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, _ortc_writeRestString);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, s);
    res = curl_easy_perform(curl);
    if(res == CURLE_OK){
      *response = strdup(s->ptr);
      free(s->ptr);
      free(s);
      curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &httpCode);
      curl_easy_cleanup(curl);
      if(httpCode == 200) {
	return 1;
      } else {
	return 0;
      }
    } else {
      curl_easy_cleanup(curl);
      free(s->ptr);
      free(s);
      return -1;
    }    
  } else {
    free(s);
    return -2;
  }
}





int _ortc_getIntFromPresenceString(char* presenceStr, int startIdx, int endIdx){
  int ret;		
  int strlen = endIdx - startIdx + 1;
  char *s = (char*)malloc(strlen);

  if(s==NULL){
    fprintf(stderr, "malloc() failed\n");
    exit(EXIT_FAILURE);
  }
  memcpy(s, presenceStr + startIdx, strlen-1);
  s[strlen-1] = '\0';
  ret  = atoi(s);
  free(s);
  return ret;
}

ortc_presenceData *_ortc_initPresence(){
  ortc_presenceData *p = (ortc_presenceData *)malloc(sizeof(ortc_presenceData));

  if(p==NULL){
    fprintf(stderr, "malloc() failed\n");
    exit(EXIT_FAILURE);
  }
  p->subscriptions = 0;
  p->records = NULL;
  p->recordsCount = 0;
  return p;
}

void _ortc_addPresenceRecord(ortc_presenceData *p, char* metadata, int metadataCount){
  ortc_metadataRecord mr = {metadata, metadataCount};
  void *temp;

  p->recordsCount++;
  temp = realloc(p->records, p->recordsCount * sizeof(ortc_metadataRecord));
  if(temp==NULL){
    fprintf(stderr, "realloc() failed\n");
    exit(EXIT_FAILURE);
  }
  p->records = (ortc_metadataRecord*)temp;
  p->records[p->recordsCount-1] = mr;
}

void _ortc_freePresence(ortc_presenceData *p){
  int m;

  for(m = 0; m < p->recordsCount; m++){
    free(p->records[m].metadata);
  }
  free(p->records);
  free(p);
}

ortc_presenceData* _ortc_parsePresence(char *p){
  unsigned int i;
  unsigned long len = strlen(p);
  int isCM = 0, isEsc = 0, cmStartIdx = 0, subscriptions = 0, count = 0;
  char *currentMetadata = NULL, *cm = NULL, *replaced = NULL;
  ortc_presenceData *pre;

  if(len<19){
    return NULL; //wrong presence string, too short
  }
  if(p[16]!=':'){
    return NULL; //wrong presence string
  }
  for(i = 17; i < len && p[i]!=',' && p[i]!='}'; i++){
  }
  subscriptions = _ortc_getIntFromPresenceString(p, 17, i);
  pre = _ortc_initPresence();
  pre->subscriptions = subscriptions;
  if(p[i]==','){//there is a metadata
    for(i=i+12; i < len; i++){
      if(p[i]=='}' && isCM==0 && isEsc==0){	
	count = _ortc_getIntFromPresenceString(p, cmStartIdx+1, i);
	if(count>0)
	  _ortc_addPresenceRecord(pre, currentMetadata, count);
	break;
      } else if(p[i]=='\\'){
	if(isEsc == 0)
	  isEsc = 1;
	else
	  isEsc = 0;
      } else if(p[i]=='"' && isEsc==0){
	if(isCM==0){
	  isCM = 1;
	  cmStartIdx = i;
	} else {
	  isCM = 0;
	  cm = (char*)malloc(i - cmStartIdx);
	  if(cm==NULL){
	    fprintf(stderr, "malloc() failed\n");
	    exit(EXIT_FAILURE);
	  }
	  memcpy(cm, p + cmStartIdx + 1, i - cmStartIdx - 1);
	  cm[i - cmStartIdx - 1] = '\0';
	  replaced = NULL;
	  replaced = (char*)_ortc_replace(cm, "\\\\", "\\");
	  currentMetadata = NULL;
	  currentMetadata = (char*)_ortc_replace(replaced, "\\\"", "\"");
	  free(cm);
	  free(replaced);
	}
      } else if(p[i]==':' && isCM==0) {
	cmStartIdx = i;
      } else if(p[i]==',' && isCM==0) {
	int count = _ortc_getIntFromPresenceString(p, cmStartIdx+1, i);
	_ortc_addPresenceRecord(pre, currentMetadata, count);
      } else {
	if(isEsc==1)
	  isEsc = 0;
      }
    }
  }
  return pre;
}


int _ortc_presenceRest(char* url, char* applicationKey, char* authenticationToken, char* channel, char **response){
  char pUrl[256];
  CURL *curl;
  long httpCode = 0;
  CURLcode res;
  ortc_RestString *s = (ortc_RestString *)malloc(sizeof(ortc_RestString));

  if(s==NULL)
    return -3;

  if(url[strlen(url)-1] == '/'){
    snprintf(pUrl, sizeof pUrl, "%spresence/%s/%s/%s", url, applicationKey, authenticationToken, channel);
  } else {
    snprintf(pUrl, sizeof pUrl, "%s/presence/%s/%s/%s", url, applicationKey, authenticationToken, channel);
  }

  if(_ortc_initRestString(s)<0){
    free(s);
    return -3;
  }

  curl = curl_easy_init();
  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, pUrl);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, _ortc_writeRestString);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, s);
    res = curl_easy_perform(curl);
    if(res == CURLE_OK){      
      *response = strdup(s->ptr);
      free(s->ptr);
      free(s);
      curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &httpCode);
      curl_easy_cleanup(curl);
      if(httpCode == 200) {
	return 1;
      } else {
	return 0;
      }
    } else {
      curl_easy_cleanup(curl);
      free(s->ptr);
      free(s);
      return -1;
    }    
  } else {
    free(s);
    return -2;
  }
}
