import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/constants/auth_const.dart';
import 'package:rv1g_info/src/constants/theme_colors.dart';
import 'package:rv1g_info/src/features/authentication/presentation/widgets/sign_in_page.dart';
import 'package:rv1g_info/src/features/news/presentation/widgets/news_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnnonKey,
    authFlowType: AuthFlowType.pkce,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            primaryColor: blue,
          ),
          home: session == null
            ? const SignInPage()
            : const MyHomePage(),
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

  bool admin = false;
  int index = 0;
  List<Widget> screens = [];

  @override
  void initState() {
    isUserAdmin()
      .then((value) {
        setState(() {
          admin = value;
          screens = [
            NewsPage(isAdmin: admin),
            NewsPage(isAdmin: admin),
            NewsPage(isAdmin: admin),
            NewsPage(isAdmin: admin),
            NewsPage(isAdmin: admin),
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
            backgroundColor: navigationBarColor,
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

  Future<bool> isUserAdmin() async{
    final supabase = Supabase.instance.client;
    return await supabase.auth.currentUser!.userMetadata!['admin'] ?? false;
  }
}