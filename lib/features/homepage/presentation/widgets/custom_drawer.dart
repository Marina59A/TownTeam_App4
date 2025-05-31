import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:townteam_app/common/models/auth_provider.dart';
import 'package:townteam_app/common/models/language_provider.dart';
import 'package:townteam_app/features/KidsCatogry/presentation/view/kids_catogry.dart';
import 'package:townteam_app/features/MensCatogry/presentation/view/mens_catogry.dart';
import 'package:townteam_app/features/account/presentation/view/my_account_page.dart';
import 'package:townteam_app/features/auth/presentation/view/login_page.dart';
import 'package:townteam_app/l10n/app_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);

    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 50),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'TOWN TEAM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 20),
                _buildDrawerItem(
                  icon: Icons.home_outlined,
                  title: l10n.home,
                  onTap: () => Navigator.pushNamed(context, '/home'),
                ),
                _buildDrawerItem(
                  icon: Icons.person_outline,
                  title: l10n.mens,
                  onTap: () => Navigator.pushNamed(
                    context,
                    MensCatogry.id,
                    // '/product',
                    // arguments: 'mens',
                  ),
                ),
                _buildDrawerItem(
                  icon: Icons.child_care,
                  title: l10n.kids,
                  onTap: () => Navigator.pushNamed(context, KidsCatogry.id
                      // '/product',
                      // arguments: 'kids',
                      ),
                ),
                _buildDrawerItem(
                  icon: Icons.wb_sunny_outlined,
                  title: l10n.perfumes,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/perfumes',
                    // '/product',
                    // arguments: 'summer',
                  ),
                ),
                _buildDrawerItem(
                  icon: Icons.new_releases_outlined,
                  title: l10n.winterCollection,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/menspullover',
                    // '/product',
                    // arguments: 'winter',
                  ),
                ),
                _buildDrawerItem(
                  icon: Icons.local_offer_outlined,
                  title: l10n.accessories,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/accessories',
                    // '/product',
                    // arguments: 'promotions',
                  ),
                ),
                _buildDrawerItem(
                  icon: Icons.person_outline,
                  title: l10n.myAccount,
                  onTap: () {
                    if (authProvider.isLoggedIn) {
                      Navigator.pushNamed(context, MyAccountPage.id);
                    } else {
                      Navigator.pushNamed(context, LoginPage.id);
                    }
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.headset_mic_outlined,
                  title: l10n.customerService,
                  onTap: () {},
                ),
                _buildDrawerItem(
                  icon: Icons.contact_support_outlined,
                  title: l10n.contactUs,
                  onTap: () {},
                ),
                _buildDrawerItem(
                  icon: Icons.shopping_bag_outlined,
                  title: l10n.howToPurchase,
                  onTap: () {},
                ),
                _buildDrawerItem(
                  icon: Icons.local_shipping_outlined,
                  title: l10n.deliveryAndReturns,
                  onTap: () {},
                ),
                _buildDrawerItem(
                  icon: Icons.facebook,
                  title: l10n.facebook,
                  onTap: () {},
                ),
                _buildDrawerItem(
                  icon: Icons.email_outlined,
                  title: l10n.email,
                  onTap: () {},
                ),
                _buildDrawerItem(
                  icon: Icons.language,
                  title: l10n.language,
                  onTap: () {
                    final languageProvider =
                        Provider.of<LanguageProvider>(context, listen: false);
                    languageProvider.toggleLanguage();
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        l10n.facebook,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const Text(' · ', style: TextStyle(color: Colors.white)),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        l10n.email,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Provider.of<LanguageProvider>(context)
                                  .currentLocale
                                  .languageCode ==
                              'en'
                          ? 'English, EGP'
                          : 'العربية, ج.م',
                      style: const TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        final languageProvider = Provider.of<LanguageProvider>(
                            context,
                            listen: false);
                        languageProvider.toggleLanguage();
                      },
                      child: Text(
                        l10n.change,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }
}
