import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/providers/user_provider.dart';
import 'package:instagram_clone_flutter/screens/chat_room.dart';
import 'package:provider/provider.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  var searchController=TextEditingController();
  String key='';
  @override
  Widget build(BuildContext context) {
    searchController.addListener(() {
      setState(() {
        key;
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10)
              ),
              height: 40,
              padding: EdgeInsets.only(left: 30),
              child: Form(
                child: TextFormField(
                  controller: searchController,
                  decoration:
                  const InputDecoration(hintText: 'Search for a user...',border: InputBorder.none),
                  onFieldSubmitted: (String _) {
                    setState(() {
                      key;
                    });
                    print(_);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                UserProvider provider =Provider.of<UserProvider>(context,listen: false);
                if(!snapshot.hasData)return CircularProgressIndicator();
                return ListView.builder(
                  key: Key(key),
                  itemBuilder: (BuildContext context, int index) {
                    if(provider.getUser.following.contains(snapshot.data!.docs[index].data()['uid'].toString()) && snapshot.data!.docs[index].data()['username'].toString().toLowerCase().contains(searchController.text))
                      return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatPage(arguments: ChatPageArguments(peerId:snapshot.data!.docs[index].data()['uid'],peerAvatar:snapshot.data!.docs[index].data()['photoUrl'],peerNickname: snapshot.data!.docs[index].data()['username'] ),)));
                      },
                      child: Container(
                        height: 70,
                        width: double.infinity,
                        margin: EdgeInsets.all(4),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.black12,borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                snapshot.data!.docs[index].data()['photoUrl'].toString(),
                              ),
                            ),
                            SizedBox(width: 16,),
                            Text(snapshot.data!.docs[index].data()['username'],textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    );
                    return SizedBox();
                  },
                  itemCount: snapshot.data!.docs.length,
                );
              },
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
            ),
          ),
        ],
      ),
    );
  }
}
