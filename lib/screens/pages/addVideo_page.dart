import 'dart:io';

import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/screens/confirm_screen.dart';
import 'package:tiktok_clone/universal_variables.dart';

class AddVideoPage extends StatefulWidget {
  @override
  _AddVideoPageState createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  pickVideo(ImageSource src) async {
    Navigator.of(context).pop();
    final video = await ImagePicker().getVideo(source: src);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ConfirmScreen(File(video.path), video.path, src),
      ),
    );
  }

  showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () => pickVideo(ImageSource.gallery),
                child: Row(
                  children: [
                    Icon(Icons.image),
                    Padding(
                      padding: EdgeInsets.all(7),
                      child: Text(
                        "Gallery",
                        style: latoStyle(20),
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () => pickVideo(ImageSource.camera),
                child: Row(
                  children: [
                    Icon(Icons.camera_alt),
                    Padding(
                      padding: EdgeInsets.all(7),
                      child: Text(
                        "Camera",
                        style: latoStyle(20),
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(),
                child: Row(
                  children: [
                    Icon(Icons.cancel),
                    Padding(
                        padding: EdgeInsets.all(7),
                        child: Text(
                          "Cancel",
                          style: latoStyle(20),
                        )),
                  ],
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: InkWell(
          onTap: () => showOptionsDialog(context),
          child: Container(
            width: 190,
            height: 80,
            decoration: BoxDecoration(color: Colors.red),
            child: Center(
              child: Text(
                "Add Video",
                style: latoStyle(30, Colors.black, FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
