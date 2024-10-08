import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:rv1g_info/src/components/difference_in_dates.dart';
import 'package:rv1g_info/src/constants/firebase_options.dart';
import 'package:rv1g_info/src/features/authentication/presentation/widgets/email_verification_page.dart';
import 'package:rv1g_info/src/features/authentication/presentation/widgets/forgot_password_page.dart';
import 'package:rv1g_info/src/features/authentication/presentation/widgets/sign_up_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rv1g_info/src/constants/const.dart';
import 'package:rv1g_info/src/constants/theme.dart';

import 'package:rv1g_info/src/features/authentication/presentation/widgets/sign_in_page.dart';
import 'package:rv1g_info/src/features/news/presentation/widgets/news_page.dart';
import 'src/constants/api_keys.dart';
import 'src/features/changes/presentation/widgets/changes_page.dart';
import 'package:rv1g_info/src/features/schedule/presentation/widgets/schedule_page.dart';
import 'package:rv1g_info/src/features/menu/presentation/widgets/menu_page.dart';
import 'package:rv1g_info/src/features/shop/presentation/widgets/shop_page.dart';

Future<void> main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnnonKey,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _router = GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        if (Supabase.instance.client.auth.currentSession != null && state.fullPath == "/") {
          return '/main';
        } else {
          return null;
        }
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SignInPage(),
        ),
        GoRoute(
          path: '/authentication',
          builder: (context, state) => const SignInPage(),
          routes: [
            GoRoute(
              path: 'sign-in',
              builder: (context, state) => SignInPage(),
            ),
            GoRoute(
              path: 'sign-up',
              builder: (context, state) => SignUpPage(),
            ),
            GoRoute(
              path: 'forgot-password',
              builder: (context, state) => ForgotPasswordPage(),
            ),
            GoRoute(
              path: 'email-verification',
              builder: (context, state) => EmailVerificationPage(),
            ),
          ]
        ),
        GoRoute(
          path: '/main',
          builder: (context, state) => MyHomePage(),
        ),
      ]
    );

    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp.router(
          theme: ThemeData(
            primaryColor: blue
          ),
          routerConfig: _router,
        );
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String profilePicUrl = "";
  String fullName = "";
  String email = "";
  bool verified = false;
  bool admin = false;
  List<String> events = [];
  List<String> controllers = [];

  int index = 0;
  List<Widget> screens = [];

  @override
  void initState() {
    getUserData()
      .then((value) {
        setState(() {
          profilePicUrl = value[0];
          fullName = value[1];
          email = value[2];
          verified = value[3];
          admin = value[4];
          events = value[5];
          controllers = value[6];

          screens = [
            NewsPage(
              profilePicUrl: profilePicUrl,
              fullName: fullName,
              events: events,
              controllers: controllers,
              isAdmin: admin
            ),
            ChangesPage(
              profilePicUrl: profilePicUrl,
              fullName: fullName,
              events: events,
              controllers: controllers,
              isAdmin: admin
            ),
            SchedulePage(
              profilePicUrl: profilePicUrl,
              fullName: fullName,
              isVerified: verified,
              events: events,
              controllers: controllers,
              isAdmin: admin
            ),
            MenuPage(
              profilePicUrl: profilePicUrl,
              fullName: fullName,
              isVerified: verified,
              events: events,
              controllers: controllers,
              isAdmin: admin
            ),
            ShopPage(
              profilePicUrl: profilePicUrl,
              fullName: fullName,
              email: email,
              events: events,
              controllers: controllers,
              isAdmin: admin
            ),
          ];
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: IndexedStack(
        index: index,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 2.0,
              offset: Offset(0, 1)
            ),
          ]
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: blue,
          ),
          child: NavigationBar(
            height: 50.h,
            backgroundColor: const Color.fromRGBO(241, 244, 251, 1),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            selectedIndex: index,
            onDestinationSelected: (index) =>
                setState(() => this.index = index),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.article_outlined),
                selectedIcon: Icon(Icons.article, color: Colors.white),
                label: "Ziņas"
              ),
              NavigationDestination(
                icon: Icon(Icons.new_releases_outlined),
                selectedIcon: Icon(Icons.new_releases, color: Colors.white),
                label: "Izmaiņas"
              ),
              NavigationDestination(
                icon: Icon(Icons.table_chart_outlined),
                selectedIcon: Icon(Icons.table_chart, color: Colors.white),
                label: "Saraksts"
              ),
              NavigationDestination(
                icon: Icon(Icons.food_bank_outlined),
                selectedIcon: Icon(Icons.food_bank, color: Colors.white),
                label: "Pusdienas"
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_basket_outlined),
                selectedIcon: Icon(Icons.shopping_basket, color: Colors.white),
                label: "Veikals"
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List> getUserData() async{
    final supabase = Supabase.instance.client;

    final email = supabase.auth.currentUser!.email;
    final res = await supabase
      .from('users')
      .select()
      .eq('email', email);

    final profilePicUrl = res[0]['profile_pic_url'];
    final name = '${res[0]['name']} ${res[0]['surname']}';

    final resRoles = await supabase
      .from('roles')
      .select()
      .eq('user_id', res[0]['id']);

    List<String> events = [];
    List<String> controllers = [];

    for(int i=0;i<resRoles.length;i++){
      String role = resRoles[i]['role'];
      if(role[0] == 'P'){
        if(differenceInDates(DateTime.parse(resRoles[i]['end_date']), DateTime.now())[0] != "-"){
          events.add(role.substring(22));
          controllers.add(role.substring(22));
        }
      } else if(role[0] == 'B'){
        if(differenceInDates(DateTime.parse(resRoles[i]['end_date']), DateTime.now())[0] != "-"){
          controllers.add(role.substring(22));
        }
      }
    }

    if(DateTime.now().day <=31
      && DateTime.now().day >=18
      && DateTime.now().month ==5
    ){

      final form = await supabase
        .from('forms')
        .select()
        .eq('id', res[0]['form_id']);

      if(form[0]['number'] == 12){
        await supabase
          .from('users')
          .update({'form_id':34})
          .eq('email', email);
      } else if(form[0]['letter'] != "Absolvents"){
        int id = dropdownValues['${form[0]['number']+1}.${form[0]['letter']} klase']!;
        await supabase
          .from('users')
          .update({'form_id':id})
          .eq('email', email);
      }
    }

    return [
      profilePicUrl,
      name,
      email,
      res[0]['verified'],
      await supabase.auth.currentUser!.userMetadata!['admin'] ?? false,
      events,
      controllers,
    ];
  }
}