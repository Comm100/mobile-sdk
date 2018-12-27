package com.comm100.livechat.androidclient;

import android.os.Bundle;
import com.comm100.livechat.ChatActivity;
import com.comm100.livechat.VisitorClientInterface;


public class MainActivity extends ChatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState){
        VisitorClientInterface.setChatUrl("https://chatserver.comm100.com/chatwindow.aspx?siteId=10014&planId=5000339");
        super.onCreate(savedInstanceState);
    }
}
