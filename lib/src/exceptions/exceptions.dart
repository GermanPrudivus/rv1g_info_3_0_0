Map<String, String> authExceptions = {
  "AuthException(message: Invalid login credentials, statusCode: 400)"
  :"Inncorect login email and/or password! Please try different email and/or password!",
  "ClientException with SocketException: Failed host lookup: 'mznfnrsqtgzhhltmpwwh.supabase.co' (OS Error: No address associated with hostname, errno = 7), uri=https://mznfnrsqtgzhhltmpwwh.supabase.co/auth/v1/token?grant_type=password"
  :"Please check your internet connection!",
  "AuthException(message: Email not confirmed, statusCode: 400)"
  :"Please verify your email to login!",
};