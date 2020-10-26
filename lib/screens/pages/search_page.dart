import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:tiktok_clone/universal_variables.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<QuerySnapshot> searchResult;

  searchUser(String typedUser) {
    var users = userCollection
        .where("username", isGreaterThanOrEqualTo: typedUser)
        .get();
    setState(() {
      searchResult = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: TextFormField(
          decoration: InputDecoration(
            filled: false,
            hintText: "Search",
            hintStyle: latoStyle(18, Colors.white),
          ),
          onFieldSubmitted: searchUser,
        ),
      ),
      body: searchResult == null
          ? Center(
              child: Text(
                "Search for users!",
                style: ralewayStyle(25, Colors.white, FontWeight.bold),
              ),
            )
          : FutureBuilder(
              future: searchResult,
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot user = snapshot.data.docs[index];
                      return ListTile(
                        leading: Icon(Icons.search, color: Colors.white,),
                        trailing: CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: NetworkImage(user.data()["profilePic"]),
                        ),
                        title: Text(user.data()["username"], style: ralewayStyle(25, Colors.white),),
                      );
                    });
              }),
    );
  }
}
