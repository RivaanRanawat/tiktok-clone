import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:tiktok_clone/screens/comment_screen.dart';
import 'package:tiktok_clone/universal_variables.dart';
import 'package:tiktok_clone/widgets/circle_animation.dart';
import 'package:tiktok_clone/widgets/video_player.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  Stream videoStream;
  String uid;

  initState() {
    super.initState();
    videoStream = videoColection.snapshots();
    uid = FirebaseAuth.instance.currentUser.uid;
  }

  shareVideo(String video, String id) async {
    var req = await HttpClient().getUrl(Uri.parse(video));
    var res = await req.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(res);
    await Share.file("TikTok", "Video.mp4", bytes, "video/mp4");
    DocumentSnapshot doc = await videoColection.doc(id).get();
    videoColection.doc(id).update({"shareCount": doc.data()["shareCount"] + 1});
  }

  buildProfile(String url) {
    return Container(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: (60 / 2) - (50 / 2),
            child: Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(
                    url,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: (60 / 2) - (20 / 2),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  buildMusicAlbum(String url) {
    return Container(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(11.0),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey[800],
                  Colors.grey[700],
                ],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(
                  url,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    likeVideo(String id) async {
      DocumentSnapshot doc = await videoColection.doc(id).get();
      if (doc.data()["likes"].contains(uid)) {
        videoColection.doc(id).update({
          "likes": FieldValue.arrayRemove([uid]),
        });
      } else {
        videoColection.doc(id).update({
          "likes": FieldValue.arrayUnion([uid]),
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder(
          stream: videoStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return PageView.builder(
                itemCount: snapshot.data.docs.length,
                controller: PageController(initialPage: 0, viewportFraction: 1),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  DocumentSnapshot videos = snapshot.data.docs[index];
                  print(videos);
                  return Stack(
                    children: [
                      VideoPlayerItem(videos.data()["videoUrl"]),
                      Column(
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          videos.data()["username"],
                                          style: ralewayStyle(20, Colors.white,
                                              FontWeight.bold),
                                        ),
                                        Text(
                                          videos.data()["caption"],
                                          style: latoStyle(15, Colors.white),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.music_note,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              videos.data()["songName"],
                                              style: ralewayStyle(
                                                15,
                                                Colors.white,
                                                FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          12),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildProfile(videos.data()["profilePic"]),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () =>
                                                likeVideo(videos.data()["id"]),
                                            child: Icon(
                                              Icons.favorite,
                                              size: 55,
                                              color: videos
                                                      .data()["likes"]
                                                      .contains(uid)
                                                  ? Colors.red
                                                  : Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                              videos
                                                  .data()["likes"]
                                                  .length
                                                  .toString(),
                                              style:
                                                  latoStyle(20, Colors.white)),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () =>
                                                Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CommentScreen(
                                                  videos.data()["id"]
                                                ),
                                              ),
                                            ),
                                            child: Icon(Icons.comment,
                                                size: 55, color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                              videos
                                                  .data()["commentCount"]
                                                  .toString(),
                                              style:
                                                  latoStyle(20, Colors.white)),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () => shareVideo(
                                                videos.data()["videoUrl"],
                                                videos.data()["id"]),
                                            child: Icon(Icons.reply,
                                                size: 55, color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                              videos
                                                  .data()["shareCount"]
                                                  .toString(),
                                              style:
                                                  latoStyle(20, Colors.white)),
                                        ],
                                      ),
                                      CircleAnimation(buildMusicAlbum(
                                          videos.data()["profilePic"])),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                });
          }),
    );
  }
}
