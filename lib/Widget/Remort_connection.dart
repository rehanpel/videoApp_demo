import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';

class RemortConnection extends StatefulWidget {
  final RTCVideoRenderer render;
  final Connection connection;

  const RemortConnection(
      {Key? key, required this.render, required this.connection})
      : super(key: key);

  @override
  State<RemortConnection> createState() => _RemortConnectionState();
}

class _RemortConnectionState extends State<RemortConnection> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RTCVideoView(
          widget.render,
          mirror: false,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
        ),
        Container(
          decoration: BoxDecoration(
              color: widget.connection.videoEnabled!
                  ? Colors.transparent
                  : Colors.blueGrey[900]),
          child: Center(
            child: Text(
              widget.connection.videoEnabled! ? '' : widget.connection.name!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            color: Colors.black,
            padding: EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.connection.name!,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  widget.connection.audioEnabled! ? Icons.mic : Icons.mic_off,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
