import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:tiktok_clone/universal_variables.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  ProfilePage(this.uid);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username;
  String onlineUser;
  String profilePic;
  Future myVideos;
  var likes = 0;
  var isData = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllData();
  }

  getAllData() async {
    myVideos = videoColection.where("uid", isEqualTo: widget.uid).get();
    DocumentSnapshot userDoc = await userCollection.doc(widget.uid).get();
    username = userDoc.data()["username"];
    profilePic = userDoc.data()["profilePic"];

    var docs = await videoColection.where("uid", isEqualTo: widget.uid).get();
    for (var item in docs.docs) {
      likes += item.data()["likes"].length;
    }
    setState(() {
      isData = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isData == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage(
                        profilePic,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      username,
                      style: ralewayStyle(
                        25,
                        Colors.white,
                        FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "100",
                          style: latoStyle(23, Colors.red, FontWeight.bold),
                        ),
                        Text(
                          "50",
                          style: latoStyle(23, Colors.red, FontWeight.bold),
                        ),
                        Text(
                          likes.toString(),
                          style: latoStyle(23, Colors.red, FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Followers",
                          style: latoStyle(23, Colors.white, FontWeight.w500),
                        ),
                        Text(
                          "Following",
                          style: latoStyle(23, Colors.white, FontWeight.w500),
                        ),
                        Text(
                          "Likes",
                          style: latoStyle(23, Colors.white, FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 40,
                      color: Colors.red,
                      child: Center(
                        child: Text(
                          "Edit Profile",
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Videos",
                      style: latoStyle(20, Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FutureBuilder(
                      future: myVideos,
                      builder: (BuildContext coontext, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 5,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot video = snapshot.data.docs[index];
                            return Container(
                              child: Image(
                                image: NetworkImage(
                                  video.data()["previewImage"],
                                ),
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
