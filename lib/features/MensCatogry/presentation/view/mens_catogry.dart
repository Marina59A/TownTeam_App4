import 'package:flutter/material.dart';
import 'package:townteam_app/features/product/presentaion/view/Product_list_page.dart';

class MensCatogry extends StatelessWidget {
  const MensCatogry({super.key});
  static String id = 'mens_catogry';
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
                      builder: (context) => ProductListPage.mensJackets(),
                    ),
                  );
                },
                child: Image.asset('assets/images/jacket.jpg'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListPage.mensSweatshirts(),
                    ),
                  );
                },
                child: Image.asset('assets/images/sweatshirt_mens.jpg'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListPage.mensPullovers(),
                    ),
                  );
                },
                child: Image.asset('assets/images/pullover.jpg'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListPage.mensShirts(),
                    ),
                  );
                },
                child: Image.asset('assets/images/summer_collection.jpg'),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListPage.mensSportswear(),
                    ),
                  );
                },
                child: Image.asset('assets/images/sportswear.jpg'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
