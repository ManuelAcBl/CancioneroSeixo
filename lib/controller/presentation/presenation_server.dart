import 'dart:convert';
import 'dart:io';

import 'package:cancionero_seixo/controller/presentation/presentation_socket.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_cast_notifier.dart';

class PresentationServer {
  late final ServerSocket serverSocket;

  final List<Socket> clients = [];
  CastData data = CastData(decoration: PresentationCastNotifier.decoration);

  Future<void> start(Function(int displayId) onConnect, Function(int displayId) onDisconnect) async {
    serverSocket = await ServerSocket.bind(PresentationSocket.ip, PresentationSocket.port);

    await for (final client in serverSocket) {
      clients.add(client);

      int id = -1;

      client.listen((data) {
        Map<String, dynamic> json = jsonDecode(utf8.decode(data));

        id = json['displayId'];
        onConnect(id);
      }).onDone(() {
        clients.remove(client);
        onDisconnect(id);
      });

      client.write(jsonEncode(data.toJson()));
    }
  }

  void stop() => serverSocket.close();

  void broadcastSlideData(CastData data) {
    this.data = data;
    //print("broadcast: ${clients.length}");
    for (Socket client in clients) {
      client.write(jsonEncode(data.toJson()));
      //print("Server sent: ${jsonEncode(slideData.toJson())}");
    }
  }
}
