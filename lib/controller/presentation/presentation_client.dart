import 'dart:convert';
import 'dart:io';

import 'package:cancionero_seixo/controller/presentation/presentation_socket.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_cast_notifier.dart';

class CastClient {
  late final Socket socket;

  void start(int displayId, Function(CastData data) onSlideDataReceived) async {
    try {
      socket = await Socket.connect(PresentationSocket.ip, PresentationSocket.port);
    } on SocketException {
      await Future.delayed(const Duration(seconds: 2));
      return start(displayId, onSlideDataReceived);
    }

    socket.write(jsonEncode({"displayId": displayId}));

    socket.listen((data) {
      //print("Client received: ${String.fromCharCodes(data)}");
      onSlideDataReceived(CastData.fromJson(jsonDecode(utf8.decode(data))));

    });
  }

  void stop() => socket.close();
}
