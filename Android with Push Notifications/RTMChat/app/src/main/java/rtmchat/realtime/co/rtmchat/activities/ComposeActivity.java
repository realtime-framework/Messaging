package rtmchat.realtime.co.rtmchat.activities;

import java.util.Date;

import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import config.Config;
import domains.Message;
import handlers.OrtcHandler;
import preferences.PreferencesManager;
import rtmchat.realtime.co.rtmchat.R;

public class ComposeActivity extends ActionBarActivity {

	private String channel;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_compose);
		
		this.channel = getIntent().getStringExtra("channel");
		this.setTitle(this.channel);
		
		
		final TextView charNumber = (TextView) findViewById(R.id.charNumber);
    	charNumber.setText("" + Config.MSG_SIZE);
		
    	final EditText text = (EditText) this.findViewById(R.id.editMessage);
		
	    text.addTextChangedListener(new TextWatcher(){
	        public void afterTextChanged(Editable s) {
	        	charNumber.setText("" + (Config.MSG_SIZE - text.getText().toString().length()));
	        }
	        public void beforeTextChanged(CharSequence s, int start, int count, int after){}
	        public void onTextChanged(CharSequence s, int start, int before, int count){}
	    }); 		
		
		Button save = (Button) this.findViewById(R.id.save);
		
		save.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				OrtcHandler.selfHandler.sendMsg(new Message(PreferencesManager.getInstance(ComposeActivity.this).loadUser(), text.getText().toString(), new Date().toString()), channel);
				finish();
			}
		});
		
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.menu_compose, menu);
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
}
