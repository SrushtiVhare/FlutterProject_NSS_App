// import 'package:flutter/material.dart';
// import '../../utils/constants.dart';

// class AnimatedSplash extends StatefulWidget {
//   final VoidCallback onComplete;
//   const AnimatedSplash({super.key, required this.onComplete});

//   @override
//   State<AnimatedSplash> createState() => _AnimatedSplashState();
// }

// class _AnimatedSplashState extends State<AnimatedSplash>
//     with TickerProviderStateMixin {
//   late AnimationController _logoController;
//   late AnimationController _textController;
//   late AnimationController _taglineController;

//   late Animation<double> _logoScale;
//   late Animation<double> _logoOpacity;
//   late Animation<double> _textSlide;
//   late Animation<double> _taglineFade;

//   @override
//   void initState() {
//     super.initState();
//     _setupAnimations();
//     _startAnimationSequence();
//   }

//   void _setupAnimations() {
//     _logoController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );

//     _textController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );

//     _taglineController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );

//     _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
//     );

//     _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _logoController, curve: const Interval(0.0, 0.8)),
//     );

//     _textSlide = Tween<double>(begin: 50.0, end: 0.0).animate(
//       CurvedAnimation(parent: _textController, curve: Curves.easeOutBack),
//     );

//     _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _taglineController, curve: Curves.easeIn),
//     );
//   }

//   void _startAnimationSequence() async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     _logoController.forward();

//     await Future.delayed(const Duration(milliseconds: 800));
//     _textController.forward();

//     await Future.delayed(const Duration(milliseconds: 500));
//     _taglineController.forward();

//     await Future.delayed(const Duration(milliseconds: 2000));
//     widget.onComplete();
//   }

//   @override
//   void dispose() {
//     _logoController.dispose();
//     _textController.dispose();
//     _taglineController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFF0D47A1),
//               Color(0xFF1976D2),
//               Color(0xFF42A5F5),
//               Color(0xFF64B5F6),
//             ],
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Animated Logo
//             AnimatedBuilder(
//               animation: _logoController,
//               builder: (context, child) {
//                 return Transform.scale(
//                   scale: _logoScale.value,
//                   child: Opacity(
//                     opacity: _logoOpacity.value,
//                     child: Container(
//                       width: 180,
//                       height: 180,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         // borderRadius: BorderRadiusDirectional.circular(23),
//                         color: AppColors.white.withValues(alpha: 0.1),
//                         boxShadow: [
//                           BoxShadow(
//                             color: AppColors.primaryOrange.withValues(
//                               alpha: 0.4,
//                             ),
//                             blurRadius: 40,
//                             spreadRadius: 10,
//                           ),
//                           // BoxShadow(
//                           //   color: AppColors.white.withValues(alpha: 0.2),
//                           //   blurRadius: 20,
//                           //   spreadRadius: 5,
//                           // ),
//                         ],
//                       ),
//                       child: ClipRRect(
//                         child: Container(
//                           padding: const EdgeInsets.all(20),
//                           child: Image.asset(
//                             'assets/Nss_Logo.jpg',
//                             fit: BoxFit.contain,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),

//             const SizedBox(height: 50),

//             // Animated App Name
//             AnimatedBuilder(
//               animation: _textController,
//               builder: (context, child) {
//                 return Transform.translate(
//                   offset: Offset(0, _textSlide.value),
//                   child: Text(
//                     'PARIVARTAN',
//                     style: TextStyle(
//                       fontSize: 42,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.white,
//                       letterSpacing: 4,
//                       shadows: [
//                         Shadow(
//                           color: Colors.black.withValues(alpha: 0.4),
//                           blurRadius: 15,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 );
//               },
//             ),

//             const SizedBox(height: 20),

//             // Animated Tagline
//             AnimatedBuilder(
//               animation: _taglineController,
//               builder: (context, child) {
//                 return Opacity(
//                   opacity: _taglineFade.value,
//                   child: Column(
//                     children: [
//                       Text(
//                         'Not Me, But You',
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.white.withValues(alpha: 0.95),
//                           letterSpacing: 1.5,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         'National Service Scheme',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: AppColors.white.withValues(alpha: 0.8),
//                           letterSpacing: 1.2,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Building a Better Tomorrow',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: AppColors.white.withValues(alpha: 0.7),
//                           letterSpacing: 0.8,
//                           fontStyle: FontStyle.italic,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),

//             const SizedBox(height: 80),

//             // Loading indicator
//             AnimatedBuilder(
//               animation: _taglineController,
//               builder: (context, child) {
//                 return Opacity(
//                   opacity: _taglineFade.value,
//                   child: Column(
//                     children: [
//                       const SizedBox(
//                         width: 35,
//                         height: 35,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 3,
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             AppColors.white,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Loading...',
//                         style: TextStyle(
//                           color: AppColors.white.withValues(alpha: 0.8),
//                           fontSize: 14,
//                           letterSpacing: 1,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class AnimatedSplash extends StatefulWidget {
  final VoidCallback onComplete;
  const AnimatedSplash({super.key, required this.onComplete});

  @override
  State<AnimatedSplash> createState() => _AnimatedSplashState();
}

class _AnimatedSplashState extends State<AnimatedSplash>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _taglineController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textSlide;
  late Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimationSequence();
  }

  void _setupAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0.0, 0.8)),
    );

    _textSlide = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutBack),
    );

    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeIn),
    );
  }

  void _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _taglineController.forward();

    await Future.delayed(const Duration(milliseconds: 2000));
    widget.onComplete();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.navyBlue,
              Color(0xFF1976D2),
              Color(0xFF42A5F5),
              Color(0xFF64B5F6),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Animated Logo
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoScale.value,
                  child: Opacity(
                    opacity: _logoOpacity.value,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        //color: AppColors.white.withValues(alpha: 0.1),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryOrange.withValues(
                              alpha: 0.4,
                            ),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: Image.asset(
                              'assets/Nss_Logo.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 50),

            // Animated App Name
            // AnimatedBuilder(
            //   animation: _textController,
            //   builder: (context, child) {
            //     return Transform.translate(
            //       offset: Offset(0, _textSlide.value),
            //       child: Text(
            //         'परिवर्तन',
            //         style: TextStyle(
            //           fontSize: 42,
            //           fontWeight: FontWeight.bold,
            //           color: AppColors.white,
            //           letterSpacing: 4,
            //           shadows: [
            //             Shadow(
            //               color: Colors.black.withValues(alpha: 0.4),
            //               blurRadius: 15,
            //               offset: const Offset(0, 3),
            //             ),
            //           ],
            //         ),
            //         textAlign: TextAlign.center,
            //       ),
            //     );
            //   },
            // ),
            AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _textSlide.value),
                  child: Text(
                    'परिवर्तन', // Marathi text
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontFamily: 'NotoSansDevanagari', // 👈 important
                      letterSpacing: 4,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 15,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Animated Tagline
            AnimatedBuilder(
              animation: _taglineController,
              builder: (context, child) {
                return Opacity(
                  opacity: _taglineFade.value,
                  child: Column(
                    children: [
                      Text(
                        'Not Me, But You',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white.withValues(alpha: 0.95),
                          letterSpacing: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'National Service Scheme',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.white.withValues(alpha: 0.8),
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Building a Better Tomorrow',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.white.withValues(alpha: 0.7),
                          letterSpacing: 0.8,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 80),

            // Loading indicator
            AnimatedBuilder(
              animation: _taglineController,
              builder: (context, child) {
                return Opacity(
                  opacity: _taglineFade.value,
                  child: Column(
                    children: [
                      const SizedBox(
                        width: 35,
                        height: 35,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading...',
                        style: TextStyle(
                          color: AppColors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
