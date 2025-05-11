/// Represents a file to be uploaded in a multipart request
///
class FormFile {
  /// Creates a new upload file entry
  ///
  /// [fieldName] - The form field name for this file
  /// [path] - The local path to the file
  ///
  FormFile({
    required this.fieldName,
    required this.path,
  });

  /// The form field name that will be used for this file in the request
  ///
  final String? fieldName;

  /// The local path to the file to be uploaded
  ///
  final String? path;
}
