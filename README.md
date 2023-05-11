# capacitor-cloudkit

Basic CloudKit authentication plugin. v1 is Capacitor 4, v2 is Capacitor 5.

## Install

```bash
npm install capacitor-cloudkit
npx cap sync
```

## Setup

Each different platform requires a different `ckAPIToken`.
- Web: Token configured for `postMessage`.
- iOS: Token configured to redirect to your container's URL scheme. It'll show up on the CloudKit dashboard in a dropdown when you create an API key. Mine is `cloudkit-icloud.baseline.getbaseline.app://`, so I'll be using that as an example. I set mine to `cloudkit-icloud.baseline.getbaseline.app://callback`.
- Android: Token configured to redirect to `https://example.com` or some similar existant but blank domain.

## Setup (iOS)

- Add your callback URL as a URL scheme in your app, in the Info tab. (e.g. `cloudkit-icloud.baseline.getbaseline.app`)
- Add the following to the beginning of `func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool` in `AppDelegate`:

```swift
if (url.scheme == "PUT CALLBACK URL SCHEME HERE (e.g. cloudkit-icloud.baseline.getbaseline.app)") {
    NotificationCenter.default.post(name: NSNotification.Name("cloudkitLogin"), object: url);
}
```

## API

<docgen-index>

* [`authenticate(...)`](#authenticate)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### authenticate(...)

```typescript
authenticate(options: SignInOptions) => Promise<{ ckWebAuthToken: string; }>
```

| Param         | Type                                                    |
| ------------- | ------------------------------------------------------- |
| **`options`** | <code><a href="#signinoptions">SignInOptions</a></code> |

**Returns:** <code>Promise&lt;{ ckWebAuthToken: string; }&gt;</code>

--------------------


### Interfaces


#### SignInOptions

| Prop                      | Type                                       |
| ------------------------- | ------------------------------------------ |
| **`containerIdentifier`** | <code>string</code>                        |
| **`environment`**         | <code>'development' \| 'production'</code> |
| **`ckAPIToken`**          | <code>string</code>                        |

</docgen-api>
