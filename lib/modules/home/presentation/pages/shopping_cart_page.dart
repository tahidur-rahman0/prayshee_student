import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_training_template/app/const/const.dart';
import 'package:flutter_upi_india/flutter_upi_india.dart';
import 'package:online_training_template/models/user_model.dart';
import 'package:online_training_template/modules/home/presentation/pages/order_confirmed_page.dart';
import 'package:online_training_template/repositories/transaction_repository.dart';
import 'package:online_training_template/repositories/auth_local_repository.dart';
import 'package:online_training_template/providers/current_user_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PaymentMethod { online, cash }

class ShoppingCartPage extends ConsumerStatefulWidget {
  final int id;
  final String title;
  final String description;
  final int totalPdfs;
  final int totalVideos;
  final String price;
  final String mrp;
  final int validity;
  final String image;
  final int teacherId;

  const ShoppingCartPage({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.totalPdfs,
    required this.totalVideos,
    required this.price,
    required this.mrp,
    required this.validity,
    required this.image,
    required this.teacherId,
  });

  @override
  ConsumerState<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends ConsumerState<ShoppingCartPage> {
  final NumberFormat currencyFormat = NumberFormat.currency(symbol: '\₹');
  PaymentMethod _selectedPaymentMethod = PaymentMethod.online;
  List<ApplicationMeta>? upiApps;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _fetchUpiApps();
  }

  Future<void> _fetchUpiApps() async {
    try {
      upiApps = await UpiPay.getInstalledUpiApplications(
        statusType: UpiApplicationDiscoveryAppStatusType.all,
      );
      setState(() {});
    } catch (e) {
      debugPrint('Error fetching UPI apps: $e');
    }
  }

  Future<void> _processTransaction(String paymentId, String paymentMode) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final token = ref.read(authLocalRepositoryProvider).getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final currentUser = ref.read(currentUserNotifierProvider);
      if (currentUser == null) {
        throw Exception('No user data found');
      }

      final transactionRepo = ref.read(transactionRepositoryProvider);
      final result = await transactionRepo.createTransection(
        token: token,
        teacherId: widget.teacherId,
        studentId: currentUser.id,
        studentName: currentUser.name,
        courseId: widget.id,
        courseName: widget.title,
        price: double.parse(widget.price),
        paymentId: paymentId,
        paymentMode: paymentMode,
      );

      int timestamp = DateTime.now().millisecondsSinceEpoch;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationPage(
            courseId: widget.id,
            courseTitle: widget.title,
            amount: widget.price,
            transactionId: timestamp.toString(),
          ),
        ),
      );

      // result.fold(
      //   (failure) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text('Transaction failed: ${failure.message}'),
      //         backgroundColor: Colors.red,
      //       ),
      //     );
      //   },
      //   (transaction) {
      //     // Navigate to order confirmation page
      //     if (mounted) {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => OrderConfirmationPage(
      //             courseId: widget.id,
      //             courseTitle: widget.title,
      //             amount: widget.price,
      //             transactionId: transaction.payment_id,
      //           ),
      //         ),
      //       );
      //     }
      //   },
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing transaction: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Parse string prices to double for calculations
    final double priceValue = double.tryParse(widget.price) ?? 0;
    final double mrpValue = double.tryParse(widget.mrp) ?? 0;
    final double discount = mrpValue - priceValue;
    final discountPercentage = (discount / mrpValue * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Prayashee Cart"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Header
                  _buildCourseHeader(),
                  const SizedBox(height: 24),

                  // Course Details
                  _buildDetailRow("Course Title", widget.title),
                  _buildDetailRow("Description", widget.description),
                  _buildDetailRow("PDF Courses", "${widget.totalPdfs} PDFs"),
                  _buildDetailRow(
                      "Video Courses", "${widget.totalVideos} Videos"),
                  _buildDetailRow(
                      "Validity", '${widget.validity.toString()} Months'),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Pricing
                  _buildPriceRow("MRP", '₹ ${widget.mrp}', isOriginal: true),
                  _buildPriceRow("Discount", currencyFormat.format(discount)),
                  _buildPriceRow("You Pay", '₹ ${widget.price}', isTotal: true),

                  Text(
                    "You save ${discountPercentage}% (${currencyFormat.format(discount)})",
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Payment Section
          _buildPaymentSection(),
        ],
      ),
    );
  }

  Widget _buildCourseHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage('${ServerConstant.baseUrl}${widget.image}'),
              fit: BoxFit.cover,
              // Optional: Add a placeholder while loading
              onError: (exception, stackTrace) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount,
      {bool isOriginal = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isOriginal ? Colors.grey : Colors.black,
              decoration: isOriginal ? TextDecoration.lineThrough : null,
            ),
          ),
          const Spacer(),
          Text(
            amount,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 16,
              color: isTotal
                  ? defaultPrimaryColor
                  : (isOriginal ? Colors.grey : Colors.black),
              decoration: isOriginal ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    final priceValue = double.tryParse(widget.price) ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, -3)),
        ],
      ),
      child: Column(
        children: [
          // Payment Options
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Payment Method",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildPaymentOption(
                  "Online Payment",
                  PaymentMethod.online,
                  Icons.credit_card,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPaymentOption(
                  "Pay cash Request",
                  PaymentMethod.cash,
                  Icons.money,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Pay Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                if (_selectedPaymentMethod == PaymentMethod.cash) {
                  int timestamp = DateTime.now().millisecondsSinceEpoch;

                  _processTransaction(
                    timestamp.toString(),
                    'Cash',
                  );
                } else {
                  if (upiApps == null || upiApps!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No UPI apps installed on this device.'),
                      ),
                    );
                    return;
                  }

                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Choose UPI App',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            GridView.count(
                              crossAxisCount: 4,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: upiApps!.map((app) {
                                return Material(
                                  child: InkWell(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      final transactionRef = DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString();

                                      final response =
                                          await UpiPay.initiateTransaction(
                                        amount: widget.price,
                                        app: app.upiApplication,
                                        receiverName: 'Tohidur Rahman',
                                        receiverUpiAddress:
                                            'rahmantohidur12-2@oksbi',
                                        transactionRef: transactionRef,
                                        transactionNote:
                                            'Payment for ${widget.title}',
                                      );

                                      if (response.status == 'SUCCESS') {
                                        await _processTransaction(
                                          response.txnId ?? '',
                                          'UPI',
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Transaction failed: ${response.status}',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        app.iconImage(48),
                                        const SizedBox(height: 4),
                                        Text(
                                          app.upiApplication.getAppName(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
              child: const Text(
                "PAY NOW",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
      String title, PaymentMethod method, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _selectedPaymentMethod == method
                ? defaultPrimaryColor
                : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: _selectedPaymentMethod == method
                  ? defaultPrimaryColor
                  : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontWeight: _selectedPaymentMethod == method
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: _selectedPaymentMethod == method
                    ? defaultPrimaryColor
                    : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
