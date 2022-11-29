import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CustomMonthPicker extends DatePickerModel {
  CustomMonthPicker({
    DateTime? currentTime,
    DateTime? minTime,
    DateTime? maxTime,
  }) : super(
            locale: LocaleType.vi,
            minTime: minTime,
            maxTime: maxTime,
            currentTime: currentTime);

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }
}