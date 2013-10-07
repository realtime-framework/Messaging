#ifndef libortc_h__channel
#define libortc_h__channel

#include "libortc.h"
#include <stdio.h>
#include <stdlib.h>

void _ortc_save_permissions(ortc_context *context, char *permissions);
void _ortc_subscribeOnReconnected(ortc_context *context);
void _ortc_subscribe(ortc_context* context, char* channel, int subscribeOnReconnected, int toBeSaved, void (*onMessage)(ortc_context*, char*, char*));
void _ortc_unsubscribe(ortc_context* context, char* channel);
char* _ortc_get_channel_permission(ortc_context *context, char* channel);
int _ortc_is_subscribing(ortc_context *context, char* channel);

#endif  // libortc_h__channel
