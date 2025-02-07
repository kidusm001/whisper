import 'package:flutter/material.dart';

class PayoutSettingsScreen extends StatefulWidget {
  const PayoutSettingsScreen({super.key});

  @override
  State<PayoutSettingsScreen> createState() => _PayoutSettingsScreenState();
}

class _PayoutSettingsScreenState extends State<PayoutSettingsScreen> {
  String? _selectedPaymentMethod;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers for bank details
  final _accountNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _routingNumberController = TextEditingController();
  final _bankNameController = TextEditingController();

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _routingNumberController.dispose();
    _bankNameController.dispose();
    super.dispose();
  }

  Widget _buildPaymentMethodCard({
    required String title,
    required String description,
    required String imagePath,
    required String value,
    required VoidCallback onTap,
  }) {
    final isSelected = _selectedPaymentMethod == value;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF320064).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF320064) : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF320064).withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Radio(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value as String;
                });
              },
              activeColor: const Color(0xFF320064),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankTransferForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            controller: _accountNameController,
            label: 'Account Holder Name',
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter account holder name' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _accountNumberController,
            label: 'Account Number',
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter account number' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _routingNumberController,
            label: 'Routing Number',
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter routing number' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _bankNameController,
            label: 'Bank Name',
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter bank name' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF320064)),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Payout Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Payout Method',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose how you want to receive your earnings',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            _buildPaymentMethodCard(
              title: 'PayPal',
              description: 'Get paid directly to your PayPal account',
              imagePath: 'assets/images/paypal.png', // Add this image
              value: 'paypal',
              onTap: () => setState(() => _selectedPaymentMethod = 'paypal'),
            ),
            _buildPaymentMethodCard(
              title: 'Stripe',
              description: 'Connect with Stripe for secure payments',
              imagePath: 'assets/images/stripe.png', // Add this image
              value: 'stripe',
              onTap: () => setState(() => _selectedPaymentMethod = 'stripe'),
            ),
            _buildPaymentMethodCard(
              title: 'Bank Transfer',
              description: 'Direct deposit to your bank account',
              imagePath: 'assets/images/bank.png', // Add this image
              value: 'bank',
              onTap: () => setState(() => _selectedPaymentMethod = 'bank'),
            ),
            if (_selectedPaymentMethod == 'bank') ...[
              const SizedBox(height: 24),
              Text(
                'Bank Account Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),
              _buildBankTransferForm(),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_selectedPaymentMethod == 'bank') {
                          if (!_formKey.currentState!.validate()) return;
                        }
                        // Handle save payout method
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF320064),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Save Payout Method',
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
      ),
    );
  }
} 