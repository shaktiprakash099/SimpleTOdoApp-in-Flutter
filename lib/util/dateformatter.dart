import 'package:intl/intl.dart';
String dateFormatted(){
  var now = DateTime.now();
  var formatter = new DateFormat("EEE, MM dd,yy");
  String formatted = formatter.format(now);
  return formatted;
}
