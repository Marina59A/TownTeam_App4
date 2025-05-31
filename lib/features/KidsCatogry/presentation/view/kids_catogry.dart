import 'package:flutter/material.dart';
import 'package:townteam_app/features/product/presentaion/view/Product_list_page.dart';

class KidsCatogry extends StatelessWidget {
  const KidsCatogry({super.key});
  static String id = 'kids_catogry';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListPage.kidsJackets(),
                    ),
                  );
                },
                child: Image.asset('assets/images/jacket_kids.jpg'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListPage.kidsSweatshirts(),
                    ),
                  );
                },
                child: Image.asset('assets/images/sweatshirt_kids.jpg'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListPage.kidsPullovers(),
                    ),
                  );
                },
                child: Image.asset('assets/images/pullover_kids.jpg'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListPage.kidsJeans(),
                    ),
                  );
                },
                child: Image.asset('assets/images/summercollectionkids.jpg'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
