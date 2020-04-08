import 'dart:io' show File;
import 'package:flutter/material.dart' show AppBar, BottomAppBar, BuildContext, Center, CircularProgressIndicator, Color, Colors, Column, Container, CrossAxisAlignment, EdgeInsets, Icon, Icons, InkWell, ListTile, ListView, MainAxisAlignment, MainAxisSize, Navigator, Padding, Row, Scaffold, SizedBox, State, StatefulWidget, Text, TextAlign, TextStyle, Widget;
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' show FirebaseStorage, StorageReference, StorageTaskSnapshot, StorageUploadTask;
import 'package:file_picker/file_picker.dart' show FilePicker, FileType;

mixin FileUploader implements StatefulWidget {
  @override
  Future<_FileUploaderState> createState() async => _FileUploaderState();
}

mixin _FileUploaderState implements State<FileUploader> {
  var fileType = '';
  bool loading = false;
  File file;
  String fileName = '';
  String operationText = '';
  bool isUploaded = true;
  String result = '';

  Future filePicker(BuildContext context) async {
    try {
      var fileType2 = fileType;
            if (fileType2 == 'image') {
        file = await FilePicker.getFile(type: FileType.image);
        setState(() {
          fileName = path.basename(file.path);
        });
        print(fileName);
      }
      if (fileType == 'audio') {
        file = await FilePicker.getFile(type: FileType.audio);
        fileName = path.basename(file.path);
        setState(() {
          fileName = path.basename(file.path);
        });
        print(fileName);
      }
      var fileType3 = fileType;
            if (fileType3 == 'video') {
        file = await FilePicker.getFile(type: FileType.video);
        fileName = path.basename(file.path);
        setState(() {
          fileName = path.basename(file.path);
        });
        print(fileName);
      }
      var fileType4 = fileType;
            if (fileType4 == 'pdf') {
        file = await FilePicker.getFile(
            type: FileType.custom, fileExtension: 'pdf');
        fileName = path.basename(file.path);
        setState(() {
          fileName = path.basename(file.path);
        });
        print(fileName);
      }
      var fileType5 = fileType;
            if (fileType5 == 'others') {
        file = await FilePicker.getFile(type: FileType.any);
        fileName = path.basename(file.path);
        setState(() {
          fileName = path.basename(file.path);
        });
        print(fileName);
      }
    } catch (e) {
     var showDialog3 = showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Upload Cancelled'),
                  content: Text('Upload cancelled by the user. Please select again and choose your files to upload.'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              }
          );
          var showDialog2 = showDialog3;
    }
  }

  Future<void> _uploadFile(File file, String filename) async {
    setState(() {
      loading = true;
    });
    StorageReference storageReference;
    var fileType2 = fileType;
        if (fileType2 == 'image') {
      storageReference =
          FirebaseStorage.instance.ref().child("images/$filename");
    }
    var fileType3 = fileType;
        if (fileType3 == 'audio') {
      storageReference =
          FirebaseStorage.instance.ref().child("audio/$filename");
    }
    var fileType4 = fileType;
        if (fileType4 == 'video') {
      storageReference =
          FirebaseStorage.instance.ref().child("videos/$filename");
    }
    var fileType5 = fileType;
        if (fileType5 == 'pdf') {
      storageReference = FirebaseStorage.instance.ref().child("pdf/$filename");
    }
    var fileType6 = fileType;
        if (fileType6 == 'others') {
      storageReference =
          FirebaseStorage.instance.ref().child("others/$filename");
    }
    final uploadTask = storageReference.putFile(file);
    final downloadUrl = (await uploadTask.onComplete);
    final url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
    setState(() {
      loading = false;
      Navigator.pop(context);
    });
  }

  @override
  Future<Widget> build(BuildContext context) {
    var column = Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Please wait uploading....")
                    ],
                  );
        var icon = Icon(
                              Icons.pages,
                              color: Colors.red.shade700,
                            );
                var scaffold = Scaffold(
                                  backgroundColor: Color(0xff212121).withAlpha(80),
                                  body: loading
                                      ? Center(
                                          child: column,
                                    )
                                  : Center(
                                      child: ListView(
                                        children: <Widget>[
                                          ListTile(
                                            title: Text(
                                              'Image',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            leading: Icon(
                                              Icons.image,
                                              color: Colors.red.shade700,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                fileType = 'image';
                                              });
                                              filePicker(context);
                                            },
                                          ),
                                          ListTile(
                                            title: Text(
                                              'Audio',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            leading: Icon(
                                              Icons.audiotrack,
                                              color: Colors.red.shade700,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                fileType = 'audio';
                                              });
                                              filePicker(context);
                                            },
                                          ),
                                          ListTile(
                                            title: Text(
                                              'Video',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            leading: Icon(
                                              Icons.video_label,
                                              color: Colors.red.shade700,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                fileType = 'video';
                                              });
                                              filePicker(context);
                                            },
                                          ),
                                          ListTile(
                                            title: Text(
                                              'PDF',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            leading: icon,
                                    onTap: () {
                                      setState(() {
                                        fileType = 'pdf';
                                      });
                                      filePicker(context);
                                    },
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  fileName != ""
                                      ? Text(
                                          "File name - \n\n" + fileName,
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        )
                                      : Container(
                                          height: 0,
                                          width: 0,
                                        ),
                                ],
                              ),
                            ),
                      bottomNavigationBar: BottomAppBar(
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            fileName != ""
                                ? InkWell(
                                    onTap: () {
                                      _uploadFile(file, fileName);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Icon(Icons.cloud_upload),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text("Upload")
                                        ],
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      child: Text("Choose the file type."),
                                    ),
                                  )
                          ],
                        ),
                      ),
                      appBar: AppBar(
                        title: Text(
                          'Upload File',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                                return widget(child: scaffold);
  }
}
