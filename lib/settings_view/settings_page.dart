import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:tt_9/services/mixins/config_mixin.dart';
import 'package:tt_9/styles/app_theme.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with ConfigMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Settings',
              style: AppTheme.displayMedium.copyWith(color: AppTheme.secondary),
            ),
            const SizedBox(
              height: 36,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () async => await InAppReview.instance.requestReview(),
              minSize: 1,
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/images/Vector (7).svg',
                  color: Colors.white,
                ),
                title: const Text(
                  'Rate app ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.redAccent,
                ),
              ),
            ),
            const Divider(
              color: AppTheme.surface,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => launchUrlString(termsLink),
              minSize: 1,
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/images/Vector (8).svg',
                  color: Colors.white,
                ),
                title: const Text(
                  'Term of use ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.redAccent,
                ),
              ),
            ),
            const Divider(
              color: AppTheme.surface,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => launchUrlString(privacyLink),
              minSize: 1,
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/images/Vector (9).svg',
                  color: Colors.white,
                ),
                title: const Text(
                  'Privacy Policy ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.redAccent,
                ),
              ),
            ),
            const Divider(
              color: AppTheme.surface,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () async => await FlutterEmailSender.send(
                Email(
                  recipients: ['ferjoao383@gmail.com'],
                  subject: 'To support of "Busy Bookseller Compass"',
                ),
              ),
              minSize: 1,
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/images/Vector (10).svg',
                  color: Colors.white,
                ),
                title: const Text(
                  'Support',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.redAccent,
                ),
              ),
            ),
            const Divider(
              color: AppTheme.surface,
            ),
          ],
        ),
      )),
    );
  }
}
