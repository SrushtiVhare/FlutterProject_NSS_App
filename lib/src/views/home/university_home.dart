// import 'package:firebase_core/firebase_core.dart';

// import 'package:flutter/material.dart';
// import 'package:parivartan/University_Module/AcceptDonation.dart';
// import 'package:parivartan/University_Module/AcceptRequriements.dart';
// import 'package:parivartan/University_Module/Firebase_Initializer.dart';
// import 'package:parivartan/University_Module/HealthCamps.dart';
// import 'package:parivartan/University_Module/UniGroupChat.dart';

// class AppColors {
//   static const Color navyBlue = Color(0xFF1A3A52);
//   static const Color primaryOrange = Color(0xFFF97316);
//   static const Color successGreen = Color(0xFF10B981);
//   static const Color darkGrey = Color(0xFF6B7280);
//   static const Color lightGrey = Color(0xFFF3F4F6);
//   static const Color white = Color(0xFFFFFFFF);
// }

// // void main() {
// //   runApp(
// //     MaterialApp(home: UniversityHomePage(), debugShowCheckedModeBanner: false),
// //   );
// // }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(
//     MaterialApp(home: UniversityHomePage(), debugShowCheckedModeBanner: false),
//   );
// }

// class UniversityHomePage extends StatelessWidget {
//   const UniversityHomePage({super.key});

//   Widget _buildManagementCard({
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
//               colors: [
//                 color.withValues(alpha: 0.1),
//                 color.withValues(alpha: 0.05),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: color.withValues(alpha: 0.2)),
//             boxShadow: [
//               BoxShadow(
//                 color: color.withValues(alpha: 0.1),
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
//                   color: color.withValues(alpha: 0.15),
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
//               Icon(Icons.arrow_forward_ios, size: 16, color: color),
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
//             color: Colors.black.withValues(alpha: 0.05),
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
//         elevation: 0,
//         backgroundColor: AppColors.navyBlue,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [AppColors.navyBlue, Color(0xFF1976D2)],
//             ),
//           ),
//         ),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(30),
//                 child: Image.asset(
//                   "assets/Nss_Logo.jpg",
//                   width: 40,
//                   height: 40,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'University Dashboard',
//                   style: TextStyle(
//                     color: AppColors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 Text(
//                   'Manage NSS Programs',
//                   style: TextStyle(color: AppColors.white, fontSize: 12),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [AppColors.navyBlue, Color(0xFF1976D2)],
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Empower Your Students',
//                       style: TextStyle(
//                         color: AppColors.white,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     // const SizedBox(height: 8),
//                     // Text(
//                     //   'Create meaningful volunteer opportunities and track impact',
//                     //   style: TextStyle(
//                     //     color: AppColors.white.withValues(alpha: 0.9),
//                     //     fontSize: 14,
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildStatsCard(
//                           title: 'Active Events',
//                           value: '8',
//                           icon: Icons.event,
//                           color: AppColors.primaryOrange,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _buildStatsCard(
//                           title: 'Students',
//                           value: '156',
//                           icon: Icons.people,
//                           color: AppColors.successGreen,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _buildStatsCard(
//                           title: 'Hours Logged',
//                           value: '1.2K',
//                           icon: Icons.access_time,
//                           color: AppColors.navyBlue,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),
//                   const Text(
//                     'Management Tools',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.navyBlue,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   _buildManagementCard(
//                     title: 'Donations',
//                     subtitle: 'Organize health camps, awareness drives',
//                     icon: Icons.add_circle,
//                     color: AppColors.primaryOrange,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const AdminDonationPage(),
//                         ),
//                       );
//                     },
//                   ),
//                   _buildManagementCard(
//                     title: 'Requirment',
//                     subtitle: 'Track student participation and progress',
//                     icon: Icons.people_alt,
//                     color: AppColors.successGreen,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               const AllRequirementsPage(languageCode: 'en'),
//                         ),
//                       );
//                     },
//                   ),
//                   _buildManagementCard(
//                     title: 'Group Chat',
//                     subtitle: 'Generate detailed impact reports',
//                     icon: Icons.analytics,
//                     color: AppColors.navyBlue,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const GroupChatScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   _buildManagementCard(
//                     title: 'Health Camps',
//                     subtitle: 'Issue and track certificates',
//                     icon: Icons.verified,
//                     color: Colors.purple,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const AdminDashboard(),
//                         ),
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:parivartan/University_Module/AcceptDonation.dart';
import 'package:parivartan/University_Module/AcceptRequriements.dart';
import 'package:parivartan/University_Module/Firebase_Initializer.dart';
import 'package:parivartan/University_Module/HealthCamps.dart';
import 'package:parivartan/University_Module/Mark_Attendence.dart';
import 'package:parivartan/University_Module/UniGroupChat.dart';
import 'package:parivartan/University_Module/Uni_Map.dart';

class AppColors {
  static const Color navyBlue = Color(0xFF1A3A52);
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color successGreen = Color(0xFF10B981);
  static const Color darkGrey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);
}

// void main() {
//   runApp(
//     MaterialApp(home: UniversityHomePage(), debugShowCheckedModeBanner: false),
//   );
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(home: UniversityHomePage(), debugShowCheckedModeBanner: false),
  );
}

class UniversityHomePage extends StatelessWidget {
  const UniversityHomePage({super.key});

  Widget _buildManagementCard({
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
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.1),
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
                  color: color.withValues(alpha: 0.15),
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
              Icon(Icons.arrow_forward_ios, size: 16, color: color),
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
            color: Colors.black.withValues(alpha: 0.05),
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
              //SizedBox(width: 12),
              // Text(
              //   'Logout',
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.w600,
              //     //color: Colors.redAccent,
              //     //fontFamily: 'Poppins', // optional if using Google Fonts
              //   ),
              // ),
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
        elevation: 0,
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
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
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
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'University Dashboard',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Manage NSS Activities',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              //width: double.infinity,
              // decoration: const BoxDecoration(
              //   gradient: LinearGradient(
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //     colors: [AppColors.navyBlue, Color(0xFF1976D2)],
              //   ),
              // ),
              // child: Padding(
              //   padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
              //   // child: Column(
              //   //   crossAxisAlignment: CrossAxisAlignment.start,
              //   //   children: [
              //   //     // const Text(
              //   //     //   'Empower Your Students',
              //   //     //   style: TextStyle(
              //   //     //     color: AppColors.white,
              //   //     //     fontSize: 22,
              //   //     //     fontWeight: FontWeight.bold,
              //   //     //   ),
              //   //     // ),
              //   //     // const SizedBox(height: 8),
              //   //     // Text(
              //   //     //   'Create meaningful volunteer opportunities and track impact',
              //   //     //   style: TextStyle(
              //   //     //     color: AppColors.white.withValues(alpha: 0.9),
              //   //     //     fontSize: 14,
              //   //     //   ),
              //   //     // ),
              //   //   ],
              //   // ),
              // ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatsCard(
                          title: 'Active Events',
                          value: '8',
                          icon: Icons.event,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatsCard(
                          title: 'Students',
                          value: '156',
                          icon: Icons.people,
                          color: AppColors.successGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatsCard(
                          title: 'Hours Logged',
                          value: '1.2K',
                          icon: Icons.access_time,
                          color: AppColors.navyBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Management Tools',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navyBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildManagementCard(
                    title: 'Donations',
                    subtitle: 'Helping hands make hearts happy.',
                    icon: Icons.add_circle,
                    color: AppColors.primaryOrange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminDonationPage(),
                        ),
                      );
                    },
                  ),
                  _buildManagementCard(
                    title: 'Requirment',
                    subtitle: 'Basic needs for every process.',
                    icon: Icons.fact_check,
                    color: AppColors.successGreen,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AllRequirementsPage(languageCode: 'en'),
                        ),
                      );
                    },
                  ),
                  _buildManagementCard(
                    title: 'Group Chat',
                    subtitle: 'Connect, share, and grow together.',
                    icon: Icons.groups,
                    color: Colors.redAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GroupChatScreen(),
                        ),
                      );
                    },
                  ),
                  _buildManagementCard(
                    title: 'Health Camps',
                    subtitle: 'Check. Care. Cure. Live healthy.',
                    icon: Icons.health_and_safety,
                    color: Colors.blueAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminDashboard(),
                        ),
                      );
                    },
                  ),
                  _buildManagementCard(
                    title: 'Mark Attendence',
                    subtitle: 'Stay punctual, mark your presence.',
                    icon: Icons.calendar_today,
                    color: AppColors.primaryOrange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AttendanceApp(),
                        ),
                      );
                    },
                  ),
                  _buildManagementCard(
                    title: 'Map to track',
                    subtitle: 'Your direction, always on map.',
                    icon: Icons.public,
                    color: Colors.blueAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RouteMapApp(),
                        ),
                      );
                    },
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
