import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class IntroSlider extends StatefulWidget {
  final VoidCallback onComplete;
  const IntroSlider({Key? key, required this.onComplete}) : super(key: key);

  @override
  IntroSliderState createState() => IntroSliderState();
}

class IntroSliderState extends State<IntroSlider> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, dynamic>> slides = [
    {
      'title': 'Join the Movement',
      'subtitle': 'Be the Change',
      'body':
          'Connect with like-minded volunteers and make a real difference in your community.',
      'icon': Icons.people_alt,
      'color': AppColors.navyBlue,
    },
    {
      'title': 'Organize Events',
      'subtitle': 'Create Impact',
      'body':
          'Plan health camps, awareness drives, and community service programs with ease.',
      'icon': Icons.event,
      'color': AppColors.navyBlue,
    },
    {
      'title': 'Track Progress',
      'subtitle': 'Transparent Impact',
      'body':
          'Monitor donations, volunteer hours, and community impact with complete transparency.',
      'icon': Icons.analytics,
      'color': AppColors.navyBlue,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: widget.onComplete,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.navyBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (index) => setState(() => currentIndex = index),
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated Icon
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                slide['color'].withValues(alpha: 0.1),
                                slide['color'].withValues(alpha: 0.05),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: slide['color'].withValues(alpha: 0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            slide['icon'],
                            size: 80,
                            color: slide['color'],
                          ),
                        ),
                        const SizedBox(height: 50),

                        // Subtitle
                        Text(
                          slide['subtitle'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: slide['color'],
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),

                        // Title
                        Text(
                          slide['title'],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navyBlue,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // Description
                        Text(
                          slide['body'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.darkGrey,
                            height: 1.6,
                            letterSpacing: 0.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom section with dots and button
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Dots indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: currentIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentIndex == index
                              ? slides[currentIndex]['color']
                              : AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Next/Get Started button
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            slides[currentIndex]['color'],
                            slides[currentIndex]['color'].withValues(
                              alpha: 0.8,
                            ),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: slides[currentIndex]['color'].withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (currentIndex == slides.length - 1) {
                            widget.onComplete();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          currentIndex == slides.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
