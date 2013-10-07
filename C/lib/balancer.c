#include "balancer.h"
#include "common.h"

int _ortc_getBalancer(char* url, char** response){
  CURL *curl;  
  CURLcode res;
  long httpCode;
  char *temp, *cluster;
  ortc_RestString *s = (ortc_RestString *)malloc(sizeof(ortc_RestString));
  
  if(s==NULL){
    *response = strdup("malloc() failed!");
    return -4;
  }

  curl = curl_easy_init();
  if(!curl){
    *response = strdup("Can not init curl!");
    free(s);
    return -1;
  }

  if(_ortc_initRestString(s)<0){
    *response = strdup("malloc() failed!");
    free(s);
    return -4;
  }
  curl_easy_setopt(curl, CURLOPT_URL, url);
  curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, _ortc_writeRestString);
  curl_easy_setopt(curl, CURLOPT_WRITEDATA, s);
  res = curl_easy_perform(curl);  
  if(res != CURLE_OK){
    *response = strdup("Can not connect with balancer!");
    curl_easy_cleanup(curl);
    free(s->ptr);
    free(s);
    return -2;
  }

  curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &httpCode);
  curl_easy_cleanup(curl);
  if(httpCode != 200){
    *response = strdup(s->ptr);
    free(s->ptr);
    free(s);
    return -3;
  }
  temp = _ortc_remove(s->ptr, "var SOCKET_SERVER = \"");
  cluster = _ortc_remove(temp, "\";");
  free(s->ptr);
  free(s);
  free(temp);
  *response = cluster;
  return 0;
}

int _ortc_parseUrl(char* url, char** host, int* port, int* useSSL){
	char* temp, *sPort;
  if(url[0]=='h' && url[1]=='t' && url[2]=='t' && url[3]=='p' && url[4]==':' && url[5]=='/' && url[6]=='/') { //url starts with http://
    int len = strlen(url);
    *useSSL = 0;
    *port = 80;
    temp = (char*)malloc(len - 7 + 1);
    if(temp == NULL){
      return -1;
    }
    memcpy(temp, &url[7], len - 7);    
    temp[len - 7] = '\0';
    *host = temp;
    return 0;
  }
  
  if(url[0]=='h' && url[1]=='t' && url[2]=='t' && url[3]=='p' && url[4]=='s' && url[5]==':' && url[6]=='/' && url[7]=='/') { //url starts with https://
    int len = strlen(url);
    int idxOfColon = -1;
    int i = 8;
    *useSSL = 2; 
    for(i; i < len; i++){
      if(url[i]==':'){
	idxOfColon = i;
      }
    }
    if(idxOfColon == -1){
      fprintf(stderr, "wrong url (no port defined)");
      return -1;
    }
    temp = (char*)malloc(idxOfColon - 8 + 1);        
    if(temp == NULL){
      return -1;
    }
    memcpy(temp, &url[8], idxOfColon - 8);
    temp[idxOfColon - 8] = '\0';
    *host = temp;

    sPort = (char*)malloc(len - idxOfColon);
    if(sPort == NULL){
      free(temp);
      return -1;
    }
    memcpy(sPort, &url[idxOfColon+1], len - idxOfColon);
    sPort[len - idxOfColon -1] = '\0';
    *port = atoi(sPort);
    free(sPort);
    *useSSL = 2;    
    return 0;
  }
  return -1;
}
