/** \mainpage
* ORTC API C
*
* The ORTC (Open Real-Time Connectivity) was developed to add a layer of abstraction to real-time full-duplex web communications platforms by making real-time web applications independent of those platforms.\n
* ORTC provides a standard software API (Application Programming Interface) for sending and receiving data in real-time over the web

* \section Example
* Simple example of using ORTC API C:
\code
#include <stdio.h>
#include "libortc.h"

#if defined(WIN32) || defined(_WIN32) || defined(__WIN32) && !defined(__CYGWIN__)
#include "Windows.h"
#endif

#define ORTC_CLUSTER "http://ortc-developers.realtime.co/server/2.1"
#define ORTC_APP_KEY "your_application_key"
#define ORTC_AUTH_TOKEN "your_authentication_token"

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

*	\endcode
*/

#ifndef libortc_h__
#define libortc_h__

#if _MSC_VER
#define _CRT_SECURE_NO_WARNINGS
#pragma warning(disable : 4996)
#pragma warning(disable : 4129)
#define snprintf _snprintf
#define strdup _strdup
#endif  

#define ORTC_SNDBUF_SIZE 64000
#define ORTC_MAX_MESSAGE_SIZE 800
#define ORTC_HEARTBEAT_TIMEOUT 30
#define ORTC_RECONNECT_INTERVAL 5
#define ORTC_CONNECTION_METADATA_MAX_SIZE 256
#define ORTC_CHANNEL_MAX_SIZE 100

#if __APPLE__
#define ORTC_OPERATION_PATTERN "^a\\[\"\{\\\\\"op\\\\\":\\\\\"\\([^\"]*\\)\\\\\",\\(.*\\)\}\"\\]$"
#define ORTC_PERMISSIONS_PATTERN "^\\\\\"up\\\\\":\\{1\\}\\(.*\\),\\\\\"set\\\\\":\\(.*\\)$"
#define ORTC_CHANNEL_PATTERN "^\\\\\"ch\\\\\":\\\\\"\\(.*\\)\\\\\"$"
#define ORTC_MESSAGE_PATTERN "^a\\[\"\{\\\\\"ch\\\\\":\\\\\"\\(.*\\)\\\\\",\\\\\"m\\\\\":\\\\\"\\(.*\\)\\\\\"\}\"\\]$"
#define ORTC_MULTIPART_PATTERN "^\\(.[^_]*\\)_\\(.[^_]*\\)-\\(.[^_]*\\)_\\(.*\\)$"
#define ORTC_EXCEPTION_PATTERN "ex\\\\\":\\\\\"\\(.*\\)\\\\\"\}$"
#define ORTC_VALID_URL_PATTERN "^http\\(s\\)*://\\([a-zA-Z0-9./:-]*\\)$"
#define ORTC_VALID_INPUT_PATTERN "^\\([a-zA-Z0-9:._/-]*\\)$"
#else
#define ORTC_OPERATION_PATTERN "^a\\[\"\{\\\\\"op\\\\\":\\\\\"\\([^\"]\\+\\)\\\\\",\\(.*\\)\\}\"\\]$"
#define ORTC_PERMISSIONS_PATTERN "^\\\\\"up\\\\\":\\{1\\}\\(.*\\),\\\\\"set\\\\\":\\(.*\\)$"
#define ORTC_CHANNEL_PATTERN "^\\\\\"ch\\\\\":\\\\\"\\(.*\\)\\\\\"$"
#define ORTC_MESSAGE_PATTERN "^a\\?\\[\"\{\\\\\"ch\\\\\":\\\\\"\\(.*\\)\\\\\",\\\\\"m\\\\\":\\\\\"\\(.*\\)\\\\\"\\}\"\\]$"
#define ORTC_MULTIPART_PATTERN "^\\(.[^_]*\\)_\\(.[^_]*\\)-\\(.[^_]*\\)_\\(.*\\)$"
#define ORTC_EXCEPTION_PATTERN "ex\\\\\":\\\\\"\\(.*\\)\\\\\"\\}$"
#define ORTC_VALID_URL_PATTERN "^\\(https\\|http\\)://\\([a-zA-Z0-9./:-]\\+\\)$"
#define ORTC_VALID_INPUT_PATTERN "^\\([a-zA-Z0-9:._/-]*\\)$"
#endif
 
#if __APPLE__
#include <stddef.h>
#endif

#include <pthread.h>
#include <regex.h>

#include "dlist.h"



typedef struct ortc_context {
  char* appKey;
  char* authToken;
  char* metadata;
  char* announcementSubChannel;
  char sessionId[17];
  char* cluster;
  char* url;
  char* server;
  struct libwebsocket_context *lws_context;
  struct libwebsocket *wsi;
  char* host;
  int port;
  int useSSL;
  regex_t reOperation;
  regex_t rePermissions;
  regex_t reChannel;
  regex_t reMessage;
  regex_t reMultipart;
  regex_t reException;
  regex_t reValidUrl;
  regex_t reValidInput;
  pthread_t connectionThread;
  pthread_t heartbeatThread;
  pthread_t reconnectingThread;
  pthread_t throttleThread;
  int connection_loop_active;
  int reconnecting_loop_active;
  int heartbeat_loop_active;
  int heartbeat_counter;
  ortc_dlist *multiparts;
  ortc_dlist *channels;
  ortc_dlist *permissions;
  ortc_dlist *messagesToSend;
  ortc_dlist *ortcCommands;
  void (*onConnected)(struct ortc_context*);
  void (*onDisconnected)(struct ortc_context*);
  void (*onSubscribed)(struct ortc_context*, char*);
  void (*onUnsubscribed)(struct ortc_context*, char*);
  void (*onException)(struct ortc_context*, char*);
  void (*onReconnecting)(struct ortc_context*);
  void (*onReconnected)(struct ortc_context*);
  int isConnected;
  int isConnecting;  
  int isDisconnecting;
  int isReconnecting;
  int throttleCounter;
} ortc_context;

/**
 * @brief Metadata Record Structure
 *
 * Structure containing presence information for single metadata record. Indicates the number of clients using the same metadata.
 */
typedef struct {
  char* metadata; /**< null-terminated metadata string*/
  int count; /**< metadata repetition counter*/
} ortc_metadataRecord;

/**
 * @brief Presence Data Structure
 *
 * Structure containing presence information for specific channel. 
 */
typedef struct {
  int subscriptions; /**< total number of subscriptions*/
  ortc_metadataRecord *records; /**< pointer to array of ortc_metadataRecord*/
  int recordsCount; /**< size of records array*/
} ortc_presenceData;

/**
 * @brief Channel Permission Structure
 *
 * Structure containing permission for specific channel. Permissions are: read, write and presence.
 */
typedef struct{
  char* channel; /**< null-terminated channel name string*/
  char* permission; /**< null-terminated permission string (combination of characters: 'r', 'w' and 'p')*/
} ortc_channelPermissions;

/**
* Creates an ortc_context\n
* Creating an ortc_context is the first thing that need to be done. All methods requires the first parameter to be pointer to ortc_context structure. When the ortc_context is no longer needed, please remember to free it with ortc_free_context() method to prevent memory leaks.
* @return pointer to initialized ortc_context structure
*/
extern ortc_context* ortc_create_context(void);

/**
* Free all resources used by ortc_context.
* @param context - a pointer to ortc_context structure
*/
extern void ortc_free_context(ortc_context* context);

/**
* Sets a cluster url for ortc connection\n
* You have to call this method or ortc_set_url() before calling the ortc_connect() method.
* @param context pointer to ortc_context structure
* @param cluster null-terminated string containing url address
*/
extern void ortc_set_cluster(ortc_context* context, char* cluster);

/**
* Gets a cluster url for ortc connection\n
* @param context pointer to ortc_context structure
* @return null-terminated string containing url address
*/
extern char* ortc_get_cluster(ortc_context* context);

/**
* Sets a server url for ortc connection\n
* You have to call this method or ortc_set_cluster() before calling the ortc_connect() method.
* @param context pointer to ortc_context structure
* @param url null-terminated string containing url address
*/
extern void ortc_set_url(ortc_context* context, char* url);

/**
* Gets a server url for ortc connection.
* @param context pointer to ortc_context structure
* @return null-terminated string containing url address
*/
extern char* ortc_get_url(ortc_context* context);

/**
* Sets a connection metadata.
* @param context pointer to ortc_context structure
* @param connection_metadata null-terminated string containing connection metadata
*/
extern void ortc_set_connection_metadata(ortc_context* context, char* connection_metadata);

/**
* Gets a connection metadata.
* @param context pointer to ortc_context structure
* @return null-terminated string containing connection metadata
*/
extern char* ortc_get_connection_metadata(ortc_context* context);

/**
* Sets an announcement subchannel.
* @param context pointer to ortc_context structure
* @param announcementSubChannel null-terminated string containing announcement subchannel
*/
extern void ortc_set_announcementSubChannel(ortc_context* context, char* announcementSubChannel);

/**
* Gets an announcement subchannel.
* @param context pointer to ortc_context structure
* @return null-terminated string containing announcement subchannel
*/
extern char* ortc_get_announcementSubChannel(ortc_context* context);

/**
* Gets a sessionId.
* @param context pointer to ortc_context structure
* @return null-terminated string containing sessionId
*/
extern char* ortc_get_sessionId(ortc_context* context);

/**
* Indicates whether connection is established in given context.
* @param context pointer to ortc_context structure
* @return 1 when connection is established otherwise 0
*/
extern int ortc_is_connected(ortc_context* context);

/**
* Indicates whether subscription is valid to the supplied channel in given context.
* @param context pointer to ortc_context structure
* @param channel null-terminated string containing the channel name
* @return 1 when subscription to the supplied channel is valid otherwise 0
*/
extern int ortc_is_subscribed(ortc_context* context, char* channel);

/**
* Connects to ORTC service using the supplied application key and authentication token.
* @param context pointer to ortc_context structure
* @param applicationKey null-terminated string containing the application key
* @param authenticationToken null-terminated string containing the authentication token
*/
extern void ortc_connect(ortc_context* context, char* applicationKey, char* authenticationToken);

/**
* Disconnects from ORTC service for given context.
* @param context pointer to ortc_context structure
*/
extern void ortc_disconnect(ortc_context* context);

/**
* Subscribes to the supplied channel to receive messages sent to it.
* @param context pointer to ortc_context structure
* @param channel null-terminated string containing the channel name
* @param subscribeOnReconnected 1 - Indicates whether subscription to the channel should be restated when reconnected (if it was previously subscribed when connected).
* @param onMessage The callback called when a message arrives at the channel.
*/
extern void ortc_subscribe(ortc_context* context, char *channel,
	int subscribeOnReconnected, void (*onMessage)(ortc_context *, char *, char *));

/**
* Unsubscribes from the supplied channel to stop receiving messages sent to it.
* @param context pointer to ortc_context structure
* @param channel null-terminated string containing the channel name
*/
extern void ortc_unsubscribe(ortc_context* context, char* channel);

/**
* Sends the supplied message to the supplied channel.
* @param context pointer to ortc_context structure
* @param channel null-terminated string containing the channel name
* @param message null-terminated string containing the message
*/
extern void ortc_send(ortc_context* context, char *channel, char *message);

/**
* Sets the callback which occurs when the connection is established.
* @param context pointer to ortc_context structure
* @param onConnected method to be called when the connection is established
*/
extern void ortc_set_onConnected(ortc_context* context, void (*onConnected)(ortc_context*));

/**
* Sets the callback which occurs when the connection is closed.
* @param context pointer to ortc_context structure
* @param onDisconnected method to be called when the connection is closed
*/
extern void ortc_set_onDisconnected(ortc_context* context, void (*onDisconnected)(ortc_context*));

/**
* Sets the callback which occurs when the connection restates.
* @param context pointer to ortc_context structure
* @param onReconnected method to be called when the connection restates
*/
extern void ortc_set_onReconnected(ortc_context* context, void (*onReconnected)(ortc_context*));

/**
* Sets the callback which occurs when the connection attempts to restate.
* @param context pointer to ortc_context structure
* @param onReconnecting method to be called when the connection attempts to restate
*/
extern void ortc_set_onReconnecting(ortc_context* context, void (*onReconnecting)(ortc_context*));

/**
* Sets the callback which occurs when there is an exception.
* @param context pointer to ortc_context structure
* @param onException method to be called when there is an exception
*/
extern void ortc_set_onException(ortc_context* context, void (*onException)(ortc_context*, char*));

/**
* Sets the callback which occurs when subscription to the channel was successful.
* @param context pointer to ortc_context structure
* @param onSubscribed method to be called when subscription to the channel is successful
*/
extern void ortc_set_onSubscribed(ortc_context* context, void (*onSubscribed)(ortc_context*, char*));

/**
* Sets the callback which occurs when unsubscription from the channel was successful.
* @param context pointer to ortc_context structure
* @param onUnsubscribed method to be called when unsubscription from the channel is successful
*/
extern void ortc_set_onUnsubscribed(ortc_context* context, void (*onUnsubscribed)(ortc_context*, char*));

/**
* Enables presence for the specified channel with first 100 unique metadata if true.\n
* <b>Note:</b> This method will send your Private Key over the Internet. Make sure to use secure connection.
* @param context pointer to ortc_context structure
* @param privateKey null-terminated string containing private key provided when the ORTC service is purchased
* @param channel null-terminated string containing channel name
* @param metadata defines if to collect first 100 unique metadata (1 - yes, 0 - no)
* @param callback the callback with channel, error and result parameters
*/
extern void ortc_enable_presence(ortc_context* context, char* privateKey, 
	char* channel, int metadata, void (*callback)(ortc_context*, char*, char*, char*));

/**
* Enables presence for the specified channel with first 100 unique metadata if true.\n
* This method does not require previous connection.\n
* <b>Note:</b> This method will send your Private Key over the Internet. Make sure to use secure connection.
* @param context pointer to ortc_context structure
* @param url null-terminated string containing ORTC server URL
* @param isCluster indicates whether the ORTC server is in a cluster (1 - yes, 0 - no)
* @param appKey null-terminated string containing the application key
* @param privateKey null-terminated string containing private key provided when the ORTC service is purchased
* @param channel null-terminated string containing channel name
* @param metadata defines if to collect first 100 unique metadata (1 - yes, 0 - no)
* @param callback the callback with channel, error and result parameters
*/
extern void ortc_enable_presence_ex(ortc_context* context, char* url, int isCluster,
	char* appKey, char* privateKey, char* channel, int metadata,
	void (*callback)(ortc_context*, char*, char*, char*));

/**
* Disables presence for the specified channel.\n
* <b>Note:</b> This method will send your Private Key over the Internet. Make sure to use secure connection.
* @param context pointer to ortc_context structure
* @param privateKey null-terminated string containing private key provided when the ORTC service is purchased
* @param channel null-terminated string containing channel name
* @param callback the callback with channel, error and result parameters
*/
extern void ortc_disable_presence(ortc_context* context, char* privateKey, 
	char* channel, void (*callback)(ortc_context*, char*, char*, char*));

/**
* Disables presence for the specified channel.\n
* This method does not require previous connection.\n
* <b>Note:</b> This method will send your Private Key over the Internet. Make sure to use secure connection.
* @param context pointer to ortc_context structure
* @param url null-terminated string containing ORTC server URL
* @param isCluster indicates whether the ORTC server is in a cluster (1 - yes, 0 - no)
* @param appKey null-terminated string containing the application key
* @param privateKey null-terminated string containing private key provided when the ORTC service is purchased
* @param channel null-terminated string containing channel name
* @param callback the callback with channel, error and result parameters
*/
extern void ortc_disable_presence_ex(ortc_context* context, char* url, int isCluster,
	char* appKey, char* privateKey, char* channel, 
	void (*callback)(ortc_context*, char*, char*, char*));

/**
* Gets a presence data indicating the subscriptions number in the specified channel and if active the first 100 unique metadata.
* @param context pointer to ortc_context structure
* @param channel null-terminated string containing channel name
* @param callback the callback with channel, error and result (ortc_presenceData) parameters
*/
extern void ortc_presence(ortc_context* context, char* channel, 
	void (*callback)(ortc_context*, char*, char*, ortc_presenceData*));

/**
* Gets a presence data indicating the subscriptions number in the specified channel and if active the first 100 unique metadata.\n
* This method does not require previous connection.
* @param context pointer to ortc_context structure
* @param url null-terminated string containing ORTC server URL
* @param isCluster indicates whether the ORTC server is in a cluster (1 - yes, 0 - no)
* @param appKey null-terminated string containing the application key
* @param authToken null-terminated string containing the authentication token
* @param channel null-terminated string containing channel name
* @param callback the callback with channel, error and result (ortc_presenceData) parameters
*/
extern void ortc_presence_ex(ortc_context* context, char* url, 
	int isCluster, char* appKey, char* authToken, char* channel, 
	void (*callback)(ortc_context*, char*, char*, ortc_presenceData*));

/**
* Saves the channel and its permissions for the supplied application key and authentication token.\n
* <b>Note:</b> This method will send your Private Key over the Internet. Make sure to use secure connection.
* @param context pointer to ortc_context structure
* @param authToken null-terminated string containing the authentication token
* @param isPrivate indicates whether the authentication token is private (1 - yes, 0 - no)
* @param ttl the authentication token time to live (TTL), in other words, the allowed activity time (in seconds)
* @param privateKey null-terminated string containing private key provided when the ORTC service is purchased
* @param permissions pointer to array of structures (ortc_channelPermissions) containing channels and their permissions (read, write or presence)
* @param sizeOfChannelPermissions size of permissions array
* @param callback the callback with channel, error and result (ortc_presenceData) parameters
*/
extern void ortc_save_authentication(ortc_context *context,
	char *authToken, int isPrivate, int ttl, char *privateKey,
	ortc_channelPermissions *permissions, int sizeOfChannelPermissions,
	void (*callback)(ortc_context*, char*, char*));

/**
* Saves the channel and its permissions for the supplied application key and authentication token.\n
* This method does not require previous connection.\n
* <b>Note:</b> This method will send your Private Key over the Internet. Make sure to use secure connection.
* @param context pointer to ortc_context structure
* @param url null-terminated string containing ORTC server URL
* @param isCluster indicates whether the ORTC server is in a cluster (1 - yes, 0 - no)
* @param authToken null-terminated string containing the authentication token
* @param isPrivate indicates whether the authentication token is private (1 - yes, 0 - no)
* @param appKey null-terminated string containing the application key
* @param ttl the authentication token time to live (TTL), in other words, the allowed activity time (in seconds)
* @param privateKey null-terminated string containing private key provided when the ORTC service is purchased
* @param permissions pointer to array of structures (ortc_channelPermissions) containing channels and their permissions (read, write or presence)
* @param sizeOfChannelPermissions size of permissions array
* @param callback the callback with channel, error and result (ortc_presenceData) parameters
*/
extern void ortc_save_authentication_ex(ortc_context *context, char* url, 
	int isCluster, char* authToken, int isPrivate, char* appKey,
	int ttl, char *privateKey, ortc_channelPermissions *permissions,
	int sizeOfChannelPermissions, void (*callback)(ortc_context*, char*, char*));


#endif  // libortc_h__
