import 'package:flutter/material.dart';
import 'package:parivartan/Admin_Module/AddScheme.dart';

class AppColors {
  static const Color navyBlue = Color(0xFF1A3A52);
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF707070);
  static const Color white = Colors.white;
  static const Color successGreen = Color(0xFF4CAF50);
}

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  Widget _buildAdminCard({
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.darkGrey,
                        fontSize: 13,
                      ),
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
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.navyBlue,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: AppColors.darkGrey),
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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Admin Dashboard',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'NSS Management',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
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
                  //     'LogOut',
                  //     style: TextStyle(
                  //       color: AppColors.white,
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(width: 5),
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
            //   'Oversee the NSS Ecosystem',
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //     color: AppColors.navyBlue,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // const Text(
            //   'Monitor, manage, and optimize the entire NSS platform',
            //   style: TextStyle(color: AppColors.navyBlue, fontSize: 14),
            // ),
            // const SizedBox(height: 20),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatsCard(
                    title: 'Universities',
                    value: '45',
                    icon: Icons.business,
                    color: AppColors.primaryOrange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatsCard(
                    title: 'Students',
                    value: '2.1K',
                    icon: Icons.people,
                    color: AppColors.successGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatsCard(
                    title: 'Events',
                    value: '156',
                    icon: Icons.event,
                    color: AppColors.navyBlue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Admin Tools
            const Text(
              'Administrative Tools',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.navyBlue,
              ),
            ),
            const SizedBox(height: 16),

            _buildAdminCard(
              title: 'Government Schemes',
              subtitle: 'View and manage government schemes',
              icon: Icons.public,
              color: AppColors.primaryOrange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminPanelPage(),
                  ),
                );
              },
            ),

            _buildAdminCard(
              title: 'User Management',
              subtitle: 'Manage users, roles, and permissions',
              icon: Icons.people_alt,
              color: Colors.indigo,
              onTap: () {},
            ),

            // _buildAdminCard(
            //   title: 'System Analytics',
            //   subtitle: 'Platform performance and insights',
            //   icon: Icons.analytics,
            //   color: AppColors.primaryOrange,
            //   onTap: () {},
            // ),

            // _buildAdminCard(
            //   title: 'Content Moderation',
            //   subtitle: 'Review and moderate platform content',
            //   icon: Icons.security,
            //   color: AppColors.primaryOrange,
            //   onTap: () {},
            // ),

            // _buildAdminCard(
            //   title: 'Reports & Insights',
            //   subtitle: 'Generate comprehensive reports',
            //   icon: Icons.assessment,
            //   color: AppColors.primaryOrange,
            //   onTap: () {},
            // ),
            _buildAdminCard(
              title: 'System Settings',
              subtitle: 'Configure platform settings',
              icon: Icons.settings,
              color: AppColors.successGreen,
              onTap: () {},
            ),

            _buildAdminCard(
              title: 'Support Center',
              subtitle: 'Handle user queries and issues',
              icon: Icons.support_agent,
              color: const Color.fromARGB(255, 237, 88, 78),
              onTap: () {},
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
