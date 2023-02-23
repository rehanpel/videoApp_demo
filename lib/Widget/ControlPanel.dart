import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class ControlPanel extends StatelessWidget {
  final bool? videoEnable;
  final bool? audioEnable;
  final bool? isConnectionFailed;
  final Function()? onVideoToggle;
  final Function()? onAudioToggle;
  final Function()? onReconnect;
  final Function()? onMeetingEnd;

  const ControlPanel(
      {Key? key,
      this.videoEnable,
      this.audioEnable,
      this.isConnectionFailed,
      this.onVideoToggle,
      this.onAudioToggle,
      this.onReconnect,
      this.onMeetingEnd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.blueGrey[900],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buildControls(),
      ),
    );
  }
  List<Widget> buildControls() {
    if (!isConnectionFailed!) {
      return <Widget>[
        IconButton(
          onPressed: onVideoToggle!,
          icon: Icon(videoEnable! ? Icons.videocam : Icons.videocam_off),
          color: Colors.white,
          iconSize: 32,
        ),
        IconButton(
          onPressed: onAudioToggle!,
          icon: Icon(audioEnable! ? Icons.mic : Icons.mic_off),
          color: Colors.white,
          iconSize: 32,
        ),
        const SizedBox(
          width: 25,
        ),
        Container(
          width: 70,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), color: Colors.red),
          child: IconButton(
            onPressed: onMeetingEnd,
            icon: const Icon(
              Icons.call_end,
              color: Colors.white,
            ),
          ),
        )
      ];
    } else {
      return <Widget>[
        FormHelper.submitButton(
            "Reconnect",
            onReconnect!,
            btnColor: Colors.red,
            borderRadius: 10,
            width: 200,
            height: 40
        ),
      ];
    }
  }

}
