import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('dart:io HttpClient preserves Authorization header case', () async {
    final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    String? rawHead;
    server.listen((socket) {
      final chunks = <int>[];
      socket.listen((data) {
        chunks.addAll(data);
        final text = latin1.decode(chunks);
        if (text.contains('\r\n\r\n') && rawHead == null) {
          rawHead = text.substring(0, text.indexOf('\r\n\r\n'));
          socket.write('HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK');
          socket.close();
        }
      });
    });

    final client = HttpClient();
    final req = await client.getUrl(Uri.parse('http://127.0.0.1:${server.port}/'));
    req.headers.add('Authorization', 'Basic abc123', preserveHeaderCase: true);
    final resp = await req.close();
    await resp.drain();
    client.close();
    await server.close();

    expect(rawHead, isNotNull);
    expect(rawHead, contains('Authorization:'));
    expect(rawHead, isNot(contains('authorization:')));
  });
}
