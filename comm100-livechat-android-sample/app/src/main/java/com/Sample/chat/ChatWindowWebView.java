import android.content.Context;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.comm100.livechat.model.CustomField;
import com.comm100.livechat.model.SystemField;
import com.comm100.livechat.view.VisitorClientCustomJS;

import java.util.Vector;

public class ChatWindowWebView extends WebView {

    public static final String kWebviewHandler = "webviewHandler";

    public ChatWindowWebView(Context context) {
        super(context);
        this.setWebViewClient(mWebViewClient);
        this.addJavascriptInterface(new Object(){
          //  @JavascriptInterface
            public void onCloseWindow() {
                // write your own code, exit current activity or switch current view.
            }
        }, kWebviewHandler);
    }

    private WebViewClient mWebViewClient = new WebViewClient(){
        @Override
        public void onPageFinished(WebView view, String url)
        {



            super.onPageFinished(view, url);

            StringBuilder scriptBuilder = new StringBuilder();

            scriptBuilder.append("Comm100API.onReady = function() {");
            scriptBuilder.append("Comm100API.on('livechat.prechat.close', function (){");
            scriptBuilder.append(String.format("window.%s.onCloseWindow();", kWebviewHandler));
            scriptBuilder.append("});");
            scriptBuilder.append("}");

            view.loadUrl("javascript:" + scriptBuilder.toString());
        }
    };
}