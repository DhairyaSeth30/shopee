
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    ScreenUtil.ensureScreenSize(),
  ]);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
        (value) => runApp(const ProviderScope(child: MyApp())),
  );
}

// Future<void> preloadSVGs(List<String> paths) async {
//   for (final path in paths) {
//     final loader = SvgAssetLoader(path);
//     await svg.cache.putIfAbsent(
//       loader.cacheKey(null),
//           () => loader.loadBytes(null),
//     );
//   }
// }

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isDarkMode = ref.watch(themeProvider).isDarkMode;

    return ScreenUtilInit(
      splitScreenMode: true,
      ensureScreenSize: true,
      child: MaterialApp.router(
        routerConfig: router,
        // theme: lightTheme,
        // darkTheme: darkTheme,
        // themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        scrollBehavior: const ScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.trackpad,
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
          },
        ),
        title: 'Shopee',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
