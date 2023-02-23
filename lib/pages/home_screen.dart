import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:video_demo/api/meeting_api.dart';
import 'package:video_demo/model/meetingDetails.dart';
import 'package:video_demo/pages/join_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  static String meetingId = "";

  formUi() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Webrtc Demo",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FormHelper.inputFieldWidget(
              context,
              "meetingId",
              "Enter Meeting Id",
              (val) {
                if (val.isEmpty) {
                  return "Meeting id Cannot be Null";
                }
                return null;
              },
              (onSave) {
                meetingId = onSave;
              },
              borderRadius: 10,
              borderFocusColor: Colors.redAccent,
              borderColor: Colors.redAccent,
              hintColor: Colors.grey,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: FormHelper.submitButton(
                    "Join Meeting",
                    () {
                      if (onValidate()) {
                        validateMeeting(meetingId);
                      }
                    },
                  ),
                ),
                Flexible(
                  child: FormHelper.submitButton(
                    "Start Meeting",
                    () async {
                      var respose = await startMeeting();
                      final body = respose!.data;
                      print(body);
                      final meetingId = body['data'];
                      validateMeeting(meetingId);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void validateMeeting(String meetingId) async {
    try {
      Response? res = await joinMeeting(meetingId);
      final body = res.data;
      final meetingDetails = MeetingDetails.fromJson(body['data']);
      goToJoinScreen(meetingDetails);
    } catch (error) {
      FormHelper.showSimpleAlertDialog(
        context,
        "Meeting App",
        "Invalid Meeting Id",
        "ok",
        () {
          Navigator.pop(context);
        },
      );
    }
  }

  goToJoinScreen(MeetingDetails meetingDetails) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return JoinScreen(
            meetingDetails: meetingDetails,
          );
        },
      ),
    );
  }

  bool onValidate() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meeting App Demo"),
        backgroundColor: Colors.redAccent,
      ),
      body: Form(
        child: formUi(),
        key: globalKey,
      ),
    );
  }
}
