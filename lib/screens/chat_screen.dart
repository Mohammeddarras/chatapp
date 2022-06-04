import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chatapp/constants.dart';
import 'package:path/path.dart';
import 'package:chatapp/screens/user_list.dart';

class ChatScreen extends StatefulWidget {
  static const String id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User loggedUser;
  var _auth = FirebaseAuth.instance;
  var _firestore = FirebaseFirestore.instance;
  String message;
  var msgController = TextEditingController();

  //Upload
  File _imageFile;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile.path);
      uploadImageToFirebase();
    });
  }

  Future uploadImageToFirebase() async {
    String fileName = basename(_imageFile.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    var url = imageUrl.toString();
    print(url);

    _firestore.collection("messages").add({
      'sender': loggedUser.email,
      'receiver': UsersList.toUser,
      'text': url,
      'time': DateTime.now().millisecondsSinceEpoch,
      'type': '2'
    });
  }

  /*void getMessages() async{
    var messages = await _firestore.collection("messages").get();
    for(var m in messages.docs){
      print(m.data());
    }
  }

  void messageStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var msg in snapshot.docs) {
        print(msg.data());
      }
    }
  }*/

  void getCurrentUser() async {
    var user = await FirebaseAuth.instance.currentUser;
    if (user != null)
      loggedUser = user;

    //print(loggedUser.email);
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: [
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection("messages").orderBy('time', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var messages = snapshot.data.docs;
                  List<MessageBubble> msgWidgets = [];
                  for (dynamic msg in messages) {
                    var msgText = msg.data()["text"];
                    var msgSender = msg.data()["sender"];
                    var msgType = msg.data()["type"];
                    var msgWidget = MessageBubble(
                        sender: msgSender,
                        text: msgText,
                        isMe: loggedUser.email == msgSender,
                        type: msgType);
                    msgWidgets.add(msgWidget);
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      children: msgWidgets,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: msgController,
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _firestore.collection("messages").add({
                        'sender': loggedUser.email,
                        'receiver': UsersList.toUser,
                        'text': message,
                        'time': DateTime.now().millisecondsSinceEpoch,
                        'type': '1'
                      });
                      msgController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.camera, color: Colors.lightBlueAccent),
                      onPressed: (){
                        pickImage();
                      }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender, this.isMe, this.type});

  final text;
  final sender;
  final isMe;
  final type;

  @override
  Widget build(BuildContext context) {
    if (type == "1") {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              '$sender',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(30),
              color: isMe ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  '$text',
                  style: TextStyle(
                      fontSize: 16,
                      color: isMe ? Colors.white : Colors.black54),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              '$sender',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            Container(
              width: 150.0,
              height: 150.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill, image: new NetworkImage("$text"))),
            ),
          ],
        ),
      );
    }
  }
}
