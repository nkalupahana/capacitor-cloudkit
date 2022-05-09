package cloudkit.baseline.getbaseline.app;

import static android.app.Activity.RESULT_OK;

import android.content.Intent;
import android.net.Uri;

import androidx.activity.result.ActivityResult;
import androidx.activity.result.ActivityResultCallback;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

@CapacitorPlugin(name = "CloudKit")
public class CloudKitPlugin extends Plugin {
    ActivityResultLauncher<Intent> launcher;
    PluginCall lastCall;
    OkHttpClient client = new OkHttpClient();

    @Override
    public void load() {
        super.load();
        launcher = getActivity().registerForActivityResult(new ActivityResultContracts.StartActivityForResult(),
                new ActivityResultCallback<ActivityResult>() {
                    @Override
                    public void onActivityResult(ActivityResult result) {
                        if (result.getResultCode() == RESULT_OK) {
                            JSObject ret = new JSObject();
                            ret.put("ckWebAuthToken", result.getData().getData().toString().split("ckWebAuthToken=")[1]);
                            lastCall.resolve(ret);
                        } else {
                            lastCall.reject("User closed view.");
                        }
                    }
                });
    }

    @PluginMethod
    public void authenticate(PluginCall call) {
        lastCall = call;
        String url = "https://api.apple-cloudkit.com/database/1/" + call.getString("containerIdentifier") + "/" + call.getString("environment") + "/public/users/caller?ckAPIToken=" + call.getString("ckAPIToken");
        Request request = new Request.Builder().url(url).build();
        try (Response response = client.newCall(request).execute()) {
            JSONObject resp = new JSONObject(response.body().string());
            Intent intent = new Intent(getContext(), SignInWithCloudKit.class);
            if (!resp.getString("serverErrorCode").equals("AUTHENTICATION_REQUIRED")) {
                call.reject("API key invalid.");
                return;
            }

            intent.setData(Uri.parse(resp.getString("redirectURL")));
            launcher.launch(intent);
        } catch (IOException | JSONException e) {
            call.reject(e.getLocalizedMessage());
        }
    }
}
