import httplib
import re
import random
import string
import time
import websocket
import json
import threading

REST_TIMEOUT = 5

class OrtcError(Exception):
    def __init__(self, message):
        self.message = message
    def __str__(self):
        return self.message
    
class Channel(object):
    @property
    def name(self):
        return self._name
    @name.setter
    def name(self, name):
        self._name = name

    @property
    def subscribe_on_reconnecting(self):
        return self._subscribe_on_reconnecting
    @subscribe_on_reconnecting.setter
    def subscribe_on_reconnecting(self, subscribe_on_reconnecting):
        self._subscribe_on_reconnecting = subscribe_on_reconnecting

    @property
    def is_subscribing(self):
        return self._is_subscribing
    @is_subscribing.setter
    def is_subscribing(self, is_subscribing):
        self._is_subscribing = is_subscribing

    @property
    def is_subscribed(self):
        return self._is_subscribed
    @is_subscribed.setter
    def is_subscribed(self, is_subscribed):
        self._is_subscribed = is_subscribed

    @property
    def callback(self):
        return self._callback
    @callback.setter
    def callback(self, callback):
        self._callback = callback

    def __init__(self, name, subscribe_on_reconnecting, callback):
        self._name = name
        self._subscribe_on_reconnecting = subscribe_on_reconnecting
        self._is_subscribing = False
        self._is_subscribed = False
        self._callback = callback


class MultiMessage(object):
    @property
    def total_parts(self):
        return self._total_parts
    @total_parts.setter
    def total_parts(self, total_parts):
        self._total_parts = total_parts

    @property
    def ready_parts(self):
        return self._ready_parts
    @ready_parts.setter
    def ready_parts(self, ready_parts):
        self._ready_parts = ready_parts

    def __init__(self, total_parts):
        self._total_parts = total_parts
        self._ready_parts = 0
        self._parts = [None]*total_parts

    def set_part(self, part_id, part):
        if self._parts[part_id] == None:
            self._ready_parts += 1
        self._parts[part_id] = part

    def is_ready(self):
        return True if self._ready_parts == self._total_parts else False

    def get_all_message(self):
        return ''.join([str(x) for x in self._parts])        

class Private:
    @staticmethod
    def _get_cluster(host, app_key):
        try:
            host += '?appkey='+app_key
            from urlparse import urlparse
            uri = urlparse(host)
            conn = httplib.HTTPConnection(uri.netloc, timeout=REST_TIMEOUT)
            conn.request("GET", uri.path)
            res = conn.getresponse()
            if res.status == 200:
                rbody = re.search('"(.*)"', res.read()).group(0)
                return rbody[1:][:-1] 
        except StandardError:
            return None

    @staticmethod
    def _call_exception_callback(sender, exception):
        if sender.on_exception_callback:
            sender.on_exception_callback(sender, exception)

    @staticmethod
    def _validate_url(url):
        return True if re.compile('^\s*(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?\s*$').match(url) else False

    @staticmethod
    def _validate_input(var):
        return True if re.compile('^[\w\-:\/\.]*$').match(var) else False

    @staticmethod
    def _enum_state(**state):
        return type('Enum state', (), state)

    @staticmethod
    def _remove_slashes(text):
        text = text.replace("\\\\\\\"", '"')
        text = text.replace("\\\\\\\\", '\\')
        text = text.replace("\\\\n", '\n')
        return text

    @staticmethod
    def _check_permission(permissions, channel):
        if permissions == {}:
            return True, ''
        if channel in permissions:
            return True, permissions[channel]
        if ':' in channel:
            if channel[:channel.index(':')]+':*' in permissions:
                return True, permissions[channel[:channel.index(':')]+':*']
        return False, ''

    @staticmethod
    def _rest_post_request(url, body, callback):
        def p_thread():
            try:
                from urlparse import urlparse
                uri = urlparse(url)
                conn = httplib.HTTPSConnection(uri.netloc, timeout=REST_TIMEOUT)
                headers = {}
                headers['Content-Length'] = len(body)
                conn.request("POST", uri.path, None, headers)
                conn.send(body)
                res = conn.getresponse()
                if res.status==200:
                    callback(None, res.read())
                else:
                    callback(str(res.status), None)
            except Exception, e:
                callback(str(e), None)
        t = threading.Thread(target=p_thread)
        t.setDaemon(True)
        t.start()


    @staticmethod
    def _prepare_server(url, is_cluster, app_key, callback):
        server = Private._get_cluster(url, app_key) if is_cluster else url
        if server == None:
            callback('Error getting server from Cluster', None)
            return
        server += '/' if not server[-1] == '/' else ''
        return server

    @staticmethod
    def _prepare_server_internal(url, cluster_url, app_key, callback):
        if app_key == None:
            callback('Please, do connect first', None)
            return False, None
        server = Private._get_cluster(cluster_url, app_key) if not cluster_url == None else url
        if server == None:
            callback('Error getting server from Cluster', None)
            return False, None
        return True, server
