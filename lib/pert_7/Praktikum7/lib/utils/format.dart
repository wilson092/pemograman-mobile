import 'package:intl/intl.dart';

class FormatUtil {
  static String rupiah(int nominal) {
    final formatRupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatRupiah.format(nominal);
  }

  static String tanggal(String yyyyMMdd) {
    try {
      final dt = DateTime.parse(yyyyMMdd);
      return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(dt);
    } catch (_) {
      return yyyyMMdd;
    }
  }

  static String hariIni() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }
}
