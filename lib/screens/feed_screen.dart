import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone_flutter/screens/add_post_screen.dart';
import 'package:instagram_clone_flutter/screens/chat_list_screen.dart';
import 'package:instagram_clone_flutter/screens/chat_page.dart';
import 'package:instagram_clone_flutter/screens/home_page.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/global_variable.dart';
import 'package:instagram_clone_flutter/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String tag='Job';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
        elevation: 0,
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Text('App Name',style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_a_photo,
              color: primaryColor,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> AddPostScreen()));
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.messenger_outline,
              color: primaryColor,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatList()));
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').where('tag',isEqualTo: tag).snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // snapshot.data!.docs.forEach((element) {
          //   if(element)
          // })
          // if(snapshot.data!.docs[index].data()['tag']!=tag)
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          tag='Job';
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 8,bottom: 8,left: 30,right: 30),
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: tag=='Job' ? Colors.blue : Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text('Job',style: TextStyle(fontWeight: FontWeight.bold,color: tag!='Job' ? Colors.black : Colors.white),)),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          tag='Training';
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 8,bottom: 8,left: 30,right: 30),
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: tag=='Training' ? Colors.blue : Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text('Training',style: TextStyle(fontWeight: FontWeight.bold,color: tag!='Training' ? Colors.black : Colors.white),)),
                      ),
                    ),
                  ],
                ),
            snapshot.data!.docs.length==0? Expanded(child: Center(child: Text('No posts'),)) : Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: width > webScreenSize ? width * 0.3 : 0,
                        vertical: width > webScreenSize ? 15 : 0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: PostCard(
                          snap: snapshot.data!.docs[index].data(),
                        ),
                      ),
                    );
                  }
                ),
              ),
            ),
            ],
            ),
          );
        },
      ),
    );
  }
}
