import 'dart:developer';
import 'package:custom_progressbar/custom_progressbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt_9/onboarding_view/initial_screen.dart';
import 'package:tt_9/services/mixins/network_mixin.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class PrivacyView extends StatefulWidget {
  const PrivacyView({super.key});

  @override
  State<PrivacyView> createState() => _PrivacyViewState();
}

class _PrivacyViewState extends State<PrivacyView> with NetworkMixin {
  late final WebViewController _controller;

  var isLoading = true;

  String get _cssCode {
    return ".docs-ml-promotion, #docs-ml-header-id { display: none !important; } .app-container { margin: 0 !important; }";
  }

  String get _jsCode => """
      var style = document.createElement('style');
      style.type = "text/css";
      style.innerHTML = "$_cssCode";
      document.head.appendChild(style);
    """;

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            log('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            log('Page started loading: $url');
          },
          onPageFinished: (String url) {
            controller.runJavaScript(_jsCode);
            log('Page finished loading: $url');
            setState(() => isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            log('''
              Page resource error:
                code: ${error.errorCode}
                description: ${error.description}
                errorType: ${error.errorType}
                isForMainFrame: ${error.isForMainFrame}
          ''');
            if (error.errorCode == -1009) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const InitialScreen(),
                ),
              );
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            log('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) async {
            log('URL changed to ${change.url}');
            if (change.url != null) {
              await _saveLastVisitedUrl(change.url!);
            }
          },
        ),
      );

    if (controller.platform is WebKitWebViewController) {
      (controller.platform as WebKitWebViewController)
          .setAllowsBackForwardNavigationGestures(true);
    }

    _controller = controller;

    _loadUrl().then((urlToLoad) {
      _controller.loadRequest(Uri.parse(urlToLoad));
    });
  }

  Future<void> _saveLastVisitedUrl(String url) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastVisitedUrl', url);
      log('Last visited URL saved: $url');
    } catch (e) {
      log('Error saving last visited URL: $e');
    }
  }

  Future<String> _loadUrl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final initialLink = prefs.getString('initialLink');
      if (initialLink == null) {
        prefs.setString('initialLink', link);
      } else {
        if (link != initialLink) {
          prefs.setString('initialLink', link);
          return link;
        }
      }
      final url = prefs.getString('lastVisitedUrl') ?? link;
      log('Last visited URL loaded: $url');
      return url;
    } catch (e) {
      log('Error loading last visited URL: $e');
      return link;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? Center(
                child: ProgressBar(
                  containerWidth: 150,
                  containerHeight: 150,
                  progressColor: const Color(0xFF222224),
                  boxFit: BoxFit.contain,
                  iconHeight: 120,
                  iconWidth: 120,
                  imageFile: 'assets/images/icon.png',
                  progressHeight: 150,
                  progressWidth: 150,
                  progressStrokeWidth: 7,
                ),
              )
            : WebViewWidget(controller: _controller),
      ),
    );
  }
}
