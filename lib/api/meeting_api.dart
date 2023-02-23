import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:video_demo/utils/user.utils.dart';

String MEETING_API_URL = "https://50ff-103-173-20-78.in.ngrok.io/api/meeting";

var client = http.Client();

Future<Response?> startMeeting() async {
  var userId = await loadUserId();

  try {
    var response = await Dio().post(
      "$MEETING_API_URL/start",
      options: Options(headers: {"Content-Type": "application/json"}),
      data: {"hostId": userId, "hostName": "Rehan"},
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      return response;
    }
  } catch (error) {
    print(error);
  }
  return null;
}

Future<Response> joinMeeting(String meetingId) async {
  Map<String, String> requestHeader = {"Content-Type": "application/json"};
  var userId = await loadUserId();

  Response response = await Dio().get(
    "$MEETING_API_URL/join?meetingId=$meetingId",
    options: Options(headers: {"Content-Type": "application/json"}),
  );

  print(response.data);

  if (response.statusCode! >= 200 && response.statusCode! < 400) {
    return response;
  }
  throw UnsupportedError('Not a valid Meeting');
}
