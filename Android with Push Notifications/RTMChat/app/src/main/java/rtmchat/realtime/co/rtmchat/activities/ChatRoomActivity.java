package rtmchat.realtime.co.rtmchat.activities;

import java.util.ArrayList;

import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.TableLayout;

import config.Config;
import domains.Message;
import handlers.OrtcHandler;
import interfaces.InterfaceRefresher;
import preferences.PreferencesManager;
import rtmchat.realtime.co.rtmchat.R;
import ui.CustomTableRow;


public class ChatRoomActivity extends ActionBarActivity implements InterfaceRefresher {
	private Boolean editing;
	private ArrayList<String> channels;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_chat_room);


        OrtcHandler.selfHandler.chatRoom = this;
		
		editing = false;

		channels = PreferencesManager.getInstance(ChatRoomActivity.this).loadChannels();

		setChannels();

		Button btEdit = (Button) this.findViewById(R.id.chatEditButton);
		btEdit.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				editing = !editing;

				Button btEdit = (Button) findViewById(R.id.chatEditButton);
				if (editing) {
					btEdit.setText(getString(R.string.doneLabel));
				} else {
                    PreferencesManager.getInstance(ChatRoomActivity.this).saveChannels(channels);
					btEdit.setText(R.string.editLabel);
				}
				clearChannelsList();
				setChannels();
			}
		});
	}
	
	@Override
	protected void onResume(){
		super.onResume();
		clearChannelsList();
		setChannels();
	}

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_chat_room, menu);
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

	@Override
	public void refreshData(Message msg) {
		runOnUiThread(new Runnable() {
            @Override
            public void run() {
                clearChannelsList();
                setChannels();
            }
        });
		
	}

	public void addChat(String chatName) {
		channels.add(chatName);
		clearChannelsList();
		setChannels();
	}

	public void delChat(String chatName) {
		int index = this.channels.indexOf(chatName);
		channels.remove(index);
		clearChannelsList();
		setChannels();
	}

	private void setChannels() {
		TableLayout chatRoomsTable = (TableLayout) findViewById(R.id.chatRoomTable);
		if(channels.size() == 0)
		{
			editing = true;
			 new CustomTableRow(this, chatRoomsTable,
					Config.CHANNEL_ADD, null);
			return;
		}
		if (editing) {
			for (String channel : channels) {
				new CustomTableRow(this,
						chatRoomsTable, Config.CHANNEL_DEL, channel);
			}
			CustomTableRow newRow = new CustomTableRow(this, chatRoomsTable,
					Config.CHANNEL_ADD, null);
		} else {
			for (String channel : channels) {
				new CustomTableRow(this,
						chatRoomsTable, Config.CHANNEL_NAME, channel);
			}
		}
	}

	private void clearChannelsList() {
		TableLayout chatRoomsTable = (TableLayout) findViewById(R.id.chatRoomTable);
		chatRoomsTable.removeAllViews();
	}

}
