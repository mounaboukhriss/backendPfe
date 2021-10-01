import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:showroom_backend/models/admin.dart';
import 'package:showroom_backend/models/user.dart';
import 'package:showroom_backend/utils/constants.dart';
import 'package:showroom_backend/views/dashboard/dashboard_screen.dart';
import 'package:showroom_backend/views/login/login_controller.dart';
import 'package:showroom_backend/views/register/register_screen.dart';
import 'package:showroom_backend/widgets/app_button.dart';
import 'package:showroom_backend/widgets/app_loading.dart';
import 'package:showroom_backend/widgets/app_textfield.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:showroom_backend/widgets/info_message.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginController loginController;
  late StreamSubscription<QueryEvent> _readUserData;

  @override
  void initState() {
    super.initState();
    loginController = LoginController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/blur_background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 500,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0x22000000)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 30, top: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/app_logo.png", width: 150),
                          Text("Showroom",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: FONT_POPPINS_MEDIUM,
                                  fontSize: 25)),
                          const SizedBox(
                            height: 30,
                          ),
                          Text("Authentification",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: FONT_POPPINS_MEDIUM,
                                  fontSize: 15)),
                          SizedBox(
                            height: 50,
                          ),
                          AppTextField(
                            placeholder: "Username",
                            controller: this.loginController.usernameController,
                            colorTheme: Colors.white,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          AppTextField.password(
                            placeholder: "Mot de passe",
                            controller: this.loginController.passwordController,
                            colorTheme: Colors.white,
                            onSubmit: () {
                              loginUser(context);
                            },
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          AppButton(
                            buttonText: "S'authentifier",
                            onClickHandler: () {
                              loginUser(context);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return RegisterScreen();
                              }));
                            },
                            child: Text("Register",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: FONT_POPPINS_LIGHT,
                                    fontSize: 15)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  loginUser(BuildContext appContext) {
    bool inputVerification = loginController.verifInputField();
    if (inputVerification) {
      Database db = database();
      DatabaseReference ref = db.ref('admin_users');
      var userValid = false;
      _readUserData = ref.onValue.listen((event) {
        event.snapshot.forEach((item) {
          var user = Admin.fromJson(item.val());
          if (user.password == loginController.passwordController.text &&
              user.username == loginController.usernameController.text) {
            userValid = true;
            _readUserData.cancel();
            Navigator.pushReplacement(appContext, MaterialPageRoute(
              builder: (context) {
                return DashbaordScreen(
                  connectedUser: user,
                  userKey: item.key,
                );
              },
            ));
          }
        });

        if (!userValid) {
          MotionToast.error(
            description: "Veuillez verifier vos coordonnées",
            width: 300,
          ).show(appContext);
        }
      });
    } else {
      MotionToast.error(
        description: "Veuillez verifier vos coordonnées",
        width: 300,
      ).show(appContext);
    }
  }
}
