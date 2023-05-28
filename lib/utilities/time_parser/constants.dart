// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class Constants {
  static const String TIME_INTERVAL_PREFIX = "for|about";
  static const String TIME_INTERVAL_SUFFIX = "seconds|minutes|hours|days|weeks|months|years|second|minute|hour|day|week|month|year";
  static final RegExp TIME_INTERVAL_REGEX = RegExp('\b($TIME_INTERVAL_PREFIX)\b ([0-9]+(-[0-9]+)?) ($TIME_INTERVAL_SUFFIX)', caseSensitive: false);
}