export interface SignInOptions {
  containerIdentifier: string;
  environment: 'development' | 'production';
  ckAPIToken: string;
}

export interface CloudKitPlugin {
  authenticate(options: SignInOptions): Promise<{ ckWebAuthToken: string }>;
}
