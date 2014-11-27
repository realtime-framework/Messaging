package services;

import config.Config;
import ibt.ortc.api.Ortc;
import ibt.ortc.extensibility.OnConnected;
import ibt.ortc.extensibility.OnException;
import ibt.ortc.extensibility.OnMessage;
import ibt.ortc.extensibility.OrtcClient;
import ibt.ortc.extensibility.OrtcFactory;
import rtmchat.realtime.co.rtmchat.R;
import rtmchat.realtime.co.rtmchat.activities.MessageActivity;
import rtmchat.realtime.co.rtmchat.activities.NotificationActivity;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.support.v4.app.NotificationCompat;
import android.util.Log;

public class MyService extends Service {

	private static final String TAG = "MyService";
	private static OrtcClient client = null;

	@Override
	public void onCreate() {
		Log.i(TAG, "Service onCreate");
			if(client == null){
				try {
					Ortc ortc = new Ortc();

					OrtcFactory factory;
					factory = ortc.loadOrtcFactory("IbtRealtimeSJ");
					client = factory.createClient();
					client.setHeartbeatActive(true);
					Ortc.setOnPushNotification(new OnMessage() {
						@Override
						public void run(OrtcClient sender, final String channel, final String message) {
							Log.i(TAG, String.format("Push notification on channel %s: %s", channel, message));
                            if(!MessageActivity.isInForeground() && !NotificationActivity.isInForeground()) {
                                String parts [] = message.split(":");
                                String user = parts[0].split("_")[parts[0].split("_").length - 1];
                                String msg = parts[1];
                                displayNotification(channel, user,msg);
                            }
						}
					});
					client.setApplicationContext(getApplicationContext());
					client.setGoogleProjectId(Config.PROJECT_ID);
				} catch (Exception e) {
					Log.i(TAG, String.format("ORTC CREATE ERROR: %s", e.toString()));
				}
			}
			if(client != null){
				client.onConnected = new OnConnected() {
					public void run(final OrtcClient sender) {
				        Log.i(TAG, String.format("Connected to: %s", ((OrtcClient) sender).getUrl()));
					}
				};
				client.onException = new OnException() {
					public void run(final OrtcClient sender, Exception ex) {
						Log.i(TAG, String.format("Ortc error: %s", ex.getMessage()));
					}
				};

				if(!client.getIsConnected()){
					client.setClusterUrl(Config.CLUSTERURL);
					client.setConnectionMetadata(Config.METADATA);
					client.connect(Config.APPKEY, Config.TOKEN);
				}
			}
	}


	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		Log.i(TAG, "Service onStartCommand");
		return Service.START_STICKY;
	}

	@Override
	public void onDestroy() {
		Log.i(TAG, "Service onDestroy");

	}

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private void displayNotification(String channel, String user, String message) {
        NotificationManager notificationManager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);

        Intent notificationIntent = new Intent(this, NotificationActivity.class);
        notificationIntent.putExtra("channel", channel);
        notificationIntent.putExtra("message", message);
        notificationIntent.putExtra("user", user);
        notificationIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        Notification notification = new NotificationCompat.Builder(this).setContentTitle(channel).setContentText(message).setSmallIcon(R.drawable.ic_launcher)
                .setContentIntent(pendingIntent).setAutoCancel(true).build();
        notificationManager.notify(9999, notification);
    }
}
