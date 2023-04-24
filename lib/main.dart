import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mockter/application/application.dart';
import 'package:mockter/application/dependency_injection.dart';
import 'package:mockter/presentation/home/home.dart';
import 'package:shelf/shelf.dart';
import 'package:window_manager/window_manager.dart';

Future<Response> handleRequest(Request request) async {
  final method = request.method;
  final url = request.requestedUri;
  final queryParams = request.url.queryParameters;
  final headers = request.headers;
  final path = request.url.path;

  // Lee el cuerpo de la solicitud si existe
  String body = '';
  if ((request.contentLength ?? 0) > 0) {
    body = await request.readAsString();
  }

  print('Método: $method');
  print('URL: $url');
  print('Query Params: $queryParams');
  print('Headers: $headers');
  print('Cuerpo: $body');
  print('path: $path');

  // Aquí puedes personalizar la respuesta según los parámetros de la solicitud
  final responseBody = json.encode({
    'message': 'Respuesta del mock server',
  });

  return Response.ok(responseBody,
      headers: {'Content-Type': 'application/json'});
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initModule();
  WindowManager.instance.setMinimumSize(const Size(1000, 740));
  runApp(const MyApp());
}



/*HttpServer? _server;
  bool _isRunning = false;



  Future<void> startServer() async {
    final router = sr.Router();

    router.all('/<ignored|.*>', handleRequest);

    _server = await io.serve(router, '192.168.1.8', 7001);
    print(
        'Servidor iniciado en http://${_server!.address.host}:${_server!.port}');
    setState(() {
      _isRunning = true;
    });
  }

  Future<void> stopServer() async {
    await _server?.close(force: true);
    print('Servidor detenido');
    setState(() {
      _isRunning = false;
    });
  }*/
