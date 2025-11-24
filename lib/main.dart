import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/auth/register_screen.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/cubit/auth_cubit.dart';


// باقي الصفحات
import 'splash.dart';
import 'onboarding.dart';
import 'features/auth/login.dart';
import 'home.dart';
import 'product.dart';
import 'product_detail.dart';
import 'favorites.dart';
import 'cart.dart';
import 'makeup.dart';
import 'furniture.dart';
import 'perfume.dart';
import 'foods.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const AhmedsStoreApp());
}

class AhmedsStoreApp extends StatelessWidget {
  const AhmedsStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (_, __) => MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (_) => AuthCubit(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Ahmed's Store",
          theme: ThemeData(
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: const Color(0xFFF9F9F9),
            colorScheme: const ColorScheme.light(primary: Color(0xFF6C8C6E)),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFF9F9F9),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black87),
              titleTextStyle: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          initialRoute: Splash.routeName,

          routes: {
            Splash.routeName: (_) => Splash(),
            Onboarding.routeName: (_) => Onboarding(),
            LoginScreen.routeName: (_) => LoginScreen(),
            RegisterScreen.routeName: (_) => RegisterScreen(),
            HomePage.routeName: (_) => HomePage(),
            ProductPage.routeName: (_) => ProductPage(),
            ProductDetail.routeName: (_) => ProductDetail(),
            FavoritesPage.routeName: (_) => FavoritesPage(),
            CartPage.routeName: (_) => CartPage(),
            MakeupPage.routeName: (_) => MakeupPage(),
            FurniturePage.routeName: (_) => FurniturePage(),
            PerfumePage.routeName: (_) => PerfumePage(),
            FoodsPage.routeName: (_) => FoodsPage(),
          },
        ),
      ),
    );
  }
}
