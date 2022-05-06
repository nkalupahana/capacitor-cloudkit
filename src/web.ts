import { WebPlugin } from '@capacitor/core';

import type { CloudKitPlugin } from './definitions';

export class CloudKitWeb extends WebPlugin implements CloudKitPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
