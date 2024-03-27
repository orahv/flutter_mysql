import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_project/components/consts.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as path;

class DisplayDataPage extends StatefulWidget {
  const DisplayDataPage({super.key});
  @override
  State<DisplayDataPage> createState() => _DisplayDataPageState();
}

class _DisplayDataPageState extends State<DisplayDataPage> {
  List data = [];
  String searchText = "";
  File? imageFile;

  @override
  void initState() {
    getData('');
    super.initState();
  }

  Future getData(String search) async {
    var response;
    var uri = Uri.parse('http://$ip/$folder/search.php');
    response = await http.post(uri, body: {
      "search": search,
    });
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      return Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Something went wrong ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  //ADD DATA AND IMAGES
  Future addData(String name, String item, File imageFile) async {
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse('http://$ip/$folder/insert.php');
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile("image", stream, length,
        filename: path.basename(imageFile.path));

    request.files.add(multipartFile);
    request.fields['name'] = name;
    request.fields['item'] = item;
    var response = await request.send();

    if (response.statusCode == 200) {
      getData('');
      return Fluttertoast.showToast(
        backgroundColor: Colors.green,
        textColor: Colors.white,
        msg: 'Data Added Successfully',
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      return Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Something went wrong ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Future deleteData(String id, String photo) async {
    var response;
    var uri = Uri.parse('http://$ip/$folder/delete.php');
    response = await http.post(uri, body: {
      "id": id,
      "photo": photo,
    });
    if (response.statusCode == 200) {
      getData('');
      return Fluttertoast.showToast(
        backgroundColor: Colors.green,
        textColor: Colors.white,
        msg: 'Data Deleted Successfully',
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      return Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Something went wrong ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  AlertDialog _alertDialogDelete(Map<String, dynamic> data) {
    return AlertDialog(
      title: Text('Delete Data'),
      content: Text('Do you want to delete ${data['name']}'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            deleteData(data['id'], data['photo']);
            Navigator.of(context).pop();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }

  Widget _displayMedia(String? media) {
    if (media == null || media == '') {
      return Image.asset('assets/images/avatar.jpg');
    } else {
      return Image.network('http://$ip/$folder/img/$media');
    }
  }

  Future updateData(
    String id,
    String name,
    String item,
    String old_photo,
    File photo,
    String old_name,
    String old_item,
  ) async {
    var stream = http.ByteStream(DelegatingStream.typed(photo.openRead()));
    var length = await photo.length();
    var uri = Uri.parse('http://$ip/$folder/update.php');
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile("image", stream, length,
        filename: path.basename(photo.path));

    request.files.add(multipartFile);
    request.fields['id'] = id;
    request.fields['name'] = name;
    request.fields['item'] = item;
    request.fields['old_name'] = old_name;
    request.fields['old_item'] = old_item;
    request.fields['old_photo'] = old_photo;
    var response = await request.send();

    if (response.statusCode == 200) {
      getData('');
      return Fluttertoast.showToast(
        backgroundColor: Colors.green,
        textColor: Colors.white,
        msg: 'Data Changed Successfully',
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      return Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Something went wrong ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  StatefulBuilder _alertDialogUpdate(Map<String, dynamic> data) {
    TextEditingController ctrlname = TextEditingController();
    TextEditingController ctrlitem = TextEditingController();
    ctrlname.text = data['name'];
    ctrlitem.text = data['item'];

    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Text('Change Data'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrlname,
                decoration: const InputDecoration(
                  label: Text('name'),
                ),
              ),
              TextField(
                controller: ctrlitem,
                // keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text('Item'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        if (image == null) return;
                        final imageTemp = File(image.path);
                        setState(() {
                          imageFile = imageTemp;
                        });
                      } on PlatformException catch (e) {
                        print('Failed to pick image: $e');
                      }
                    },
                    child: Text('Camera'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (image == null) return;
                        final imageTemp = File(image.path);
                        setState(() {
                          imageFile = imageTemp;
                        });
                      } on PlatformException catch (e) {
                        print('Failed to pick image: $e');
                      }
                    },
                    child: Text('Gallery'),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              imageFile == null
                  ? Container()
                  : SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.file(
                        imageFile!,
                        fit: BoxFit.cover,
                      ),
                    )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                imageFile = null;
              });
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              updateData(data['id'], ctrlname.text, ctrlitem.text,
                  data['photo'], imageFile!, data['name'], data['item']);
              getData('');
              Navigator.of(context).pop();
              setState(() {
                imageFile = null;
              });
            },
            child: const Text('Save'),
          ),
        ],
      );
    });
  }

  StatefulBuilder _alertDialog() {
    TextEditingController ctrlname = TextEditingController();
    TextEditingController ctrlitem = TextEditingController();
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Text('Add Data'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrlname,
                decoration: const InputDecoration(
                  label: Text('name'),
                ),
              ),
              TextField(
                controller: ctrlitem,
                // keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text('Item'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        if (image == null) return;
                        final imageTemp = File(image.path);
                        setState(() {
                          imageFile = imageTemp;
                        });
                      } on PlatformException catch (e) {
                        print('Failed to pick image: $e');
                      }
                    },
                    child: Text('Camera'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (image == null) return;
                        final imageTemp = File(image.path);
                        setState(() {
                          imageFile = imageTemp;
                        });
                      } on PlatformException catch (e) {
                        print('Failed to pick image: $e');
                      }
                    },
                    child: Text('Gallery'),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              imageFile == null
                  ? Container()
                  : SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.file(
                        imageFile!,
                        fit: BoxFit.cover,
                      ),
                    )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                imageFile = null;
              });
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              addData(ctrlname.text, ctrlitem.text, imageFile!);
              getData('');
              Navigator.of(context).pop();
              setState(() {
                imageFile = null;
              });
            },
            child: const Text('Save'),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return _alertDialog();
                });
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: AnimatedSearchBar(
            onChanged: (value) {
              setState(() {
                getData(value);
              });
            },
          ),
        ),
        body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
// leading: Icon(
// Icons.account_circle,
// size: 50,
// ),
              leading: Container(
                  width: 50,
                  height: 50,
                  child: _displayMedia(data[index]['photo'])),
// Image.asset(
// 'assets/${data[index]['photo']}',
// height: 70,
// width: 70,
// ),
              title: Text(data[index]['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              subtitle: Text('Item ${data[index]['item']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return _alertDialogUpdate(data[index]);
                            });
                      },
                      icon: Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return _alertDialogDelete(data[index]);
                            });
                      },
                      icon: Icon(Icons.delete)),
                ],
              ),
            );
          },
        ));
  }
}
