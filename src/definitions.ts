export interface CloudKitPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
