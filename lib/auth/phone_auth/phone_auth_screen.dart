import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/home_screen.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PhoneAuth extends StatefulWidget {
  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {

  TextEditingController _phoneController = TextEditingController();

  String countryCode = '+1';

  Future phoneAuth(String phoneNumber, context) async {
    final TextEditingController _otpController = TextEditingController();
    FirebaseAuth auth = FirebaseAuth.instance;
    if (kIsWeb) {
      try {
        ConfirmationResult confirmationResult =
        await auth.signInWithPhoneNumber(phoneNumber);
        showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                child: SafeArea(
                  child: Container(
                    height: 400,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PinCodeTextField(
                          length: 6,
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          textStyle:  TextStyle(
                            color: Color(0xFF2E2C2C),
                            fontSize: 14,

                            fontWeight: FontWeight.w400,
                          ),
                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              disabledColor: Colors.blue,
                              fieldHeight: 56,
                              fieldWidth: 44,
                              activeColor: Color(0xFFCCCCCC),
                              inactiveColor:  Color(0xFFCCCCCC),
                              activeFillColor:  Color(0xFFCCCCCC),
                              inactiveFillColor:  Color(0xFFCCCCCC),
                              selectedFillColor:  Color(0xFFCCCCCC),
                              selectedColor: Color(0xFFCCCCCC)),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: false,
                          onCompleted: (v) {},
                          onChanged: (value) {},
                          beforeTextPaste: (text) {
                            return true;
                          },
                          appContext: context,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              UserCredential userCredential =
                              await confirmationResult.confirm(
                                _otpController.text,
                              );
                              if (userCredential.user != null) {
                                print('Success');

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => HomeScreen()));
                              } else {
                                print('Failed');
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              print('Failed! Try Again.');
                              Navigator.pop(context);
                            }
                          },
                          child: Text('continue'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      } catch (e) {
        print('Something is wrong');
      }
    }
    else {
      try {
        await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            var result = await auth.signInWithCredential(credential);
            User? user = result.user;
            if (user!.uid.isNotEmpty) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => HomeScreen()));
            }
          },
          verificationFailed: (FirebaseAuthException e) async {
            if (e.code == 'invalid-phone-number') {
              print("The provided phone number is not valid.");
            }
          },
          codeSent: (String verificationId, int? resendToken) async {
            return showDialog(
                context: context,
                builder: (_) {
                  return Dialog(
                    child: SafeArea(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          height: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PinCodeTextField(
                                length: 6,
                                obscureText: false,
                                keyboardType: TextInputType.number,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                textStyle:  TextStyle(
                                  color: Color(0xFF2E2C2C),
                                  fontSize: 14,

                                  fontWeight: FontWeight.w400,
                                ),
                                pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(5),
                                    disabledColor: Colors.blue,
                                    fieldHeight: 56,
                                    fieldWidth: 44,
                                    activeColor: Color(0xFFCCCCCC),
                                    inactiveColor:  Color(0xFFCCCCCC),
                                    activeFillColor:  Color(0xFFCCCCCC),
                                    inactiveFillColor:  Color(0xFFCCCCCC),
                                    selectedFillColor:  Color(0xFFCCCCCC),
                                    selectedColor: Color(0xFFCCCCCC)),
                                backgroundColor: Colors.transparent,
                                enableActiveFill: false,
                                onCompleted: (v) {},
                                onChanged: (value) {},
                                beforeTextPaste: (text) {
                                  return true;
                                },
                                appContext: context,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    PhoneAuthCredential _phoneCredential =
                                    PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: _otpController.text,
                                    );
                                    var result = await FirebaseAuth.instance
                                        .signInWithCredential(_phoneCredential);
                                    User? user = result.user;
                                    if (user != null) {
                                      print("Success");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  HomeScreen()));
                                    } else {
                                      print("Failed");
                                      Navigator.pop(context);
                                    }
                                  } catch (e) {
                                    print("Failed! Try Again.");
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text('Verify'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          },
          codeAutoRetrievalTimeout: (String verificationId) async {},
          timeout: Duration(seconds: 60),
        );
      } catch (e) {
        print('Something is wrong');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 60,
            left: 25,
            right: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Authentication with phone number!',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'enter your phone number, we will send you an otp to complete the verification process.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [


                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: 'phone number',
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.transparent,
              ),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () {
                    var number = countryCode + _phoneController.text.trim();
                    print(number);
                    phoneAuth(number, context);
                  },
                  child: Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}