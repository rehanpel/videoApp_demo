import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_demo/Widget/ControlPanel.dart';
import 'package:video_demo/Widget/Remort_connection.dart';
import 'package:video_demo/model/meetingDetails.dart';
import 'package:video_demo/pages/home_screen.dart';
import 'package:video_demo/utils/user.utils.dart';

class MeetingPage extends StatefulWidget {
  final String? meetingId;
  final String? name;
  final MeetingDetails meetingDetail;

  const MeetingPage(
      {Key? key, this.meetingId, this.name, required this.meetingDetail})
      : super(key: key);

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final _localRenderer = RTCVideoRenderer();

  final Map<String, dynamic> mediaConstraints = {"audio": true, "video": true};

  bool isConnectionFailed = false;
  WebRTCMeetingHelper? webRTCMeetingHelper;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: _buildMeetingRoom(),
      bottomNavigationBar: ControlPanel(
        onAudioToggle: isAudioEnable,
        onVideoToggle: isVideoEnable,
        videoEnable: onVideoToggle(),
        audioEnable: onAudioToggle(),
        isConnectionFailed: isConnectionFailed,
        onMeetingEnd: onMeetingEnd,
        onReconnect: onReconnect,
      ),
    );
  }

  startMeeting() async {
    final String userId = await loadUserId();
    webRTCMeetingHelper = WebRTCMeetingHelper(
      url: "https://50ff-103-173-20-78.in.ngrok.io",
      name: widget.name,
      userId: userId,
      meetingId: widget.meetingDetail.id,
    );
    MediaStream localstream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = localstream;
    webRTCMeetingHelper!.stream = localstream;
    setState(() {});

    webRTCMeetingHelper!.on('open', null, (ev, context) {
      print("OPen=========>");
      setState(() {
        isConnectionFailed = false;
      });
    });

    webRTCMeetingHelper!.on('connection', null, (ev, context) {
      print("connection=========>");
      setState(() {
        isConnectionFailed = false;
      });
    });

    webRTCMeetingHelper!.on('user-left', null, (ev, ctx) {
      print("user-left=========>");
      setState(() {
        isConnectionFailed = false;
      });
    });

    webRTCMeetingHelper!.on('video-toggle', null, (ev, ctx) {
      print("video-toggle=========>");
      setState(() {});
    });

    webRTCMeetingHelper!.on('audio-toggle', null, (ev, ctx) {
      print("audio-toggle=========>");
      setState(() {});
    });

    webRTCMeetingHelper!.on('meeting-ended', null, (ev, ctx) {
      print("meeting-ended=========>");
      onMeetingEnd();
      setState(() {});
    });

    webRTCMeetingHelper!.on('connection-setting-changed', null, (ev, ctx) {
      print("connection-setting-changed=========>");
      setState(() {
        isConnectionFailed = false;
      });
    });

    webRTCMeetingHelper!.on('stream-changed', null, (ev, ctx) {
      print("stream-changed=========>");
      setState(() {});
    });
  }

  initRender() async {
    await _localRenderer.initialize();
  }

  @override
  void initState() {
    super.initState();
    initRender();
    startMeeting();
    initPermission();
  }

  @override
  void deactivate() {
    super.deactivate();
    _localRenderer.dispose();
    if (webRTCMeetingHelper != null) {
      webRTCMeetingHelper!.destroy();
      webRTCMeetingHelper = null;
    }
  }

  void onMeetingEnd() {
    if (webRTCMeetingHelper != null) {
      setState(() {
        webRTCMeetingHelper!.endMeeting();
        webRTCMeetingHelper = null;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  bool onAudioToggle() {
    return webRTCMeetingHelper != null
        ? webRTCMeetingHelper!.audioEnabled!
        : false;
  }

  bool onVideoToggle() {
    return webRTCMeetingHelper != null
        ? webRTCMeetingHelper!.videoEnabled!
        : false;
  }

  isVideoEnable() {
    if (webRTCMeetingHelper != null) {
      setState(() {
        webRTCMeetingHelper!.toggleVideo();
      });
    }
  }

  isAudioEnable() {
    if (webRTCMeetingHelper != null) {
      setState(() {
        webRTCMeetingHelper!.toggleAudio();
      });
    }
  }

  onReconnect() {
    if (webRTCMeetingHelper != null) {
      setState(() {
        webRTCMeetingHelper!.reconnect();
      });
    }
  }

  _buildMeetingRoom() {
    return Stack(
      children: [
        webRTCMeetingHelper != null &&
                webRTCMeetingHelper!.connections.isNotEmpty
            ?
            GridView.count(
                    crossAxisCount:
                        webRTCMeetingHelper!.connections.length < 3 ? 1 : 2,
                    children: List.generate(
                      webRTCMeetingHelper!.connections.length,
                      (index) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: RemortConnection(
                            render:
                                webRTCMeetingHelper!.connections[index].renderer,
                            connection: webRTCMeetingHelper!.connections[index],
                          ),
                        );
                      },
                    ),
                  )
            // const Center(
            //     child: Padding(
            //       padding: EdgeInsets.all(8.0),
            //       child: Text(
            //         "Participant Joined ",
            //         textAlign: TextAlign.center,
            //         style: TextStyle(color: Colors.grey, fontSize: 24),
            //       ),
            //     ),
            //   )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Waiting For Participates",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 24),
                  ),
                ),
              ),
        Positioned(
          right: 0,
          bottom: 10,
          child: SizedBox(
            height: 200,
            width: 150,
            child: RTCVideoView(
              _localRenderer,
            ),
          ),
        ),
      ],
    );
  }

  void initPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.audio,
      Permission.videos,
    ].request();
  }
}
