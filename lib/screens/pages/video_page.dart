import "package:flutter/material.dart";
import 'package:tiktok_clone/universal_variables.dart';
import 'package:tiktok_clone/widgets/circle_animation.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  buildProfile() {
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
                    "https://www.accountingweb.co.uk/sites/all/modules/custom/sm_pp_user_profile/img/default-user.png",
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

  buildMusicAlbum() {
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
                  "https://www.accountingweb.co.uk/sites/all/modules/custom/sm_pp_user_profile/img/default-user.png",
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(color: Colors.black),
          ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Username",
                              style: ralewayStyle(
                                  20, Colors.white, FontWeight.bold),
                            ),
                            Text(
                              "Description goes blah blah blah blah blah",
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
                                  "Music Name",
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
                      margin: EdgeInsets.only(top: 150),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildProfile(),
                          Column(
                            children: [
                              Icon(Icons.favorite,
                                  size: 55, color: Colors.white),
                              SizedBox(
                                height: 7,
                              ),
                              Text("20", style: latoStyle(20, Colors.white)),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.comment,
                                  size: 55, color: Colors.white),
                              SizedBox(
                                height: 7,
                              ),
                              Text("20", style: latoStyle(20, Colors.white)),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.reply, size: 55, color: Colors.white),
                              SizedBox(
                                height: 7,
                              ),
                              Text("20", style: latoStyle(20, Colors.white)),
                            ],
                          ),
                          CircleAnimation(buildMusicAlbum()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
