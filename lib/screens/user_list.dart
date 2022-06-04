import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/screens/chat_screen.dart';

class UsersList extends StatefulWidget {
  static const String id = "user_list";
  static String toUser = "";
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  var _firestore = FirebaseFirestore.instance;
  List<dynamic> users = [];

  void getUsers() async {
    var fbusers = await _firestore.collection("users").get();
    for (var m in fbusers.docs) {
      users.add(m.data()["email"]);
    }
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        UsersList.toUser = users[index];
                        Navigator.pushNamed(context, ChatScreen.id);
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Container(
                          decoration: BoxDecoration(color: Color(0xffffffff)),
                          child: ListTile(
                            leading: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.black54,
                            ),
                            title: Text(
                              users[index]["email"].toString(),
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
