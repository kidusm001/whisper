import 'package:flutter/material.dart';

class SubscriptionTiersScreen extends StatelessWidget {
  const SubscriptionTiersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Tiers'),
        backgroundColor: const Color(0xFF320064),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Choose Your Access Level',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildTierCard(
                context,
                title: 'General Admission',
                price: '\$5.00',
                description: 'Basic access to creator content',
                features: [
                  'Access to public posts',
                  'Comment on content',
                  'Join community discussions',
                  'Monthly newsletter',
                ],
                isPopular: false,
              ),
              const SizedBox(height: 16),
              _buildTierCard(
                context,
                title: 'Backstage Pass',
                price: '\$15.00',
                description: 'Enhanced access with exclusive content',
                features: [
                  'All General Admission benefits',
                  'Exclusive behind-the-scenes content',
                  'Early access to new content',
                  'Monthly Q&A sessions',
                  'Exclusive merchandise discounts',
                ],
                isPopular: true,
              ),
              const SizedBox(height: 16),
              _buildTierCard(
                context,
                title: 'Inner Circle',
                price: '\$30.00',
                description: 'VIP access with personal interaction',
                features: [
                  'All Backstage Pass benefits',
                  'Personal interaction with creator',
                  'Private Discord channel access',
                  'Custom content requests',
                  'Exclusive live streams',
                  'Priority support',
                ],
                isPopular: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTierCard(
    BuildContext context, {
    required String title,
    required String price,
    required String description,
    required List<String> features,
    required bool isPopular,
  }) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (isPopular)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF320064),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: const Text(
                'MOST POPULAR',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '$price/month',
                  style: TextStyle(
                    fontSize: 20,
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: theme.hintColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ...features.map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF320064),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature,
                              style: TextStyle(
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement subscription logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF320064),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Subscribe Now'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
