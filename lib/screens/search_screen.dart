import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone_flutter/screens/profile_screen.dart';
import 'package:instagram_clone_flutter/utils/global_variable.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                        isShowUsers = true;
                      });
                      print(_);
                    },
                  ),
                ),
              ),
            ),
      isShowUsers
          ? Expanded(
            child: FutureBuilder(
        future: FirebaseFirestore.instance
              .collection('users')
              .where(
            'username',
            isGreaterThanOrEqualTo: searchController.text,
        )
              .get(),
        builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        uid: (snapshot.data! as dynamic).docs[index]['uid'],
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        (snapshot.data! as dynamic).docs[index]['photoUrl'],
                      ),
                      radius: 16,
                    ),
                    title: Text(
                      (snapshot.data! as dynamic).docs[index]['username'],
                    ),
                  ),
                );
              },
            );
        },
      ),
          )
          : Expanded(
            child: FutureBuilder(
        future: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('datePublished')
              .get(),
        builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return StaggeredGridView.countBuilder(
              crossAxisCount: 3,
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) => Image.network(
                (snapshot.data! as dynamic).docs[index]['postUrl'][0],
                fit: BoxFit.cover,
              ),
              staggeredTileBuilder: (index) => MediaQuery.of(context)
                  .size
                  .width >
                  webScreenSize
                  ? StaggeredTile.count(
                  (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                  : StaggeredTile.count(
                  (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            );
        },
      ),
          )
          ],
        ),
      )
    );
  }
}
