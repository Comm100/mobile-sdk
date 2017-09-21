package com.comm100.webviewchatwindow;

import com.comm100.livechat.VisitorClientActivity;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class MainActivity extends Activity {

	private Button mChatButton = null;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		mChatButton = (Button)findViewById(R.id.btn_chat_now);
		
		mChatButton.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v) {
				int siteId = 10000;		//your site id
				int planId = 5000239;	//your code plan id
				String chatServer = "https://chatserver.comm100.com";	// chat server path, shared platform is https://chatserver.comm100.com, enterprise is https://ent.comm100.com/chatserver 
				
				Intent intent  = new Intent(MainActivity.this, VisitorClientActivity.class);
				intent.putExtra("site_id", siteId);
				intent.putExtra("plan_id", planId);
				intent.putExtra("chat_server", chatServer);
				startActivity(intent);
			}});
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.activity_main, menu);
		return true;
	}

}
