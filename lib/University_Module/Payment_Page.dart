import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import 'Firebase_Initializer.dart';

// ============ APP COLORS ============
class AppColors {
  static const Color primaryOrange = Color(0xFFF97316);
  static const Color navyBlue = Color(0xFF1E3A8A);
  static const Color darkGrey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);
}

// ============ NSS PAYMENT CONSTANTS ============
class NSSPaymentConfig {
  static const String recipientUpiId = 'vaishnavisunilpatil123@okhdfcbank';
  static const String recipientMobile = '8788764308';
  static const String recipientName = 'NSS Donation';
}

// ============ PAYMENT MODEL ============
class PaymentDonationModel {
  final String id;
  final String name;
  final double amount;
  final String payerUpiId;
  final String upiId;
  final String recipientMobile;
  final String description;
  final DateTime date;
  final String paymentMethod;
  final String transactionId;
  final String paymentStatus;
  final String verificationStatus;
  final String? aiVerificationNotes;

  PaymentDonationModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.payerUpiId,
    required this.upiId,
    required this.recipientMobile,
    required this.description,
    required this.date,
    this.paymentMethod = 'UPI',
    this.transactionId = '',
    this.paymentStatus = 'Pending',
    this.verificationStatus = 'Pending',
    this.aiVerificationNotes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'payerUpiId': payerUpiId,
      'upiId': upiId,
      'recipientMobile': recipientMobile,
      'description': description,
      'date': Timestamp.fromDate(date),
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
      'paymentStatus': paymentStatus,
      'verificationStatus': verificationStatus,
      'aiVerificationNotes': aiVerificationNotes,
      'type': 'Money',
      'details': description,
      'email': 'payment@nss.org',
      'phone': recipientMobile,
      'approvalStatus': 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

// ============ PAYMENT FIREBASE CONTROLLER ============
class PaymentFirebaseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _donationsCollection =>
      _firestore.collection('Donation');

  Future<String> savePaymentDonation(PaymentDonationModel payment) async {
    try {
      debugPrint('💾 Saving payment donation to Firestore...');
      await _donationsCollection.doc(payment.id).set(payment.toMap());
      debugPrint('✅ Payment donation saved successfully');
      return payment.id;
    } catch (e) {
      debugPrint('❌ Error saving payment donation: $e');
      rethrow;
    }
  }

  Future<void> updatePaymentStatus(
    String paymentId,
    String transactionId,
    String status,
  ) async {
    try {
      debugPrint('🔄 Updating payment status...');
      await _donationsCollection.doc(paymentId).update({
        'transactionId': transactionId,
        'paymentStatus': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ Payment status updated');
    } catch (e) {
      debugPrint('❌ Error updating payment status: $e');
      rethrow;
    }
  }

  Future<void> updateAIVerification(
    String paymentId,
    String verificationStatus,
    String notes,
  ) async {
    try {
      debugPrint('🤖 Updating AI verification...');
      await _donationsCollection.doc(paymentId).update({
        'verificationStatus': verificationStatus,
        'aiVerificationNotes': notes,
        'approvalStatus': verificationStatus == 'Verified'
            ? 'Approved'
            : 'Pending',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ AI verification updated');
    } catch (e) {
      debugPrint('❌ Error updating AI verification: $e');
      rethrow;
    }
  }
}

// ============ MAIN APP ============
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    debugPrint('\n🚀🚀🚀 PAYMENT APP STARTING 🚀🚀🚀\n');
    debugPrint('========================================');
    debugPrint('FIREBASE INITIALIZATION');
    debugPrint('========================================');
    debugPrint('📦 Platform: ${kIsWeb ? "Web" : "Mobile (Android/iOS)"}');
    debugPrint('📍 Project: parivartan-c3238');

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');

    if (kIsWeb) {
      debugPrint('🌐 Running on Web - default settings applied');
    } else {
      try {
        FirebaseFirestore.instance.settings = const Settings(
          persistenceEnabled: true,
        );
        debugPrint('📱 Mobile persistence enabled');
      } catch (e) {
        debugPrint('⚠️ Could not enable persistence: $e');
      }
    }

    debugPrint('========================================\n');
  } catch (e, stackTrace) {
    debugPrint('\n❌❌❌ FIREBASE INITIALIZATION ERROR ❌❌❌');
    debugPrint('Error: $e');
    debugPrint('Stack trace: $stackTrace');
    debugPrint('========================================\n');
  }

  runApp(const PaymentDonationApp());
}

class PaymentDonationApp extends StatelessWidget {
  const PaymentDonationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NSS Payment Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
      home: const PaymentDonationPage(),
    );
  }
}

// ============ AI PAYMENT VERIFIER (Simulated) ============
class AIPaymentVerifier {
  static Future<Map<String, dynamic>> verifyPayment({
    required String name,
    required double amount,
    required String payerUpiId,
    required String upiId,
    required String transactionId,
    required String description,
  }) async {
    // Simulate AI processing delay
    await Future.delayed(const Duration(seconds: 2));

    debugPrint('🤖 AI Verification Started');
    debugPrint('Name: $name');
    debugPrint('Amount: ₹$amount');
    debugPrint('Payer UPI ID: $payerUpiId');
    debugPrint('Recipient UPI ID: $upiId');
    debugPrint('Transaction ID: $transactionId');

    // Simulated AI checks
    bool isNameValid = name.trim().length >= 3;
    bool isAmountValid = amount >= 10 && amount <= 100000;
    bool isPayerUpiValid = payerUpiId.contains('@') && payerUpiId.length > 5;
    bool isUpiValid = upiId == NSSPaymentConfig.recipientUpiId;
    bool isTransactionIdValid = transactionId.length >= 10;

    // Calculate verification score
    int score = 0;
    List<String> checks = [];

    if (isNameValid) {
      score += 20;
      checks.add('✓ Name validation passed');
    } else {
      checks.add('✗ Name too short');
    }

    if (isAmountValid) {
      score += 20;
      checks.add('✓ Amount within acceptable range');
    } else {
      checks.add('✗ Amount out of range');
    }

    if (isPayerUpiValid) {
      score += 20;
      checks.add('✓ Payer UPI ID format validated');
    } else {
      checks.add('✗ Invalid payer UPI ID format');
    }

    if (isUpiValid) {
      score += 20;
      checks.add('✓ Payment sent to correct UPI ID');
    } else {
      checks.add('✗ Payment not sent to NSS UPI ID');
    }

    if (isTransactionIdValid) {
      score += 20;
      checks.add('✓ Transaction ID verified');
    } else {
      checks.add('✗ Transaction ID too short');
    }

    String status = score >= 80
        ? 'Verified'
        : score >= 60
        ? 'Review'
        : 'Failed';
    String notes = checks.join('\n') + '\n\nAI Confidence Score: $score%';

    debugPrint('🤖 AI Verification Complete: $status ($score%)');

    return {
      'status': status,
      'score': score,
      'notes': notes,
      'verified': status == 'Verified',
    };
  }
}

// ============ PAYMENT DONATION PAGE ============
class PaymentDonationPage extends StatefulWidget {
  const PaymentDonationPage({super.key});

  @override
  State<PaymentDonationPage> createState() => _PaymentDonationPageState();
}

class _PaymentDonationPageState extends State<PaymentDonationPage> {
  final _formKey = GlobalKey<FormState>();
  final PaymentFirebaseController _firebaseController =
      PaymentFirebaseController();

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _payerUpiIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _transactionIdController =
      TextEditingController();

  bool _isProcessing = false;
  String? _currentPaymentId;

  @override
  void dispose() {
    _nameController.dispose();
    _payerUpiIdController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _transactionIdController.dispose();
    super.dispose();
  }

  Future<void> _initiatePayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    try {
      // Create payment donation model
      final paymentId = 'PAY${DateTime.now().millisecondsSinceEpoch}';
      final payment = PaymentDonationModel(
        id: paymentId,
        name: _nameController.text.trim(),
        payerUpiId: _payerUpiIdController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        upiId: NSSPaymentConfig.recipientUpiId,
        recipientMobile: NSSPaymentConfig.recipientMobile,
        description: _descriptionController.text.trim(),
        date: DateTime.now(),
      );

      // Save to Firebase
      await _firebaseController.savePaymentDonation(payment);
      _currentPaymentId = paymentId;

      // Launch payment app with error handling
      await _launchPaymentApp(payment);

      // Show transaction ID dialog
      if (mounted) {
        _showTransactionIdDialog();
      }
    } catch (e) {
      debugPrint('❌ Error initiating payment: $e');
      if (mounted) {
        _showErrorDialog('Failed to initiate payment: $e');
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _launchPaymentApp(PaymentDonationModel payment) async {
    final amount = payment.amount.toStringAsFixed(2);
    final upiId = NSSPaymentConfig.recipientUpiId;
    final name = Uri.encodeComponent(NSSPaymentConfig.recipientName);
    final note = Uri.encodeComponent(payment.description);

    // Generic UPI URL that works with all UPI apps
    String upiUrl = 'upi://pay?pa=$upiId&pn=$name&am=$amount&cu=INR&tn=$note';
    final Uri uri = Uri.parse(upiUrl);

    try {
      if (kIsWeb) {
        // For web, show payment instructions
        if (mounted) {
          _showWebPaymentInstructions(payment);
        }
      } else {
        // For mobile, try to launch UPI app
        bool launched = false;

        try {
          launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (e) {
          debugPrint('⚠️ UPI launch failed: $e');
          launched = false;
        }

        if (!launched) {
          // If UPI launch fails, show manual payment instructions
          if (mounted) {
            _showManualPaymentDialog(payment);
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error launching payment app: $e');
      if (mounted) {
        _showManualPaymentDialog(payment);
      }
    }
  }

  void _showManualPaymentDialog(PaymentDonationModel payment) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.primaryOrange),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Payment Instructions',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Colors.orange[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Please complete payment manually using any UPI app',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Follow these steps:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 12),
              _buildPaymentStep(
                '1',
                'Open any UPI app (PhonePe, Google Pay, Paytm, etc.)',
              ),
              _buildPaymentStep('2', 'Select "Send Money" or "Pay"'),
              _buildPaymentStep('3', 'Enter the following details:'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCopyableInfoRow(
                      'UPI ID:',
                      NSSPaymentConfig.recipientUpiId,
                      context,
                    ),
                    const Divider(height: 16),
                    _buildInfoRow('Name:', NSSPaymentConfig.recipientName),
                    const Divider(height: 16),
                    _buildInfoRow(
                      'Amount:',
                      '₹${payment.amount.toStringAsFixed(2)}',
                    ),
                    const Divider(height: 16),
                    _buildInfoRow(
                      'Note:',
                      payment.description.length > 30
                          ? '${payment.description.substring(0, 30)}...'
                          : payment.description,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildPaymentStep('4', 'Complete the payment'),
              _buildPaymentStep('5', 'Note down the Transaction ID'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelPayment();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showTransactionIdDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              foregroundColor: Colors.white,
            ),
            child: const Text('I Have Completed Payment'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primaryOrange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(text, style: const TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyableInfoRow(
    String label,
    String value,
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        IconButton(
          icon: const Icon(Icons.copy, size: 18),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$label copied to clipboard'),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ],
    );
  }

  void _showWebPaymentInstructions(PaymentDonationModel payment) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.payment, color: AppColors.primaryOrange),
            const SizedBox(width: 12),
            const Text('Web Payment'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please make payment using your UPI app with these details:',
            ),
            const SizedBox(height: 16),
            _buildInfoRow('UPI ID:', NSSPaymentConfig.recipientUpiId),
            _buildInfoRow('Mobile:', NSSPaymentConfig.recipientMobile),
            _buildInfoRow('Amount:', '₹${payment.amount.toStringAsFixed(2)}'),
            _buildInfoRow('Note:', payment.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showTransactionIdDialog();
            },
            child: const Text('I Have Completed Payment'),
          ),
        ],
      ),
    );
  }

  void _showTransactionIdDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.receipt_long, color: AppColors.primaryOrange),
            const SizedBox(width: 12),
            const Text('Enter Transaction ID'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Please enter the UPI transaction ID from your payment app to verify the payment.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _transactionIdController,
              decoration: InputDecoration(
                labelText: 'Transaction ID *',
                hintText: 'e.g., 123456789012',
                prefixIcon: const Icon(
                  Icons.tag,
                  color: AppColors.primaryOrange,
                ),
                filled: true,
                fillColor: AppColors.lightGrey,
                border: OutlineInputBorder(
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
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelPayment();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_transactionIdController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter transaction ID'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              Navigator.pop(context);
              await _verifyPaymentWithAI();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Verify Payment'),
          ),
        ],
      ),
    );
  }

  Future<void> _verifyPaymentWithAI() async {
    if (_currentPaymentId == null) return;

    // Show verification dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primaryOrange),
                SizedBox(height: 16),
                Text(
                  '🤖 AI Verification in Progress...',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Analyzing payment details'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // Update transaction ID
      await _firebaseController.updatePaymentStatus(
        _currentPaymentId!,
        _transactionIdController.text.trim(),
        'Completed',
      );

      // AI Verification
      final verification = await AIPaymentVerifier.verifyPayment(
        name: _nameController.text.trim(),
        payerUpiId: _payerUpiIdController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        upiId: NSSPaymentConfig.recipientUpiId,
        transactionId: _transactionIdController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      // Update AI verification status
      await _firebaseController.updateAIVerification(
        _currentPaymentId!,
        verification['status'],
        verification['notes'],
      );

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        _showVerificationResult(verification);
      }
    } catch (e) {
      debugPrint('❌ Error in AI verification: $e');
      if (mounted) {
        Navigator.pop(context);
        _showErrorDialog('Verification failed: $e');
      }
    }
  }

  void _showVerificationResult(Map<String, dynamic> verification) {
    final bool isVerified = verification['verified'];
    final String status = verification['status'];
    final int score = verification['score'];
    final String notes = verification['notes'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              isVerified ? Icons.check_circle : Icons.info,
              color: isVerified ? Colors.green : Colors.orange,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isVerified ? 'Payment Verified!' : 'Verification $status',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isVerified ? Colors.green[50] : Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Confidence Score: $score%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isVerified
                            ? Colors.green[700]
                            : Colors.orange[700],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(notes, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isVerified
                    ? 'Thank you for your donation! Your payment has been verified and will be processed shortly.'
                    : 'Your payment is under review. Our team will verify it manually.',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetForm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _cancelPayment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cancel Payment?'),
        content: const Text(
          'Are you sure you want to cancel this payment? Your donation will not be processed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, Continue'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetForm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _nameController.clear();
    _payerUpiIdController.clear();
    _amountController.clear();
    _descriptionController.clear();
    _transactionIdController.clear();
    _currentPaymentId = null;
    setState(() {});
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
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
                    'NSS Donation',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Secure Payment Gateway',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryOrange,
                    AppColors.primaryOrange.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryOrange.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.volunteer_activism,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Make a Difference Today',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your contribution helps us serve the community better',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.95),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Form Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipient Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Colors.blue,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Payment Recipient Details',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            'UPI ID:',
                            NSSPaymentConfig.recipientUpiId,
                          ),
                          const SizedBox(height: 4),
                          _buildInfoRow(
                            'Mobile:',
                            NSSPaymentConfig.recipientMobile,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Payer Details Section
                    Text(
                      'Your Details',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyBlue,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name *',
                        hintText: 'Enter your full name',
                        prefixIcon: const Icon(
                          Icons.person,
                          color: AppColors.primaryOrange,
                        ),
                        filled: true,
                        fillColor: AppColors.lightGrey,
                        border: OutlineInputBorder(
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
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        if (value.trim().length < 3) {
                          return 'Name must be at least 3 characters';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Payer UPI ID Field
                    TextFormField(
                      controller: _payerUpiIdController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Your UPI ID *',
                        hintText: 'e.g., yourname@paytm',
                        prefixIcon: const Icon(
                          Icons.account_balance_wallet,
                          color: AppColors.primaryOrange,
                        ),
                        filled: true,
                        fillColor: AppColors.lightGrey,
                        border: OutlineInputBorder(
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
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your UPI ID';
                        }
                        if (!value.contains('@')) {
                          return 'Invalid UPI ID format (must contain @)';
                        }
                        if (value.trim().length < 6) {
                          return 'UPI ID is too short';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Amount Field
                    Text(
                      'Donation Amount',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Amount (₹) *',
                        hintText: 'Enter amount',
                        prefixIcon: const Icon(
                          Icons.currency_rupee,
                          color: AppColors.primaryOrange,
                        ),
                        filled: true,
                        fillColor: AppColors.lightGrey,
                        border: OutlineInputBorder(
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
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter amount';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount < 10) {
                          return 'Minimum amount is ₹10';
                        }
                        if (amount > 100000) {
                          return 'Maximum amount is ₹1,00,000';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Quick Amount Buttons
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [100, 500, 1000, 2000, 5000].map((amount) {
                        return ActionChip(
                          label: Text('₹$amount'),
                          onPressed: () {
                            _amountController.text = amount.toString();
                          },
                          backgroundColor: AppColors.lightGrey,
                          labelStyle: GoogleFonts.poppins(
                            color: AppColors.navyBlue,
                            fontWeight: FontWeight.w600,
                          ),
                          side: const BorderSide(
                            color: AppColors.primaryOrange,
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Description Field
                    Text(
                      'Purpose of Donation',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Description *',
                        hintText:
                            'Why are you donating? (e.g., Community support, Education aid)',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 60),
                          child: Icon(
                            Icons.description,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.lightGrey,
                        border: OutlineInputBorder(
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
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please describe the purpose';
                        }
                        if (value.trim().length < 10) {
                          return 'Please provide more details (min 10 characters)';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // AI Badge
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.withOpacity(0.1),
                            Colors.blue.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.purple.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.psychology,
                              color: Colors.purple,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AI-Powered Verification',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Your payment will be automatically verified using AI technology for security and accuracy.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _initiatePayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          shadowColor: AppColors.primaryOrange.withOpacity(0.5),
                        ),
                        child: _isProcessing
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.payment, size: 24),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Proceed to Payment',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Security Note
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.security,
                            color: Colors.green,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your payment is secure and encrypted. All transactions are verified by our AI system.',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.green[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
