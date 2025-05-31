import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:townteam_app/common/models/auth_provider.dart';
import 'package:townteam_app/common/models/cart_provider.dart';
import 'package:townteam_app/common/models/favorites_provider.dart';
import 'package:townteam_app/common/models/language_provider.dart';
import 'package:townteam_app/common/models/nav_provider.dart';
import 'package:townteam_app/common/services/git_it_service.dart';
import 'package:townteam_app/features/AccessoriesCatogry/accessories_catogry.dart';
import 'package:townteam_app/features/Cart/presentation/view/cart_page.dart';
import 'package:townteam_app/features/KidsCatogry/presentation/view/kids_catogry.dart';
import 'package:townteam_app/features/MensCatogry/presentation/view/mens_catogry.dart';
import 'package:townteam_app/features/account/presentation/widgets/custom_edit_profile.dart';
import 'package:townteam_app/features/auth/presentation/view/login_page.dart';
import 'package:townteam_app/features/auth/presentation/view/signUp_view.dart';
import 'package:townteam_app/features/homepage/presentation/view/home_page.dart';
import 'package:townteam_app/features/splashScreen/presentation/view/landing_page.dart';
import 'package:townteam_app/features/product/presentaion/view/Product_list_page.dart';
import 'package:townteam_app/features/search/presentation/pages/search_page.dart';
import 'package:townteam_app/features/account/presentation/view/my_account_page.dart';
import 'package:townteam_app/features/account/presentation/view/my_favorites_page.dart';
import 'package:townteam_app/l10n/app_localizations.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupGitIt();
  runApp(const TownTeamApp());
}

class TownTeamApp extends StatelessWidget {
  const TownTeamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (_) => CartProvider(),
          update: (_, auth, cart) {
            if (auth.userId != null) {
              cart?.setUserId(auth.userId!);
            }
            return cart ?? CartProvider();
          },
        ),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'TownTeam App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            locale: languageProvider.currentLocale,
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            routes: {
              '/landing': (context) => const LandingPage(),
              '/home': (context) => HomePage(),
              '/cart': (context) => const CartPage(),
              '/mensjackets': (context) => ProductListPage.mensJackets(),
              '/menssweatshirts': (context) =>
                  ProductListPage.mensSweatshirts(),
              '/menspullover': (context) => ProductListPage.mensPullovers(),
              '/mensshirts': (context) => ProductListPage.mensShirts(),
              '/menssports': (context) => ProductListPage.mensSportswear(),
              '/kidsjackets': (context) => ProductListPage.kidsJackets(),
              '/kidspullover': (context) => ProductListPage.kidsPullovers(),
              '/kidsswitchirts': (context) => ProductListPage.kidsSweatshirts(),
              '/kidsjeans': (context) => ProductListPage.kidsJeans(),
              '/perfumes': (context) => ProductListPage.perfumes(),
              '/accessories': (context) => const AccessoriesCatogry(),
              '/socks': (context) => ProductListPage.socks(),
              '/bags': (context) => ProductListPage.bags(),
              '/bodysplash': (context) => ProductListPage.bodySplash(),
              '/deodorants': (context) => ProductListPage.deodorants(),
              '/wallets': (context) => ProductListPage.wallets(),
              '/icecaps': (context) => ProductListPage.iceCaps(),
              LoginPage.id: (context) => const LoginPage(),
              SignupView.id: (context) => const SignupView(),
              MensCatogry.id: (context) => const MensCatogry(),
              KidsCatogry.id: (context) => const KidsCatogry(),
              MyAccountPage.id: (context) => const MyAccountPage(),
              MyFavoritesPage.id: (context) => const MyFavoritesPage(),
              CustomEditProfile.id: (context) => const CustomEditProfile(),
              SearchPage.id: (context) => const SearchPage(),
            },
            initialRoute: '/landing',
            // initialRoute: MyFavoritesPage.id,

            onGenerateRoute: (settings) {
              if (settings.name == '/product') {
                final args = settings.arguments as Map<String, String>;
                final pathParts = args['path']!.split('/');
                return MaterialPageRoute(
                  builder: (context) => ProductListPage(
                    title: args['title']!,
                    collectionPath: pathParts[0],
                    documentPath: pathParts[1],
                    subcollectionPath: args['subcategory']!,
                    category: pathParts[0],
                  ),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
