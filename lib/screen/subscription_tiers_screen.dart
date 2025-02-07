import 'package:flutter/material.dart';

class SubscriptionTiersScreen extends StatelessWidget {
  const SubscriptionTiersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Tiers'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTierCard(
            context,
            title: 'Basic',
            price: '\$4.99/month',
            features: [
              'Access to exclusive posts',
              'Join community discussions'
            ],
            tier: 'basic',
          ),
          const SizedBox(height: 16),
          _buildTierCard(
            context,
            title: 'Premium',
            price: '\$9.99/month',
            features: [
              'All Basic features',
              'Early access to content',
              'Exclusive live streams'
            ],
            tier: 'premium',
          ),
          const SizedBox(height: 16),
          _buildTierCard(
            context,
            title: 'VIP',
            price: '\$19.99/month',
            features: [
              'All Premium features',
              'Direct messaging with creator',
              'Monthly virtual meetups',
              'Custom badge on comments'
            ],
            tier: 'vip',
          ),
        ],
      ),
    );
  }

  Widget _buildTierCard(
    BuildContext context, {
    required String title,
    required String price,
    required List<String> features,
    required String tier,
  }) {
    return Card(
      child: InkWell(
        onTap: () {
          // Return the selected tier to the previous screen
          Navigator.pop(context, tier);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                price,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              ...features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(feature),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
