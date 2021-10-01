import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:showroom_backend/models/media.dart';
import 'package:showroom_backend/models/screen.dart';
import 'package:showroom_backend/views/login/login_screen.dart';
import 'package:showroom_backend/widgets/add_media.dart';
import 'package:showroom_backend/widgets/info_message.dart';

class ScreenMedia extends StatefulWidget {
  final Screen selectedScreen;

  const ScreenMedia({required this.selectedScreen});

  @override
  _ScreenMediaState createState() => _ScreenMediaState();
}

class _ScreenMediaState extends State<ScreenMedia> {
  List<Map<String, MediaObject>> listMedia = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _getMediaList();
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 20,
                                ),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                      "assets/images/screen_monitor.png",
                                      width: 50),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    this.widget.selectedScreen.name,
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ],
                              ),
                              Container()
                            ],
                          )),
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
                              Text("${this.widget.selectedScreen.name} Media",
                                  style: TextStyle(fontSize: 18)),
                              SizedBox(
                                height: 5,
                              ),
                              Text("${this.listMedia.length} Media total",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  AddMedia(
                                    addNewMedia: (link, startTime, endTime) {
                                      Navigator.pop(context);
                                      Database db = database();
                                      DatabaseReference ref = db.ref('media');

                                      ref.push({
                                        "media_link": link,
                                        "end_time": endTime,
                                        "start_time": startTime,
                                        "screen_id":
                                            this.widget.selectedScreen.id
                                      });
                                    },
                                  ).show(context);
                                },
                                child: Icon(Icons.add, color: Colors.black),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.grey[200]!)),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                child: Container(
                                    child: GridView.count(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 1.0,
                                        mainAxisSpacing: 1.0,
                                        children: List.generate(
                                            this.listMedia.length, (index) {
                                          return Center(
                                            child: Container(
                                              width: 250,
                                              height: 250,
                                              color: Colors.grey[200],
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  this
                                                                      .listMedia[
                                                                          index]
                                                                      .values
                                                                      .toList()[
                                                                          0]
                                                                      .mediaLink),
                                                              fit: BoxFit
                                                                  .cover)),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text("Start time"),
                                                            Text(
                                                              this
                                                                  .listMedia[
                                                                      index]
                                                                  .values
                                                                  .toList()[0]
                                                                  .startTime,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(width: 15),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text("End time"),
                                                            Text(
                                                              this
                                                                  .listMedia[
                                                                      index]
                                                                  .values
                                                                  .toList()[0]
                                                                  .endTime,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            AddMedia(
                                                              media: listMedia[
                                                                      index]
                                                                  .values
                                                                  .toList()[0],
                                                              addNewMedia:
                                                                  (link,
                                                                      startTime,
                                                                      endTime) {
                                                                Navigator.pop(
                                                                    context);
                                                                Database db =
                                                                    database();
                                                                DatabaseReference ref = db
                                                                    .ref(
                                                                        'media')
                                                                    .child(listMedia[
                                                                            index]
                                                                        .keys
                                                                        .toList()[0]);
                                                                ref.update({
                                                                  "media_link":
                                                                      link,
                                                                  "end_time":
                                                                       endTime,
                                                                  "start_time":
                                                                      startTime
                                                                });
                                                                InfoMessage(
                                                                        message:
                                                                            "Données mis à jour")
                                                                    .show(
                                                                        context);
                                                              },
                                                            ).show(context);
                                                          },
                                                          child: Icon(
                                                              Icons
                                                                  .edit_outlined,
                                                              color:
                                                                  Colors.black),
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty.all<
                                                                      Color>(Colors
                                                                          .grey[
                                                                      200]!)),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Database db =
                                                                database();
                                                            DatabaseReference ref = db
                                                                .ref('media')
                                                                .child(listMedia[
                                                                        index]
                                                                    .keys
                                                                    .toList()[0]);
                                                            ref.remove();
                                                          },
                                                          child: Icon(
                                                              Icons.delete,
                                                              color:
                                                                  Colors.black),
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty.all<
                                                                      Color>(Colors
                                                                          .grey[
                                                                      200]!)),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }))),
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

  _getMediaList() {
    Database db = database();
    DatabaseReference ref = db.ref('media');

    ref.onValue.listen((event) {
      this.listMedia.clear();
      event.snapshot.forEach((item) {
        var media = MediaObject.fromJson(item.val());
        if (media.screenId == this.widget.selectedScreen.id) {
          this.listMedia.add({item.key: media});
        }
      });
      setState(() {});
    });
  }
}
