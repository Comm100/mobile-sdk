package com.Sample.chat;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;



import cn.jpush.android.api.JPushInterface;
import com.comm100.livechat.VisitorClientInterface;

/**
 * Created by allon on 5/25/2018.
 */

public class JPushReceiver extends BroadcastReceiver {

    private static final String TAG = "JPushReceiveer";

    @Override
    public void onReceive(Context context, Intent intent) {
        try{
            Bundle bundle = intent.getExtras();

            if(JPushInterface.ACTION_REGISTRATION_ID.equals(intent.getAction())) {
                String regId = bundle.getString(JPushInterface.EXTRA_REGISTRATION_ID);
                Log.d(TAG, "JPushReceiver receive Registration Id: " + regId);
                VisitorClientInterface.setRemoteNotificationDeviceId(regId);
            }

            if(JPushInterface.ACTION_NOTIFICATION_OPENED.equals(intent.getAction())) {
                Log.d(TAG, "JPushReceiver receive Notification Opened");
                Intent i = new Intent(context, ExtendChatActivity.class);
                i.putExtras(bundle);
                i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                context.startActivity(i);
            }

        } catch(Exception e){

        }

    }
}
