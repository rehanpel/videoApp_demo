import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:video_demo/model/meetingDetails.dart';
import 'package:video_demo/pages/Meeting_Page.dart';

class JoinScreen extends StatefulWidget {
  final MeetingDetails meetingDetails;

  const JoinScreen({Key? key, required this.meetingDetails}) : super(key: key);

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  static String userId = "";

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
              "userId",
              "Enter Your UserName",
              (val) {
                if (val.isEmpty) {
                  return "UserName  Cannot be Empty";
                }
                return null;
              },
              (onSave) {
                userId = onSave;
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
                    "Join",
                    () {
                      if (onValidate()) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MeetingPage(
                              meetingDetail: widget.meetingDetails,
                              meetingId: widget.meetingDetails.id,
                              name: userId,
                            ),
                          ),
                        );
                      }
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
