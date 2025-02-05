import 'package:flutter/material.dart';
import '../../models/subscription_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TierListPage extends StatefulWidget {
  const TierListPage({super.key});

  @override
  State<TierListPage> createState() => _TierListPageState();
}

class _TierListPageState extends State<TierListPage> {
  final _tiers = SubscriptionTier.getDefaultTiers();
  UserModel? _currentUser;
  bool _isLoading = false;
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _initializeAuthService();
  }

  Future<void> _initializeAuthService() async {
    _authService = AuthService(await SharedPreferences.getInstance());
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await _authService.getCurrentUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  Future<void> _subscribe(SubscriptionTier tier) async {
    if (_currentUser == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Update user's subscription tier locally
      final updatedUser = _currentUser!.copyWith(
        subscriptionTier: tier.level,
        subscriptionExpiry: DateTime.now().add(const Duration(days: 30)),
      );

      await _authService.updateUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully subscribed to ${tier.name}!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error subscribing to tier'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Subscription Tiers',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF9146FF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
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
                ..._tiers.map((tier) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildTierCard(context, tier),
                    )),
              ],
            ),
    );
  }

  Widget _buildTierCard(BuildContext context, SubscriptionTier tier) {
    final isCurrentTier = _currentUser?.subscriptionTier == tier.level;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isCurrentTier
              ? const Color(0xFF9146FF)
              : tier.isPopular
                  ? const Color(0xFF9146FF)
                  : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          if (tier.isPopular)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: const BoxDecoration(
                color: Color(0xFF9146FF),
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
          if (isCurrentTier)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: const BoxDecoration(
                color: Color(0xFF9146FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: const Text(
                'CURRENT TIER',
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
                  tier.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${tier.price.toStringAsFixed(2)}/month',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tier.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ...tier.benefits.map((benefit) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.purple[300],
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(benefit),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isCurrentTier ? null : () => _subscribe(tier),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9146FF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isCurrentTier ? 'Current Tier' : 'Subscribe Now',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
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
