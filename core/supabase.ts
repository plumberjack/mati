import { createClient } from '@supabase/supabase-js';

const PUBLIC_URL = 'https://rrubwukbozlveswbvvyv.supabase.co';
const PUBLIC_KEY = `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJydWJ3dWtib3psdmVzd2J2dnl2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc4OTkzNjEsImV4cCI6MjA1MzQ3NTM2MX0.arZ6M3n3vF5e9Hapy-gZ3xw15IGwDwV4IkWYxxonrzY`;

export default createClient(PUBLIC_URL, PUBLIC_KEY, {
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
