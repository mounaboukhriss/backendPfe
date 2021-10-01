import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showroom_backend/models/admin.dart';
import 'package:showroom_backend/models/screen.dart';
import 'package:showroom_backend/models/user.dart';
import 'package:showroom_backend/utils/constants.dart';
import 'package:showroom_backend/views/login/login_screen.dart';
import 'package:showroom_backend/views/screen/screen_media.dart';
import 'package:showroom_backend/widgets/add_screen.dart';
import 'package:showroom_backend/widgets/add_user.dart';
import 'package:showroom_backend/widgets/app_textfield.dart';
import 'package:showroom_backend/widgets/info_message.dart';
import 'package:showroom_backend/widgets/tab_menu_button.dart';

class DashbaordScreen extends StatefulWidget {
  Admin connectedUser;
  final String userKey;

  DashbaordScreen(
      {required this.connectedUser, required this.userKey, Key? key})
      : super(key: key);

  @override
  _DashbaordScreenState createState() => _DashbaordScreenState();
}

class _DashbaordScreenState extends State<DashbaordScreen> {
  bool switcherValue = false;
  String pageTitle = "Screen List";
  DISPLAYED_SECTION displayedSection = DISPLAYED_SECTION.SCREENS;

  List<Map<String, Screen>> screens = [];
  List<Map<String, UserData>> users = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _getScreensData();
      _getUsersData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white.withOpacity(0),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 350,
                        width: 120,
                        decoration: BoxDecoration(
                            color: Colors.blue[300],
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Image.asset("assets/images/app_logo.png",
                                width: 120),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return LoginScreen();
                                    },
                                  ));
                                },
                                child: Text(
                                  "Logout",
                                  style: TextStyle(fontSize: 12),
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blue[400]!)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 10,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.grey[100],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    this.displayedSection =
                                        DISPLAYED_SECTION.SCREENS;
                                  });
                                },
                                child: TabMenuButton(title: "Screens")),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    this.displayedSection =
                                        DISPLAYED_SECTION.USERS;
                                  });
                                },
                                child: TabMenuButton(title: "Users")),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    this.displayedSection =
                                        DISPLAYED_SECTION.ADMIN;
                                  });
                                },
                                child: TabMenuButton(title: "Admin")),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Container(
                        color: Colors.white.withOpacity(0),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_getPageTitle(),
                                  style: TextStyle(fontSize: 18)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(_getPageSmallTitle(),
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible: this.displayedSection !=
                                    DISPLAYED_SECTION.ADMIN,
                                child: ElevatedButton(
                                    onPressed: onAddButtonPressed,
                                    child: Icon(Icons.add, color: Colors.black),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.grey[200]!))),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                child: _getDisplayedContent(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  onAddButtonPressed() {
    if (this.displayedSection == DISPLAYED_SECTION.SCREENS) {
      AddScreen(
        addNewScreen: (name, startDate, endDate) {
          Navigator.pop(context);
          Database db = database();
          DatabaseReference ref = db.ref('screens');

          ref.push({
            "name": name,
            "start_time": startDate,
            "end_time": endDate,
            "id": _getMaxID() + 1,
            "enabled": true
          });
        },
      ).show(context);
    } else {
      AddUser(
        addNewUser: _addNewUser,
      ).show(context);
    }
  }

  _addNewUser(firstName, lastName, login, password, age) {
    Navigator.pop(context);
    Database db = database();
    DatabaseReference ref = db.ref('users');

    ref.push({
      "name": firstName,
      "lastname": lastName,
      "login": login,
      "password": password,
      "age": age
    });
  }

  int _getMaxID() {
    var id = 0;
    for (var screen in screens) {
      if (id < screen.values.toList()[0].id) {
        id = screen.values.toList()[0].id;
      }
    }
    return id;
  }

  String _getPageTitle() {
    switch (this.displayedSection) {
      case DISPLAYED_SECTION.ADMIN:
        return "Admin";
      case DISPLAYED_SECTION.USERS:
        return "List Users";
      default:
        return "List Screens";
    }
  }

  String _getPageSmallTitle() {
    switch (this.displayedSection) {
      case DISPLAYED_SECTION.ADMIN:
        return "Compte admin";
      case DISPLAYED_SECTION.USERS:
        return "${this.users.length} Utilisateurs en total";
      default:
        return "${this.screens.length} Screens en total";
    }
  }

  Widget _getDisplayedContent() {
    switch (this.displayedSection) {
      case DISPLAYED_SECTION.ADMIN:
        return _renderAdminSection();
      case DISPLAYED_SECTION.USERS:
        return _renderListUsers();
      default:
        return _renderListScreens();
    }
  }

  ListView _renderListUsers() {
    return ListView.builder(
      itemCount: this.users.length,
      itemBuilder: (context, index) {
        return _renderUserItem(index);
      },
    );
  }

  ListView _renderListScreens() {
    return ListView.builder(
      itemCount: this.screens.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ScreenMedia(
                selectedScreen: screens[index].values.toList()[0],
              );
            }));
          },
          child: _renderScreenItemElement(index),
        );
      },
    );
  }

  Widget _renderAdminSection() {
    print(this.widget.connectedUser);
    var emailTextController =
        TextEditingController(text: this.widget.connectedUser.email);
    var loginTextController =
        TextEditingController(text: this.widget.connectedUser.username);
    var passwordTextController =
        TextEditingController(text: this.widget.connectedUser.password);

    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle,
            size: 40,
          ),
          SizedBox(
            height: 10,
          ),
          Text("Information du compte admin", style: TextStyle(fontSize: 20)),
          SizedBox(
            height: 60,
          ),
          AppTextField(
              placeholder: "Email",
              controller: emailTextController,
              colorTheme: Colors.blue),
          SizedBox(
            height: 15,
          ),
          AppTextField(
              placeholder: "Login",
              controller: loginTextController,
              colorTheme: Colors.blue),
          SizedBox(
            height: 15,
          ),
          AppTextField(
            placeholder: "Mot de passe",
            controller: passwordTextController,
            colorTheme: Colors.blue,
          ),
          SizedBox(
            height: 60,
          ),
          Container(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    Database db = database();
                    DatabaseReference ref =
                        db.ref('admin_users').child(this.widget.userKey);
                    ref.update({
                      "email": emailTextController.text,
                      "password": passwordTextController.text,
                      "login": loginTextController.text
                    });
                    InfoMessage(message: "Données mis à jour").show(context);
                    this.widget.connectedUser = Admin.fromJson({
                      "email": emailTextController.text,
                      "password": passwordTextController.text,
                      "login": loginTextController.text
                    });
                  },
                  child: Text("Enregistrer")))
        ],
      ),
    );
  }

  _renderUserItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[100],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset("assets/images/screen_monitor.png", width: 20),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        "${users[index].values.toList()[0].name} ${users[index].values.toList()[0].lastname}"),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        AddUser(
                          addNewUser: (name, lastName, login, password, age) {
                            Navigator.pop(context);
                            Database db = database();
                            DatabaseReference ref = db
                                .ref('users')
                                .child(users[index].keys.toList()[0]);
                            ref.update({
                              "name": name,
                              "lastname": lastName,
                              "login": login,
                              "password": password,
                              "age": age
                            });
                            InfoMessage(message: "Données mis à jour")
                                .show(context);
                          },
                          user: users[index].values.toList()[0],
                        ).show(context);
                      },
                      child: Icon(Icons.edit, color: Colors.black),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey[200]!)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _deleteUserItem(users[index].keys.toList()[0]);
                      },
                      child: Icon(Icons.delete, color: Colors.black),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey[200]!)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _renderScreenItemElement(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[100],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset("assets/images/screen_monitor.png", width: 20),
                    SizedBox(
                      width: 10,
                    ),
                    Text(screens[index].values.toList()[0].name),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(screens[index].values.toList()[0].startTime),
                    SizedBox(
                      width: 20,
                    ),
                    Text(screens[index].values.toList()[0].endTime),
                    SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        AddScreen(
                          addNewScreen: (name, startDate, endDate) {
                            Navigator.pop(context);
                            Database db = database();
                            DatabaseReference ref = db
                                .ref('screens')
                                .child(screens[index].keys.toList()[0]);
                            ref.update({
                              "name": name,
                              "start_time": startDate,
                              "end_time": endDate,
                              "enabled":
                                  screens[index].values.toList()[0].enabled
                            });
                            InfoMessage(message: "Données mis à jour")
                                .show(context);
                          },
                          screen: screens[index].values.toList()[0],
                        ).show(context);
                      },
                      child: Icon(Icons.edit, color: Colors.black),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey[200]!)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _deleteScreenItem(screens[index].keys.toList()[0]);
                      },
                      child: Icon(Icons.delete, color: Colors.black),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey[200]!)),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: [
                        Text("Off"),
                        Switch(
                            value: screens[index].values.toList()[0].enabled,
                            onChanged: (value) {
                              Database db = database();
                              DatabaseReference ref = db
                                  .ref('screens')
                                  .child(screens[index].keys.toList()[0]);
                              ref.update({
                                "name": screens[index].values.toList()[0].name,
                                "start_time":
                                    screens[index].values.toList()[0].startTime,
                                "end_time":
                                    screens[index].values.toList()[0].endTime,
                                "enabled": value
                              });
                              InfoMessage(message: "Données mis à jour")
                                  .show(context);
                            }),
                        Text("On"),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _deleteScreenItem(String screenKey) {
    Database db = database();
    DatabaseReference ref = db.ref('screens').child(screenKey);
    ref.remove();
    InfoMessage(message: "Element supprimé").show(context);
  }

  _deleteUserItem(String userKey) {
    Database db = database();
    DatabaseReference ref = db.ref('users').child(userKey);
    ref.remove();
    InfoMessage(message: "Element supprimé").show(context);
  }

  _getScreensData() async {
    Database db = database();
    DatabaseReference ref = db.ref('screens');

    ref.onValue.listen((event) {
      screens.clear();
      event.snapshot.forEach((item) {
        screens.add({item.key: Screen.fromJson(item.val())});
      });
      setState(() {});
    });
  }

  _getUsersData() async {
    Database db = database();
    DatabaseReference ref = db.ref('users');

    ref.onValue.listen((event) {
      users.clear();
      event.snapshot.forEach((item) {
        users.add({item.key: UserData.fromJson(item.val())});
      });
      setState(() {});
    });
  }
}
