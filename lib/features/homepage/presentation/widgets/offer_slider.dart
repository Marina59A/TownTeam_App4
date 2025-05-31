import 'package:flutter/material.dart';

class OfferSlider extends StatelessWidget {
  const OfferSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: PageView(
        children: [
          Stack(
            children: [
              Image.network(
                'https://via.placeholder.com/400x300',
                fit: BoxFit.cover,
              ),
              const Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "UNIQUE PICK",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    Text(
                      "40% OFF",
                      style: TextStyle(color: Colors.yellow, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Image.network(
                'https://via.placeholder.com/400x300',
                fit: BoxFit.cover,
              ),
              const Positioned(
                bottom: 20,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "WINTER SALE",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    Text(
                      "50% OFF",
                      style: TextStyle(color: Colors.yellow, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
