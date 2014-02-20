package ibt.ortcandroidsample;

import ibt.ortc.api.ChannelPermissions;
import ibt.ortc.api.OnDisablePresence;
import ibt.ortc.api.OnEnablePresence;
import ibt.ortc.api.OnPresence;
import ibt.ortc.api.OnRestWebserviceResponse;
import ibt.ortc.api.Ortc;
import ibt.ortc.api.Presence;
import ibt.ortc.extensibility.OnConnected;
import ibt.ortc.extensibility.OnDisconnected;
import ibt.ortc.extensibility.OnException;
import ibt.ortc.extensibility.OnMessage;
import ibt.ortc.extensibility.OnReconnected;
import ibt.ortc.extensibility.OnReconnecting;
import ibt.ortc.extensibility.OnSubscribed;
import ibt.ortc.extensibility.OnUnsubscribed;
import ibt.ortc.extensibility.OrtcClient;
import ibt.ortc.extensibility.OrtcFactory;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import android.app.Activity;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.os.Bundle;
import android.text.format.DateFormat;
import android.text.method.ScrollingMovementMethod;
import android.view.Menu;
import android.view.View;
import android.view.WindowManager;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesUtil;

public class ORTCAndroidSample extends Activity {
	private static final String defaultPrivateKey = "YOUR_PRIVATE_KEY";
	private static final boolean defaultNeedsAuthentication = false;

	private OrtcClient client;
	private int reconnectingTries = 0;

	private final static int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;
	private boolean mIsInForegroundMode;

	@Override
	protected void onPause() {
		super.onPause();
		mIsInForegroundMode = false;
	}

	@Override
	protected void onResume() {
		super.onResume();
		mIsInForegroundMode = true;
	}

	// Some function.
	public boolean isInForeground() {
		return mIsInForegroundMode;
	}

	/**
	 * Check the device to make sure it has the Google Play Services APK. If it
	 * doesn't, display a dialog that allows users to download the APK from the
	 * Google Play Store or enable it in the device's system settings.
	 */
	private boolean checkPlayServices() {
		int resultCode = GooglePlayServicesUtil.isGooglePlayServicesAvailable(this.getBaseContext());
		if (resultCode != ConnectionResult.SUCCESS) {
			if (GooglePlayServicesUtil.isUserRecoverableError(resultCode)) {
				GooglePlayServicesUtil.getErrorDialog(resultCode, (Activity) this.getBaseContext(), PLAY_SERVICES_RESOLUTION_REQUEST).show();
			} else {
				log("The device is not supported!");
			}
			return false;
		}
		return true;
	}

	private void displayNotification(String channel, String message) {
		NotificationManager notificationManager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);

		Intent notificationIntent = new Intent(this, ORTCAndroidSample.class);
		PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0);

		Notification notification = new Notification.Builder(this).setContentTitle(channel).setContentText(message).setSmallIcon(R.drawable.ic_launcher)
				.setContentIntent(pendingIntent).addAction(R.drawable.ic_launcher, "View", pendingIntent).build();
		notificationManager.notify(9999, notification);
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

		getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);

		try {
			Ortc ortc = new Ortc();

			OrtcFactory factory;

			factory = ortc.loadOrtcFactory("IbtRealtimeSJ");

			client = factory.createClient();

			client.setHeartbeatActive(true);

			if (checkPlayServices()) {

				Ortc.setOnPushNotification(new OnMessage() {
					@Override
					public void run(OrtcClient sender, final String channel, final String message) {
						runOnUiThread(new Runnable() {
							public void run() {
								log(String.format("Push notification on channel %s: %s", channel, message));
								if (!mIsInForegroundMode) {
									displayNotification(channel, message);
								}
							}
						});
					}
				});

				client.setApplicationContext(getApplicationContext());
				client.setGoogleProjectId("your_google_project_id");
			}

		} catch (Exception e) {
			log(String.format("ORTC CREATE ERROR: %s", e.toString()));
		}

		if (client != null) {
			try {
				client.onConnected = new OnConnected() {

					public void run(final OrtcClient sender) {
						runOnUiThread(new Runnable() {

							public void run() {
								log(String.format("Connected to: %s", ((OrtcClient) sender).getUrl()));
							}
						});
					}
				};

				client.onDisconnected = new OnDisconnected() {

					public void run(OrtcClient arg0) {
						runOnUiThread(new Runnable() {

							public void run() {
								log("Disconnected");
							}
						});
					}
				};

				client.onSubscribed = new OnSubscribed() {

					public void run(OrtcClient sender, String channel) {
						final String subscribedChannel = channel;
						runOnUiThread(new Runnable() {

							public void run() {
								log(String.format("Subscribed to channel: %s", subscribedChannel));
							}
						});
					}
				};

				client.onUnsubscribed = new OnUnsubscribed() {

					public void run(OrtcClient sender, String channel) {
						final String subscribedChannel = channel;
						runOnUiThread(new Runnable() {

							public void run() {
								log(String.format("Unsubscribed from channel: %s", subscribedChannel));
							}
						});
					}
				};

				client.onException = new OnException() {

					public void run(OrtcClient send, Exception ex) {
						final Exception exception = ex;
						runOnUiThread(new Runnable() {

							public void run() {
								log(String.format("Error: %s", exception.getMessage()));
							}
						});
					}
				};

				client.onReconnected = new OnReconnected() {

					public void run(final OrtcClient sender) {
						runOnUiThread(new Runnable() {

							public void run() {
								reconnectingTries = 0;

								log(String.format("Reconnected to: %s", ((OrtcClient) sender).getUrl()));
							}
						});
					}
				};

				client.onReconnecting = new OnReconnecting() {

					public void run(OrtcClient sender) {
						runOnUiThread(new Runnable() {

							public void run() {
								reconnectingTries++;

								log(String.format("Reconnecting %s...", reconnectingTries));
							}
						});
					}
				};
			} catch (Exception e) {
				log(String.format("ORTC EXCEPTION: %s", e.toString()));
			}
		}
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	@Override
	protected void onStart() {
		super.onStart();
	}

	public void clearClickEventHandler(View v) {
		TextView textViewLog = (TextView) findViewById(R.id.TextViewLog);
		textViewLog.setText("");
		textViewLog.scrollTo(0, 0);
	}

	public void subscribeClickEventHandler(View v) {
		log("Subscribing...");

		EditText editTextChannel = (EditText) findViewById(R.id.EditTextChannel);

		client.subscribeWithNotifications(editTextChannel.getText().toString(), true, new OnMessage() {
			public void run(OrtcClient sender, String channel, String message) {
				final String subscribedChannel = channel;
				final String messageReceived = message;
				runOnUiThread(new Runnable() {
					public void run() {
						log(String.format("Message on channel %s: %s", subscribedChannel, messageReceived));
						if (!mIsInForegroundMode) {
							displayNotification(subscribedChannel, messageReceived);
						}
					}
				});
			}
		});
	}

	public void unsubscribeClickEventHandler(View v) {
		log("Unsubscribing...");

		EditText editTextChannel = (EditText) findViewById(R.id.EditTextChannel);
		client.unsubscribe(editTextChannel.getText().toString());
	}

	public void sendClickEventHandler(View v) {
		EditText editTextMessage = (EditText) findViewById(R.id.EditTextMessage);
		EditText editTextChannel = (EditText) findViewById(R.id.EditTextChannel);

		String channel = editTextChannel.getText().toString();
		String message = editTextMessage.getText().toString();

		log(String.format("Sending %s to %s...", message, channel));

		client.send(channel, message);
	}

	public void connectClickEventHandler(View v) {
		final EditText editTextServer = (EditText) findViewById(R.id.EditTextServer);
		final EditText editTextApplicationKey = (EditText) findViewById(R.id.EditTextApplicationKey);
		final EditText editTextAuthenticationToken = (EditText) findViewById(R.id.EditTextAuthenticationToken);
		final EditText editTextConnectionMetadata = (EditText) findViewById(R.id.EditTextConnectionMetadata);
		final CheckBox checkBoxIsCluster = (CheckBox) findViewById(R.id.CheckBoxIsCluster);

		if (defaultNeedsAuthentication) {
			try {
				TextView textViewLog = (TextView) findViewById(R.id.TextViewLog);
				textViewLog.setMovementMethod(new ScrollingMovementMethod());

				HashMap<String, ChannelPermissions> permissions = new HashMap<String, ChannelPermissions>();

				permissions.put("yellow:*", ChannelPermissions.Write);
				permissions.put("yellow", ChannelPermissions.Write);
				permissions.put("test:*", ChannelPermissions.Write);
				permissions.put("test", ChannelPermissions.Write);

				log("Authenticating...");

				Ortc.saveAuthentication(editTextServer.getText().toString(), checkBoxIsCluster.isChecked(), editTextAuthenticationToken.getText().toString(),
						false, editTextApplicationKey.getText().toString(), 14000, defaultPrivateKey, permissions, new OnRestWebserviceResponse() {

							@Override
							public void run(Exception error, String response) {
								if (error != null) {
									log(String.format("ORTC AUTHENTICATION ERROR: %s", error.toString()));
								} else {
									log("Authentication successfull: " + response);
								}

								if (checkBoxIsCluster.isChecked()) {
									client.setClusterUrl(editTextServer.getText().toString());
								} else {
									client.setUrl(editTextServer.getText().toString());
								}

								client.setConnectionMetadata(editTextConnectionMetadata.getText().toString());

								log("Connecting...");
								client.connect(editTextApplicationKey.getText().toString(), editTextAuthenticationToken.getEditableText().toString());
							}
						});
			} catch (Exception e) {
				log(String.format("ORTC AUTHENTICATION ERROR: %s", e.toString()));
			}
		}else{
			if (checkBoxIsCluster.isChecked()) {
				client.setClusterUrl(editTextServer.getText().toString());
			} else {
				client.setUrl(editTextServer.getText().toString());
			}

			client.setConnectionMetadata(editTextConnectionMetadata.getText().toString());

			log("Connecting...");
			client.connect(editTextApplicationKey.getText().toString(), editTextAuthenticationToken.getEditableText().toString());
		}

	}

	public void disconnectClickEventHandler(View v) {
		log("Disconnecting...");
		client.disconnect();
	}

	public void presenceClickEventHandler(View v) {
		EditText editTextServer = (EditText) findViewById(R.id.EditTextServer);
		EditText editTextApplicationKey = (EditText) findViewById(R.id.EditTextApplicationKey);
		EditText editTextAuthenticationToken = (EditText) findViewById(R.id.EditTextAuthenticationToken);
		EditText editTextChannel = (EditText) findViewById(R.id.EditTextChannel);
		CheckBox checkBoxIsCluster = (CheckBox) findViewById(R.id.CheckBoxIsCluster);

		Ortc.presence(editTextServer.getText().toString(), checkBoxIsCluster.isChecked(), editTextApplicationKey.getText().toString(),
				editTextAuthenticationToken.getText().toString(), editTextChannel.getText().toString(), new OnPresence() {
					@Override
					public void run(Exception error, Presence presence) {
						final Exception exception = error;
						final Presence presenceData = presence;
						runOnUiThread(new Runnable() {
							@Override
							public void run() {
								if (exception != null) {
									log(String.format("Error: %s", exception.getMessage()));
								} else {
									Iterator<?> metadataIterator = presenceData.getMetadata().entrySet().iterator();
									while (metadataIterator.hasNext()) {
										@SuppressWarnings("unchecked")
										Map.Entry<String, Long> entry = (Map.Entry<String, Long>) metadataIterator.next();
										log(entry.getKey() + " - " + entry.getValue());
									}
									log("Subscriptions - " + presenceData.getSubscriptions());
								}
							}
						});
					}
				});
	}

	public void enablePresenceClickEventHandler(View v) {
		EditText editTextServer = (EditText) findViewById(R.id.EditTextServer);
		EditText editTextApplicationKey = (EditText) findViewById(R.id.EditTextApplicationKey);
		EditText editTextChannel = (EditText) findViewById(R.id.EditTextChannel);
		CheckBox checkBoxIsCluster = (CheckBox) findViewById(R.id.CheckBoxIsCluster);

		Ortc.enablePresence(editTextServer.getText().toString(), checkBoxIsCluster.isChecked(), editTextApplicationKey.getText().toString(), defaultPrivateKey,
				editTextChannel.getText().toString(), true, new OnEnablePresence() {
					@Override
					public void run(Exception error, String result) {
						final Exception exception = error;
						final String resultText = result;
						runOnUiThread(new Runnable() {
							@Override
							public void run() {
								if (exception != null) {
									log(String.format("Error: %s", exception.getMessage()));
								} else {
									log(resultText);
								}
							}
						});
					}
				});
	}

	public void disablePresenceClickEventHandler(View v) {
		EditText editTextServer = (EditText) findViewById(R.id.EditTextServer);
		EditText editTextApplicationKey = (EditText) findViewById(R.id.EditTextApplicationKey);
		EditText editTextChannel = (EditText) findViewById(R.id.EditTextChannel);
		CheckBox checkBoxIsCluster = (CheckBox) findViewById(R.id.CheckBoxIsCluster);

		Ortc.disablePresence(editTextServer.getText().toString(), checkBoxIsCluster.isChecked(), editTextApplicationKey.getText().toString(),
				defaultPrivateKey, editTextChannel.getText().toString(), new OnDisablePresence() {
					@Override
					public void run(Exception error, String result) {
						final Exception exception = error;
						final String resultText = result;
						runOnUiThread(new Runnable() {
							@Override
							public void run() {
								if (exception != null) {
									log(String.format("Error: %s", exception.getMessage()));
								} else {
									log(resultText);
								}
							}
						});
					}
				});
	}

	private void log(final String text) {
		runOnUiThread(new Runnable() {
			public void run() {
				TextView t = ((TextView) findViewById(R.id.TextViewLog));
				t.setText(String.format("%s - %s\n%s", DateFormat.format("hh:mm:ss", new java.util.Date()), text, t.getText()));
			}
		});
	}
}
