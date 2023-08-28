import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_app/crud/info_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  final storage=FirebaseStorage.instance;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                      progressDialogue();
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
      ),
    );
  }

  progressDialogue(){
    showDialog(
        context:context ,
        builder: (context){
          return const SizedBox(
            height: 30, width: 30,
            child: Center(
                child: CircularProgressIndicator()
            ),
          );
        });
  }
}
