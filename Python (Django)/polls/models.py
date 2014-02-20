import datetime
from django.utils import timezone
from django.db import models

import json
import ortc

# Create your models here.
class Poll(models.Model):
    question = models.CharField(max_length=200)
    pub_date = models.DateTimeField('date published')
    def __str__(self):
        return self.question
    def was_published_recently(self):
        return self.pub_date >= timezone.now() - datetime.timedelta(days=1)
    was_published_recently.admin_order_field = 'pub_date'
    was_published_recently.boolean = True
    was_published_recently.short_description = 'Published recently?'

class Choice(models.Model):
    poll = models.ForeignKey(Poll)
    choice_text = models.CharField(max_length=200)
    votes = models.IntegerField(default=0)
    def __str__(self):
        return self.choice_text

class Messaging:
    def __init__(self, message):
        cluster_url = "http://ortc-developers.realtime.co/server/2.1"
        application_key = "[YOUR APPLICATION KEY HERE]"
        private_key = "[YOUR PRIVATE KEY]"
        authentication_token = "poll_token"
        channel = "poll_" + message["poll"]
        channels_permissions = {}
        channels_permissions[channel] = "w"

        def on_exception(sender, exception):
            print "exception: " + exception

        def on_connected(sender):
            print "connected"
            ortc_client.send(channel, json.dumps(message))

        def on_authenticated(result, error):
            print "authenticated"
            ortc_client.connect(application_key, authentication_token)

        ortc_client = ortc.OrtcClient()
        ortc_client.cluster_url = cluster_url
        ortc_client.connection_metadata = 'pollExample'
        ortc_client.set_on_exception_callback(on_exception)
        ortc_client.set_on_connected_callback(on_connected)
        # ortc_client.set_on_subscribed_callback(on_subscribed)
        
        ortc_client.connect(application_key, authentication_token)

    def send(choice, votes):
        message = {}
        message["poll"] = poll.id
        message["choice"] = choice
        message["votes"] = votes
        if ortc_client.is_connected:
            ortc_client.send(channel, message)

