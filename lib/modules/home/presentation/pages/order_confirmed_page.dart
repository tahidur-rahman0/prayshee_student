import 'package:flutter/material.dart';

class OrderConfirmationPage extends StatefulWidget {
  final int courseId;
  final String courseTitle;
  final String amount;
  final String transactionId;

  const OrderConfirmationPage({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.amount,
    required this.transactionId,
  });

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late Animation<double> _iconScale;

  bool _showDetails = false;

  @override
  void initState() {
    super.initState();

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _iconScale = CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    );

    _iconController.forward().whenComplete(() {
      setState(() {
        _showDetails = true;
      });
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _iconScale,
              child: Icon(
                Icons.check_circle_rounded,
                size: 120,
                color: Colors.green.shade600,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _showDetails ? 1.0 : 0.0,
              child: Column(
                children: [
                  const Text(
                    "Order Confirmed!",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Your order has been placed successfully.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildOrderCard(),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Go back or home
                    },
                    icon: const Icon(Icons.home),
                    label: const Text("Back to Home"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.receipt_long, color: Colors.blue),
              title: const Text("Transaction ID"),
              subtitle: Text(widget.transactionId),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.school, color: Colors.deepPurple),
              title: const Text("Course"),
              subtitle: Text(widget.courseTitle),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.payment, color: Colors.green),
              title: const Text("Amount Paid"),
              subtitle: Text("₹${widget.amount}"),
            ),
          ],
        ),
      ),
    );
  }
}
