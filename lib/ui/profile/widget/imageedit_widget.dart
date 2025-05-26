import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> imagePickerSheet({
  required BuildContext context,
  required VoidCallback defaultImage,
  required Future<void> Function(ImageSource source) imagePick,
}) async {
  await showModalBottomSheet(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.image),
              title: Text('기본 이미지로 설정'),
              onTap: () {
                Navigator.pop(context);
                defaultImage();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('라이브러리에서 선택'),
              onTap: () async {
                Navigator.pop(context);
                await imagePick(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('카메라로 찍기'),
              onTap: () async {
                Navigator.pop(context);
                await imagePick(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text('취소'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    },
  );
}
