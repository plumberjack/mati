import type { User } from '@supabase/supabase-js';

import { join } from 'node:path';
import { homedir } from 'node:os';

import { Listr } from 'listr2';

import supabase from 'core/supabase';

type Config = {
  version: string;
  host: User | null;
};

const init = new Listr<Config>(
  [
    {
      title: 'Initializing mati...',
      task: (_, main) => {
        return main.newListr([
          {
            enabled: (ctx) => !ctx.host,
            title: 'Synchronizing',
            task: async (ctx) => {
              try {
                const { data } = await supabase.auth.signInAnonymously();
                if (data) {
                  ctx.host = data.user;
                  main.title = main.title.replace('...', ': done');
                }
                return true;
              } catch {
                main.title = main.title.replace('...', ': failed');
                process.exit(1);
              }
            },
          },
        ]);
      },
    },
  ],
  {
    concurrent: false,
  },
);

// hook up to mati config file
const configPath = join(homedir(), '.mati', '.mati.json');
const config = Bun.file(configPath, { type: 'application/json' });

try {
  if (await config.exists()) {
    const cfg: Config = await config.json();
    if (!cfg.host) await init.run(cfg);
  } else {
    config.write(
      JSON.stringify(
        await init.run({
          version: import.meta.env['VERSION'] || 'latest',
          host: null,
        }),
        null,
        2,
      ),
    );
  }
} catch {
  // if all fails remove the config file to start over later
  await config.delete();
}
