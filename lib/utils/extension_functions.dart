import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:naxa_maplibre_gl/naxa_maplibre_gl.dart';

import '../core/config/flavor/configuration.dart';
import '../core/config/flavor/configuration_provider.dart';
import '../../l10n/l10n.dart';
import '../ui/features/main_wrapper/enums/nav_item.dart';

/// BuildContext Extension functions
extension BuildContextExt on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Configuration get flavorConfiguration =>
      ConfigurationProvider.of(this).configuration;

  ThemeData get theme => Theme.of(this);

  double get width => MediaQuery.sizeOf(this).width;

  double get height => MediaQuery.sizeOf(this).height;

  EdgeInsets get padding => MediaQuery.paddingOf(this);

  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  bool get isRtl => Directionality.of(this) == TextDirection.rtl;

  GoRouter get goRouter => GoRouter.of(this);

  ScaffoldState get scaffold => Scaffold.of(this);

  bool get isDarkTheme => theme.brightness == Brightness.dark;

  TextTheme get textTheme => theme.textTheme;

  AppLocalizations get appLocalization => AppLocalizations.of(this)!;

  Locale? get locale => Localizations.maybeLocaleOf(this);

  String localizeNumber(int number) {
    final locale = Localizations.localeOf(this);
    return number.fromLocale(locale);
  }

  String localizeStringWithNumber(String s) {
    final locale = Localizations.localeOf(this);
    return s.fromLocale(locale);
  }

  Future<T?> showBottomSheet<T>({
    required Widget Function(BuildContext context) builder,
    Color? backgroundColor,
    ShapeBorder? shape,
    bool isScrollControlled = false,
    bool useRootNavigator = true,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useSafeArea = false,
  }) =>
      showModalBottomSheet<T>(
        context: this,
        builder: builder,
        backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
        shape: shape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24.0),
              ),
            ),
        barrierColor: theme.dividerColor.withValues(alpha: 0.2),
        isScrollControlled: isScrollControlled,
        useRootNavigator: useRootNavigator,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        useSafeArea: useSafeArea,
      );
}

/// Extension functions on String
extension StringExt on String {
  /// Capitalize First
  String get capitalize {
    if (trim().isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Getter for path name from the location string
  String get toPathName => replaceFirst("/", "");

  /// Getter for uppercase
  String get uppercase => toUpperCase();

  /// Getter for Abbreviation
  String get abbreviation {
    if (trim().isEmpty) return '';

    final words = split(' ').where((w) => w.trim().isNotEmpty).toList();

    if (words.length == 1) {
      final word = words.first.trim();

      if (word.isEmpty) return '';

      if (word.contains('_') || word.contains('-')) {
        final temps = word.split(word.contains('_') ? '_' : '-');

        final fWord = temps.first.replaceFirst("(", "");
        final lWord = temps.last.replaceFirst("(", "");

        return '${fWord.substring(0, 1)}${lWord.substring(0, 1)}'.uppercase;
      }

      if (word.length > 1) return word.substring(0, 2).uppercase;
      return word.substring(0).uppercase;
    }

    final fWord = words.first.replaceFirst("(", "");
    final lWord = words.last.replaceFirst("(", "");

    return '${fWord.substring(0, 1)}${lWord.substring(0, 1)}'.uppercase;
  }

  /// To convert num char in devanagari
  String fromLocale(Locale locale) {
    return characters
        .map((e) =>
            locale.languageCode == L10n.ne.languageCode ? _toDevanagari(e) : e)
        .join();
  }

  String _toDevanagari(String s) {
    final values = {
      "1": '१',
      "2": '२',
      "3": '३',
      "4": '४',
      "5": '५',
      "6": '६',
      "7": '७',
      "8": '८',
      "9": '९',
      "0": '०',
    };

    return values[s] ?? s;
  }

  /// Format the date like this 11 Jan 2022.
  String get toddMMMYYYY {
    final date = DateTime.tryParse(this);

    if (date == null) return "";

    final months = {
      DateTime.january: 'Jan',
      DateTime.february: 'Feb',
      DateTime.march: 'Mar',
      DateTime.april: 'Apr',
      DateTime.may: 'May',
      DateTime.june: 'Jun',
      DateTime.july: 'Jul',
      DateTime.august: 'Aug',
      DateTime.september: 'Sept',
      DateTime.october: 'Oct',
      DateTime.november: 'Nov',
      DateTime.december: 'Dec',
    };

    return "${date.day} ${months[date.month]} ${date.year}";
  }

  /// Check if the string is a file path.
  ///
  /// This method determines if the string represents a file path by checking
  /// for common patterns and excluding specific cases like asset paths,
  /// single filenames, and HTTP URLs.
  bool get isFilePath {
    if (isEmpty) {
      return false;
    }

    // Exclude paths starting with "assets/" or containing only filenames
    if (startsWith('assets/') || !contains('/') || startsWith("http")) {
      return false;
    }

    // A basic regex to check for common file path patterns.
    // This is a simplified version and might need adjustments based on your specific needs.
    final filePathRegex = RegExp(
        r'^(/|([A-Za-z]:\\))?([A-Za-z0-9_\-\.]+/)*([A-Za-z0-9_\-\.]+\.[A-Za-z0-9]+)?$');

    return filePathRegex.hasMatch(this);
  }

  /// Checks if the string is a directory path.
  ///
  /// This method uses a regular expression to identify directory paths,
  /// including those with or without drive letters on Windows.
  bool get isDirectoryPath {
    if (isEmpty) {
      return false;
    }

    // A regex to check for common directory path patterns.
    final directoryPathRegex =
        RegExp(r'^(/|([A-Za-z]:\\))?([A-Za-z0-9_\-\.]+/)*$');

    return directoryPathRegex.hasMatch(this);
  }

  /// Check if the string is path.
  ///
  /// Returns true if the string is either a file path or a directory path.
  bool get isPath => isFilePath || isDirectoryPath;

  /// Getter to check if string is url
  ///
  bool get isUrl {
    final uri = Uri.tryParse(this);
    return uri != null && uri.scheme.startsWith('http');
  }

  /// Getter to get filename from url
  ///
  String? get fileNameFromUrl {
    if (!isUrl) return null;
    return Uri.tryParse(this)?.pathSegments.lastOrNull;
  }

  /// Getter to get filename from path
  ///
  String? get fileNameFromFilePath {
    return Uri.tryParse(this)?.pathSegments.lastOrNull;
  }

  /// Getter to check if string is audio file url
  ///
  bool get isAudioUrl {
    final audioName = fileNameFromUrl;
    return isUrl &&
        audioName != null &&
        (audioName.endsWith(".mp3") ||
            audioName.endsWith(".aac") ||
            audioName.endsWith(".wma") ||
            audioName.endsWith(".wav"));
  }

  /// Getter to check if string is audio file url
  ///
  bool get isVideoUrl {
    final videoName = fileNameFromUrl;
    return isUrl &&
        videoName != null &&
        (videoName.endsWith(".mp4") ||
            videoName.endsWith(".mov") ||
            videoName.endsWith(".wmv") ||
            videoName.endsWith(".mkv") ||
            videoName.endsWith(".flv") ||
            videoName.endsWith(".mpg") ||
            videoName.endsWith(".m4v") ||
            videoName.endsWith(".webm") ||
            videoName.endsWith(".avi"));
  }

  /// Getter to check if string is audio file url
  ///
  bool get isVideoFile {
    final videoName = Uri.tryParse(this)?.pathSegments.lastOrNull;
    return videoName != null &&
        (videoName.endsWith(".mp4") ||
            videoName.endsWith(".mov") ||
            videoName.endsWith(".wmv") ||
            videoName.endsWith(".mkv") ||
            videoName.endsWith(".flv") ||
            videoName.endsWith(".mpg") ||
            videoName.endsWith(".m4v") ||
            videoName.endsWith(".webm") ||
            videoName.endsWith(".avi"));
  }

  /// Getter to check if string is image file url
  ///
  bool get isImageUrl {
    final imageName = fileNameFromUrl;
    return isUrl &&
        imageName != null &&
        (imageName.endsWith(".jpg") ||
            imageName.endsWith(".jpeg") ||
            imageName.endsWith(".png") ||
            imageName.endsWith(".gif") ||
            imageName.endsWith(".bmp") ||
            imageName.endsWith(".tiff") ||
            imageName.endsWith(".svg"));
  }

  /// Getter to check if string is image file url
  ///
  bool get isImageFile {
    final imageName = Uri.tryParse(this)?.pathSegments.lastOrNull;
    return imageName != null &&
        (imageName.endsWith(".jpg") ||
            imageName.endsWith(".jpeg") ||
            imageName.endsWith(".png") ||
            imageName.endsWith(".gif") ||
            imageName.endsWith(".bmp") ||
            imageName.endsWith(".tiff") ||
            imageName.endsWith(".svg"));
  }

  /// Getter to check if string is file url
  ///
  bool get isFileUrl {
    final fileName = fileNameFromUrl;
    return isUrl &&
        fileName != null &&
        (fileName.endsWith(".pdf") ||
            fileName.endsWith(".doc") ||
            fileName.endsWith(".docx") ||
            fileName.endsWith(".xls") ||
            fileName.endsWith(".xlsx") ||
            fileName.endsWith(".ppt") ||
            fileName.endsWith(".pptx") ||
            fileName.endsWith(".txt") ||
            fileName.endsWith(".csv") ||
            fileName.endsWith(".zip") ||
            fileName.endsWith(".rar") ||
            fileName.endsWith(".7z") ||
            fileName.endsWith(".html") ||
            fileName.endsWith(".xml") ||
            fileName.endsWith(".json"));
  }

  /// Method for formatted text spans
  /// [pattern] - Regex pattern you want to search for or match
  /// [replacingValue] - Value you want to replace to the matched one
  /// [textStyle4Matched] - Text style for the matched text
  /// [textStyle4NonMatched] - Text style for other than matched text
  ///
  List<TextSpan> formattedTextSpans({
    String pattern = r"@[a-zA-Z0-9._-]+", // Matches text like @username
    String? replacingValue,
    TextStyle? textStyle4Matched,
    TextStyle? textStyle4NonMatched,
  }) {
    final List<TextSpan> spans = [];

    splitMapJoin(
      RegExp(pattern),
      onMatch: (match) {
        // Getting matched text
        String text = match.group(0) ?? '';

        // If replacing value is not null
        if (replacingValue != null && replacingValue.trim().isNotEmpty) {
          text = text.replaceAll(match.group(0)!, replacingValue);
        }

        // Adding bold text for matches
        spans.add(
          TextSpan(
            text: text,
            style: textStyle4Matched ??
                const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
          ),
        );
        return text;
      },
      onNonMatch: (s) {
        // Add normal text for non-matches
        spans.add(
          TextSpan(
            text: s,
            style: textStyle4NonMatched,
          ),
        );
        return s;
      },
    );

    return spans;
  }

  /// Helper extension function to convert camelCase to snake_case
  ///
  String get camelToSnake {
    final RegExp exp = RegExp(r'(?<=[a-z])[A-Z]');
    return replaceAllMapped(exp, (Match m) => '_${m.group(0)!.toLowerCase()}');
  }

  /// Helper extension function to convert snake_case to camelCase
  ///
  String get snakeToCamel {
    return replaceAllMapped(
      RegExp(r'_([a-z])'),
      (Match m) => m.group(1)!.toUpperCase(),
    );
  }

  /// Getter to get LatLng from wkt string
  ///
  LatLng? get toLatLng {
    try {
      String normalized = trim();

      // Remove SRID prefix if present
      if (normalized.toUpperCase().startsWith('SRID=')) {
        final semicolonIndex = normalized.indexOf(';');
        if (semicolonIndex != -1) {
          normalized = normalized.substring(semicolonIndex + 1);
        }
      }

      // Improved regex that handles whitespace more flexibly
      RegExp regExp = RegExp(r'POINT\s*\(\s*([-\d.]+)\s+([-\d.]+)\s*\)',
          caseSensitive: false);
      final match = regExp.firstMatch(normalized);

      if (match != null) {
        final longitude = double.tryParse(match.group(1) ?? '');
        final latitude = double.tryParse(match.group(2) ?? '');

        if (longitude != null && latitude != null) {
          return LatLng(latitude, longitude);
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Getter to get LatLng points from wkt line, multiline and polygon string
  ///
  List<List<LatLng>> get toPoints {
    try {
      String normalized = trim();

      // Remove SRID prefix if present
      if (normalized.toUpperCase().startsWith('SRID=')) {
        final semicolonIndex = normalized.indexOf(';');
        if (semicolonIndex != -1) {
          normalized = normalized.substring(semicolonIndex + 1);
        }
      }

      // Handle simple LINESTRING format
      if (normalized.toUpperCase().contains('LINESTRING')) {
        if (!normalized.toUpperCase().contains('MULTILINESTRING')) {
          final regex =
              RegExp(r'LINESTRING\s*\(([^)]+)\)', caseSensitive: false);
          final match = regex.firstMatch(normalized);
          if (match != null) {
            return [_parseCords(match.group(1)!)];
          }
        }
      }

      // Handle MULTILINESTRING with double parentheses
      if (normalized.toUpperCase().contains('MULTILINESTRING')) {
        final regex =
            RegExp(r'MULTILINESTRING\s*\(\((.*?)\)\)', caseSensitive: false);
        final match = regex.firstMatch(normalized);
        if (match != null && match.group(1) != null) {
          return [_parseCords(match.group(1)!)];
        }
      }

      // Handle POLYGON with double parentheses
      if (normalized.toUpperCase().contains('POLYGON')) {
        final regex = RegExp(r'POLYGON\s*\(\((.*?)\)\)', caseSensitive: false);
        final match = regex.firstMatch(normalized);
        if (match != null && match.group(1) != null) {
          // For a simple polygon, we just need the outer ring
          return [_parseCords(match.group(1)!)];

          // We are not handling inner rings (holes) here
        }
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  /// Helper method to parse coordinates from wkt string
  List<LatLng> _parseCords(String cord) {
    try {
      return cord.split(',').map((pair) {
        final parts = pair.trim().split(RegExp(r'\s+'));
        if (parts.length < 2) {
          throw FormatException('Invalid coordinate pair: $pair');
        }
        final lon = double.parse(parts[0]);
        final lat = double.parse(parts[1]);
        return LatLng(lat, lon);
      }).toList();
    } catch (e) {
      return [];
    }
  }
}

extension IntExt on int? {
  /// To convert num char in devanagari
  String fromLocale(Locale locale) {
    return toString()
        .characters
        .map((e) =>
            locale.languageCode == L10n.ne.languageCode ? _toDevanagari(e) : e)
        .join();
  }

  String _toDevanagari(String s) {
    final values = {
      "1": '१',
      "2": '२',
      "3": '३',
      "4": '४',
      "5": '५',
      "6": '६',
      "7": '७',
      "8": '८',
      "9": '९',
      "0": '०',
    };

    return values[s] ?? s;
  }
}

/// Extension on NavItem
extension NavItemExt on NavItem {
  BottomNavigationBarItem toBottomNavigationBarItem(BuildContext context) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      activeIcon: Icon(activeIcon),
      label: localizedLabel(context),
      tooltip: label,
    );
  }
}

/// Extension on locale
///
extension LocalaeExt on Locale {
  String localizedLabel(BuildContext context) {
    final languageCodes = {
      L10n.ne.languageCode: context.appLocalization.nepali,
      L10n.en.languageCode: context.appLocalization.english,
      L10n.bn.languageCode: context.appLocalization.bengali,
      // L10n.hi.languageCode: context.appLocalization.hindi,
      // L10n.es.languageCode: context.appLocalization.spanish,
      // L10n.ar.languageCode: context.appLocalization.arabic,
      // L10n.fr.languageCode: context.appLocalization.french,
      // L10n.de.languageCode: context.appLocalization.german,
      // L10n.ru.languageCode: context.appLocalization.russian,
    };

    return languageCodes[languageCode] ?? context.appLocalization.english;
  }

  String get unlocalizedLabel {
    final languageCodes = {
      L10n.ne.languageCode: "Nepali",
      L10n.en.languageCode: "English",
      L10n.bn.languageCode: "Bengali",
      // L10n.hi.languageCode: "Hindi",
      // L10n.es.languageCode: "Spanish",
      // L10n.ar.languageCode: "Arabic",
      // L10n.fr.languageCode: "French",
      // L10n.de.languageCode: "German",
      // L10n.ru.languageCode: "Russian",
    };

    return languageCodes[languageCode] ?? "English";
  }

  String get translatedLabel {
    final languageCodes = {
      L10n.ne.languageCode: "नेपाली",
      L10n.en.languageCode: "English",
      L10n.bn.languageCode: "বাঙালি",
      // L10n.hi.languageCode: "हिन्दी",
      // L10n.es.languageCode: "Español",
      // L10n.ar.languageCode: "العربية",
      // L10n.fr.languageCode: "Français",
      // L10n.de.languageCode: "Deutsch",
      // L10n.ru.languageCode: "Русский",
    };

    return languageCodes[languageCode] ?? "English";
  }

  String get flag {
    final languageCodes = {
      L10n.ne.languageCode: "🇳🇵",
      L10n.en.languageCode: "🇺🇸",
      L10n.bn.languageCode: "🇧🇩",
      // L10n.hi.languageCode: "🇮🇳",
      // L10n.es.languageCode: "🇪🇸",
      // L10n.ar.languageCode: "🇸🇦",
      // L10n.fr.languageCode: "🇫🇷",
      // L10n.de.languageCode: "🇩🇪",
      // L10n.ru.languageCode: "🇷🇺",
    };

    return languageCodes[languageCode] ?? "🇺🇸";
  }
}

/// Extension on GlobalKey
///
extension GlobalKeyExt on GlobalKey {
  /// Helper method to get the offset of the clicked item with key
  ///
  Offset? get position {
    try {
      final box = currentContext?.findRenderObject() as RenderBox?;
      if (box == null) return null;
      final position = box.localToGlobal(Offset.zero);
      return position;
    } catch (e) {
      return null;
    }
  }
}
