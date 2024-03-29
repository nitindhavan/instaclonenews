import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_flutter/providers/user_provider.dart';
import 'package:instagram_clone_flutter/resources/firestore_methods.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  List<Uint8List> _files=[];
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  String tag='Job';

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    if(file.isNotEmpty) {
                      _files.add(file);
                    }
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    if(file.isNotEmpty) {
                      _files.add(file);
                    }
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage(String uid, String username, String profImage,String tag) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _files,
        uid,
        username,
        profImage,tag
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
        clearImage();
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _files = [];
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
        return Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: const Text(
                'Post',
              ),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  onPressed: () => postImage(
                    userProvider.getUser.uid,
                    userProvider.getUser.username,
                    userProvider.getUser.photoUrl,
                    tag
                  ),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )
              ],
            ),
            // POST FORM
            body: _files.isNotEmpty ? SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  isLoading
                      ? const LinearProgressIndicator()
                      : const Padding(padding: EdgeInsets.only(top: 0.0)),
                  Row(
                    children: [
                      SizedBox(width: 16,),
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
                            color: tag=='Job' ? Colors.blue : Colors.white70,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text('Job',style: TextStyle(fontWeight: FontWeight.bold),)),
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
                            color: tag!='Job' ? Colors.blue : Colors.white70,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text('Training',style: TextStyle(fontWeight: FontWeight.bold),)),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(width: 16,),
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          userProvider.getUser.photoUrl,
                        ),
                      ),
                      SizedBox(width: 16,),
                      Text(userProvider.getUser.username),
                    ],
                  ),
                  SizedBox(height: 16,),
                  Container(
                    height: 300,
                    child: ListView.builder(itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(16),
                        child: Image.memory(_files[index]),
                      );
                    },itemCount: _files.length,scrollDirection: Axis.horizontal,),
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                          hintText: "Write a caption...",
                          border: InputBorder.none),
                      maxLines: 8,
                      minLines: 1,
                    ),
                  ),
                  const Divider(),

                ],
              ),
            ) :
            Center(
              child: GestureDetector( onTap:(){
                _selectImage(context);
              },child: Text('upload Image'))
              ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'add', onPressed: () {
              _selectImage(context);

          },child: Icon(Icons.add),
          ),
          );
  }
}
