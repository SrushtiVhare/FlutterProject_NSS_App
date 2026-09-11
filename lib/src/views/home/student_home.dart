// import 'package:flutter/material.dart';
// import 'package:parivartan/Student_Module/Attendence.dart';
// import 'package:parivartan/Student_Module/HiringProcess.dart';
// import 'package:parivartan/Student_Module/SocialGlimps.dart';
// //import 'package:parivartan/student_Module/Attendence.dart' hide AttendanceApp;
// //import 'package:parivartan/student_Module/HiringProcess.dart'
// //  hide HiringProcessPage;
// //import 'package:parivartan/student_Module/SocialGlimps.dart'
// //  hide SocialGlimpsePage;
// import 'package:parivartan/student_Module/StudentChat.dart';

// void main() {
//   runApp(
//     MaterialApp(home: StudentHomePage(), debugShowCheckedModeBanner: false),
//   );
// }

// class AppColors {
//   static const Color navyBlue = Color(0xFF1A3A52);
//   static const Color primaryOrange = Color(0xFFF97316);
//   static const Color lightGrey = Color(0xFFF5F5F5);
//   static const Color darkGrey = Color(0xFF707070);
//   static const Color white = Colors.white;
//   static const Color successGreen = Color(0xFF4CAF50);
// }

// class StudentHomePage extends StatelessWidget {
//   const StudentHomePage({super.key});

//   Widget _buildQuickAction({
//     required String title,
//     required String subtitle,
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: color.withOpacity(0.2)),
//             boxShadow: [
//               BoxShadow(
//                 color: color.withOpacity(0.1),
//                 blurRadius: 15,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(icon, color: color, size: 24),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.navyBlue,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       subtitle,
//                       style: TextStyle(color: AppColors.darkGrey, fontSize: 13),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(
//                 Icons.arrow_forward_ios,
//                 size: 16,
//                 color: AppColors.primaryOrange,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatsCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 28),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: AppColors.navyBlue,
//             ),
//           ),
//           Text(
//             title,
//             style: TextStyle(fontSize: 12, color: AppColors.darkGrey),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.lightGrey,
//       appBar: AppBar(
//         toolbarHeight: 100,
//         backgroundColor: AppColors.navyBlue,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [AppColors.navyBlue, Color(0xFF1976D2)],
//             ),
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Row(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(25),
//                     child: Image.asset(
//                       "assets/Nss_Logo.jpg",
//                       width: 50,
//                       height: 50,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           'Welcome Back!',
//                           style: TextStyle(
//                             color: AppColors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Text(
//                           'Volunteer/Student Dashboard',
//                           style: TextStyle(
//                             color: AppColors.white.withOpacity(0.8),
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Container(
//                   //   padding: const EdgeInsets.symmetric(
//                   //     horizontal: 12,
//                   //     vertical: 6,
//                   //   ),
//                   //   decoration: BoxDecoration(
//                   //     color: AppColors.primaryOrange,
//                   //     borderRadius: BorderRadius.circular(20),
//                   //   ),
//                   //   child: const Text(
//                   //     'NSS',
//                   //     style: TextStyle(
//                   //       color: AppColors.white,
//                   //       fontSize: 12,
//                   //       fontWeight: FontWeight.bold,
//                   //     ),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Ready to make a difference?',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.navyBlue,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Join events, track your impact, and grow with the community',
//               style: TextStyle(color: AppColors.navyBlue, fontSize: 14),
//             ),
//             const SizedBox(height: 20),

//             // Stats Row
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildStatsCard(
//                     title: 'Events Joined',
//                     value: '12',
//                     icon: Icons.event,
//                     color: AppColors.primaryOrange,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _buildStatsCard(
//                     title: 'Hours Served',
//                     value: '48',
//                     icon: Icons.access_time,
//                     color: AppColors.successGreen,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _buildStatsCard(
//                     title: 'Certificates',
//                     value: '3',
//                     icon: Icons.verified,
//                     color: AppColors.navyBlue,
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 24),

//             // Quick Actions
//             _buildQuickAction(
//               title: 'Social Glimpse',
//               subtitle: 'Discover nearby volunteer opportunities',
//               icon: Icons.search,
//               color: AppColors.primaryOrange,
//               onTap: () {
//                 // Navigate to SocialGlimpsePage
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const SocialGlimpsePage(),
//                   ),
//                 );
//               },
//             ),

//             _buildQuickAction(
//               title: 'Group Chat',
//               subtitle: 'View your registered events',
//               icon: Icons.event_note,
//               color: AppColors.successGreen,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const MemberApp()),
//                 );
//               },
//             ),

//             _buildQuickAction(
//               title: 'Attendence',
//               subtitle: 'Log your volunteer hours',
//               icon: Icons.timer,
//               color: AppColors.navyBlue,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const AttendanceApp(),
//                   ),
//                 );
//               },
//             ),

//             _buildQuickAction(
//               title: 'Hiring Process',
//               subtitle: 'Download your certificates',
//               icon: Icons.verified,
//               color: Colors.purple,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const HiringProcessPage(),
//                   ),
//                 );
//               },
//             ),

//             // _buildQuickAction(
//             //   title: 'Community',
//             //   subtitle: 'Connect with fellow volunteers',
//             //   icon: Icons.people,
//             //   color: Colors.teal,
//             //   onTap: () {},
//             // ),

//             // _buildQuickAction(
//             //   title: 'Impact Report',
//             //   subtitle: 'See your contribution to society',
//             //   icon: Icons.analytics,
//             //   color: Colors.indigo,
//             //   onTap: () {},
//             // ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:parivartan/Student_Module/AboutUsPage.dart';
import 'package:parivartan/Student_Module/Attendence.dart';
import 'package:parivartan/Student_Module/HiringProcess.dart';
import 'package:parivartan/Student_Module/SocialGlimps.dart';
//import 'package:parivartan/student_Module/Attendence.dart' hide AttendanceApp;
//import 'package:parivartan/student_Module/HiringProcess.dart'
//  hide HiringProcessPage;
//import 'package:parivartan/student_Module/SocialGlimps.dart'
//  hide SocialGlimpsePage;
import 'package:parivartan/student_Module/StudentChat.dart';

void main() {
  runApp(
    MaterialApp(home: StudentHomePage(), debugShowCheckedModeBanner: false),
  );
}

class AppColors {
  static const Color navyBlue = Color(0xFF1A3A52);
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF707070);
  static const Color white = Colors.white;
  static const Color successGreen = Color(0xFF4CAF50);
}

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  Widget _buildQuickAction({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: AppColors.darkGrey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.primaryOrange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.navyBlue,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: AppColors.darkGrey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              // Icon(Icons.logout, color: AppColors.primaryOrange),
              // SizedBox(width: 12),
              // Text('Logout'),
            ],
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.darkGrey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: AppColors.navyBlue,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.navyBlue, Color(0xFF1976D2)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      "assets/Nss_Logo.jpg",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Student Dashboard',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Not me,but you!',
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    decoration: BoxDecoration(
                      //border: Border.all(color: Colors.white, width: 1.2),
                      //borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      // icon: const Icon(
                      //   Icons.logout,
                      //   color: Colors.white,
                      //   size: 20,
                      // ),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        backgroundColor: Colors.white.withOpacity(
                          0.1,
                        ), // translucent effect
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   'Ready to make a difference?',
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //     color: AppColors.navyBlue,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // const Text(
            //   'Join events, track your impact, and grow with the community',
            //   style: TextStyle(color: AppColors.navyBlue, fontSize: 14),
            // ),
            // const SizedBox(height: 20),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatsCard(
                    title: 'Events Joined',
                    value: '12',
                    icon: Icons.event,
                    color: AppColors.primaryOrange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatsCard(
                    title: 'Hours Served',
                    value: '48',
                    icon: Icons.access_time,
                    color: AppColors.successGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatsCard(
                    title: 'Certificates',
                    value: '3',
                    icon: Icons.verified,
                    color: AppColors.navyBlue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Quick Actions
            _buildQuickAction(
              title: 'Social Glimpse',
              subtitle: 'Be a part of our achievements.',
              icon: Icons.camera_alt_outlined,
              color: AppColors.successGreen,
              onTap: () {
                // Navigate to SocialGlimpsePage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SocialGlimpsePage(),
                  ),
                );
              },
            ),

            _buildQuickAction(
              title: 'Group Chat',
              subtitle: 'Connect, share, and grow together.',
              icon: Icons.groups,
              color: Colors.redAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MemberApp()),
                );
              },
            ),
            _buildQuickAction(
              title: 'Hiring Process',
              subtitle: 'Join us and be a part of us.',
              icon: Icons.edit_note,
              color: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HiringProcessPage(),
                  ),
                );
              },
            ),
            _buildQuickAction(
              title: 'Mark Attendence',
              subtitle: 'Stay punctual, mark your presence.',
              icon: Icons.calendar_today,
              color: AppColors.primaryOrange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AttendanceScreen(),
                  ),
                );
              },
            ),

            _buildQuickAction(
              title: 'About Us',
              subtitle: 'Connect with us',
              icon: Icons.people,
              color: const Color.fromARGB(255, 241, 171, 127),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ParivartanProjectPage(),
                  ),
                );
              },
            ),

            // _buildQuickAction(
            //   title: 'Impact Report',
            //   subtitle: 'See your contribution to society',
            //   icon: Icons.analytics,
            //   color: Colors.indigo,
            //   onTap: () {},
            // ),
          ],
        ),
      ),
    );
  }
}
