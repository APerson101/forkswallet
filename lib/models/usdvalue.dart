import 'dart:convert';

class USDChia {
  double usd;
  double btc;
  USDChia({
    required this.usd,
    required this.btc,
  });

  USDChia copyWith({
    double? usd,
    double? btc,
  }) {
    return USDChia(
      usd: usd ?? this.usd,
      btc: btc ?? this.btc,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usd': usd,
      'btc': btc,
    };
  }

  factory USDChia.fromMap(Map<String, dynamic> map) {
    return USDChia(
      usd: map['usd']?.toDouble() ?? 0.0,
      btc: map['btc']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory USDChia.fromJson(String source) =>
      USDChia.fromMap(json.decode(source));

  @override
  String toString() => 'USDChia(usd: $usd, btc: $btc)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is USDChia && other.usd == usd && other.btc == btc;
  }

  @override
  int get hashCode => usd.hashCode ^ btc.hashCode;
}
