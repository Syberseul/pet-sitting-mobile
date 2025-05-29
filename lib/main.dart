import 'package:colorful_print/colorful_print.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_projects/constants/c_routes.dart';
import 'package:flutter_projects/language/localization_service.dart';
import 'package:flutter_projects/modules/user_preference.dart';
import 'package:flutter_projects/providers/auth_provider.dart';
import 'package:flutter_projects/providers/owner_provider.dart';
import 'package:flutter_projects/providers/tour_provider.dart';
import 'package:flutter_projects/screens/auth_screen/sign_up_screen/index.dart';
import 'package:flutter_projects/screens/dashboard/index.dart';
import 'package:flutter_projects/utils/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");

    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.get("FIREBASE_API_KEY"),
        appId: dotenv.get("FIREBASE_APP_ID"),
        messagingSenderId: dotenv.get("FIREBASE_MESSAGING_SENDER_ID"),
        projectId: dotenv.get("FIREBASE_PROJECT_ID"),
      ),
    );

    _setupFCMHandlers();

    final userPreference = await UserPreference.load();
    final initLocal = Locale(userPreference.language);

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => TourProvider()),
          ChangeNotifierProvider(create: (_) => OwnerProvider()),
        ],
        child: MyApp(initialLocale: initLocal),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint("初始化失败: $e");
    debugPrint("堆栈跟踪: $stackTrace");

    // 可选：显示错误界面或回退逻辑
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              "Failed initialize application, please contact support.",
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  final Locale initialLocale;

  const MyApp({super.key, required this.initialLocale});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  void setLocale(Locale newLocale) {
    setState(() => _locale = newLocale);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        locale: _locale,
        supportedLocales: [Locale("en", "US"), Locale("zh", "CN")],
        localizationsDelegates: [
          _AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.lightBlueAccent[100],
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
            floatingLabelStyle: TextStyle(
              color: Colors.lightBlueAccent,
              fontWeight: FontWeight.w600,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        title: "Your own dog sitting calendar",
        initialRoute: Routes.signInScreen,
        routes: {
          Routes.signInScreen: (context) => SignInRoutes.getRoute(context),
          Routes.signUpScreen: (context) => SignUpScreen(),
          Routes.dashboardScreen: (context) => Dashboard(),
        },
      ),
    );
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

void _setupFCMHandlers() {
  // ----------------------------
  // 1. 处理前台通知（App打开时）
  // ----------------------------
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    _showForegroundNotification(message);
  });

  // ----------------------------
  // 2. 处理后台/退出状态通知点击
  // ----------------------------
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    printColor("should jump to details page", textColor: TextColor.yellow);
  });

  // ----------------------------
  // 3. 处理App未启动时通知点击（可选）
  // ----------------------------
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null)
      printColor("should jump to details page", textColor: TextColor.yellow);
  });
}

void _showForegroundNotification(RemoteMessage message) {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'high_importance_channel',
        '重要通知',
        icon: '@drawable/notification_icon',
        importance: Importance.max,
        priority: Priority.high,
      );

  if (message.notification != null) {
    FlutterLocalNotificationsPlugin().show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(android: androidPlatformChannelSpecifics),
    );
  }
}
