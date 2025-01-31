import type { RouteConfig } from '@react-router/dev/routes';

import { join } from 'node:path';
import { prefix } from '@react-router/dev/routes';
import { flatRoutes } from '@react-router/fs-routes';

async function createRoute(path: string, basePath?: string) {
  const rootDirectory = join('routes', basePath || '', path);
  return prefix(path, await flatRoutes({ rootDirectory }));
}

export default [
  ...(await createRoute('apps')),
  ...(await createRoute('components')),
] satisfies RouteConfig;
