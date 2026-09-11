import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:parivartan/firebase_options.dart';

// Remove the main() function and Firebase initialization from here
// Firebase is already initialized in your main.dart

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const AttendanceApp());
// }

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Viewer',
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
      home: const AttendanceScreen(),
    );
  }
}

class AppColors {
  static const Color navyBlue = Color(0xFF1A3A52);
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color successGreen = Color(0xFF10B981);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color darkGrey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);
}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _searchQuery = '';
  String _filterStatus = 'all'; // 'all', 'present', 'absent'

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
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      width: 50,
                      height: 50,
                      color: AppColors.white,
                      child: Image.asset(
                        "assets/Nss_Logo.jpg",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Icon(
                              Icons.how_to_reg,
                              color: AppColors.navyBlue,
                              size: 30,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Attendance Records',
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'All Student Activity Attendance',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('Attendance').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryOrange,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 80,
                            color: Colors.red.shade300,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Error loading attendance',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 100,
                          color: AppColors.darkGrey.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Attendance Records',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navyBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No attendance data found in the database',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                var attendanceRecords = snapshot.data!.docs;

                // Apply search filter
                if (_searchQuery.isNotEmpty) {
                  attendanceRecords = attendanceRecords.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final studentName = (data['studentName'] ?? '')
                        .toString()
                        .toLowerCase();
                    final activityName = (data['activityName'] ?? '')
                        .toString()
                        .toLowerCase();
                    final query = _searchQuery.toLowerCase();

                    return studentName.contains(query) ||
                        activityName.contains(query);
                  }).toList();
                }

                // Apply status filter
                if (_filterStatus != 'all') {
                  attendanceRecords = attendanceRecords.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final status = data['status']?.toString() ?? '';

                    return _filterStatus == 'present'
                        ? status == 'Present'
                        : status != 'Present';
                  }).toList();
                }

                // Sort by date (most recent first)
                attendanceRecords.sort((a, b) {
                  final aData = a.data() as Map<String, dynamic>;
                  final bData = b.data() as Map<String, dynamic>;
                  final aDate = aData['date'];
                  final bDate = bData['date'];

                  if (aDate == null && bDate == null) return 0;
                  if (aDate == null) return 1;
                  if (bDate == null) return -1;

                  return (bDate as Timestamp).compareTo(aDate as Timestamp);
                });

                return Column(
                  children: [
                    _buildAttendanceStats(attendanceRecords),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: attendanceRecords.length,
                        itemBuilder: (context, index) {
                          final doc = attendanceRecords[index];
                          final data = doc.data() as Map<String, dynamic>;
                          return _buildAttendanceCard(data, doc.id);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
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
          TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search by student or activity name...',
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.primaryOrange,
              ),
              filled: true,
              fillColor: AppColors.lightGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.filter_list,
                color: AppColors.darkGrey,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Filter:',
                style: TextStyle(
                  color: AppColors.darkGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', 'all'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Present', 'present'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Absent', 'absent'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterStatus == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterStatus = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryOrange : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.darkGrey,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceStats(List<QueryDocumentSnapshot> records) {
    final presentCount = records.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data['status']?.toString() == 'Present';
    }).length;
    final absentCount = records.length - presentCount;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryOrange.withOpacity(0.1),
            AppColors.primaryOrange.withOpacity(0.05),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total', records.length, AppColors.navyBlue),
          Container(
            width: 1,
            height: 40,
            color: AppColors.darkGrey.withOpacity(0.3),
          ),
          _buildStatItem('Present', presentCount, AppColors.successGreen),
          Container(
            width: 1,
            height: 40,
            color: AppColors.darkGrey.withOpacity(0.3),
          ),
          _buildStatItem('Absent', absentCount, AppColors.errorRed),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.darkGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceCard(Map<String, dynamic> data, String docId) {
    final studentName = data['studentName']?.toString() ?? 'Unknown Student';
    final activityName = data['activityName']?.toString() ?? 'No Activity';
    final status = data['status']?.toString() ?? 'Unknown';
    final isPresent = status == 'Present';
    final date = data['date'];
    final markedAt = data['markedAt'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPresent
              ? AppColors.successGreen.withOpacity(0.3)
              : AppColors.errorRed.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        studentName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.navyBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.event,
                            size: 14,
                            color: AppColors.darkGrey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              activityName,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.darkGrey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isPresent
                        ? AppColors.successGreen
                        : AppColors.errorRed,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                if (date != null) ...[
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.primaryOrange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat(
                      'MMM dd, yyyy',
                    ).format((date as Timestamp).toDate()),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (markedAt != null) ...[
                  const Spacer(),
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.primaryOrange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat(
                      'hh:mm a',
                    ).format((markedAt as Timestamp).toDate()),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
