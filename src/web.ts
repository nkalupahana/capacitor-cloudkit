import { WebPlugin } from '@capacitor/core';

import type { CloudKitPlugin, FetchRecordOptions, SignInOptions } from './definitions';

export class CloudKitWeb extends WebPlugin implements CloudKitPlugin {
  authenticate(options: SignInOptions): Promise<{ ckWebAuthToken: string }> {
    return new Promise((resolve, reject) => {
      (async () => {
        const listener = (event: MessageEvent) => {
          if (event.origin === 'https://cdn.apple-cloudkit.com') {
            window.removeEventListener('message', listener);
            if (event.data.ckSession) {
              resolve({
                ckWebAuthToken: encodeURIComponent(event.data.ckSession),
              });
            } else if (event.data.errorMessage) {
              reject(event.data.errorMessage);
            } else {
              reject('Something went wrong, please try again!');
            }
          }
        };

        const login = await fetch(
          `https://api.apple-cloudkit.com/database/1/${options.containerIdentifier}/${options.environment}/public/users/caller?ckAPIToken=${options.ckAPIToken}`,
        );
        window.addEventListener('message', listener, false);
        window.open((await login.json())['redirectURL']);
      })();
    });
  }

  fetchRecord(_: FetchRecordOptions): Promise<any> {
    throw new Error('Method not available on web.');
  }
}
