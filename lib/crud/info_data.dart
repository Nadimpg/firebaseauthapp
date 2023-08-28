import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InfoData extends StatefulWidget {
  const InfoData({super.key});

  @override
  State<InfoData> createState() => _InfoDataState();
}

class _InfoDataState extends State<InfoData> {
  final Stream<QuerySnapshot> _infoStream =
      FirebaseFirestore.instance.collection('Information').snapshots();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  progressDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  updateData(context,documentID) async {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      hintText: 'Name',
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 8,),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: 'email',
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 8,),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                      hintText: 'Address',
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 8,),
                ElevatedButton(onPressed: ()async {
                  try {
                    // show the loading indicator
                    progressDialog();


                    // store the image & name to our database
                    firestore.collection('Information').doc(documentID).update(
                      {
                        'name': _nameController.text,
                        'email':_emailController.text,
                        'address':_addressController.text
                      },
                    ).whenComplete(
                          () {
                        // after adding data to the database
                        Fluttertoast.showToast(msg: 'Added Successfully');
                        _nameController.clear();
                        _emailController.clear();
                        _addressController.clear();

                        Navigator.pop(context);

                      },
                    );
                  } catch (e) {
                    // if try block doesn't work
                    print(e);
                    Navigator.pop(context);

                  }
                }, child: Text('Confirm'))
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Info Data'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _infoStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Stack(
                children: [
                  ListTile(
                    title: Text(data['name']),
                    subtitle: Text(data['email']),
                    trailing: Text(data['address']),
                  ),
                  Positioned(
                      right: 0,
                      child: Container(
                        height: 25,
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () =>updateData(context, document.id),
                                icon: Icon(
                                  Icons.edit_note_sharp,
                                  color: Colors.green,
                                  size: 16,
                                )),
                            IconButton(
                                onPressed: () {
                                  firestore
                                      .collection('Information')
                                      .doc(document.id)
                                      .delete()
                                      .then((value) => Fluttertoast.showToast(
                                          msg: 'delete successfully'))
                                      .catchError((error) =>
                                          Fluttertoast.showToast(msg: error));
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 16,
                                )),
                          ],
                        ),
                      ))
                ],
              );
            }).toList(),
          );
        },
      ),
    ));
  }
}
