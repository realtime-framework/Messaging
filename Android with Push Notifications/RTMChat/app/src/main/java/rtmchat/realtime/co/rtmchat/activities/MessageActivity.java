package rtmchat.realtime.co.rtmchat.activities;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.TableLayout;

import java.util.ArrayList;

import domains.Channel;
import domains.Message;
import handlers.OrtcHandler;
import interfaces.InterfaceRefresher;
import preferences.PreferencesManager;
import ui.MessageTableRow;
import rtmchat.realtime.co.rtmchat.R;

public class MessageActivity extends ActionBarActivity implements InterfaceRefresher {

	private String channel;
	private boolean pause;
    private static boolean mIsInForegroundMode;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_message);

		Button composeBtn = (Button) findViewById(R.id.btCompose);
		composeBtn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent messages = new Intent(MessageActivity.this,
						ComposeActivity.class).putExtra("channel", channel);
				startActivity(messages);
			}
		});
	}

	@Override
	protected void onResume() {
		super.onResume();
        pause = false;
        mIsInForegroundMode = true;
        OrtcHandler.selfHandler.messagesView = this;
        channel = getIntent().getStringExtra("channel");
        setTitle(channel);
		TableLayout tableMessages = (TableLayout) findViewById(R.id.tableMessages);
		tableMessages.removeAllViews();
		loadMsg();

	}

	@Override
	protected void onPause() {
		super.onPause();
		pause = true;
        mIsInForegroundMode = false;
	}

    // Some function.
    public static boolean isInForeground() {
        return mIsInForegroundMode;
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_message, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

	private void loadMsg() {
        ArrayList<Message> messages = OrtcHandler.selfHandler.messages.get(channel).getMessages();
        for (Message msg : messages) {
            setmsg(msg);
        }
	}

	private void setmsg(Message msg) {	
		if(pause == false){
			Channel cn = OrtcHandler.selfHandler.messages.get(channel);
			cn.setUnRead(0);
		}
		
		TableLayout tableMessages = (TableLayout) findViewById(R.id.tableMessages);

		if (msg.user.equals(PreferencesManager.getInstance(MessageActivity.this).loadUser())) {
			new MessageTableRow(this, tableMessages, true, msg);
		} else {
			new MessageTableRow(this, tableMessages, false, msg);
		}
	}

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
	public void refreshData(final Message msg) {
		runOnUiThread(new Runnable() {
            @Override
            public void run() {
                setmsg(msg);
            }
        });
	}
}
