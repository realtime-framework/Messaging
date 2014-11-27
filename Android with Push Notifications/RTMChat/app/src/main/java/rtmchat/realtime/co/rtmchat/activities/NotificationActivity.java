package rtmchat.realtime.co.rtmchat.activities;

import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TableLayout;
import android.widget.TextView;

import java.text.SimpleDateFormat;
import java.util.Date;

import config.Config;
import domains.Message;
import ibt.ortc.api.Ortc;
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
import preferences.PreferencesManager;
import rtmchat.realtime.co.rtmchat.R;
import ui.MessageTableRow;


public class NotificationActivity extends ActionBarActivity {

        private OrtcClient client;
        private String channel;
        private static boolean mIsInForegroundMode;
        final public static String ORTC_TAG = "ORTC";

        @Override
        protected void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.activity_notification);

            channel = getIntent().getStringExtra("channel");
            setTitle(channel);

            String message = getIntent().getStringExtra("message");
            String user = getIntent().getStringExtra("user");
            refreshUI(user+":"+message);

            final TextView charNumber = (TextView) findViewById(R.id.charNumber);
            charNumber.setText("" + 260);

            final EditText text = (EditText) this.findViewById(R.id.editMessage);

            text.addTextChangedListener(new TextWatcher(){
                public void afterTextChanged(Editable s) {
                    charNumber.setText("" + (260 - text.getText().toString().length()));
                }
                public void beforeTextChanged(CharSequence s, int start, int count, int after){}
                public void onTextChanged(CharSequence s, int start, int before, int count){}
            });

            final Button saveBtn = (Button) findViewById(R.id.btnSave);
            saveBtn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    String user = PreferencesManager.getInstance(NotificationActivity.this).loadUser();
                    String msg = text.getText().toString();
                    SimpleDateFormat sdf = new SimpleDateFormat(Config.DATE_FORMAT);
                    client.send(channel,new Message(user,msg,sdf.format(new Date())).toString());
                    text.clearFocus();
                    InputMethodManager imm = (InputMethodManager)getSystemService(
                           INPUT_METHOD_SERVICE);
                    imm.hideSoftInputFromWindow(text.getWindowToken(), 0);
                }
            });

            try {
                Ortc ortc = new Ortc();

                OrtcFactory factory;

                factory = ortc.loadOrtcFactory("IbtRealtimeSJ");

                client = factory.createClient();

                client.setHeartbeatActive(true);

            } catch (Exception e) {
            }

            if (client != null) {
                try {

                    client.onConnected = new OnConnected() {

                        public void run(final OrtcClient sender) {
                            runOnUiThread(new Runnable() {

                                public void run() {
                                    Log.i(ORTC_TAG, "Connected");
                                    client.subscribe(channel,true,new OnMessage() {
                                        @Override
                                        public void run(OrtcClient ortcClient, String channel, final String message) {
                                            runOnUiThread(new Runnable() {
                                                @Override
                                                public void run() {
                                                    refreshUI(message);
                                                }
                                            });

                                        }
                                    });
                                }
                            });
                        }
                    };

                    client.onDisconnected = new OnDisconnected() {

                        public void run(OrtcClient arg0) {
                            runOnUiThread(new Runnable() {

                                public void run() {
                                    Log.i(ORTC_TAG, "Disconnected");
                                }
                            });
                        }
                    };

                    client.onSubscribed = new OnSubscribed() {

                        public void run(OrtcClient sender, final String channel) {
                            runOnUiThread(new Runnable() {

                                public void run() {
                                    Log.i(ORTC_TAG, "Subscribed to " + channel);
                                    saveBtn.setEnabled(true);
                                }
                            });
                        }
                    };

                    client.onUnsubscribed = new OnUnsubscribed() {

                        public void run(OrtcClient sender, final String channel) {
                            runOnUiThread(new Runnable() {

                                public void run() {
                                    Log.i(ORTC_TAG, "Unsubscribed from " + channel);
                                }
                            });
                        }
                    };

                    client.onException = new OnException() {

                        public void run(OrtcClient send, final Exception ex) {
                            runOnUiThread(new Runnable() {

                                public void run() {
                                    Log.e(ORTC_TAG, "Exception " + ex.toString());
                                }
                            });
                        }
                    };

                    client.onReconnected = new OnReconnected() {

                        public void run(final OrtcClient sender) {
                            runOnUiThread(new Runnable() {

                                public void run() {
                                    Log.i(ORTC_TAG, "Reconnected");
                                }
                            });
                        }
                    };

                    client.onReconnecting = new OnReconnecting() {

                        public void run(OrtcClient sender) {
                            runOnUiThread(new Runnable() {

                                public void run() {
                                    Log.i(ORTC_TAG, "Reconnecting");

                                }
                            });
                        }
                    };
                } catch (Exception e) {
                    Log.e("Exception ",e.toString());
                }

                client.setConnectionMetadata(Config.METADATA);

                if(Config.CLUSTERURL != null){
                    client.setClusterUrl(Config.CLUSTERURL);
                } else {
                    client.setUrl(Config.CLUSTERURL);
                }
                client.connect(Config.APPKEY, Config.TOKEN);
            }


        }

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

        public static boolean isInForeground() {
            return mIsInForegroundMode;
        }

        private void refreshUI(String message){
            String[] parts = message.split(":");
            Message newMsg = new Message(parts[0], parts[1], new Date().toString());

            TableLayout tableMessages = (TableLayout) findViewById(R.id.tableMessages);

            if (newMsg.user.equals(PreferencesManager.getInstance(NotificationActivity.this).loadUser())) {
                new MessageTableRow(NotificationActivity.this, tableMessages, true, newMsg);
            } else {
                new MessageTableRow(NotificationActivity.this, tableMessages, false, newMsg);
            }
        }
}
