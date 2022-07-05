package com.Sample.chat;

import android.view.KeyEvent;

import com.comm100.livechat.ChatActivity;

/**
 * Created by allon on 5/31/2018.
 */

public class ExtendChatActivity extends ChatActivity {

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if(keyCode == KeyEvent.KEYCODE_BACK) {
            moveTaskToBack(false);
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

}
