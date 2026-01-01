/// Payment models for WorkOn.
///
/// Data models for Stripe payment integration.
///
/// **PR-RC1:** Initial implementation.
library;

/// Response from creating a PaymentIntent.
class PaymentIntentResponse {
  /// Stripe PaymentIntent ID.
  final String paymentIntentId;

  /// Client secret for frontend confirmation.
  final String clientSecret;

  /// Amount in cents.
  final int amount;

  /// Currency code (e.g., 'CAD').
  final String currency;

  /// Associated mission ID.
  final String missionId;

  const PaymentIntentResponse({
    required this.paymentIntentId,
    required this.clientSecret,
    required this.amount,
    required this.currency,
    required this.missionId,
  });

  /// Parse from JSON (backend response).
  factory PaymentIntentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentIntentResponse(
      paymentIntentId: json['paymentIntentId'] as String? ?? '',
      clientSecret: json['clientSecret'] as String? ?? '',
      amount: json['amount'] as int? ?? 0,
      currency: json['currency'] as String? ?? 'CAD',
      missionId: json['missionId'] as String? ?? '',
    );
  }

  /// Formatted amount (e.g., "$75.00").
  String get formattedAmount {
    final dollars = amount / 100;
    return '\$${dollars.toStringAsFixed(2)}';
  }
}

/// Payment status enum.
enum PaymentStatus {
  pending,
  processing,
  succeeded,
  failed,
  cancelled;

  static PaymentStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'succeeded':
        return PaymentStatus.succeeded;
      case 'processing':
        return PaymentStatus.processing;
      case 'failed':
        return PaymentStatus.failed;
      case 'cancelled':
      case 'canceled':
        return PaymentStatus.cancelled;
      default:
        return PaymentStatus.pending;
    }
  }
}

