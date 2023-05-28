import 'constants.dart';

class TimeParser {
    static int extractDuration(String instruction) {
        final match = RegExp(Constants.TIME_INTERVAL_REGEX, caseSensitive: false).firstMatch(instruction);
        if (match != null && match.groupCount > 1) {
            String unit = match.group(4)!;
            int duration = 0;

            if (match.group(2)!.contains('-')) {
                List<String> range = match.group(2)!.split('-');
                // In the case of "3-4 minutes", we use the maximum value (4 in this case)
                duration = int.tryParse(range[1]) ?? 0;
            } else {
                duration = int.tryParse(match.group(2)!) ?? 0;
            }

            return getDurationInSeconds(duration, unit);
        }
        return 0;
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