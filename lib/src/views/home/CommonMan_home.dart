// import 'package:flutter/material.dart';
// import 'package:parivartan/CommonMan_Module/AcceptDonation.dart';
// import 'package:parivartan/CommonMan_Module/AcceptRequrimemts.dart';
// import 'package:parivartan/CommonMan_Module/FirebaseInitializers.dart';
// import 'package:parivartan/CommonMan_Module/GovermentSchemesProvide/main.dart';
// import 'package:parivartan/CommonMan_Module/Health_Dental_Camp/main.dart';

// class AppColors {
//   static const Color navyBlue = Color(0xFF1A3A52);
//   static const Color primaryOrange = Color(0xFFF97316);
//   static const Color lightGrey = Color(0xFFF5F5F5);
//   static const Color darkGrey = Color(0xFF707070);
//   static const Color white = Colors.white;
//   static const Color successGreen = Color(0xFF4CAF50);
// }

// // void main() {
// //   runApp(
// //     MaterialApp(home: VolunteerHomePage(), debugShowCheckedModeBanner: false),
// //   );
// // }

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await FirebaseConfig.initialize(); // One line initialization
//   // runApp(const CommonPeople());
//   runApp(
//     MaterialApp(home: CommonManHomePage(), debugShowCheckedModeBanner: false),
//   );
// }

// class CommonManHomePage extends StatelessWidget {
//   const CommonManHomePage({super.key});

//   Widget _buildOpportunityCard({
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
//                           'Common Man Hub',
//                           style: TextStyle(
//                             color: AppColors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Text(
//                           'Join the Movement',
//                           style: TextStyle(
//                             color: AppColors.white.withOpacity(0.8),
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: AppColors.primaryOrange,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: const Text(
//                       'NSS',
//                       style: TextStyle(
//                         color: AppColors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
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
//               'Your Skills, Our Impact',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.navyBlue,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Find opportunities that match your skills and availability',
//               style: TextStyle(color: AppColors.navyBlue, fontSize: 14),
//             ),
//             const SizedBox(height: 20),

//             // Stats Row
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildStatsCard(
//                     title: 'Completed',
//                     value: '15',
//                     icon: Icons.check_circle,
//                     color: Colors.green,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _buildStatsCard(
//                     title: 'Hours',
//                     value: '120',
//                     icon: Icons.access_time,
//                     color: AppColors.primaryOrange,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _buildStatsCard(
//                     title: 'Impact',
//                     value: 'High',
//                     icon: Icons.trending_up,
//                     color: AppColors.navyBlue,
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 24),

//             // Opportunities
//             const Text(
//               'Volunteer Opportunities',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.navyBlue,
//               ),
//             ),
//             const SizedBox(height: 16),

//             _buildOpportunityCard(
//               title: 'Health Camps',
//               subtitle: 'Medical assistance and health awareness',
//               icon: Icons.medical_services,
//               color: AppColors.primaryOrange,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const NSSCampApp()),
//                 );
//               },
//             ),

//             _buildOpportunityCard(
//               title: 'Donation',
//               subtitle: 'Teaching and mentoring students',
//               icon: Icons.school,
//               color: AppColors.primaryOrange,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const NSSDonatioApp(),
//                   ),
//                 );
//               },
//             ),

//             _buildOpportunityCard(
//               title: 'Goverment Schemes',
//               subtitle: 'Tree planting and clean-up drives',
//               icon: Icons.eco,
//               color: AppColors.successGreen,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const GovernmentScheme(),
//                   ),
//                 );
//               },
//             ),

//             _buildOpportunityCard(
//               title: 'Our Requirements ',
//               subtitle: 'Emergency response and relief work',
//               icon: Icons.emergency,
//               color: Colors.red,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const CommonPeople()),
//                 );
//               },
//             ),

//             _buildOpportunityCard(
//               title: 'Chatbot',
//               subtitle: 'Training and capacity building',
//               icon: Icons.psychology,
//               color: Colors.indigo,
//               onTap: () {},
//             ),

//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:parivartan/CommonMan_Module/AcceptDonation.dart';
import 'package:parivartan/CommonMan_Module/AcceptRequrimemts.dart';
import 'package:parivartan/CommonMan_Module/Chatbot.dart';
import 'package:parivartan/CommonMan_Module/FirebaseInitializers.dart';
import 'package:parivartan/CommonMan_Module/GovermentSchemesProvide/main.dart';
import 'package:parivartan/CommonMan_Module/Health_Dental_Camp/main.dart';

class AppColors {
  static const Color navyBlue = Color(0xFF1A3A52);
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF707070);
  static const Color white = Colors.white;
  static const Color successGreen = Color(0xFF4CAF50);
}

// void main() {
//   runApp(
//     MaterialApp(home: VolunteerHomePage(), debugShowCheckedModeBanner: false),
//   );
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initialize(); // One line initialization
  // runApp(const CommonPeople());
  runApp(
    MaterialApp(home: CommonManHomePage(), debugShowCheckedModeBanner: false),
  );
}

class CommonManHomePage extends StatelessWidget {
  const CommonManHomePage({super.key});

  Widget _buildOpportunityCard({
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
                          'Aam Aadmi Connect',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Join Our Journey',
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 12,
                  //     vertical: 6,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: AppColors.primaryOrange,
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   child: const Text(
                  //     'NSS',
                  //     style: TextStyle(
                  //       color: AppColors.white,
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
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
            //   'Your Skills, Our Impact',
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //     color: AppColors.navyBlue,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // const Text(
            //   'Find opportunities that match your skills and availability',
            //   style: TextStyle(color: AppColors.navyBlue, fontSize: 14),
            // ),
            // const SizedBox(height: 20),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatsCard(
                    title: 'Completed',
                    value: '15',
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatsCard(
                    title: 'Hours',
                    value: '120',
                    icon: Icons.access_time,
                    color: AppColors.primaryOrange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatsCard(
                    title: 'Impact',
                    value: 'High',
                    icon: Icons.trending_up,
                    color: AppColors.navyBlue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Opportunities
            const Text(
              'Volunteer Opportunities',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.navyBlue,
              ),
            ),
            const SizedBox(height: 16),

            _buildOpportunityCard(
              title: 'Health Camps',
              subtitle: 'Check. Care. Cure. Live healthy.',
              icon: Icons.health_and_safety,
              color: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NSSCampApp()),
                );
              },
            ),

            _buildOpportunityCard(
              title: 'Donations',
              subtitle: 'Helping hands make hearts happy.',
              icon: Icons.add_circle,
              color: AppColors.primaryOrange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NSSDonatioApp(),
                  ),
                );
              },
            ),

            // _buildOpportunityCard(
            //   title: 'Goverment Schemes',
            //   subtitle: 'Tree planting and clean-up drives',
            //   icon: Icons.eco,
            //   color: Colors.redAccent,
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const GovernmentScheme(),
            //       ),
            //     );
            //   },
            // ),
            _buildOpportunityCard(
              title: 'Requirment',
              subtitle: 'Basic needs for every process.',
              icon: Icons.fact_check,
              color: AppColors.successGreen,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CommonPeople()),
                );
              },
            ),
            _buildOpportunityCard(
              title: 'Goverment Schemes',
              subtitle: 'Ensuring every benefit reaches the needy.',
              icon: Icons.eco,
              color: const Color.fromARGB(255, 242, 149, 82),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GovernmentScheme(),
                  ),
                );
              },
            ),

            // _buildOpportunityCard(
            //   title: 'Chatbot',
            //   subtitle: 'Training and capacity building',
            //   icon: Icons.psychology,
            //   color: Colors.deepOrangeAccent,
            //   onTap: () {},
            // ),
            _buildOpportunityCard(
              title: 'AI Assistant',
              subtitle: 'Chat with NSS AI Assistant',
              icon: Icons.smart_toy,
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatbotPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
