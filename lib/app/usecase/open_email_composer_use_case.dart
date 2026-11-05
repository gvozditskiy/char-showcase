import 'package:url_launcher/url_launcher.dart';

class OpenEmailComposerUseCase {
  const OpenEmailComposerUseCase();

  Future<void> call({required String emailAddress, required String subject}) async {
    final emailLaunchUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      query: _encodeQueryParameters({'subject': subject}),
    );
    await launchUrl(emailLaunchUri);
  }

  String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }
}
