import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telecaliingcrm/providers/CallHistoryProvider.dart';
import 'package:telecaliingcrm/providers/ConnectivityProviders.dart';
import 'package:telecaliingcrm/providers/DashBoardProvider.dart';
import 'package:telecaliingcrm/providers/FollowupProvider.dart';
import 'package:telecaliingcrm/providers/LeadsProvider.dart';
import 'package:telecaliingcrm/providers/UserDetailsProvider.dart';
import 'package:telecaliingcrm/providers/leaderBoardprovider.dart';
import 'package:telecaliingcrm/screens/SubscriptionExpiredScreen.dart';
import 'package:telecaliingcrm/screens/TooManyRequestsScreen.dart';
import 'package:telecaliingcrm/services/ApiClient.dart';
import 'Authentication/SignInScreen.dart';
import 'screens/SpalshScreen.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Always first before anything async or platform-channel

  ApiClient.setupInterceptors(_navigatorKey); // ✅ Now okay after binding

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConnectivityProviders()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => UserDetailsProvider()),
        ChangeNotifierProvider(create: (_) => CallHistoryProvider()),
        ChangeNotifierProvider(create: (_) => LeadsProvider()),
        ChangeNotifierProvider(create: (_) => LeaderBoardProvider()),
        ChangeNotifierProvider(create: (_) => FollowupProvider()),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        builder: (BuildContext context, Widget? child) {
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(textScaleFactor: 1.0),
            child: child ?? Container(),
          );
        },
        title: 'Tele Calling CRM',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.white,
          dialogBackgroundColor: Colors.white,
          cardColor: Colors.white,
          searchBarTheme: const SearchBarThemeData(),
          tabBarTheme: const TabBarTheme(),
          dialogTheme: const DialogTheme(
            shadowColor: Colors.white,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0)), // Set the border radius of the dialog
            ),
          ),
          buttonTheme: const ButtonThemeData(),
          popupMenuTheme: const PopupMenuThemeData(
              color: Colors.white, shadowColor: Colors.white),
          appBarTheme: const AppBarTheme(
            surfaceTintColor: Colors.white,
            shadowColor: Colors.transparent,
          ),
          cardTheme: const CardTheme(
            shadowColor: Colors.white,
            surfaceTintColor: Colors.white,
            color: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffECEBFB),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                // overlayColor: MaterialStateProperty.all(Colors.white),
                ),
          ),
          bottomSheetTheme: const BottomSheetThemeData(
              surfaceTintColor: Colors.white, backgroundColor: Colors.white),
          colorScheme: const ColorScheme.light(background: Colors.white)
              .copyWith(background: Colors.white),
        ),
        routes: {
          '/signin': (context) => SignInScreen(),
          '/subscribe': (context) => SubscriptionExpiredScreen(),
          '/toomanyrequests': (context) => TooManyRequestsScreen(),
        },
        home: Splash());
  }
}
