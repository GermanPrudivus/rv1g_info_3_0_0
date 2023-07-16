import 'dart:ui';

String loginSvg = "https://mznfnrsqtgzhhltmpwwh.supabase.co/storage/v1/object/sign/rv1g_info/assets/undraw_login_re_4vu2.svg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJydjFnX2luZm8vYXNzZXRzL3VuZHJhd19sb2dpbl9yZV80dnUyLnN2ZyIsImlhdCI6MTY4ODU4MTg2NiwiZXhwIjoyMzE5MzAxODY2fQ.mu2O5uYYDMLYrtLSzlWv3gJlqzF2rZMDp0WXIO6TvsM&t=2023-07-05T18%3A31%3A06.862Z";
Color blue = const Color.fromRGBO(43, 86, 147, 1);
Color lightGrey = const Color.fromRGBO(172, 177, 193, 1);
Color transparentLightGrey = const Color.fromRGBO(172, 177, 193, 0.70);

const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://mznfnrsqtgzhhltmpwwh.supabase.co',
  );

 const String supabaseAnnonKey = String.fromEnvironment(
    'SUPABASE_ANNON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im16bmZucnNxdGd6aGhsdG1wd3doIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzY4MzE1NzMsImV4cCI6MTk5MjQwNzU3M30.6-A5IXsAaTfpp1vEjdthjeHg8Dj41wgzyUgTtKKV19Y',
  );