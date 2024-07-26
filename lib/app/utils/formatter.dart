import 'package:intl/intl.dart';

abstract class FormattedInputers {
  static String formatCpfCnpj(String value) {
    value = value.replaceAll(RegExp(r'\D'), '');

    if (value.length <= 11) {
      return value.replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d{3})(\d{2})'),
          (Match m) => "${m[1]}.${m[2]}.${m[3]}-${m[4]}");
    } else {
      return value.replaceAllMapped(
          RegExp(r'(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})'),
          (Match m) => "${m[1]}.${m[2]}.${m[3]}/${m[4]}-${m[5]}");
    }
  }

  static String formatContact(String value) {
    value = value.replaceAll(RegExp(r'\D'), '');

    if (value.length <= 10) {
      return value.replaceAllMapped(RegExp(r'(\d{2})(\d{4})(\d{4})'),
          (Match m) => "(${m[1]}) ${m[2]}-${m[3]}");
    } else {
      return value.replaceAllMapped(RegExp(r'(\d{2})(\d{5})(\d{4})'),
          (Match m) => "(${m[1]}) ${m[2]}-${m[3]}");
    }
  }

  static String formatDate(String value) {
    var text = value.replaceAll(RegExp(r'[^0-9]'), '');
    var buffer = StringBuffer();
    var textIndex = 0;

    for (var i = 0; i < text.length; i++) {
      if (i == 2 || i == 4) {
        buffer.write('/');
      }
      buffer.write(text[textIndex]);
      textIndex++;
    }

    return buffer.toString();
  }

  static String formatValue(String value) {
    var text = value.replaceAll(RegExp(r'[^0-9]'), '');
    var buffer = StringBuffer();
    var textLength = text.length;

    if (textLength > 2) {
      buffer.write('R\$ ');
      for (var i = 0; i < textLength; i++) {
        if (i == textLength - 2) {
          buffer.write(',');
        } else if (i > 0 && (textLength - i - 2) % 3 == 0) {
          buffer.write('.');
        }
        buffer.write(text[i]);
      }
    } else {
      buffer.write('R\$ $text');
    }

    return buffer.toString();
  }

  static String formatPercentage(String value) {
    var text = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.isEmpty) {
      return '0,00%';
    }

    var number = int.parse(text);
    var formattedNumber =
        NumberFormat.decimalPercentPattern(decimalDigits: 2, locale: 'pt_BR')
            .format(number / 10000.0);

    return formattedNumber;
  }

  static String formatPercentageSend(String value) {
    var text = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.isEmpty) {
      return '0,00%';
    }

    var number = int.parse(text);
    var formattedNumber =
        NumberFormat.decimalPercentPattern(decimalDigits: 2, locale: 'pt_BR')
            .format(number / 1000.0);

    return formattedNumber;
  }

  static String formatApiDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return 'Data inválida';
    }
  }

  static double convertToDouble(String valorString) {
    try {
      String valorSemMoeda = valorString.replaceAll("R\$ ", "");
      valorSemMoeda = valorSemMoeda.replaceAll(".", "");
      valorSemMoeda = valorSemMoeda.replaceAll(",", ".");
      double valorDouble = double.parse(valorSemMoeda);

      return valorDouble;
    } catch (e) {
      print("Erro ao converter o valor: $e");
    }

    return 0;
  }

  static double convertPercentageToDouble(String percentageString) {
    try {
      String valueWithoutPercentage =
          percentageString.replaceAll("%", "").trim();

      valueWithoutPercentage = valueWithoutPercentage.replaceAll(",", ".");

      double percentageValue = double.parse(valueWithoutPercentage);

      return percentageValue;
    } catch (e) {
      print("Erro ao converter o valor: $e");
    }

    return 0;
  }
}
