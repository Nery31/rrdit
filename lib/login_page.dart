import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/home.dart';
import 'package:my_app/pages/feed.dart';
import 'package:my_app/token.dart';
import 'auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hasGotToken = false;

  codeDetector(String redirectUrl) async {
    setState(() {
      hasGotToken = true;
    });
    ///  Une façon simple de parser une Uri et récupérer les paramêtres
    /// qu'elle contient
    String? code = Uri.parse(redirectUrl).queryParameters['code'];
    var auth = 'Basic ' +
        base64Encode(utf8
            .encode('7RmjSl-35G4ULrFIqevD8A:y2HS9wKGIClnuaso9okCaJKZbOYn5A'));

    final res = await Dio().post(
      'https://www.reddit.com/api/v1/access_token',
      data: FormData.fromMap(
        {
          'grant_type': 'authorization_code',
          'code': code, // this is your code part
          'redirect_uri': "https://oauth.pstmn.io/v1/browser-callback",
        },
      ),
      options: Options(
        headers: <String, String>{
          'Accept': '/',
          'Authorization': auth,
          'User-Agent': 'Reddit',
        },
      ),
    );

    recup.accessibility = res.data['access_token'];

    Navigator.push(context, MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return UserProfilePage();
      },
    ));

    /// J'utilise une SnackBar pour faire un test des données
    /// que j'ai reçu de la WebView après authentification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "REDIRECT_URL = $redirectUrl\nCODE = $code",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Reddict"),
      ),
      body: hasGotToken ? CircularProgressIndicator() : SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/images/reddict.png')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter your email ...@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter a password'),
              ),
            ),
            FlatButton(
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.orange, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: () {
                  _handleRedirectUri(codeDetector);
                },
                child: const Text(
                  "Se Connecter à Reddit",
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("New user ?"),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Create Account",
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Le callback ici recupère en paramètre l'url de redirection
  /// contenant le CODE pour faire les requêtes et récupérer
  /// le access token plus tard
  void _handleRedirectUri(Function(String) callback) async {
    await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const AuthWebView(),
      ),
    ).then((value) {
      callback(value!);
    });
  }
}
