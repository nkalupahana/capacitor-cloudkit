export interface SignInOptions {
  containerIdentifier: string;
  environment: 'development' | 'production';
  ckAPIToken: string;
}

export interface CloudKitPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  authenticate(options: SignInOptions): Promise<{ ckWebAuthToken: string }>;
}
