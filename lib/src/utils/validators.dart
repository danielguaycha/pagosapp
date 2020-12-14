
double parseDouble(dynamic number) {
  if(number==null)
    return 0.0;
  if(number is String) {
    number = number.toString().replaceAll(",", ".");
    if(isNumeric(number)) {
      return double.parse("$number");
    } else return null;
  }
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

bool parseBool(dynamic b){
  
  if(b == null) return false;

  if(b is bool) {
    return b;
  }

  if(b is int) {
    if(b == 1) return true;
    else return false;
  }

  if(b is String) {
    if(b.toLowerCase() == 'true') return true;
    else return false;
  }  
  
  return false;
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

bool isAfter(DateTime date){
  return date.isAfter(DateTime.now());
}

bool isBefore(DateTime date){
  return date.isBefore(DateTime.now());
}

bool isToday(DateTime date) {
  int diffDays = date.difference(DateTime.now()).inDays;
  return (diffDays == 0);
}