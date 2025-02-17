import 'dart:convert';

import 'package:calendar_dashboard/network/mqtt_func.dart';
import 'package:http/http.dart' as http;

class NetworkCalls {
  //postrelative

  Future<String> postRelative(var body) async {
    String returnString = '';

    try {
      var url = Uri.parse('https://bsdjudaica.com/postRelative.php');

      http.Response res = await http.post(url, body: jsonEncode(body));

      if (res.statusCode >= 200 && res.statusCode < 300) {
        returnString = res.body;
      } else {
        returnString = "Error: ${res.reasonPhrase.toString()}";
      }
    } on Exception catch (e) {
      print(e);
    }
    return returnString;
  }

  //postPlaque

  Future<String> postPlaque(var body) async {
    String returnString = '';

    // try {
    print('in postPlaque');
    var url = Uri.parse('https://bsdjudaica.com/postPlaque.php');
    print('after uri');
    http.Response res = await http.post(url, body: jsonEncode(body));
    print(res);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      returnString = res.body;
      MQTTClientWrapper newclient = MQTTClientWrapper();
    } else {
      returnString = "Error: ${res.reasonPhrase.toString()}";
    }
    // } on Exception catch (e) {
    // print(e);
    // }
    return returnString;
  }

  Future<String> getPlaque() async {
    String returnString = '';

    try {
      var url = Uri.parse('https://bsdjudaica.com/postPlaque.php');

      http.Response res = await http.get(url);
      print(res.statusCode);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        returnString = res.body;
        print(res.body);
      } else {
        print(res.body);
        print(res.reasonPhrase);
        returnString = "Error: ${res.reasonPhrase.toString()}";
      }
    } on Exception catch (e) {
      print(e);
    }
    return returnString;
  }

  Future<String> getMessage() async {
    String returnString = '';
    try {
      var url = Uri.parse('https://bsdjudaica.com/messageapi.php');
      print('here reached');

      var req = http.Request('GET', url);

      var res = await req.send();

      final resBody = await res.stream.bytesToString();
      print(resBody);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        print('success');

        print(resBody);
        returnString = resBody;
      } else {
        print('error');
        returnString = 'Error: ${res.reasonPhrase}';

        print(res.reasonPhrase);
      }
    } on Exception catch (e) {
      print('Exception ::: $e');
      print(e);
    }
    // try {
    //   var url = Uri.parse('http://colibridatalogger.com/plaque/messageapi.php');

    //   http.Response res = await http.get(url);

    //   if (res.statusCode >= 200 && res.statusCode < 300) {
    //     returnString = res.body;
    //   } else {
    //     returnString = "Error: ${res.reasonPhrase.toString()}";
    //   }
    // } on Exception catch (e) {
    //   print(e);
    // }
    return returnString;
  }

  //////
  ///
  ///
  Future<String> getAvailableLeds() async {
    String returnString = '';
    try {
      var url = Uri.parse('https://bsdjudaica.com/getavailable_leds.php');
      print('here reached');

      var req = http.Request('GET', url);

      var res = await req.send();

      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print('success');

        print(resBody);
        returnString = resBody;
      } else {
        print('error');
        returnString = 'Error: ${res.reasonPhrase}';

        print(res.reasonPhrase);
      }
    } on Exception catch (e) {
      print('Exception ::: $e');
      print(e);
    }
    // try {
    //   var url = Uri.parse('http://colibridatalogger.com/plaque/messageapi.php');

    //   http.Response res = await http.get(url);

    //   if (res.statusCode >= 200 && res.statusCode < 300) {
    //     returnString = res.body;
    //   } else {
    //     returnString = "Error: ${res.reasonPhrase.toString()}";
    //   }
    // } on Exception catch (e) {
    //   print(e);
    // }
    return returnString;
  }

  Future<String> getAllLeds() async {
    String returnString = '';
    try {
      var url = Uri.parse('https://bsdjudaica.com/getall_leds.php');
      print('here reached');

      var req = http.Request('GET', url);

      var res = await req.send();

      final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print('success');

        print(resBody);
        returnString = resBody;
      } else {
        print('error');
        returnString = 'Error: ${res.reasonPhrase}';

        print(res.reasonPhrase);
      }
    } on Exception catch (e) {
      print('Exception ::: $e');
      print(e);
    }
    // try {
    //   var url = Uri.parse('http://colibridatalogger.com/plaque/messageapi.php');

    //   http.Response res = await http.get(url);

    //   if (res.statusCode >= 200 && res.statusCode < 300) {
    //     returnString = res.body;
    //   } else {
    //     returnString = "Error: ${res.reasonPhrase.toString()}";
    //   }
    // } on Exception catch (e) {
    //   print(e);
    // }
    return returnString;
  }

  ///
  ///
  ///
  ///////

  Future<String> postMessage(var body) async {
    String returnString = '';

    // try {
    print('in postPlaque');
    var url = Uri.parse('https://bsdjudaica.com/messageapi.php');
    print('after uri');
    http.Response res = await http.post(url, body: jsonEncode(body));
    print(res);
    print(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      returnString = res.body;
    } else {
      returnString = "Error: ${res.reasonPhrase.toString()}";
    }
    // } on Exception catch (e) {
    // print(e);
    // }
    return returnString;
  }

  Future<String> deletePlaque(String id) async {
    String returnString = '';

    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'POST', Uri.parse('https://bsdjudaica.com/deletePlaque.php'));
    request.body = json.encode({"id": id});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String resBody = await response.stream.bytesToString();
      returnString = resBody;
    } else {
      print(response.reasonPhrase);
      returnString = "Error: ${response.reasonPhrase.toString()}";
    }
    return returnString;
  }

  Future<String> deleteRelative(String id) async {
    String returnString = '';

    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'POST', Uri.parse('https://bsdjudaica.com/deleteRelative.php'));
    request.body = json.encode({"id": id});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String resBody = await response.stream.bytesToString();
      returnString = resBody;
    } else {
      print(response.reasonPhrase);
      returnString = "Error: ${response.reasonPhrase.toString()}";
    }
    return returnString;
  }

  Future<String> postLed(var body) async {
    String returnString = '';

    // try {
    print('in post led');
    var url = Uri.parse('https://bsdjudaica.com/postleds.php');
    http.Response res = await http.post(url,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    print(res);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      returnString = res.body;
    } else {
      returnString = "Error: ${res.reasonPhrase.toString()}";
    }
    // } on Exception catch (e) {
    // print(e);
    // }
    return returnString;
  }

  Future<String> getWebsites() async {
    String returnString = '';

    try {
      var url = Uri.parse('https://bsdjudaica.com/links.php');

      http.Response res = await http.get(url);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        returnString = res.body;
      } else {
        returnString = "Error: ${res.reasonPhrase.toString()}";
      }
    } on Exception catch (e) {
      print(e);
    }
    return returnString;
  }

  Future<String> saveWebsites(var body) async {
    String returnString = '';

    // try {
    print('in post led');
    var url = Uri.parse('https://bsdjudaica.com/links.php');
    http.Response res = await http.post(url,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    print(res);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      returnString = res.body;
    } else {
      returnString = "Error: ${res.reasonPhrase.toString()}";
    }

    return returnString;
  }

  Future<String> saveCredetials(var body) async {
    String returnString = '';

    // try {
    print('in post led');
    var url = Uri.parse('https://bsdjudaica.com/mqtt.php');
    http.Response res = await http.post(url,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    print(res);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      returnString = res.body;
    } else {
      returnString = "Error: ${res.reasonPhrase.toString()}";
    }

    return returnString;
  }

  Future<String> getCredentials() async {
    String returnString = '';

    try {
      var url = Uri.parse('https://bsdjudaica.com/mqtt.php');

      http.Response res = await http.get(url);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        returnString = res.body;
      } else {
        returnString = "Error: ${res.reasonPhrase.toString()}";
      }
    } on Exception catch (e) {
      print(e);
    }
    return returnString;
  }

  Future<String> testLed(var body) async {
    String returnString = '';

    // try {
    print('in test led');
    var url = Uri.parse('https://bsdjudaica.com/testled.php');
    http.Response res = await http.post(url,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json', 'Accept': '*/*'});
    print(res);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      returnString = res.body;
    } else {
      returnString = "Error: ${res.reasonPhrase.toString()}";
    }
    // } on Exception catch (e) {
    // print(e);
    // }
//     var headersList = {
//       'Accept': '*/*',
//       'Content-Type': 'application/json',
//       'Access-Control-Allow-Origin': '*'
//     };
//     var url = Uri.parse('http://colibridatalogger.com/plaque/testled.php');

// // var body = {"led_number":"N1-14"};

//     var req = http.Request('POST', url);
//     req.headers.addAll(headersList);
//     req.body = json.encode(body);

//     var res = await req.send();
//     final resBody = await res.stream.bytesToString();

//     if (res.statusCode >= 200 && res.statusCode < 300) {
//       print(resBody);
//       returnString = resBody;
//     } else {
//       print(res.reasonPhrase);
//       returnString = "Error: ${res.reasonPhrase.toString()}";
//     }
    return returnString;
  }
}
