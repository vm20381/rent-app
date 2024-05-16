import 'package:url_launcher/url_launcher.dart';

class UrlService {
  static goToUrl(String url) async {
    await launchUrl(Uri.parse(url));
  }

  static getCurrentUrl(){
    var path = Uri.base.path;
    return path.replaceAll('flatten/web/', '');
  }
}
