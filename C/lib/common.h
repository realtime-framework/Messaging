#ifndef libortc_h__common
#define libortc_h__common

#include "libortc.h"
#include <stdio.h>
#include <stdlib.h>

typedef struct ortc_RestString{
  char *ptr;
  size_t len;
} ortc_RestString;

void _ortc_exception(ortc_context *context, char *exception);

int _ortc_isValidUrl(ortc_context *context, char*);
int _ortc_isValidInput(ortc_context *context, char*);

int _ortc_initRestString(ortc_RestString *s);
size_t _ortc_writeRestString(void *ptr, size_t size, size_t nmemb, ortc_RestString *s);

char* _ortc_remove(char* s, char *remove);
char* _ortc_replace(char *s, char *old, char *newStr);
char* _ortc_get_from_regmatch(char* str, regmatch_t match);
char* _ortc_prepareConnectionPath();
void _ortc_random_string(char * string, size_t length);

#endif  // libortc_h__common
