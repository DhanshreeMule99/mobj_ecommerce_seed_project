class Coupon {
  final int couponId;
  final int ruleId;
  final String code;
  final int usageLimit;
  final int usagePerCustomer;
  final int timesUsed;
  final bool isPrimary;
  final int type;
  final String discription;

  Coupon({
    required this.couponId,
    required this.ruleId,
    required this.code,
    required this.usageLimit,
    required this.usagePerCustomer,
    required this.timesUsed,
    required this.isPrimary,
    required this.type,
    this.discription = "",
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      couponId: json['coupon_id'],
      ruleId: json['rule_id'],
      code: json['code'],
      usageLimit: json['usage_limit'],
      usagePerCustomer: json['usage_per_customer'],
      timesUsed: json['times_used'],
      isPrimary: json['is_primary'],
      type: json['type'],
    );
  }
}

class Couponmodel {
  final int ruleId;
  final String name;
  final String description;
  final DateTime fromDate;
  final DateTime toDate;
  final bool isActive;
  final int usesPerCustomer;
  final int usesPerCoupon;
  final String simpleAction;
  final double discountAmount;
  final bool applyToShipping;

  Couponmodel({
    required this.ruleId,
    required this.name,
    required this.description,
    required this.fromDate,
    required this.toDate,
    required this.isActive,
    required this.usesPerCustomer,
    required this.usesPerCoupon,
    required this.simpleAction,
    required this.discountAmount,
    required this.applyToShipping,
  });

  factory Couponmodel.fromJson(Map<String, dynamic> json) {
    return Couponmodel(
      ruleId: json['rule_id'],
      name: json['name'],
      description: json['description'],
      fromDate: DateTime.parse(json['from_date']),
      toDate: DateTime.parse(json['to_date']),
      isActive: json['is_active'],
      usesPerCustomer: json['uses_per_customer'],
      usesPerCoupon: json['uses_per_coupon'],
      simpleAction: json['simple_action'],
      discountAmount: json['discount_amount'].toDouble(),
      applyToShipping: json['apply_to_shipping'],
    );
  }
}
