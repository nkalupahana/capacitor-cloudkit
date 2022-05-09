package cloudkit.baseline.getbaseline.app;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class SignInWithCloudKit extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_in_with_cloud_kit);
        WebView webview = findViewById(R.id.webView);
        webview.setWebViewClient(new WebViewClient() {
            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon)
            {
                super.onPageStarted(view, url, favicon);
                if (url.contains("example.com")) {
                    Intent intent = new Intent();
                    intent.setData(Uri.parse(url));
                    setResult(RESULT_OK, intent);
                    finish();
                }
            }
        });
        webview.getSettings().setJavaScriptEnabled(true);
        webview.loadUrl(getIntent().getData().toString());
    }

    public void cancelLogin(View view) {
        setResult(RESULT_CANCELED);
        finish();
    }
}