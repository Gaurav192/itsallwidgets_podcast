import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:itsallwidgets_podcast/bloc/podcast_bloc.dart';
import 'package:itsallwidgets_podcast/data/rss_response.dart';
import 'package:itsallwidgets_podcast/detail.dart';

class PodCastList extends StatelessWidget {
  final recognizer = TapGestureRecognizer()
    ..onTap = () {
      print("You have tapped Hillel");
    };

  @override
  Widget build(BuildContext context) {
    bloc.fetchAllPodCast();
    return Scaffold(
      body: StreamBuilder(
        stream: bloc.allPodCast,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildTitleWidget(snapshot),
                  buildBlueDivider(),
                  textAuthorSpan(snapshot.data.feed.author),
                  Container(
                    margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    child: Text(
                      snapshot.data.feed.description,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return buildListViewItem(snapshot, index, context);
                    },
                    itemCount: snapshot.data.items.length,
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  buildListViewItem(
      AsyncSnapshot<RssResponse> snapshot, int index, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 4),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) =>
                  PodCastDetail(snapshot.data.items[index], snapshot.data.feed),
            ),
          );
        },
        contentPadding: EdgeInsets.all(8),
        trailing: Icon(Icons.navigate_next),
        title: Text(snapshot.data.items[index].title),
        leading: ClipOval(
          child: Hero(
            tag: snapshot.data.items[index].title,
            child: Image.network(
              snapshot.data.feed.image,
              fit: BoxFit.cover,
              height: 48,
              width: 48,
            ),
          ),
        ),
      ),
    );
  }

  buildBlueDivider() {
    return Container(
      color: Colors.blue,
      height: 3,
      width: 50,
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
    );
  }

  Padding buildTitleWidget(AsyncSnapshot<RssResponse> snapshot) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Text(
        snapshot.data.feed.title,
        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
      ),
    );
  }

  textAuthorSpan(String author) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Hosted by ',
              style: TextStyle(
                color: Colors.blue.shade500,
              ),
            ),
            TextSpan(
              recognizer: recognizer,
              text: author,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.blue.shade900,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.ltr,
      ),
    );
  }
}

//class PodCastList extends StatefulWidget {
//  @override
//  _PodCastListState createState() => _PodCastListState();
//}
//
//class _PodCastListState extends State<PodCastList> {
//  final Xml2Json myTransformer = Xml2Json();
//  Future<RssResponse> rssResponse;
//
//  @override
//  void initState() {
//    super.initState();
//    rssResponse = fetchPodCast();
//  }
//
//  final recognizer = TapGestureRecognizer()
//    ..onTap = () {
//      print("You have tapped Hillel");
//    };
//
//  Future<RssResponse> fetchPodCast() async {
//    final response = await http.get(
//        'https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fitsallwidgets.com%2Fpodcast%2Ffeed');
//
//    if (response.statusCode == 200) {
//      // If the call to the server was successful, parse the JSON
//      return RssResponse.fromJson(json.decode(response.body));
//    } else {
//      // If that call was not successful, throw an error.
//      throw Exception('Failed to load podcast');
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return SafeArea(
//      child: Scaffold(
//        body: FutureBuilder<RssResponse>(
//          future: rssResponse,
//          builder: (context, snapshot) {
//            if (snapshot.hasData) {
//              return SingleChildScrollView(
//                physics: BouncingScrollPhysics(),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    buildTitleWidget(snapshot),
//                    buildBlueDivider(),
//                    textAuthorSpan(snapshot.data.feed.author),
//                    Container(
//                      margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
//                      child: Text(
//                        snapshot.data.feed.description,
//                        style: TextStyle(fontSize: 16.0),
//                      ),
//                    ),
//                    ListView.builder(
//                      shrinkWrap: true,
//                      physics: NeverScrollableScrollPhysics(),
//                      itemBuilder: (context, index) {
//                        return buildListViewItem(snapshot, index);
//                      },
//                      itemCount: snapshot.data.items.length,
//                    ),
//                  ],
//                ),
//              );
//            } else if (snapshot.hasError) {
//              return Text("${snapshot.error}");
//            }
//
//            // By default, show a loading spinner
//            return CircularProgressIndicator();
//          },
//        ),
//      ),
//    );
//  }
//
//  buildListViewItem(AsyncSnapshot<RssResponse> snapshot, int index) {
//    return Card(
//      child: ListTile(
//        onTap: () {
//          Navigator.of(context).push(CupertinoPageRoute(
//              builder: (context) => PodCastDetail(
//                  snapshot.data.items[index], snapshot.data.feed)));
//        },
//        contentPadding: EdgeInsets.all(8),
//        trailing: Icon(Icons.navigate_next),
//        title: Text(snapshot.data.items[index].title),
//        leading: ClipOval(
//          child: Hero(
//            tag: snapshot.data.items[index].title,
//            child: Image.network(
//              snapshot.data.feed.image,
//              fit: BoxFit.cover,
//              height: 48,
//              width: 48,
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//
//  buildBlueDivider() {
//    return Container(
//      color: Colors.blue,
//      height: 3,
//      width: 50,
//      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
//    );
//  }
//
//  Padding buildTitleWidget(AsyncSnapshot<RssResponse> snapshot) {
//    return Padding(
//      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
//      child: Text(
//        snapshot.data.feed.title,
//        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
//      ),
//    );
//  }
//
//  textAuthorSpan(String author) {
//    return Container(
//      margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
//      child: RichText(
//        text: TextSpan(
//          style: TextStyle(
//            fontWeight: FontWeight.w400,
//            fontSize: 20,
//          ),
//          children: <TextSpan>[
//            TextSpan(
//              text: 'Hosted by ',
//              style: TextStyle(
//                color: Colors.blue.shade500,
//              ),
//            ),
//            TextSpan(
//              recognizer: recognizer,
//              text: author,
//              style: TextStyle(
//                fontWeight: FontWeight.w900,
//                color: Colors.blue.shade900,
//              ),
//            ),
//          ],
//        ),
//        textAlign: TextAlign.right,
//        textDirection: TextDirection.ltr,
//      ),
//    );
//  }
//}
