import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kioskplus/screens/login/login.dart';
import 'package:lottie/lottie.dart';

class verification extends StatefulWidget {
  const verification({
    super.key,
  });

  @override
  State<verification> createState() => _verificationState();
}

class _verificationState extends State<verification> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();
    }
  }

  Future sendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      timer = Timer.periodic(Duration(seconds: 3), (timer) {
        checkEmailVerified();
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (FirebaseAuth.instance.currentUser!.emailVerified) {
              return Scaffold(
                body: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 170,
                              child:
                                  Lottie.asset('assets/lottie/congrates.json'),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Congratulations!",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 40),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Your account has been successfully created and now you can use full features of KioskPlus ",
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(7000, 50),
                                backgroundColor:
                                    const Color.fromARGB(255, 66, 103, 178),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Login(),
                                  ),
                                );
                              },
                              child: const Text('Login'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Scaffold(
                body: Center(
                  child: SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 170,
                            child: Lottie.asset(
                                'assets/lottie/email-successfully-sent.json'),
                          ),
                          Text(
                            "Verify your email address",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              "We have sent a verification link to your email address. Please click on the link to verify your email address.",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(150, 40),
                                backgroundColor:
                                    const Color.fromARGB(255, 66, 103, 178),
                              ),
                              onPressed: () {
                                sendVerificationEmail();
                              },
                              child: Text("Resend Email"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          } else {
            return Container(
              child: Text("No User"),
            );
          }
        });
  }
}
