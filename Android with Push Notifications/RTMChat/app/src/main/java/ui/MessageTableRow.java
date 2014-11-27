package ui;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;
import domains.Message;
import rtmchat.realtime.co.rtmchat.R;

public class MessageTableRow extends TableRow {

	private Boolean isFromUser;
	private Context context;
	private Message msg;
	private TableLayout tableMessages;

	public MessageTableRow(Context context, TableLayout tableMessages, Boolean fromUser, Message msg) {
		super(context);
		this.msg = msg;
		this.context = context;
		this.isFromUser = fromUser;
		this.tableMessages = tableMessages;
		
		this.setMessage();
	}

	private void setMessage() {
		if (isFromUser) {
			setFromUserCell();
		} else {
			setFromOtherCell();
		}
	}

	private void setFromUserCell() {
		LayoutInflater inflater = (LayoutInflater) context
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View tr = inflater.inflate(R.layout.cellsend, null, false);
		TextView user = (TextView)tr.findViewById(R.id.user);
		user.setText(msg.user +": "+ msg.date);
		TextView text = (TextView)tr.findViewById(R.id.text);
		text.setText(msg.content);
		tableMessages.addView(tr);
	}

	private void setFromOtherCell() {
		LayoutInflater inflater = (LayoutInflater) context
				.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View tr = inflater.inflate(R.layout.cellreceive, null, false);
		TextView user = (TextView)tr.findViewById(R.id.user);
		user.setText(msg.user +": "+ msg.date);
		TextView text = (TextView)tr.findViewById(R.id.text);
		text.setText(msg.content);
		tableMessages.addView(tr);
	}

}
