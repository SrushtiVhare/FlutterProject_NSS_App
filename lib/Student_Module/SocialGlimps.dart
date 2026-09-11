import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// Color Constants (matching AdminPanelPage)
class AppColors {
  static const Color navyBlue = Color(0xFF1A3A52);
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color successGreen = Color(0xFF10B981);
  static const Color darkGrey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NSS Social Glimpse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryOrange,
        scaffoldBackgroundColor: AppColors.white,
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryOrange,
          secondary: AppColors.primaryOrange,
          surface: AppColors.white,
        ),
      ),
      home: const SocialGlimpsePage(),
    );
  }
}

class SocialGlimpsePage extends StatefulWidget {
  const SocialGlimpsePage({Key? key}) : super(key: key);

  @override
  State<SocialGlimpsePage> createState() => _SocialGlimpsePageState();
}

class _SocialGlimpsePageState extends State<SocialGlimpsePage> {
  int _currentView = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.navyBlue, Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x401A3A52),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              titleSpacing: 0,
              toolbarHeight: 80,
              title: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        "assets/Nss_Logo.jpg",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Social Glimpse',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                letterSpacing: 0.5,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Not me,but you',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppColors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.white, AppColors.lightGrey.withOpacity(0.3)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Tab Selection
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryOrange.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTabButton('Photos', 0, Icons.photo_camera),
                      ),
                      Expanded(
                        child: _buildTabButton(
                          'Videos',
                          1,
                          Icons.play_circle_outline,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                if (_currentView == 0) _buildPhotosTab() else _buildVideosTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index, IconData icon) {
    final isActive = _currentView == index;
    return GestureDetector(
      onTap: () => setState(() => _currentView = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [AppColors.primaryOrange, Color(0xFFFF8A3D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isActive ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primaryOrange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? AppColors.white : AppColors.darkGrey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.white : AppColors.darkGrey,
                fontSize: 15,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosTab() {
    final activities = [
      {
        'title': 'Police Station Visit',
        'date': 'Oct 5, 2025',
        'photos': 6,
        'color': AppColors.primaryOrange,
        'images': [
          'assets/pic4.jpg',
          'assets/nss_activity1.jpg',
          'assets/nss_activity2.jpg',
          'assets/nss_activity4.jpg',
          'assets/police5.jpg',
          'assets/Pic2.jpg',
        ],
      },
      {
        'title': 'Tree Plantation Drive',
        'date': 'Oct 1, 2025',
        'photos': 6,
        'color': AppColors.successGreen,
        'images': [
          'assets/Pic2.jpg',
          'assets/pic5.jpg',
          'assets/nss_activity1.jpg',
          'assets/nss_activity4.jpg',
          'assets/nss_activity2.jpg',
          'assets/Pic2.jpg',
        ],
      },
      // {
      //   'title': 'Community Service',
      //   'date': 'Sep 28, 2025',
      //   'photos': 10,
      //   'color': Color(0xFF06B6D4),
      //   'images': [
      //     'assets/community1.jpg',
      //     'assets/community2.jpg',
      //     'assets/community3.jpg',
      //     'assets/community4.jpg',
      //     'assets/community5.jpg',
      //     'assets/community6.jpg',
      //     'assets/community7.jpg',
      //     'assets/community8.jpg',
      //     'assets/community9.jpg',
      //     'assets/community10.jpg',
      //   ],
      // },
      // {
      //   'title': 'Literacy Campaign',
      //   'date': 'Sep 25, 2025',
      //   'photos': 7,
      //   'color': Color(0xFFFB923C),
      //   'images': [
      //     'assets/literacy1.jpg',
      //     'assets/literacy2.jpg',
      //     'assets/literacy3.jpg',
      //     'assets/literacy4.jpg',
      //     'assets/literacy5.jpg',
      //     'assets/literacy6.jpg',
      //     'assets/literacy7.jpg',
      //   ],
      // },
      // {
      //   'title': 'Health Awareness',
      //   'date': 'Sep 20, 2025',
      //   'photos': 9,
      //   'color': Color(0xFFA855F7),
      //   'images': [
      //     'assets/health1.jpg',
      //     'assets/health2.jpg',
      //     'assets/health3.jpg',
      //     'assets/health4.jpg',
      //     'assets/health5.jpg',
      //     'assets/health6.jpg',
      //     'assets/health7.jpg',
      //     'assets/health8.jpg',
      //     'assets/health9.jpg',
      //   ],
      // },
    ];

    return Column(
      children: [
        ...activities.map((activity) {
          return _buildActivityCard(
            title: activity['title'] as String,
            date: activity['date'] as String,
            photoCount: activity['photos'] as int,
            color: activity['color'] as Color,
            images: activity['images'] as List<String>,
          );
        }).toList(),
        // Social Media Connect Section
        _buildSocialMediaSection(),
      ],
    );
  }

  Widget _buildSocialMediaSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.only(top: 3, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // 👈 remove even spacing
          children: [
            _buildSocialButton(
              icon: Icons.facebook,
              color: AppColors.primaryOrange,
              url: 'https://www.facebook.com',
            ),
            _buildSocialButton(
              icon: Icons.camera_alt,
              color: AppColors.primaryOrange,
              url:
                  'https://www.instagram.com/scoe_nss?igsh=MWR1YXp6cHBqOTR1ZQ==',
            ),
            _buildSocialButton(
              icon: Icons.tag,
              color: AppColors.primaryOrange,
              url: 'https://www.twitter.com',
            ),
            _buildSocialButton(
              icon: Icons.linked_camera_outlined,
              color: AppColors.primaryOrange,
              url:
                  'https://www.linkedin.com/company/nss-sinhgad-college-of-engineering/',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required String url,
  }) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        margin: const EdgeInsets.only(
          right: 12,
        ), // 👈 minimal spacing between icons
        padding: const EdgeInsets.all(8), // 👈 small padding for clickable area
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open $url'),
            backgroundColor: AppColors.primaryOrange,
          ),
        );
      }
    }
  }

  Widget _buildActivityCard({
    required String title,
    required String date,
    required int photoCount,
    required Color color,
    required List<String> images,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.2), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "assets/Nss_Logo.jpg",
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navyBlue,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 12,
                                    color: color,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    date,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: color,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryOrange.withOpacity(
                                  0.15,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.photo_library,
                                    size: 12,
                                    color: AppColors.primaryOrange,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$photoCount',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primaryOrange,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Photo Grid - EXACTLY 3 photos per row
              LayoutBuilder(
                builder: (context, constraints) {
                  final spacing = 10.0;
                  final totalSpacing = spacing * 2; // spacing between 3 items
                  final availableWidth = constraints.maxWidth;
                  final photoSize = (availableWidth - totalSpacing) / 3;

                  return Column(
                    children: [
                      // First row - 3 photos
                      Row(
                        children: List.generate(3, (index) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: index < 2 ? spacing : 0,
                              ),
                              child: _buildPhotoItem(
                                context,
                                title,
                                images,
                                index,
                                photoSize,
                                color,
                                photoCount,
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 10),
                      // Second row - 3 photos
                      Row(
                        children: List.generate(3, (index) {
                          final photoIndex = index + 3;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: index < 2 ? spacing : 0,
                              ),
                              child: _buildPhotoItem(
                                context,
                                title,
                                images,
                                photoIndex,
                                photoSize,
                                color,
                                photoCount,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoItem(
    BuildContext context,
    String title,
    List<String> images,
    int photoIndex,
    double photoSize,
    Color color,
    int photoCount,
  ) {
    // Get the correct image for this index
    String imageUrl = photoIndex < images.length
        ? images[photoIndex]
        : images[0]; // Fallback to first image

    return GestureDetector(
      onTap: () {
        _showPhotoViewer(context, title, imageUrl, photoIndex);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                Image.asset(
                  imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: color.withOpacity(0.2),
                      child: Icon(Icons.image, color: color, size: 35),
                    );
                  },
                ),
                if (photoIndex == 5 && photoCount > 6)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.5),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '+${photoCount - 6}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'more',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideosTab() {
    final streetPlays = [
      {
        'title': 'Anti-Plastic Awareness',
        'date': 'Oct 3, 2025',
        'duration': '5:32',
        'views': '1.2K',
        'color': AppColors.primaryOrange,
        'youtubeUrl': 'https://youtu.be/u2uG1bvZGrc?si=fUInRdtwr36CgDsi',
        'thumbnailUrl': 'assets/pic4.jpg',
      },
      {
        'title': 'Save Water Campaign',
        'date': 'Sep 29, 2025',
        'duration': '4:15',
        'views': '980',
        'color': Color(0xFF06B6D4),
        'youtubeUrl': 'https://youtu.be/m-byhF7vo-0?si=kb5atLfqk-vDdo8M',
        'thumbnailUrl': 'assets/pic5.jpg',
      },
      // {
      //   'title': 'Women Empowerment',
      //   'date': 'Sep 22, 2025',
      //   'duration': '6:20',
      //   'views': '1.5K',
      //   'color': Color(0xFFEC4899),
      //   'youtubeUrl': 'https://youtu.be/u2uG1bvZGrc?si=fUInRdtwr36CgDsi',
      //   'thumbnailUrl': 'assets/pic3.jpg',
      // },
      // {
      //   'title': 'Education for All',
      //   'date': 'Sep 15, 2025',
      //   'duration': '5:50',
      //   'views': '890',
      //   'color': Color(0xFFFB923C),
      //   'youtubeUrl': 'https://youtu.be/m-byhF7vo-0?si=kb5atLfqk-vDdo8M',
      //   'thumbnailUrl': 'assets/pic4.jpg',
      // },
      {
        'title': 'Drug Awareness',
        'date': 'Sep 10, 2025',
        'duration': '4:45',
        'views': '1.1K',
        'color': Color(0xFFEF4444),
        'youtubeUrl': 'https://youtu.be/u2uG1bvZGrc?si=fUInRdtwr36CgDsi',
        'thumbnailUrl': 'assets/glimps.jpg',
      },
    ];

    return Column(
      children: streetPlays.map((video) {
        return _buildVideoCard(
          title: video['title'] as String,
          date: video['date'] as String,
          duration: video['duration'] as String,
          views: video['views'] as String,
          color: video['color'] as Color,
          youtubeUrl: video['youtubeUrl'] as String,
          thumbnailUrl: video['thumbnailUrl'] as String,
        );
      }).toList(),
    );
  }

  Widget _buildVideoCard({
    required String title,
    required String date,
    required String duration,
    required String views,
    required Color color,
    required String youtubeUrl,
    required String thumbnailUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () => _showVideoPlayer(context, title, youtubeUrl),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.2), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "assets/Nss_Logo.jpg",
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navyBlue,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryOrange,
                                AppColors.primaryOrange.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryOrange.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            'STREET PLAY',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Image.asset(
                        thumbnailUrl,
                        width: double.infinity,
                        height: 210,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 210,
                            color: color.withOpacity(0.2),
                            child: Icon(
                              Icons.video_library,
                              color: color,
                              size: 60,
                            ),
                          );
                        },
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryOrange,
                                  AppColors.primaryOrange.withOpacity(0.8),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryOrange.withOpacity(
                                    0.5,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              size: 42,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                duration,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: color),
                        const SizedBox(width: 6),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 13,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.navyBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 14,
                          color: AppColors.navyBlue,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$views views',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.navyBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPhotoViewer(
    BuildContext context,
    String title,
    String imageUrl,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.navyBlue, Color(0xFF1976D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/Nss_Logo.jpg",
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      imageUrl,
                      width: double.infinity,
                      height: 320,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 320,
                          color: AppColors.lightGrey,
                          child: const Icon(
                            Icons.image,
                            size: 80,
                            color: AppColors.darkGrey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 4,
                      shadowColor: AppColors.primaryOrange.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVideoPlayer(BuildContext context, String title, String youtubeUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            YouTubeVideoPlayer(title: title, youtubeUrl: youtubeUrl),
      ),
    );
  }
}

// YouTube Video Player Widget
class YouTubeVideoPlayer extends StatefulWidget {
  final String title;
  final String youtubeUrl;

  const YouTubeVideoPlayer({
    Key? key,
    required this.title,
    required this.youtubeUrl,
  }) : super(key: key);

  @override
  State<YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<YouTubeVideoPlayer> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);

    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: true,
          controlsVisibleAtStart: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.navyBlue, Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            titleSpacing: 0,
            toolbarHeight: 80,
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/Nss_Logo.jpg",
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: AppColors.primaryOrange,
            progressColors: ProgressBarColors(
              playedColor: AppColors.primaryOrange,
              handleColor: AppColors.primaryOrange,
              backgroundColor: AppColors.lightGrey,
              bufferedColor: AppColors.primaryOrange.withOpacity(0.3),
            ),
            onReady: () {
              setState(() {
                _isPlayerReady = true;
              });
            },
            onEnded: (data) {
              // Video ended
            },
          ),
          builder: (context, player) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                player,
                const SizedBox(height: 20),
                if (!_isPlayerReady)
                  Column(
                    children: [
                      CircularProgressIndicator(color: AppColors.primaryOrange),
                      const SizedBox(height: 10),
                      const Text(
                        'Loading video...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
