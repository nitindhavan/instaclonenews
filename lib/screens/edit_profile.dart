import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';
import 'package:instagram_clone_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone_flutter/responsive/responsive_layout.dart';
import 'package:instagram_clone_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_clone_flutter/screens/login_screen.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/global_variable.dart';
import 'package:instagram_clone_flutter/utils/utils.dart';
import 'package:instagram_clone_flutter/widgets/text_field_input.dart';

import '../models/user.dart';
import '../resources/storage_methods.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _usernameController.dispose();
  }

  void updateUser() async {
    // set loading to true

    User user=await AuthMethods().getUserDetails();
    // signup user using our authmethodds
    user.email=_emailController.text;
    user.username=_usernameController.text;
    user.bio=_bioController.text;
    user.phone=_contactController.text;
    user.address=_addressController.text;
    if(_image!=null) {
      String photoUrl = await StorageMethods().uploadImageToStorage(
          'profilePics', _image!, false);
      user.photoUrl = photoUrl;
    }
    await AuthMethods().updateUser(user).then((value) {
      // if string returned is sucess, user has been created
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
          const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    });
    }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if(snapshot.hasData) {
                _usernameController.text=snapshot.data!.username;
                _emailController.text=snapshot.data!.email;
                _bioController.text=snapshot.data!.bio;
                _contactController.text=snapshot.data!.phone;
                _addressController.text=snapshot.data!.address;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 64,),
                      Text('App Name', style: TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold),),
                      const SizedBox(
                        height: 64,
                      ),
                      Stack(
                        children: [
                          _image != null
                              ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                            backgroundColor: Colors.red,
                          )
                              : CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                snapshot.data!.photoUrl),
                            backgroundColor: Colors.red,
                          ),
                          Positioned(
                            bottom: -10,
                            left: 80,
                            child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(Icons.add_a_photo),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFieldInput(
                        hintText: 'Enter your username',
                        textInputType: TextInputType.text,
                        textEditingController: _usernameController,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFieldInput(
                        hintText: 'Enter your email',
                        textInputType: TextInputType.emailAddress,
                        textEditingController: _emailController,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFieldInput(
                        hintText: 'Enter your bio',
                        textInputType: TextInputType.text,
                        textEditingController: _bioController,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFieldInput(
                        hintText: 'Enter your Contact Number',
                        textInputType: TextInputType.text,
                        textEditingController: _contactController,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFieldInput(
                        hintText: 'Enter your Address',
                        textInputType: TextInputType.text,
                        textEditingController: _addressController,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      InkWell(
                        child: Container(
                          child: !_isLoading
                              ? const Text(
                            'Save', style: TextStyle(color: Colors.white),
                          )
                              : const CircularProgressIndicator(
                            color: primaryColor,
                          ),
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ),
                            color: blueColor,
                          ),
                        ),
                        onTap: updateUser,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                );
              }else{
                return Center(child: CircularProgressIndicator(),);
              }
            },future: AuthMethods().getUserDetails(),
          ),
        ),
      ),
    );
  }
}
