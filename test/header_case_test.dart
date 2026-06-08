import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:test/test.dart';

/// Captures the raw HTTP request head sent to a loopback socket so we can assert
/// the exact on-the-wire casing of header names. A `dart:io` HttpServer can't be
/// used for this because it lowercases incoming header names itself.
Future<String?> _captureRequestHead(
    Future<void> Function(int port) sendRequest) async {
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

  try {
    await sendRequest(server.port);
  } catch (_) {
    // The minimal canned response may upset the client; we only care about the
    // request bytes we already captured.
  }
  await server.close();
  return rawHead;
}

void main() {
  test('dart:io HttpClient preserves Authorization header case', () async {
    final client = HttpClient();
    final rawHead = await _captureRequestHead((port) async {
      final req = await client.getUrl(Uri.parse('http://127.0.0.1:$port/'));
      req.headers.add('Authorization', 'Basic abc123', preserveHeaderCase: true);
      final resp = await req.close();
      await resp.drain();
    });
    client.close();

    expect(rawHead, isNotNull);
    expect(rawHead, contains('Authorization:'));
    expect(rawHead, isNot(contains('authorization:')));
  });

  test('dio preserves Authorization header case (WebRequester mechanism)',
      () async {
    // Mirrors how WebRequester configures dio: global preserveHeaderCase plus a
    // header set via the lowercase-keyed options map.
    final dio = Dio()..options.preserveHeaderCase = true;
    dio.options.headers['Authorization'] = 'Basic abc123';

    final rawHead = await _captureRequestHead((port) async {
      await dio.getUri<dynamic>(Uri.parse('http://127.0.0.1:$port/'));
    });
    dio.close(force: true);

    expect(rawHead, isNotNull);
    expect(rawHead, contains('Authorization:'));
    expect(rawHead, isNot(contains('authorization:')));
  });
}
