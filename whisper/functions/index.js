const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// Use the environment variable STRIPE_SECRET.
// Make sure to set this variable in your deployment environment.
// eslint-disable-next-line max-len
const stripeSecret = process.env.STRIPE_SECRET || functions.config().stripe.secret;
const stripe = require("stripe")(stripeSecret);
const cors = require("cors")({origin: true});

/**
 * Maps a subscription tier to its corresponding Stripe price ID.
 * @param {string} tier - The subscription tier.
 * @return {string} The corresponding Stripe price ID.
 */
function getStripePriceId(tier) {
  switch (tier) {
    case "backstagePass":
      return "price_123_backstage";
    case "innerCircle":
      return "price_456_inner";
    default:
      return "price_789_general";
  }
}

/**
 * Cloud Function: createSubscription
 * Expects the following JSON payload:
 * {
 *   "userId": "user_abc",
 *   "paymentMethodId": "pm_xyz",
 *   "tier": "backstagePass" // or "innerCircle" or "generalAdmission"
 * }
 */
exports.createSubscription = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    try {
      // Ensure the request method is POST.
      if (req.method !== "POST") {
        return res.status(405).send({error: "Method Not Allowed"});
      }

      const {userId, paymentMethodId, tier} = req.body;
      if (!userId || !paymentMethodId || !tier) {
        return res.status(400).send({error: "Missing parameters"});
      }

      // Optionally, look up your user in Firestore to get email, name, etc.
      // eslint-disable-next-line max-len
      const userSnapshot = await admin.firestore().collection("users").doc(userId).get();
      if (!userSnapshot.exists) {
        return res.status(404).send({error: "User not found"});
      }
      const userData = userSnapshot.data();

      // Create a Stripe customer if one doesn't exist.
      // eslint-disable-next-line max-len
      // In production, you should store the Stripe customer ID in your Firestore user document.
      let stripeCustomerId = userData.stripeCustomerId;
      if (!stripeCustomerId) {
        const customer = await stripe.customers.create({
          email: userData.email,
          metadata: {firebaseUID: userId},
        });
        stripeCustomerId = customer.id;
        // Save the customer id back to Firestore.
        await admin.firestore().collection("users").doc(userId).update({
          stripeCustomerId,
        });
      }

      // Attach the payment method to the customer.
      await stripe.paymentMethods.attach(paymentMethodId, {
        customer: stripeCustomerId,
      });

      // Set the default payment method on the customer.
      await stripe.customers.update(stripeCustomerId, {
        invoice_settings: {
          default_payment_method: paymentMethodId,
        },
      });

      // Create the subscription on Stripe.
      const subscription = await stripe.subscriptions.create({
        customer: stripeCustomerId,
        items: [{
          price: getStripePriceId(tier),
        }],
        expand: ["latest_invoice.payment_intent"],
      });

      // eslint-disable-next-line max-len
      // Optionally, you can return the client secret for the payment intent if additional authentication is required.
      const paymentIntent = subscription.latest_invoice.payment_intent;
      res.status(200).send({
        subscriptionId: subscription.id,
        clientSecret: paymentIntent ? paymentIntent.client_secret : null,
        status: subscription.status,
      });
    } catch (error) {
      console.error("Error creating subscription:", error);
      res.status(500).send({error: error.message});
    }
  });
});
