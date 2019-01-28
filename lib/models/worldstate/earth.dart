import 'package:codable/codable.dart';

class Earth extends Coding {
  DateTime expiry;
  bool isDay, isCetus;

  @override
  void decode(KeyedArchive object) {
    super.decode(object);

    isDay = object.decode('isDay');
    isCetus = object.decode('isCetus') ?? false;
    expiry = DateTime.parse(object.decode('expiry')).toLocal();

    if (expiry.difference(DateTime.now().toUtc()) <= Duration(seconds: 1)) {
      isDay = !isDay;
      if (isDay)
        expiry = isCetus
            ? expiry.add(Duration(minutes: 100))
            : expiry.add(Duration(hours: 4));
      else
        expiry = isCetus
            ? expiry.add(Duration(minutes: 50))
            : expiry.add(Duration(hours: 4));
    }
  }

  @override
  void encode(KeyedArchive object) {
    object.encode('expiry', expiry);
    object.encode('isCetus', isCetus);
    object.encode('isDay', isDay);
    object.encode('expiry', expiry.toIso8601String());
  }
}
