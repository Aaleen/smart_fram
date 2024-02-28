import 'dart:io';

class ESP8266Provider {
  Socket? socket;

  Future<bool> connectToServer(String ip) async {
    try {
      socket = await Socket.connect(ip, 80);
      print(
          'Connected to: ${socket?.remoteAddress.address}:${socket?.remotePort}');
      return true; // Connection successful
    } catch (e) {
      print("Error: $e");
      return false; // Connection failed
    }
  }

  void sendMessage(String message) {
    if (socket != null) {
      print('Sending message: $message');
      socket!.write(message);
      socket!.flush(); // Ensure the message is sent immediately
    } else {
      print('Socket is not connected');
    }
  }

  void dispose() {
    socket?.close();
  }
}
