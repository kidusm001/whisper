import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/subscription_model.dart';

class StripeService {
  final String stripePublicKey;
  // URL to your Cloud Function endpoint (replace with your deployed function URL)
  final String createSubscriptionUrl;

  StripeService({
    required this.stripePublicKey,
    required this.createSubscriptionUrl,
  }) {
    // Initialize Flutter Stripe with your publishable key.
    Stripe.publishableKey = stripePublicKey;
  }

  Future<PaymentMethod> createPaymentMethod({
    required CardDetails card,
    required String email,
  }) async {
    final paymentMethod = await Stripe.instance.createPaymentMethod(
      params: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(
          billingDetails: BillingDetails(
            email: email,
          ),
        ),
      ),
    );
    return paymentMethod;
  }

  Future<Map<String, dynamic>> createSubscriptionBackend({
    required String userId,
    required SubscriptionTier tier,
    required String paymentMethodId,
  }) async {
    final response = await http.post(
      Uri.parse(createSubscriptionUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'paymentMethodId': paymentMethodId,
        // Map your enum to a string that the backend expects.
        'tier': tier.toString().split('.').last,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create subscription: ${response.body}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> handleSubscriptionPayment({
    required String userId,
    required SubscriptionTier tier,
    required String paymentMethodId,
    required String email, // Pass the user's email
  }) async {
    try {
      // Call your backend to create the subscription on Stripe.
      final result = await createSubscriptionBackend(
        userId: userId,
        tier: tier,
        paymentMethodId: paymentMethodId,
      );

      // Extract information from the backend response.
      final subscriptionId = result['subscriptionId'];
      final clientSecret = result['clientSecret'];

      // Optionally, if client secret is returned, you may want to confirm the payment.
      if (clientSecret != null) {
        await Stripe.instance.confirmPayment(
          paymentIntentClientSecret: clientSecret,
          data: PaymentMethodParams.card(
            paymentMethodData: PaymentMethodData(
              billingDetails: BillingDetails(
                email: email,
              ),
            ),
          ),
        );
      }

      // Save the subscription details in Firestore.
      final newSubscription = Subscription(
        subscriptionId: subscriptionId,
        userId: userId,
        tier: tier,
        status: SubscriptionStatus.active,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
        amount: _getTierPrice(tier),
        currency: 'USD',
        paymentMethodId: paymentMethodId,
        stripeSubscriptionId: subscriptionId,
        autoRenew: true,
      );

      await FirebaseFirestore.instance
          .collection('subscriptions')
          .doc(subscriptionId)
          .set(newSubscription.toJson());
    } on StripeException catch (e) {
      throw Exception('Stripe error: ${e.error.localizedMessage}');
    }
  }

  double _getTierPrice(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.backstagePass:
        return 19.99;
      case SubscriptionTier.innerCircle:
        return 49.99;
      default:
        return 10.0;
    }
  }
}
