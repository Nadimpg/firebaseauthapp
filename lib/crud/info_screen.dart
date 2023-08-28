import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_app/crud/info_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  final storage=FirebaseStorage.instance;

  ProgressDialogue(){
    showDialog(
        context:context ,
        builder: (context){
          return CircularProgressIndicator();
        });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text('Information '),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>InfoData()));
          }, icon: Icon(Icons.forward))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProgressDialogue(),
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
            ElevatedButton(onPressed: () {
              try {
                ProgressDialogue();
                firestore.collection('Information').add(
                  {
                    'name': _nameController.text,
                    'email':_emailController.text,
                    'address':_addressController.text
                  },
                ).whenComplete(
                      () {
                    Fluttertoast.showToast(msg: 'Added Successfully');
                    _nameController.clear();
                    _emailController.clear();
                    _addressController.clear();

                    Navigator.push(context, MaterialPageRoute(builder: (_)=>InfoData()));
                  },
                );
              } catch (e) {
                print(e);
                Navigator.push(context, MaterialPageRoute(builder: (_)=>InfoData()));

              }
            }, child: Text('Confirm'))
          ],
        ),
      ),
    ));
  }
}
