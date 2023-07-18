import 'dart:ui';

String loginSvg = "https://mznfnrsqtgzhhltmpwwh.supabase.co/storage/v1/object/public/assets/undraw_login_re_4vu2.svg";
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

const Map<String, int> dropdownValues = {
      "Choose your class": -1,
      "7.a klase" : 1,
      "7.b klase" : 2,
      "7.c klase" : 3,
      "7.d klase" : 4,
      "8.a klase" : 5,
      "8.b klase" : 6,
      "8.c klase" : 7,
      "8.d klase" : 8,
      "9.a klase" : 9,
      "9.b klase" : 10,
      "9.c klase" : 11,
      "9.d klase" : 12,
      "10.a klase" : 13,
      "10.b klase" : 14,
      "10.c klase" : 15,
      "10.d klase" : 16,
      "10.e klase" : 17,
      "10.f klase" : 18,
      "10.sb klase" : 19,
      "11.a klase" : 20,
      "11.b klase" : 21,
      "11.c klase" : 22,
      "11.d klase" : 23,
      "11.e klase" : 24,
      "11.f klase" : 25,
      "11.sb klase" : 26,
      "12.a klase" : 27,
      "12.b klase" : 28,
      "12.c klase" : 29,
      "12.d klase" : 30,
      "12.e klase" : 31,
      "12.f klase" : 32,
      "12.sb klase" : 33,
    };

String emailSvg = "https://mznfnrsqtgzhhltmpwwh.supabase.co/storage/v1/object/public/assets/undraw_message_sent_re_q2kl.svg";