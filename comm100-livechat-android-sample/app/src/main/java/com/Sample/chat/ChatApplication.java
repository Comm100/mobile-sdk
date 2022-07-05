package com.Sample.chat;

import android.app.Activity;
import android.app.Application;
import android.app.Notification;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import com.comm100.livechat.VisitorClientInterface;
import com.comm100.livechat.model.CustomField;
import com.comm100.livechat.model.SystemField;
import com.comm100.livechat.view.VisitorClientCustomJS;

import java.util.Vector;

import cn.jpush.android.api.BasicPushNotificationBuilder;
import cn.jpush.android.api.JPushInterface;

/**
 * Created by allon on 5/28/2018.
 */

public class ChatApplication extends Application {

    public int count = 0;

    public void onCreate(){
        super.onCreate();
        Vector<SystemField> systemFields = new Vector<SystemField>();
        systemFields.add(new SystemField("name","Frank"));
        systemFields.add(new SystemField("email","comm100@comm100.com"));
        Vector<CustomField> customFields = new Vector<CustomField>();
        VisitorClientInterface.setChatUrl("https://vue.comm100.com/visitorside/chatwindow.aspx?siteId=10100000&planId=0bb92c61-8cb3-4330-8558-492dcfec7309");
        VisitorClientInterface.fillPreChat(systemFields,customFields,false);
        String jsString = VisitorClientCustomJS.buildPrechatfillingScript(systemFields,customFields,false);

        JPushInterface.setDebugMode(true);
        JPushInterface.init(this);

        BasicPushNotificationBuilder builder =
                new BasicPushNotificationBuilder(this.getApplicationContext());

        builder.statusBarDrawable = R.drawable.icon_small;
        builder.notificationFlags = Notification.FLAG_SHOW_LIGHTS;
        builder.notificationDefaults = Notification.DEFAULT_SOUND
                | Notification.DEFAULT_VIBRATE
                | Notification.DEFAULT_LIGHTS;

        JPushInterface.setDefaultPushNotificationBuilder(builder);

        if(Build.VERSION.SDK_INT > 23){
            JPushInterface.setLatestNotificationNumber(this.getApplicationContext(), 1);
        }

        String regId = JPushInterface.getRegistrationID(this);
        if(!regId.equals("")) {
            VisitorClientInterface.setRemoteNotificationDeviceId(regId);
        }

        registerActivityLifecycleCallbacks(new ActivityLifecycleCallbacks() {
            @Override
            public void onActivityStopped(Activity activity) {
                Log.v("ChatApplication", activity + "onActivityStopped");
                count--;
                if (count == 0) {
                    VisitorClientInterface.activeRemoteNotification();
                    Log.v("ChatApplication", ">>>>>>>>>>>>>>>>>>>切到后台  lifecycle");
                }
            }

            @Override
            public void onActivityStarted(Activity activity) {
                Log.v("ChatApplication", activity + "onActivityStarted");
                if (count == 0) {
                    VisitorClientInterface.inactiveRemoteNotification();
                    Log.v("ChatApplication", ">>>>>>>>>>>>>>>>>>>切到前台  lifecycle");
                }
                count++;
            }

            @Override
            public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
                Log.v("ChatApplication", activity + "onActivitySaveInstanceState");
            }

            @Override
            public void onActivityResumed(Activity activity) {
                Log.v("ChatApplication", activity + "onActivityResumed");
            }

            @Override
            public void onActivityPaused(Activity activity) {
                Log.v("ChatApplication", activity + "onActivityPaused");
            }

            @Override
            public void onActivityDestroyed(Activity activity) {
                Log.v("ChatApplication", activity + "onActivityDestroyed");
            }

            @Override
            public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
                Log.v("ChatApplication", activity + "onActivityCreated");
            }
        });
    }
}
