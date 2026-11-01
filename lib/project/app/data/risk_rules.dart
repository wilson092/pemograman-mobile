import 'package:pemob/project/app/data/models/weather_rule.dart';

class RiskRuleHelper {
  RiskRuleHelper._();

  static const List<WeatherRule> initialRules = [
    WeatherRule(
      level: RiskLevel.rendah,
      minTemp: -50.0,
      maxTemp: 22.0,
    ),
    WeatherRule(
      level: RiskLevel.sedang,
      minTemp: 22.0,
      maxTemp: 35.0,
    ),
    WeatherRule(
      level: RiskLevel.tinggi,
      minTemp: 35.0,
      maxTemp: 60.0,
    ),
  ];

  /// Calculate risk category from rules
  /// Rule: lower bound inclusive, upper bound exclusive, except High upper bound is inclusive.
  /// Temperature rounded to 1 decimal place. Outside all -> fallback Sedang.
  static RiskLevel calculateRisk(double temp, List<WeatherRule> rules, {RiskLevel? override}) {
    if (override != null) return override;

    final rounded = double.parse(temp.toStringAsFixed(1));

    WeatherRule? lowRule;
    WeatherRule? medRule;
    WeatherRule? highRule;

    for (final rule in rules) {
      if (rule.level == RiskLevel.rendah) lowRule = rule;
      if (rule.level == RiskLevel.sedang) medRule = rule;
      if (rule.level == RiskLevel.tinggi) highRule = rule;
    }

    if (lowRule != null && rounded >= lowRule.minTemp && rounded < lowRule.maxTemp) {
      return RiskLevel.rendah;
    }
    if (medRule != null && rounded >= medRule.minTemp && rounded < medRule.maxTemp) {
      return RiskLevel.sedang;
    }
    if (highRule != null && rounded >= highRule.minTemp && rounded <= highRule.maxTemp) {
      return RiskLevel.tinggi;
    }

    return RiskLevel.sedang; // Fallback Sedang
  }

  /// Format range text for display, e.g. "22,0 – 34,9 °C"
  static String formatRangeText(double temp, RiskLevel level, List<WeatherRule> rules) {
    final rule = rules.firstWhere(
      (r) => r.level == level,
      orElse: () => const WeatherRule(level: RiskLevel.sedang, minTemp: 22.0, maxTemp: 35.0),
    );

    final minStr = rule.minTemp.toStringAsFixed(1).replaceAll('.', ',');
    // For inclusive display representation: if not upper max of highest tier, subtract 0.1
    final maxVal = rule.level == RiskLevel.tinggi ? rule.maxTemp : (rule.maxTemp - 0.1);
    final maxStr = maxVal.toStringAsFixed(1).replaceAll('.', ',');

    final tempStr = temp.toStringAsFixed(1);
    return '$tempStr°C ada di rentang $minStr – $maxStr °C';
  }

  /// Validation: min < max, no overlaps, no gaps
  /// Returns error string or null if valid.
  static String? validateRules(List<WeatherRule> rules) {
    if (rules.length != 3) {
      return 'Harus memiliki tepat 3 aturan cuaca.';
    }

    final low = rules.firstWhere((r) => r.level == RiskLevel.rendah);
    final med = rules.firstWhere((r) => r.level == RiskLevel.sedang);
    final high = rules.firstWhere((r) => r.level == RiskLevel.tinggi);

    if (low.minTemp >= low.maxTemp) {
      return 'Tingkat Rendah: Suhu minimum harus lebih kecil dari maksimum.';
    }
    if (med.minTemp >= med.maxTemp) {
      return 'Tingkat Sedang: Suhu minimum harus lebih kecil dari maksimum.';
    }
    if (high.minTemp >= high.maxTemp) {
      return 'Tingkat Tinggi: Suhu minimum harus lebih kecil dari maksimum.';
    }

    if (low.maxTemp != med.minTemp) {
      return 'Celah/Tumpang tindih: Maksimum Rendah harus sama dengan Minimum Sedang (${low.maxTemp} != ${med.minTemp}).';
    }

    if (med.maxTemp != high.minTemp) {
      return 'Celah/Tumpang tindih: Maksimum Sedang harus sama dengan Minimum Tinggi (${med.maxTemp} != ${high.minTemp}).';
    }

    return null;
  }
}
