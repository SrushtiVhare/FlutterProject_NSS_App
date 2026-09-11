import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: const FirebaseOptions(
//       apiKey: 'AIzaSyDkmtgkymdThtASpBdxmWOGd6l2oyIgK_E',
//       appId: '1:776412307701:android:fe13f2c79d8260293d25bc',
//       messagingSenderId: '776412307701',
//       projectId: 'parivartan-c3238',
//       storageBucket: 'parivartan-c3238.firebasestorage.app',
//     ),
//   );
//   runApp(const AttendanceApp());
// }

// Color Constants (matching AdminPanelPage)
class AppColors {
  static const Color navyBlue = Color(0xFF1A3A52);
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color successGreen = Color(0xFF10B981);
  static const Color darkGrey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);

  static Color? get textDark => null;
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Marker',
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
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.lightGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryOrange, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade300),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryOrange,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
      ),
      home: const AttendanceHomePage(),
    );
  }
}

class AttendanceHomePage extends StatefulWidget {
  const AttendanceHomePage({super.key});

  @override
  State<AttendanceHomePage> createState() => _AttendanceHomePageState();
}

class _AttendanceHomePageState extends State<AttendanceHomePage>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  List<String> _students = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      final snapshot = await _firestore.collection('Student').get();
      if (mounted) {
        setState(() {
          _students = snapshot.docs.map((doc) => doc.id).toList();
        });
      }
    } catch (e) {
      print('Error loading students: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showMarkAttendanceDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MarkAttendanceDialog(
        students: _students,
        onStudentAdded: _loadStudents,
        onAttendanceMarked: () {
          // Refresh the page after marking attendance
          setState(() {});
        },
      ),
    );
  }

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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              titleSpacing: 0,
              toolbarHeight: 80,
              title: Row(
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Track Attendance',
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat(
                            'EEEE, MMM dd, yyyy',
                          ).format(DateTime.now()),
                          style: TextStyle(
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
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    "Today's Attendance",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navyBlue,
                    ),
                  ),
                ),
                TodayAttendanceCards(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showMarkAttendanceDialog,
        backgroundColor: AppColors.primaryOrange,
        elevation: 4,
        icon: const Icon(Icons.add_circle_outline, color: Colors.white),
        label: const Text(
          'Mark Attendance',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class TodayAttendanceCards extends StatelessWidget {
  const TodayAttendanceCards({super.key});

  Future<List<Map<String, dynamic>>> _loadRecentAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final String? recentData = prefs.getString('recent_attendance');

    if (recentData != null) {
      try {
        final List<dynamic> decoded = json.decode(recentData);
        return decoded.cast<Map<String, dynamic>>();
      } catch (e) {
        print('Error decoding recent attendance: $e');
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Attendance')
          .where('date', isEqualTo: Timestamp.fromDate(todayStart))
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _loadRecentAttendance(),
            builder: (context, cachedSnapshot) {
              if (cachedSnapshot.hasData && cachedSnapshot.data!.isNotEmpty) {
                return _buildAttendanceList(cachedSnapshot.data!, true);
              }
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryOrange,
                ),
              );
            },
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text(
                  'Error loading attendance',
                  style: TextStyle(fontSize: 16, color: AppColors.darkGrey),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.darkGrey),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _loadRecentAttendance(),
            builder: (context, cachedSnapshot) {
              if (cachedSnapshot.hasData && cachedSnapshot.data!.isNotEmpty) {
                return Column(
                  children: [
                    // Container(
                    //   padding: const EdgeInsets.all(12),
                    //   decoration: BoxDecoration(
                    //     color: AppColors.primaryOrange.withOpacity(0.1),
                    //     borderRadius: BorderRadius.circular(12),
                    //     border: Border.all(
                    //       color: AppColors.primaryOrange.withOpacity(0.3),
                    //     ),
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       Icon(
                    //         Icons.info_outline,
                    //         color: AppColors.primaryOrange,
                    //         size: 20,
                    //       ),
                    //       const SizedBox(width: 8),
                    //       Expanded(
                    //         child: Text(
                    //           'Showing cached data from previous session',
                    //           style: TextStyle(
                    //             fontSize: 12,
                    //             color: AppColors.navyBlue,
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    //const SizedBox(height: 16),
                    _buildAttendanceList(cachedSnapshot.data!, true),
                  ],
                );
              }
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
                    Text(
                      'No attendance marked today',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navyBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mark attendance to see cards here',
                      style: TextStyle(fontSize: 14, color: AppColors.darkGrey),
                    ),
                  ],
                ),
              );
            },
          );
        }

        final records = snapshot.data!.docs;
        final attendanceList = records.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'studentName': data['studentName'],
            'status': data['status'],
            'activityName': data['activityName'],
            'markedAt':
                (data['markedAt'] as Timestamp?)?.millisecondsSinceEpoch,
          };
        }).toList();

        // Save to SharedPreferences
        _saveRecentAttendance(attendanceList);

        return _buildAttendanceList(
          records.map((doc) => doc.data() as Map<String, dynamic>).toList(),
          false,
        );
      },
    );
  }

  Future<void> _saveRecentAttendance(List<Map<String, dynamic>> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('recent_attendance', json.encode(data));
    } catch (e) {
      print('Error saving recent attendance: $e');
    }
  }

  Widget _buildAttendanceList(
    List<Map<String, dynamic>> records,
    bool isCached,
  ) {
    final sortedRecords = List<Map<String, dynamic>>.from(records);
    sortedRecords.sort((a, b) {
      final aMarkedAt = a['markedAt'];
      final bMarkedAt = b['markedAt'];

      if (aMarkedAt == null && bMarkedAt == null) return 0;
      if (aMarkedAt == null) return 1;
      if (bMarkedAt == null) return -1;

      if (aMarkedAt is int && bMarkedAt is int) {
        return bMarkedAt.compareTo(aMarkedAt);
      }
      if (aMarkedAt is Timestamp && bMarkedAt is Timestamp) {
        return bMarkedAt.compareTo(aMarkedAt);
      }
      return 0;
    });

    final presentCount = sortedRecords
        .where((record) => record['status'] == 'Present')
        .length;
    final absentCount = sortedRecords.length - presentCount;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Present',
                presentCount.toString(),
                AppColors.successGreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Absent',
                absentCount.toString(),
                Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Total',
                sortedRecords.length.toString(),
                AppColors.primaryOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedRecords.length,
          itemBuilder: (context, index) {
            final record = sortedRecords[index];
            final studentName = record['studentName'] as String;
            final status = record['status'] as String;
            final activityName = record['activityName'] as String?;
            DateTime? markedAt;

            if (record['markedAt'] != null) {
              if (record['markedAt'] is int) {
                markedAt = DateTime.fromMillisecondsSinceEpoch(
                  record['markedAt'],
                );
              } else if (record['markedAt'] is Timestamp) {
                markedAt = (record['markedAt'] as Timestamp).toDate();
              }
            }

            return _buildAttendanceCard(
              studentName,
              status,
              activityName,
              markedAt,
              index,
              isCached,
            );
          },
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String label, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: AppColors.darkGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(
    String studentName,
    String status,
    String? activityName,
    DateTime? markedAt,
    int index,
    bool isCached,
  ) {
    final isPresent = status == 'Present';
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPresent
                ? AppColors.successGreen.withOpacity(0.3)
                : Colors.red.shade200,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyBlue,
                      ),
                    ),
                    if (activityName != null && activityName.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.event,
                            size: 14,
                            color: AppColors.primaryOrange,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              activityName,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.primaryOrange,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.darkGrey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          markedAt != null
                              ? 'Marked at ${DateFormat('hh:mm a').format(markedAt)}'
                              : 'Just now',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.darkGrey,
                          ),
                        ),
                        if (isCached) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'CACHED',
                              style: TextStyle(
                                fontSize: 9,
                                color: AppColors.primaryOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isPresent ? AppColors.successGreen : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MarkAttendanceDialog extends StatefulWidget {
  final List<String> students;
  final VoidCallback onStudentAdded;
  final VoidCallback? onAttendanceMarked;

  const MarkAttendanceDialog({
    super.key,
    required this.students,
    required this.onStudentAdded,
    this.onAttendanceMarked,
  });

  @override
  State<MarkAttendanceDialog> createState() => _MarkAttendanceDialogState();
}

class _MarkAttendanceDialogState extends State<MarkAttendanceDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _activityController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime _selectedDate = DateTime.now();
  String? _selectedStudent;
  bool _isLoading = false;
  bool _showNewStudentField = false;

  @override
  void dispose() {
    _nameController.dispose();
    _activityController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryOrange,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.navyBlue,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _addNewStudent() async {
    final studentName = _nameController.text.trim();

    if (studentName.isEmpty) {
      _showSnackBar('Please enter student name', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final docSnapshot = await _firestore
          .collection('Student')
          .doc(studentName)
          .get();

      if (docSnapshot.exists) {
        _showSnackBar('Student already exists!', Colors.orange);
        setState(() {
          _selectedStudent = studentName;
          _nameController.clear();
          _showNewStudentField = false;
        });
      } else {
        await _firestore.collection('Student').doc(studentName).set({
          'createdAt': FieldValue.serverTimestamp(),
          'name': studentName,
        });

        setState(() {
          _selectedStudent = studentName;
          _nameController.clear();
          _showNewStudentField = false;
        });

        widget.onStudentAdded();
        _showSnackBar('Student added successfully!', AppColors.successGreen);
      }
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}', Colors.red);
      print('Error adding student: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _markAttendance(String status) async {
    final studentName = _selectedStudent ?? _nameController.text.trim();
    final activityName = _activityController.text.trim();

    if (studentName.isEmpty) {
      _showSnackBar('Please select or add a student first', Colors.orange);
      return;
    }

    if (activityName.isEmpty) {
      _showSnackBar('Please enter activity name', Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final existingAttendance = await _firestore
          .collection('Attendance')
          .where('studentName', isEqualTo: studentName)
          .where(
            'date',
            isEqualTo: Timestamp.fromDate(
              DateTime(
                _selectedDate.year,
                _selectedDate.month,
                _selectedDate.day,
              ),
            ),
          )
          .get();

      if (existingAttendance.docs.isNotEmpty) {
        _showSnackBar(
          'Attendance already marked for this date!',
          Colors.orange,
        );
        setState(() => _isLoading = false);
        return;
      }

      await _firestore.collection('Attendance').add({
        'studentName': studentName,
        'activityName': activityName,
        'date': Timestamp.fromDate(
          DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day),
        ),
        'status': status,
        'markedAt': FieldValue.serverTimestamp(),
      });

      // Save to SharedPreferences for offline access
      await _saveToRecentAttendance(studentName, status, activityName);

      if (mounted) {
        Navigator.pop(context);
        _showSnackBar('Attendance marked as $status!', AppColors.successGreen);
        widget.onAttendanceMarked?.call();
      }
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}', Colors.red);
      print('Error marking attendance: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveToRecentAttendance(
    String studentName,
    String status,
    String activityName,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? existingData = prefs.getString('recent_attendance');

      List<Map<String, dynamic>> attendanceList = [];

      if (existingData != null) {
        try {
          final List<dynamic> decoded = json.decode(existingData);
          attendanceList = decoded.cast<Map<String, dynamic>>();
        } catch (e) {
          print('Error decoding existing data: $e');
        }
      }

      // Add new attendance record
      attendanceList.insert(0, {
        'studentName': studentName,
        'status': status,
        'activityName': activityName,
        'markedAt': DateTime.now().millisecondsSinceEpoch,
      });

      // Keep only last 50 records
      if (attendanceList.length > 50) {
        attendanceList = attendanceList.sublist(0, 50);
      }

      await prefs.setString('recent_attendance', json.encode(attendanceList));
    } catch (e) {
      print('Error saving to SharedPreferences: $e');
    }
  }

  void _showSnackBar(String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: AppColors.white),
          ),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.edit_calendar,
                          color: AppColors.primaryOrange,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Mark Attendance',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navyBlue,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              if (widget.students.isNotEmpty && !_showNewStudentField)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedStudent,
                      hint: Text(
                        'Select Student',
                        style: TextStyle(color: AppColors.darkGrey),
                      ),
                      isExpanded: true,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.primaryOrange,
                      ),
                      items: widget.students.map((student) {
                        return DropdownMenuItem(
                          value: student,
                          child: Text(
                            student,
                            style: const TextStyle(color: AppColors.navyBlue),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedStudent = value;
                          _showNewStudentField = false;
                        });
                      },
                    ),
                  ),
                ),

              if (widget.students.isNotEmpty && !_showNewStudentField) ...[
                const SizedBox(height: 16),
                Text(
                  'OR',
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showNewStudentField = true;
                      _selectedStudent = null;
                    });
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add New Student'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryOrange,
                    side: const BorderSide(color: AppColors.primaryOrange),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],

              if (_showNewStudentField || widget.students.isEmpty) ...[
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Student Name',
                    hintText: 'Enter student name',
                    prefixIcon: const Icon(
                      Icons.person,
                      color: AppColors.primaryOrange,
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_showNewStudentField && widget.students.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.close, color: AppColors.darkGrey),
                            onPressed: () {
                              setState(() {
                                _showNewStudentField = false;
                                _nameController.clear();
                              });
                            },
                          ),
                        IconButton(
                          icon: const Icon(
                            Icons.check_circle,
                            color: AppColors.primaryOrange,
                          ),
                          onPressed: _isLoading ? null : _addNewStudent,
                        ),
                      ],
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                  enabled: !_isLoading,
                ),
              ],

              const SizedBox(height: 16),

              TextField(
                controller: _activityController,
                decoration: const InputDecoration(
                  labelText: 'Activity Name',
                  hintText: 'Enter activity name',
                  prefixIcon: Icon(Icons.event, color: AppColors.primaryOrange),
                ),
                textCapitalization: TextCapitalization.words,
                enabled: !_isLoading,
              ),

              const SizedBox(height: 24),

              InkWell(
                onTap: _isLoading ? null : () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppColors.primaryOrange,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Date',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.darkGrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('MMMM dd, yyyy').format(_selectedDate),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.navyBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.primaryOrange,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _markAttendance('Present'),
                      child: const Text(
                        'Present',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.successGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _markAttendance('Absent'),
                      child: const Text(
                        'Absent',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: CircularProgressIndicator(
                    color: AppColors.primaryOrange,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
