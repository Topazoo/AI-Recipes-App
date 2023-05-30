// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class Constants {
  static const String TIME_INTERVAL_SUFFIX_GROUP = r"(seconds|minutes|hours|days|weeks|months|years|second|minute|hour|day|week|month|year)";
  static const String TIME_INTERVAL_REGEX = r"\b ([0-9]+(-[0-9]+)?) " + TIME_INTERVAL_SUFFIX_GROUP;
}