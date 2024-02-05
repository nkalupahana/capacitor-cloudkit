export interface SignInOptions {
  containerIdentifier: string;
  environment: 'development' | 'production';
  ckAPIToken: string;
}

export interface FetchRecordOptions {
  containerIdentifier: string;
  database: "private" | "public" | "shared";
  by: "recordName";
  recordName?: string;
}

export interface CloudKitPlugin {
  authenticate(options: SignInOptions): Promise<{ ckWebAuthToken: string }>;

  /**
   * Only available on iOS.
   */
  fetchRecord(options: FetchRecordOptions): Promise<any>;
}
