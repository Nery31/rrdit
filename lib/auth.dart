import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthWebView extends StatefulWidget {
  const AuthWebView({Key? key}) : super(key: key);

  @override
  AuthWebViewState createState() => AuthWebViewState();
}

class AuthWebViewState extends State<AuthWebView> {
  int _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
  }

  @override
  Widget build(BuildContext context) {
    final clientId = "7RmjSl-35G4ULrFIqevD8A";
    final redirectUri = "https://oauth.pstmn.io/v1/browser-callback";

    ///  Ici en gros je recompose l'url telle que je l'avais spécifié dans le
    /// notion du groupe Epitools. Je préfère cette forme parce qu'elle est
    /// plus lisible que celle faite en une seule ligne
    ///
    final url = Uri.https('www.reddit.com', '/api/v1/authorize.compact', {
      'client_id': clientId,
      'response_type': 'code',
      'state': 'RANDOM',
      'redirect_uri': redirectUri,
      'duration': 'permanent',
      'scope':
          'identity,edit,flair,history,modconfig,modflair,modlog,modposts,modwiki,mysubreddits,privatemessages,read,report,save,submit,subscribe,vote,wikiedit,wikiread',
    });

    /// Le userAgent sert juste à faire dire à notre WebView que notre application
    /// n'est pas un bot mais plutôt un device android/ios pour éviter que nos
    /// requêtes et autre process d'authentification dans la web
    String userAgent =
        'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.50 Mobile Safari/537.36';

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text('Autorisation'),
        actions: [
          _loadingProgress != 100
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
        ],
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        userAgent: userAgent,
        initialUrl: url.toString(),
        navigationDelegate: (navReg) {
          /// C'est ici je checke si la redirection est fait
          /// dans la page web et je reviens dans notre app
          /// avec l'URL qui contient le code
          ///
          /// Vous pouvez lire la documentation du package
          /// WebView pour comprendre mieux la propriété
          /// navigationDelegate
          if (navReg.url.contains('code=')) {
            Navigator.maybePop<String>(context, navReg.url);
          }
          return NavigationDecision.navigate;
        },
        onProgress: (value) {
          setState(() {
            _loadingProgress = value;
          });

          // Juste un log pour tuer le temps
          log(value.toString());
        },
      ),
    );
    //return Container();
  }
}
