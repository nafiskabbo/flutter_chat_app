import 'package:intl/intl.dart';
import 'package:chat/main.dart';
import 'package:url_launcher/url_launcher_string.dart';

const defaultErrorMessage = 'Something went wrong';
final formatter = NumberFormat.simpleCurrency(decimalDigits: 0, name: '');

// boolean
extension BoolNullableExt on bool? {
  bool get orFalse => this ?? false;
  bool get orTrue => this ?? true;
}

// int
extension IntNullableExt on int? {
  int get orZero => this ?? 0;
  String get formatted => formatter.format(orZero);
}

extension IntExt on int {
  String addLeadingZeroIfNeeded({bool showPositiveSign = false}) {
    if (this > 9) return showPositiveSign ? '+$this' : toString();
    if (this > -1) return showPositiveSign ? '+0$this' : '0$this';
    if (this > -10) return '-0${abs()}';
    return toString();
  }

  String get ordinal {
    String suffix;
    int lastDigit = this % 10;

    // Handle special cases (11, 12, 13) first
    if (this >= 11 && this <= 13) {
      suffix = this == 11 ? "th" : (this % 10 == 1 ? "st" : (this % 10 == 2 ? "nd" : "rd"));
    } else {
      // Handle regular cases (1-9)
      suffix = switch (lastDigit) { 1 => "st", 2 => "nd", 3 => "rd", _ => "th" };
    }

    return "$this$suffix";
  }
}

// double
extension DoubleNullableExt on double? {
  double get orZero => this ?? 0;
}

// string
extension StringNullableExt on String? {
  String get orEmpty => this ?? '';
  String get orError => this ?? defaultErrorMessage;
  int get toInt => int.tryParse(this ?? '0').orZero;
  double get toDouble => double.tryParse(this ?? '0').orZero;
  String append(String other) => '$orEmpty$other';
}

extension StringExt on String {
  String get capitalizeFirstLetter => isNotEmpty ? this[0].toUpperCase() + substring(1) : this;

  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  // Format: yyyy-MM-dd HH:mm:ss
  DateTime toDateTime() => DateTime.parse(this);

  /// Launches a provided URL in a suitable application.
  Future<void> launchURL() async {
    if (await canLaunchUrlString(this)) {
      await launchUrlString(this);
    } else {
      logger.e('Could not launch $this');
    }
  }
}

extension IterableExtension<T> on Iterable<T> {
  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

/// Extensions on iterables whose elements are also iterables.
extension IterableIterableExtension<T> on Iterable<Iterable<T>> {
  /// The sequential elements of each iterable in this iterable.
  ///
  /// Iterates the elements of this iterable.
  /// For each one, which is itself an iterable,
  /// all the elements of that are emitted
  /// on the returned iterable, before moving on to the next element.
  Iterable<T> get flattened sync* {
    for (var elements in this) {
      yield* elements;
    }
  }
}

extension ListExtensions<E> on List<E> {
  /// Takes an action for each element.
  ///
  /// Calls [action] for each element along with the index in the
  /// iteration order.
  void forEachIndexed(void Function(int index, E element) action) {
    for (var index = 0; index < length; index++) {
      action(index, this[index]);
    }
  }
}

extension EnumByNameExt<T extends Enum> on Iterable<T> {
  T? of(String? name) {
    if (name == null) return null;
    return firstWhereOrNull((e) => e.name == name);
  }
}
