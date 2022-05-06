import { registerPlugin } from '@capacitor/core';

import type { CloudKitPlugin } from './definitions';

const CloudKit = registerPlugin<CloudKitPlugin>('CloudKit', {
  web: () => import('./web').then(m => new m.CloudKitWeb()),
});

export * from './definitions';
export { CloudKit };
