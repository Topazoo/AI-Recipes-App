import 'constants.dart';

class TimeParser {
    static List<int> extractDurations(String instruction) {
        Iterable<RegExpMatch> matches = RegExp(Constants.TIME_INTERVAL_REGEX, caseSensitive: false).allMatches(instruction);
        List<int> durations = [];
        for (var match in matches) {
            if (match.groupCount > 1) {
                String unit = match.group(3)!;
                int duration = 0;

                if (match.group(1)!.contains('-')) {
                    List<String> range = match.group(1)!.split('-');
                    duration = int.tryParse(range[1]) ?? 0;
                } else {
                    duration = int.tryParse(match.group(1)!) ?? 0;
                }

                durations.add(getDurationInSeconds(duration, unit));
            }
        }
        return durations;
    }

    static int getDurationInSeconds(int duration, String unit) {
        switch (unit) {
            case 'seconds':
                // Already in seconds
                break;
            case 'minutes':
                duration *= 60;
                break;
            case 'hours':
                duration *= 60 * 60;
                break;
            case 'days':
                duration *= 60 * 60 * 24;
                break;
            case 'weeks':
                duration *= 60 * 60 * 24 * 7;
                break;
            case 'months':
                duration *= 60 * 60 * 24 * 30; // Assuming 30 days in a month
                break;
            case 'years':
                duration *= 60 * 60 * 24 * 365; // Non-leap year
                break;
            default:
                return 0; // Unrecognizable unit, return 0
        }
        return duration;
    }
}
