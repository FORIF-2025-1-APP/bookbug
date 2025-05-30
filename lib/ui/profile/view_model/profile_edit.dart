import 'package:bookbug/ui/core/ui/profileimage_base.dart';
import 'package:bookbug/ui/profile/widget/imageedit_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final TextEditingController _controller = TextEditingController();
  File? profileImage;

  void setDefaultImage() {
    setState(() {
      profileImage = null;
    });
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        profileImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('프로필 수정')),
      body: Center(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  profileImage != null
                      ? CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(profileImage!),
                      )
                      : ProfileimageBase(
                        image: 'assets/hyu.jpeg',
                        edit: Icon(Icons.edit),
                        onTapEdit: () {
                          imagePickerSheet(
                            context: context,
                            defaultImage: setDefaultImage,
                            imagePick: pickImage,
                          );
                        },
                      ),
                  SizedBox(height: 40),
                  edittextfield(context, true, 'ID', 'yourID@test.com'),
                  SizedBox(height: 10),
                  edittextfield(context, true, 'Email', 'youremail@test.com'),
                  SizedBox(height: 10),
                  edittextfield(context, false, 'Password', ''),
                  SizedBox(height: 10),
                  edittextfield(context, false, 'Password Confirm', ''),
                  SizedBox(height: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('수정 완료')));
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                      ),
                      child: Text('수정', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget edittextfield(
    BuildContext context,
    bool isreadonly,
    String labeltext,
    String hinttext,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 50,
      child: TextField(
        readOnly: isreadonly,
        controller: _controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: labeltext,
          labelStyle: TextStyle(
            color:
                isreadonly
                    ? Colors.grey.shade400
                    : Theme.of(context).colorScheme.shadow,
          ),
          hintText: hinttext,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
          border: OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color:
                  isreadonly
                      ? Colors.grey.shade200
                      : Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
      ),
    );
  }
}
