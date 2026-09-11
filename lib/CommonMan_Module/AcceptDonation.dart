import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parivartan/CommonMan_Module/FirebaseInitializers.dart';
import 'package:qr_flutter/qr_flutter.dart';

// ============ APP COLORS ============
class AppColors {
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color navyBlue = Color(0xFF1E3A8A);
  static const Color darkGrey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);
}

// ============ DONATION MODEL ============
class DonationModel {
  final String id;
  final String type;
  final String details;
  final double? amount;
  final DateTime date;
  final String name;
  final String email;
  final String phone;
  final String? transactionId;
  final String paymentStatus;

  DonationModel({
    required this.id,
    required this.type,
    required this.details,
    this.amount,
    required this.date,
    required this.name,
    required this.email,
    required this.phone,
    this.transactionId,
    this.paymentStatus = 'Completed',
  });

  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'type': type,
      'details': details,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'name': name,
      'email': email,
      'phone': phone,
      'transactionId': transactionId,
      'paymentStatus': paymentStatus,
      'createdAt': FieldValue.serverTimestamp(),
    };
    debugPrint('📝 toMap() output: $map');
    return map;
  }

  factory DonationModel.fromMap(Map<String, dynamic> map) {
    try {
      return DonationModel(
        id: map['id'] as String,
        type: map['type'] as String,
        details: map['details'] as String,
        amount: map['amount'] != null
            ? (map['amount'] as num).toDouble()
            : null,
        date: (map['date'] as Timestamp).toDate(),
        name: map['name'] as String,
        email: map['email'] as String,
        phone: map['phone'] as String,
        transactionId: map['transactionId'] as String?,
        paymentStatus: (map['paymentStatus'] as String?) ?? 'Completed',
      );
    } catch (e) {
      debugPrint('❌ Error in fromMap: $e');
      debugPrint('❌ Problematic map data: $map');
      rethrow;
    }
  }

  DonationModel copyWith({
    String? id,
    String? type,
    String? details,
    double? amount,
    DateTime? date,
    String? name,
    String? email,
    String? phone,
    String? transactionId,
    String? paymentStatus,
  }) {
    return DonationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      details: details ?? this.details,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      transactionId: transactionId ?? this.transactionId,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }
}

// ============ FIREBASE CONTROLLER ============
class FirebaseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _donationsCollection =>
      _firestore.collection('Donation');

  Future<void> saveDonation(DonationModel donation) async {
    try {
      debugPrint('\n========================================');
      debugPrint('🔥 SAVING DONATION TO FIREBASE');
      debugPrint('========================================');
      debugPrint('📍 Collection: Donation');
      debugPrint('🆔 Document ID: ${donation.id}');
      debugPrint('📦 Platform: ${kIsWeb ? "Web" : "Mobile"}');

      final donationData = donation.toMap();
      debugPrint('📄 Data to save: $donationData');

      debugPrint('⏳ Attempting to write to Firestore...');
      await _donationsCollection.doc(donation.id).set(donationData);

      debugPrint('✅ Write operation completed');
      debugPrint('⏳ Waiting 1 second for propagation...');
      await Future.delayed(const Duration(seconds: 1));

      debugPrint('🔍 Verifying document exists...');
      final docSnapshot = await _donationsCollection.doc(donation.id).get();

      if (docSnapshot.exists) {
        debugPrint('✅✅✅ SUCCESS! Document verified in Firestore');
        debugPrint('📄 Saved data: ${docSnapshot.data()}');
      } else {
        debugPrint('❌❌❌ FAILED! Document not found after write');
        throw Exception('Document verification failed');
      }

      debugPrint('========================================\n');
    } catch (e, stackTrace) {
      debugPrint('\n❌❌❌ ERROR SAVING DONATION ❌❌❌');
      debugPrint('Error type: ${e.runtimeType}');
      debugPrint('Error message: $e');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('========================================\n');
      rethrow;
    }
  }

  Stream<List<DonationModel>> getDonationsStream() {
    debugPrint('👂 Setting up Firestore listener...');
    return _donationsCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          debugPrint('📥 Stream update: ${snapshot.docs.length} documents');

          if (snapshot.docs.isEmpty) {
            debugPrint('⚠️ No documents found in Donation collection');
          }

          return snapshot.docs.map((doc) {
            try {
              final data = doc.data() as Map<String, dynamic>;
              debugPrint('📄 Document ${doc.id}: ${data.keys.toList()}');
              return DonationModel.fromMap(data);
            } catch (e) {
              debugPrint('❌ Error parsing document ${doc.id}: $e');
              rethrow;
            }
          }).toList();
        });
  }

  Future<bool> testConnection() async {
    try {
      debugPrint('\n========================================');
      debugPrint('🧪 TESTING FIRESTORE CONNECTION');
      debugPrint('========================================');
      debugPrint('📍 Project ID: project1-219ef');
      debugPrint('📦 Platform: ${kIsWeb ? "Web" : "Mobile"}');

      final testRef = _firestore.collection('test_connection').doc('test_doc');
      final testData = {
        'test': 'value',
        'timestamp': FieldValue.serverTimestamp(),
        'platform': kIsWeb ? 'web' : 'mobile',
      };

      debugPrint('⏳ Writing test document...');
      await testRef.set(testData);
      debugPrint('✅ Test document written');

      debugPrint('⏳ Reading test document...');
      final snapshot = await testRef.get();

      if (snapshot.exists) {
        debugPrint('✅✅✅ CONNECTION SUCCESS!');
        debugPrint('📄 Test data: ${snapshot.data()}');
        debugPrint('========================================\n');
        return true;
      } else {
        debugPrint('❌ Test document not found');
        debugPrint('========================================\n');
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('\n❌❌❌ CONNECTION TEST FAILED ❌❌❌');
      debugPrint('Error: $e');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('========================================\n');
      return false;
    }
  }

  Future<void> checkCollectionStatus() async {
    try {
      debugPrint('\n========================================');
      debugPrint('🔍 CHECKING DONATION COLLECTION STATUS');
      debugPrint('========================================');

      final snapshot = await _donationsCollection.limit(1).get();
      debugPrint('📊 Collection exists: ${snapshot.docs.isNotEmpty}');
      debugPrint('📊 Document count (first fetch): ${snapshot.docs.length}');

      if (snapshot.docs.isNotEmpty) {
        debugPrint('📄 Sample document: ${snapshot.docs.first.data()}');
      } else {
        debugPrint('⚠️ Collection is empty or does not exist yet');
      }
      debugPrint('========================================\n');
    } catch (e) {
      debugPrint('❌ Error checking collection: $e');
    }
  }
}

// ============ MAIN APP ============
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initialize();
  runApp(const NSSDonatioApp());
}

class NSSDonatioApp extends StatelessWidget {
  const NSSDonatioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NSS Donation Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppColors.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primaryOrange,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
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
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      home: const DonationPage(),
    );
  }
}

// ============ DONATION PAGE ============
class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage>
    with SingleTickerProviderStateMixin {
  final FirebaseController _firebaseController = FirebaseController();
  final List<DonationModel> _donations = [];
  String? _selectedCategory;

  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  late TabController _tabController;
  bool _isLoading = true;

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Clothes',
      'icon': Icons.checkroom,
      'color': const Color(0xFFF97316),
    },
    {'name': 'Food', 'icon': Icons.fastfood, 'color': const Color(0xFF1E3A8A)},
    {
      'name': 'Money',
      'icon': Icons.attach_money,
      'color': const Color(0xFFF97316),
    },
    {
      'name': 'Electronics',
      'icon': Icons.devices,
      'color': const Color(0xFFF97316),
    },
    {
      'name': 'Stationery',
      'icon': Icons.edit,
      'color': const Color(0xFFF97316),
    },
    {
      'name': 'Other',
      'icon': Icons.menu_book,
      'color': const Color(0xFFF97316),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadDonations();
  }

  Future<void> _loadDonations() async {
    setState(() => _isLoading = true);

    _firebaseController.getDonationsStream().listen(
      (loadedDonations) {
        if (mounted) {
          setState(() {
            _donations.clear();
            _donations.addAll(loadedDonations);
            _isLoading = false;
          });
          debugPrint('✅ UI updated with ${loadedDonations.length} donations');
        }
      },
      onError: (error) {
        debugPrint('❌ Stream error: $error');
        if (mounted) {
          setState(() => _isLoading = false);
          _showErrorDialog('Error loading donations: $error');
        }
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _detailsController.dispose();
    _amountController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String _generateUPILink(double amount, String donationId) {
    String upiId = "mansigavhale618@okicici";
    String name = "Mansi Ashok Gavhale";
    String txnNote = "NSS Donation - $_selectedCategory";
    String txnId = donationId;

    return "upi://pay?pa=$upiId&pn=$name&mc=0000&tid=$txnId&tr=$txnId&tn=$txnNote&am=$amount&cu=INR";
  }

  void _showQRPaymentDialog(double amount, DonationModel donation) {
    final upiString = _generateUPILink(amount, donation.id);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.qr_code_2, size: 50, color: AppColors.navyBlue),
                    const SizedBox(height: 16),
                    Text(
                      'Scan to Pay',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Amount: ₹${amount.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: QrImageView(
                        data: upiString,
                        version: QrVersions.auto,
                        size: 250,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Scan with PhonePe / GPay / Paytm',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.navyBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              try {
                                final updatedDonation = donation.copyWith(
                                  paymentStatus: 'Completed',
                                  transactionId: donation.id,
                                );

                                await _firebaseController.saveDonation(
                                  updatedDonation,
                                );

                                if (mounted) {
                                  _showReceiptDialog(updatedDonation);
                                  _showSuccessSnackBar();
                                  _clearForm();
                                }
                              } catch (e) {
                                debugPrint('❌ Payment save error: $e');
                                if (mounted) {
                                  _showErrorDialog(
                                    'Failed to save payment: $e',
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Paid'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Donation saved successfully to Firebase!'),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[400]),
            const SizedBox(width: 12),
            const Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryOrange,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    if (mounted) {
      setState(() {
        _selectedCategory = null;
        _detailsController.clear();
        _amountController.clear();
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
      });
      debugPrint('✅ Form cleared');
    }
  }

  Future<void> _submitDonation() async {
    debugPrint('\n🎯 SUBMIT DONATION BUTTON PRESSED');

    if (_selectedCategory == null ||
        _nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              const Expanded(child: Text('Please fill all required fields')),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    if (_selectedCategory == 'Money' &&
        (_amountController.text.isEmpty ||
            double.tryParse(_amountController.text) == null ||
            double.parse(_amountController.text) <= 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              const Expanded(child: Text('Please enter a valid amount')),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final donation = DonationModel(
      id: 'DON${DateTime.now().millisecondsSinceEpoch}',
      type: _selectedCategory!,
      details: _detailsController.text.trim().isEmpty
          ? 'No details provided'
          : _detailsController.text.trim(),
      amount: _selectedCategory == 'Money'
          ? double.tryParse(_amountController.text)
          : null,
      date: DateTime.now(),
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? 'Not provided'
          : _phoneController.text.trim(),
      paymentStatus: _selectedCategory == 'Money' ? 'Pending' : 'Completed',
    );

    debugPrint('📝 Created donation object with ID: ${donation.id}');

    try {
      if (donation.type == 'Money' && donation.amount != null) {
        debugPrint('💰 Money donation - showing QR dialog');
        _showQRPaymentDialog(donation.amount!, donation);
      } else {
        debugPrint('📦 Non-money donation - saving directly');

        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(color: AppColors.primaryOrange),
            ),
          );
        }

        await _firebaseController.saveDonation(donation);

        if (mounted) {
          Navigator.pop(context);
          _showReceiptDialog(donation);
          _showSuccessSnackBar();
          _clearForm();
        }
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Submit donation error: $e');
      debugPrint('Stack trace: $stackTrace');

      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        _showErrorDialog('Failed to submit donation: $e');
      }
    }
  }

  void _showReceiptDialog(DonationModel donation) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[400],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Donation Successful!',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyBlue,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          _receiptRow('Receipt ID:', donation.id),
                          const Divider(height: 24),
                          _receiptRow('Name:', donation.name),
                          const Divider(height: 24),
                          _receiptRow('Email:', donation.email),
                          const Divider(height: 24),
                          _receiptRow('Phone:', donation.phone),
                          const Divider(height: 24),
                          _receiptRow('Category:', donation.type),
                          const Divider(height: 24),
                          _receiptRow('Details:', donation.details),
                          if (donation.amount != null) ...[
                            const Divider(height: 24),
                            _receiptRow(
                              'Amount:',
                              '₹${donation.amount!.toStringAsFixed(2)}',
                            ),
                          ],
                          if (donation.transactionId != null) ...[
                            const Divider(height: 24),
                            _receiptRow(
                              'Transaction ID:',
                              donation.transactionId!,
                            ),
                          ],
                          const Divider(height: 24),
                          _receiptRow(
                            'Payment Status:',
                            donation.paymentStatus,
                          ),
                          const Divider(height: 24),
                          _receiptRow(
                            'Date:',
                            DateFormat(
                              'dd MMM yyyy, hh:mm a',
                            ).format(donation.date),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _receiptRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: AppColors.darkGrey,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: AppColors.navyBlue,
              fontSize: 13,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.navyBlue, Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(23),
                child: Image.asset(
                  "assets/Nss_Logo.jpg",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Donation Portal',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Not Me, But You',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildDonationForm(), _buildHistoryView()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [AppColors.navyBlue, Color(0xFF1976D2)],
          ),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.darkGrey,
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Donate Now'),
          Tab(text: 'History'),
        ],
      ),
    );
  }

  Widget _buildDonationForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Donation Type',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.navyBlue,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category['name'];
              return GestureDetector(
                onTap: () => setState(
                  () => _selectedCategory = category['name'] as String,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              category['color'] as Color,
                              (category['color'] as Color).withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isSelected ? null : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? category['color'] as Color
                          : AppColors.lightGrey,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        category['icon'] as IconData,
                        size: 36,
                        color: isSelected
                            ? Colors.white
                            : category['color'] as Color,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['name'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.navyBlue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          _buildTextField('Full Name *', _nameController, Icons.person_outline),
          const SizedBox(height: 16),
          _buildTextField(
            'Email Address *',
            _emailController,
            Icons.email_outlined,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            'Phone Number',
            _phoneController,
            Icons.phone_outlined,
          ),
          const SizedBox(height: 16),
          if (_selectedCategory == 'Money')
            _buildTextField(
              'Amount (₹) *',
              _amountController,
              Icons.currency_rupee,
              isNumber: true,
            ),
          if (_selectedCategory == 'Money') const SizedBox(height: 16),
          _buildTextField(
            'Additional Details',
            _detailsController,
            Icons.notes,
            maxLines: 4,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitDonation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _selectedCategory == 'Money'
                        ? Icons.qr_code_scanner
                        : Icons.favorite,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _selectedCategory == 'Money'
                        ? 'Generate QR & Pay'
                        : 'Submit Donation',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: AppColors.darkGrey),
        prefixIcon: Icon(icon, color: AppColors.primaryOrange),
        filled: true,
        fillColor: AppColors.lightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryOrange,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildHistoryView() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primaryOrange),
      );
    }

    if (_donations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: AppColors.lightGrey),
            const SizedBox(height: 16),
            Text(
              'No donations yet',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your donation history will appear here',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.darkGrey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _donations.length,
      itemBuilder: (context, index) {
        final donation = _donations[index];
        final category = _categories.firstWhere(
          (c) => c['name'] == donation.type,
          orElse: () => _categories[0],
        );
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _showReceiptDialog(donation),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (category['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        category['icon'] as IconData,
                        color: category['color'] as Color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            donation.type,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.navyBlue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            donation.details,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppColors.darkGrey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 12,
                                color: AppColors.darkGrey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('dd MMM yyyy').format(donation.date),
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: AppColors.darkGrey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (donation.amount != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '₹${donation.amount!.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right, color: AppColors.darkGrey),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
