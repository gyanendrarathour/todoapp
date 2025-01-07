// ignore_for_file: use_build_context_synchronously, file_names

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:todoapp/view/colors/colors.dart';

import '../db/dbHelper.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  List<Map<String, dynamic>> allMedia = [];
  final TextEditingController _titleController = TextEditingController();
  DBhelper? dbHelper;

  pickImage() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Select Image'),
            content: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  label: const Text('Enter Title of the Image (Optional)'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    try {
                      ImagePicker imagePicker = ImagePicker();
                      final image = await imagePicker.pickImage(
                          source: ImageSource.gallery, imageQuality: 25);
                      final imagePath = File(image!.path);
                      final mimeType = lookupMimeType(image.path)!.split('/');
                      final mediaType = mimeType[0];
                      // print(mediaType);
                      List<int> bytes = await imagePath.readAsBytes();
                      String base64 = base64Encode(bytes);

                      if (mediaType == 'image') {
                        dbHelper!.insertPicture(
                            title: _titleController.text,
                            image: base64);
                        _titleController.clear();
                        GoRouter.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Data Inserted.')));
                        getMedia();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Error: Invalid File Formate so please select only Image media file.')));
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'Error: Invalid File Formate so please select only Image   media file.')));
                    }
                  },
                  child: const Text('From Gallery')),
              TextButton(
                  onPressed: () async {
                    try {
                      ImagePicker imagePicker = ImagePicker();
                      final image = await imagePicker.pickImage(
                          source: ImageSource.camera, imageQuality: 25);
                      final imagePath = File(image!.path);
                      // final mimeType = lookupMimeType(image.path)!.split('/');
                      // final mediaType = mimeType[0];
                      // print(mediaType);
                      List<int> bytes = await imagePath.readAsBytes();
                      String base64 = base64Encode(bytes);

                      dbHelper!.insertPicture(
                          title: _titleController.text,
                          image: base64,);
                      _titleController.clear();
                      GoRouter.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Image Inserted.')));
                      getMedia();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'Error: Invalid File Formate so please select only Image   media file.')));
                    }
                  },
                  child: const Text('From Camera')),
              TextButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  child: const Text('Cancel'))
            ],
          );
        });
  }

  deleteImage(int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Are you sure to Delete!!!'),
            actions: [
              TextButton(
                  onPressed: () {
                    dbHelper!.deletePicture(id: allMedia[index]['id']);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Image deleted successfully.')));
                    GoRouter.of(context).pop();
                    getMedia();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  getMedia() async {
    allMedia = await dbHelper!.showPictures();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBhelper.dbInstace;
    getMedia();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: allMedia.isNotEmpty
          ? ListView.builder(
              itemCount: allMedia.length,
              itemBuilder: (_, index) {
                String blobImage = allMedia[index]['image'].toString();
                Uint8List bytesImage = const Base64Decoder().convert(blobImage);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: forgroundColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Image.memory(
                            bytesImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          height: 50,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color: backgroundColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  allMedia[index]['title'],
                                  style: const TextStyle(
                                      color: forgroundColor, fontSize: 15),
                                ),
                                IconButton(
                                    onPressed: () {
                                      deleteImage(index);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: forgroundColor,
                                    ))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })
          : const Center(child: Text('Add your media here from your gallery')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickImage();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
