import 'error.dart';

class Avatar {
  final String preSignedUrl;
  final String anonymousAccessUrl;
  final UserError error;

  Avatar(
      {required this.preSignedUrl,
      required this.anonymousAccessUrl,
      required this.error});
  Avatar.error({required UserError error})
      : this(preSignedUrl: '', anonymousAccessUrl: '', error: error);
}
