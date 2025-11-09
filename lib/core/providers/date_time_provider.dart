import 'package:injectable/injectable.dart';

abstract interface class IDateTimeProvider {
  DateTime now();
}

@Singleton(as: IDateTimeProvider)
class DateTimeProvider implements IDateTimeProvider {
  @override
  DateTime now() => DateTime.now();
}
