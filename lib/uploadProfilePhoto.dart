//Page for uploading Profile Photo
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

String profilePhoto;

class UpdatePic extends StatefulWidget {
  final String uid;
  final String name;
  final String number;
  final String city;

  UpdatePic(this.uid, this.name, this.number, this.city);

  @override
  _UpdatePicState createState() => _UpdatePicState();
}

class _UpdatePicState extends State<UpdatePic> {
  File image;
  String profilePhoto;

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      image = selected;
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Update Profile Picture"),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.photo_camera,
                  size: 28,
                  color: Colors.red.shade800,
                ),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              IconButton(
                icon: Icon(
                  Icons.photo_library,
                  size: 28,
                  color: Colors.blue.shade500,
                ),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        ),
        floatingActionButton: image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                ],
              )
            : Container(
                height: 0,
                width: 0,
              ),
        body: image != null
            ? Container(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(32),
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.file(
                                image,
                                height: MediaQuery.of(context).size.height * .4,
                                width: MediaQuery.of(context).size.height * .4,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: Colors.red.shade800,
                              ),
                              width: 60,
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Icon(Icons.crop),
                                    Text("Crop")
                                  ],
                                ),
                              ),
                            ),
                            onTap: _cropImage,
                          ),
                          InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: Colors.red.shade800,
                              ),
                              width: 60,
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Icon(Icons.refresh),
                                    Text("Clear")
                                  ],
                                ),
                              ),
                            ),
                            onTap: _clearImage,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Uploader(
                            file: image,
                            uid: widget.uid,
                            city: widget.city,
                            name: widget.name,
                            number: widget.number,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Container(
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Your selected image will appear here",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Tap any icon at bottom to upload",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 80,
                      )
                    ],
                  ),
                )),
              ));
  }

  void _clearImage() {
    setState(() => image = null);
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: image.path,
      // ratioX: 1.0,
      // ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );

    setState(() {
      image = cropped ?? image;
    });
  }
}

class Uploader extends StatefulWidget {
  final File file;

  final String uid;
  final String name;
  final String number;
  final String city;

  Uploader({Key key, this.file, this.uid, this.name, this.number, this.city})
      : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final fireStore = Firestore.instance;
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://search-india-cb545.appspot.com/');

  StorageUploadTask _uploadTask;

  uploadImgData() async {
    await fireStore.collection('users').document(widget.uid).setData({
      'name': widget.name,
      'mobile': widget.number,
      'city': widget.city,
      'img': profilePhoto,
    });
    Navigator.pop(context, profilePhoto);
  }

  _startUpload() async {
    String imgPath = 'images/${DateTime.now().millisecondsSinceEpoch}.png';

    setState(() {
      _uploadTask = _storage.ref().child(imgPath).putFile(widget.file);
    });
    profilePhoto = await (await _uploadTask.onComplete).ref.getDownloadURL();
    uploadImgData();
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ignore: sdk_version_ui_as_code
                  if (_uploadTask.isComplete)
                    Text('Upload Successful!',
                        style: TextStyle(
                            color: Colors.white, height: 2, fontSize: 18)),
                  // ignore: sdk_version_ui_as_code
                  if (_uploadTask.isPaused)
                    FlatButton(
                      child: Icon(Icons.play_arrow, size: 30),
                      onPressed: _uploadTask.resume,
                    ),
                  // ignore: sdk_version_ui_as_code
                  if (_uploadTask.isInProgress)
                    FlatButton(
                      child: Icon(Icons.pause, size: 30),
                      onPressed: _uploadTask.pause,
                    ),
                  SizedBox(
                    height: 6,
                  ),
                  LinearProgressIndicator(value: progressPercent),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${(progressPercent * 100).toStringAsFixed(2)} % ',
                    style: TextStyle(fontSize: 18),
                  ),
                ]);
          });
    } else {
      return InkWell(
          onTap: _startUpload,
          child: Container(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * .9,
              decoration: BoxDecoration(
                  color: Colors.red.shade900,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Update my Profile Pic',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade200),
                    ),
                  ],
                ),
              ),
            ),
          ));
    }
  }
}
