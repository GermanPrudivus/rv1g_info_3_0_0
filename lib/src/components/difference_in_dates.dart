String differenceInDates(DateTime later, DateTime earlier) {
  later = DateTime.utc(later.year, later.month, later.day, later.hour, later.minute);
  earlier = DateTime.utc(earlier.year, earlier.month, earlier.day, earlier.hour, earlier.minute);

  if(later.difference(earlier).inDays > 0){
    return "${later.difference(earlier).inDays}d";
  } else if (later.difference(earlier).inDays == 0 && later.difference(earlier).inHours > 0){
    return "${later.difference(earlier).inHours}h";
  } else if (later.difference(earlier).inHours == 0 && later.difference(earlier).inMinutes > 0){
    return "${later.difference(earlier).inMinutes}m";
  } else {
    return "${later.difference(earlier).inSeconds}s";
  }
}