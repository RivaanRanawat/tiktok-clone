import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/universal_variables.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  final ImageSource imageSource;

  ConfirmScreen(this.videoFile, this.videoPath, this.imageSource);
  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  VideoPlayerController controller;
  var isLoading = false;
  TextEditingController songController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  FlutterVideoCompress flutterVideoCompress = FlutterVideoCompress();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  compressVideo() async {
    if (widget.imageSource == ImageSource.gallery) {
      return widget.videoFile;
    } else {
      final compressedVideo = await flutterVideoCompress.compressVideo(
        widget.videoPath,
        quality: VideoQuality.MediumQuality,
      );
      return File(compressedVideo.path);
    }
  }

  getPreviewImage() async {
    final previewImage =
        await flutterVideoCompress.getThumbnailWithFile(widget.videoPath);
    return previewImage;
  }

  uploadVideoToStorage(String id) async {
    StorageUploadTask storageUploadTask =
        videosRef.child(id).putFile(await compressVideo());
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadImageToStorage(String id) async {
    StorageUploadTask storageUploadTask =
        imagesRef.child(id).putFile(await getPreviewImage());
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadVideo() async {
    setState(() {
      isLoading = true;
    });
    try {
      var uid = FirebaseAuth.instance.currentUser.uid;
      DocumentSnapshot userDoc = await userCollection.doc(uid).get();
      var allDocs = await videoColection.get();
      int len = allDocs.docs.length;
      String video = await uploadVideoToStorage("Video $len");
      String previewImage = await uploadImageToStorage("Video $len");
      videoColection.doc("Video $len").set({
        "username": userDoc.data()["username"],
        "uid": uid,
        "profilePic": userDoc.data()["profilePic"],
        "id": "Video $len",
        "likes": [],
        "commentCount": 0,
        "shareCount": 0,
        "songName": songController.text,
        "caption": captionController.text,
        "videoUrl": video,
        "previewImage": previewImage,
      });
      Navigator.of(context).pop();
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading == false
          ? SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: VideoPlayer(controller),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            controller: songController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black,
                              labelText: "Song Name",
                              labelStyle: ralewayStyle(20, Colors.red),
                              prefixIcon: Icon(
                                Icons.music_note,
                                color: Colors.red,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          child: TextField(
                            controller: captionController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black,
                              labelText: "Caption",
                              labelStyle: ralewayStyle(20, Colors.red),
                              prefixIcon: Icon(
                                Icons.closed_caption,
                                color: Colors.red,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RaisedButton(
                              onPressed: () => uploadVideo(),
                              color: Colors.red,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Share!",
                                  style: latoStyle(20, Colors.white),
                                ),
                              ),
                            ),
                            RaisedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              color: Colors.lightBlue,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Another Video",
                                  style: latoStyle(20, Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Please wait while we are uploading..",
                    style: ralewayStyle(20, Colors.white),
                  ),
                  SizedBox(height: 30),
                  CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
            ),
    );
  }
}
