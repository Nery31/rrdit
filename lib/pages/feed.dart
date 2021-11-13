import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_app/app_data/app_data.dart';
import 'package:my_app/models/profile.dart';
import 'package:my_app/models/subreddit.model.dart';
import 'package:my_app/token.dart';

class UserProfilePage extends StatefulWidget {
  UserProfilePage({Key? key}) : super(key: key);
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Profile? profile;
  int _currentIndex = 0;

  Map<String, dynamic>? data;
  List<Subreddit>? subredditsData;

  @override
  void initState() {
    super.initState();
    getUser();
    getSubreddits();
  }

  getUser() async {
    final res = await Dio().get(
      'https://oauth.reddit.com/api/v1/me',
      queryParameters: {
        'raw_json': 1,
      },
      options: Options(
        headers: <String, String>{
          'Accept': '/',
          'Authorization': 'Bearer ${recup.accessibility}'
        },
      ),
    );
    setState(() {
      data = res.data as Map<String, dynamic>;
      //log(data.toString());
    });
  }

  getSubreddits() async {
    final res = await Dio().get(
      'https://oauth.reddit.com/hot',
      queryParameters: {
        'raw_json': 1,
        'limit': 10,
        'count': 10,
        'show': 'all',
      },
      options: Options(
        headers: <String, String>{
          'Accept': '/',
          'Authorization': 'Bearer ${recup.accessibility}'
        },
      ),
    );
    final tmp = res.data['data']['children'] as List;
    setState(() {
      subredditsData = List<Subreddit>.generate(
          tmp.length, (index) => Subreddit.fromJson(tmp[index]['data']));

      log(data.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text(" ", textAlign: TextAlign.center),
          actions: [
            IconButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => SearchPage())),
                icon: Icon(Icons.search)),
          ],
        ),
        drawer: data != null
            ? Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Image.network(data!['icon_img'].toString()),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            data!['subreddit']['title'],
                            style: TextStyle(),
                          ),
                          Text(data!['subreddit']['display_name_prefixed']),
                          Text(
                            data!['subreddit']['subscribers'].toString() +
                                ' followers',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : CircularProgressIndicator(),
        body: RefreshIndicator(
          child: subredditsData == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List<Widget>.generate(
                      subredditsData!.length,
                      (index) => Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subredditsData![index].subreddit!,
                            ),
                            Text(
                              subredditsData![index].title!,
                            ),
                            Text(
                              subredditsData![index].selftext!,
                            ),
                            subredditsData![index].preview == null
                                ? Container()
                                : Image.network(subredditsData![index]
                                    .preview!
                                    .source!
                                    .url!)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          onRefresh: () async => getSubreddits(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.orange,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                label: 'Setting'),
            BottomNavigationBarItem(icon: Icon(Icons.portrait), label: 'Hot'),
            BottomNavigationBarItem(icon: Icon(Icons.near_me), label: 'news'),
          ],
        ));
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange,
          // The search area here
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        /* Clear the search field */
                      },
                    ),
                    hintText: 'Search...',
                    border: InputBorder.none),
              ),
            ),
          )),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final Profile? profile;
  HeaderSection({
    this.profile,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 110,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            child: Text(
              '',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child: Text(
              '',
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      '',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('')
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      '',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('')
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      '',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('')
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
