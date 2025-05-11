import 'package:dio/dio.dart';

import 'form_file.dart';

/// A class to handle form data with file uploads
///
class MultipartFormData {
  /// Creates a new BaseFormData instance
  ///
  /// [fields] - Optional map of form field data
  /// [files] - Optional list of files to be uploaded
  ///
  MultipartFormData({
    this.fields = const {},
    this.files = const [],
  });

  /// Map of form fields to be included in the request
  ///
  final Map<String?, dynamic>? fields;

  /// List of files to be uploaded
  ///
  final List<FormFile>? files;

  /// Returns a map with only non-null keys and values from [fields]
  ///
  Map<String, dynamic> get nonNullFormFields {
    if (fields == null) return {};

    return {
      for (final entry in fields!.entries)
        if (entry.key != null && entry.value != null) entry.key!: entry.value
    };
  }

  /// Converts the form data to a Dio FormData object for upload
  ///
  Future<FormData> get toFormData async {
    final temp = Map<String, dynamic>.from(nonNullFormFields);

    if (files?.isNotEmpty ?? false) {
      await Future.forEach(files!, (file) async {
        if (file.fieldName != null && file.path != null) {
          temp[file.fieldName!] = await MultipartFile.fromFile(file.path!);
        }
      });
    }

    return FormData.fromMap(temp);
  }

  /// Converts a dynamic map to a string map
  ///
  /// This is useful for headers or other scenarios where strings are required
  ///
  static Map<String, String> convertDynamicToStringMap(
    Map<String, dynamic> formFields,
  ) {
    final result = <String, String>{};

    formFields.forEach((key, value) {
      if (value != null) {
        result[key] = value.toString();
      }
    });

    return result;
  }
}
