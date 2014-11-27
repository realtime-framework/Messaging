package ui;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

import config.Config;
import domains.Channel;
import handlers.OrtcHandler;
import rtmchat.realtime.co.rtmchat.R;
import rtmchat.realtime.co.rtmchat.activities.ChatRoomActivity;
import rtmchat.realtime.co.rtmchat.activities.MessageActivity;

public class CustomTableRow extends TableRow {

	private String content;
	private TableLayout container;
	private Context context;

	public CustomTableRow(Context context, TableLayout container, int type,String content) {
		super(context);

		this.content = content;
		this.container = container;
		this.context = context;

		switch (type) {
            case Config.CHANNEL_NAME:
                setChannelName();
                break;

            case Config.CHANNEL_ADD:
                setChannelAdd();
                break;

            case Config.CHANNEL_DEL:
                setChannelDel();
                break;
            default:
                break;
        }
	}

	private void setChannelDel() {
		LayoutInflater inflater = (LayoutInflater) context
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View tr = inflater.inflate(R.layout.delchannel, null, false);
		TextView text = (TextView) tr.findViewById(R.id.delLabel);
		text.setText(content);
		Button delBt = (Button) tr.findViewById(R.id.delButton);
		delBt.setTextColor(Color.WHITE);
		delBt.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				ChatRoomActivity chatController = (ChatRoomActivity) context;
				chatController.delChat(content);
			}
		});

		container.addView(tr);
	}

	private void setChannelAdd() {
		LayoutInflater inflater = (LayoutInflater) context
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View tr = inflater.inflate(R.layout.addchannel, null, false);
		Button addBt = (Button) tr.findViewById(R.id.addButton);
		addBt.setTextColor(Color.WHITE);
		final EditText newChannel = (EditText) tr.findViewById(R.id.addEdit);

		addBt.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				if (!newChannel.getText().toString().equals("")) {
					OrtcHandler.subscribeChannel(newChannel.getText()
                            .toString());
					ChatRoomActivity chatController = (ChatRoomActivity) context;
					chatController.addChat(newChannel.getText().toString());
				}
			}
		});
		container.addView(tr);
	}

	private void setChannelName() {
		LayoutInflater inflater = (LayoutInflater) context
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View tr = inflater.inflate(R.layout.channel, null, false);
		tr.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				Intent messages = new Intent(context, MessageActivity.class)
						.putExtra("channel", content);
				context.startActivity(messages);
			}
		});
		TextView text = (TextView) tr.findViewById(R.id.channelName);
		text.setText(this.content);
		container.addView(tr);
		setUnread(tr);
	}

	private void setUnread(View tr) {
		TextView unRead = (TextView) tr.findViewById(R.id.unRead);
		Channel channelRef = OrtcHandler.selfHandler.messages.get(content);
		if (channelRef.getUnRead() > 0)
			unRead.setText("" + channelRef.getUnRead());
		else {
			unRead.setText("");
		}
	}

}
