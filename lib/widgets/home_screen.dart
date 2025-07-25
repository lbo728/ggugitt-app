import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              BrandingTitle(),
              SizedBox(height: 40),
              Expanded(
                child: DescriptionSection(),
              ),
              HeroImage(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class BrandingTitle extends StatelessWidget {
  const BrandingTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'GGUGITT',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이제 연속적인 투표도 해보세요!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            height: 1.3,
          ),
        ),
        SizedBox(height: 16),
        Text(
          '가끔... 투표가 끊겨서 아쉬운...\n그런 때 있지 않나요?',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class HeroImage extends StatelessWidget {
  const HeroImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.width - 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
          image: AssetImage('assets/images/img-home.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
