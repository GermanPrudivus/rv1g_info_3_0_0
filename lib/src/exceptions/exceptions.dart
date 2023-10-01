Map<String, String> authExceptions = {
  "AuthException(message: Invalid login credentials, statusCode: 400)"
  :"Incorrect login email and/or password! Please try different email and/or password!",
  "ClientException with SocketException: Failed host lookup: 'mznfnrsqtgzhhltmpwwh.supabase.co' (OS Error: No address associated with hostname, errno = 7), uri=https://mznfnrsqtgzhhltmpwwh.supabase.co/auth/v1/token?grant_type=password"
  :"Please check your internet connection!",
  "AuthException(message: Email not confirmed, statusCode: 400)"
  :"Please verify your email to login!",
  'PostgrestException(message: duplicate key value violates unique constraint "users_email_key", code: 23505, details: Conflict, hint: null)'
  :"User already exists! Please try different email!",
  "AuthException(message: Email rate limit exceeded, statusCode: 429)"
  :"Please wait 5 minutes and then try again!"
};

Map<String, String> exceptions = {
  "ClientException with SocketException: Failed host lookup: 'mznfnrsqtgzhhltmpwwh.supabase.co' (OS Error: No address associated with hostname, errno = 7), uri=https://mznfnrsqtgzhhltmpwwh.supabase.co/auth/v1/token?grant_type=password"
  :"Lūdzu, pārbaudiet savu inetrneta pieslēgumu!",
};