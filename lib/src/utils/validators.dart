
double parseDouble(dynamic number) {
  if(number==null)
    return 0.0;
  if (number is double)
    return number.toDouble();
  return double.parse("$number");
}

int parseInt(dynamic number) {
  if(number==null)
    return 0;
  if (number is int)
    return number.toInt();
  return int.parse("$number");
}

//* Redondear numero
double round(double val, int places) {
  return parseDouble(val.toStringAsFixed(2));
}

String money(value) {
  String text = "0.0";

  if (value is int) {
    text = "\$ ${(value.toDouble()).toStringAsFixed(2)}";
  }

  if (value is double) {
    text = "\$ ${(value).toStringAsFixed(2)}";
  }

  if (value is String) {
    if (isNumeric(value)) {
      text = "\$ ${double.parse(value).toStringAsFixed(2)}";
    } else {
      text = "\$ $value";
    }
  }

  return text;
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

String dateForHumans(DateTime currentTime) {
  if (currentTime == null) {
    return "__/__/__";
  }
  return "${currentTime.year}-${currentTime.month}-${currentTime.day}";
}

String dateForHumans2(DateTime currentTime) {
  if (currentTime == null) {
    return "__/__/__";
  }
  return "${currentTime.day}/${currentTime.month}/${currentTime.year}";
}

