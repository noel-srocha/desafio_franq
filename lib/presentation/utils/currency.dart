import 'package:intl/intl.dart';

class Currency {
  static final _brl = NumberFormat.simpleCurrency(locale: 'pt_BR');

  static String brl(num value) => _brl.format(value);
}
