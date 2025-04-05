import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:online_training_template/providers/current_user_notifier.dart';
import 'package:online_training_template/ui/app_theme.dart';
import 'package:online_training_template/ui/controllers/theme_controller.dart';
import 'package:online_training_template/viewmodel/auth_viewmodel.dart';

import 'app/di/dependency_injection.dart';
import 'generated/l10n.dart';
import 'ui/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).initSharedPreferences();
  await container.read(authViewModelProvider.notifier).getData();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => setUpAll().then((value) {
        runApp(UncontrolledProviderScope(container: container, child: MyApp()));
      }));
}

Future setUpAll() async {
  await initServiceLocator();
  Get.put(appSL<ThemeController>(), permanent: true);
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);

    print(currentUser?.token);

    return GetMaterialApp(
      onGenerateTitle: (ctx) {
        return 'Prayashee';
      },
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      supportedLocales: S.delegate.supportedLocales,
      themeMode: Get.find<ThemeController>().currentThemeMode.value!,
      theme: AppTheme.light().themeData,
      darkTheme: AppTheme.dark().themeData,
      initialRoute:
          currentUser == null ? AppPages.initial : AppPages.redirectHome,
      getPages: AppPages.routes,
      onInit: () async {
        await Get.find<ThemeController>().setThemeData(context);
      },
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
