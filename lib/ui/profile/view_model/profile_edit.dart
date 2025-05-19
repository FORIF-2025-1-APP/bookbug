import 'package:bookbug/ui/core/ui/profileimage_base.dart';
import 'package:flutter/material.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('프로필 수정')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 40),
              ProfileimageBase(
                image: 'assets/hyu.jpeg',
                edit: Icon(Icons.edit),
              ),
              SizedBox(height: 40),
              edittextfield(context, true, 'ID', 'yourID@test.com'),
              SizedBox(height: 10),
              edittextfield(context, true, 'Email', 'youremail@test.com'),
              SizedBox(height: 10),
              edittextfield(context, false, 'Password', ''),
              SizedBox(height: 10),
              edittextfield(context, false, 'Password Confirm', ''),
              Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextButton(
                  onPressed: () {},
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
        readOnly: isreadonly, // 읽기전용, 수정하기에서도 바꾸지 못하는
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
