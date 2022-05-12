import 'dart:convert';
import 'package:http/http.dart' as http;

class EnviarNotifi {
  sendNotifiMethod(dynamic body, String fcm_token) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAwgChUpM:APA91bEruTsfjqSvZKQCcS9gWhqP5Yd_XMhSrkuZ3MUaYsvP-wsfvs4rskxpYmgK2WPbcNREFv1fE465jcu_0__0lgt6mrIjE4dAQyzv1DmXmjvc-iRZPdhqYPfwxKdWibYChEedBqP1'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));

    request.body = json.encode({
      "notification": {"title": "notification", "body": "Asd"},
      "to": "$fcm_token",
      "data": body ?? {}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return {"succes": "true", "response": response};
    } else {
      return {"succes": "false", "response": response};
    }
  }
}
