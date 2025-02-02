import { createClient } from '@supabase/supabase-js';

export default createClient(import.meta.env['PROJECT_URL'], import.meta.env['API_KEY'], {
  db: {
    schema: 'public',
  },
  auth: {
    persistSession: false,
    autoRefreshToken: false,
  },
  global: {
    headers: { 'x-mati': 'mati' },
  },
});
