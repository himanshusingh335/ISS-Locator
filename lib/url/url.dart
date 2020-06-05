import 'package:url_launcher/url_launcher.dart';

launchURL() async {
  const url = 'https://himanshusingh335.wixsite.com/my-profile';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

launchURL1() async {
  const url = "http://wsn.spaceflight.esa.int/iss/index_portal.php";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}