# capacitor-cloudkit

Basic CloudKit authentication plugin.

## Install

```bash
npm install capacitor-cloudkit
npx cap sync
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
