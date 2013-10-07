#include "common.h"
#include <string.h>

void _ortc_exception(ortc_context *context, char *exception){
  if(context->onException)
    context->onException(context, exception);
}

int _ortc_isValidUrl(ortc_context *context, char *url){    
  size_t     nmatch = 3;
  regmatch_t pmatch[3];
  if (0 == regexec(&context->reValidUrl, url, nmatch, pmatch, 0)) { 
    return 1;
  }
  return 0;
}

int _ortc_isValidInput(ortc_context *context, char *input){
  size_t     nmatch = 3;
  regmatch_t pmatch[3];
  if (0 == regexec(&context->reValidInput, input, nmatch, pmatch, 0)) { 
    return 1;
  }
  return 0;
}

int _ortc_initRestString(ortc_RestString *t) {
  t->len = 0;
  t->ptr = malloc(t->len+1);
  if (t->ptr == NULL) {
    return -1;
  }
  t->ptr[0] = '\0';
  return 0;
}

size_t _ortc_writeRestString(void *ptr, size_t size, size_t nmemb, ortc_RestString *s){
  size_t new_len = s->len + size*nmemb;
  s->ptr = realloc(s->ptr, new_len+1);
  if (s->ptr == NULL) {
    fprintf(stderr, "realloc() failed\n");
    exit(EXIT_FAILURE);
  }
  memcpy(s->ptr+s->len, ptr, size*nmemb);
  s->ptr[new_len] = '\0';
  s->len = new_len;

  return size*nmemb;
}

char* _ortc_replace(char *s, char *old, char *newStr){
  char *ret;
  int i, count = 0;
  size_t newlen = strlen(newStr);
  size_t oldlen = strlen(old);

  for (i = 0; s[i] != '\0'; i++) {
    if (strstr(&s[i], old) == &s[i]) {
      count++;
      i += oldlen - 1;
    }
  }

  ret = (char*)malloc(i + count * (newlen - oldlen) + 1);
  if (ret == NULL){
    fprintf(stderr, "malloc() failed in ortc replace\n");
    exit(EXIT_FAILURE);
  }

  i = 0;
  while (*s) {
    if (strstr(s, old) == s) {
      strcpy(&ret[i], newStr);
      i += newlen;
      s += oldlen;
    } else
      ret[i++] = *s++;
  }
  ret[i] = '\0';
  
  return ret;
}

char* _ortc_remove(char* s, char *remove){
  char *ret;
  int i, count = 0;
  size_t removelen = strlen(remove);

  for (i = 0; s[i] != '\0'; i++) {
    if (strstr(&s[i], remove) == &s[i]) {
      count++;
      i += removelen - 1;
    }
  }
  ret = (char*)malloc(i - count * removelen + 1);
  if (ret == NULL){
    fprintf(stderr, "malloc() failed in ortc remove\n");
    exit(EXIT_FAILURE);
  }

  i = 0;
  while (*s) {
    if (strstr(s, remove) == s) {
      s += removelen;
    } else
      ret[i++] = *s++;
  }
  ret[i] = '\0';
  
  return ret;
}

char* _ortc_get_from_regmatch(char* str, regmatch_t match){
  int len = match.rm_eo - match.rm_so;
  char* ret = (char*)malloc(len + 1);

  if(ret == NULL){
    fprintf(stderr, "malloc() failed in ortc get from regmatch for string: %s\n", str);
    exit(EXIT_FAILURE);
  }
  memcpy(ret, &str[match.rm_so], len);
  ret[len] = '\0';
  return ret;
}

char* _ortc_prepareConnectionPath(){
  int r;
  char *ret;
  char path[33], s[8];

  srand((unsigned int)time(NULL));
  r = rand() % 1000;
  _ortc_random_string(s, 8);
    snprintf(path, sizeof path, "/broadcast/%d/%s/websocket", r, s);
  ret = (char*)malloc(strlen(path)+1);
  memcpy(ret, path, strlen(path));
  ret[strlen(path)] = '\0';
  return ret;
}

void _ortc_random_string(char * string, size_t length){
  int i, num_chars, r;

  num_chars = length - 1;
  srand((unsigned int) time(0));  
  //ASCII characters: 48-57, 65-90, 97-122
  for (i = 0; i < num_chars; ++i){
    r = rand() % 59;
    if(r < 10) {
      string[i] = r + 48; //digits
    } else if(r < 34) {
      string[i] = r + 55; //65 - 10
    } else {
      string[i] = r + 63; //97 -34
    }
  } 
  string[num_chars] = '\0';  
}
