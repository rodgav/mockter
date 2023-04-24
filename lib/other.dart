import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

dynamic generateMockResponse(Map<String, dynamic> endpointDefinition) {
  final responses = endpointDefinition['responses'] as Map<String, dynamic>;
  final response = responses.entries.first; // Tomamos la primera respuesta disponible
  final statusCode = int.tryParse(response.key) ?? 200;
  final responseBody = response.value['schema'] != null
      ? generateMockData(response.value['schema'] as Map<String, dynamic>)
      : {'message': 'Respuesta mock generada'};

  return Response(statusCode,
      body: json.encode(responseBody),
      headers: {'Content-Type': 'application/json'});
}

dynamic generateMockData(Map<String, dynamic> schema) {
  // Aquí puedes generar datos de ejemplo según el esquema proporcionado
  // Debes implementar esta función para generar datos en función del tipo, formato y estructura del esquema
  print('schema $schema');
  return {'message': 'Datos mock generados según el esquema'};
}

void registerRoutesFromSwagger(Map<String, dynamic> swagger, Router router) {
  final paths = swagger['paths'] as Map<String, dynamic>;

  paths.forEach((path, methods) {
    methods.forEach((method, details) {
      handler(Request request) async {
        // Lee el cuerpo de la solicitud si existe
        String body = '';
        if ((request.contentLength ?? 0) > 0) {
          body = await request.readAsString();
        }

        // Extraer queryParams y pathParams
        final queryParams = request.url.queryParameters;
        final pathParams = request.context['shelf_router/params'];

        print('body $body');
        print('queryParams $queryParams');
        print('pathParams $pathParams');

        // Generar una respuesta mock según la definición de Swagger

        return generateMockResponse(details as Map<String, dynamic>);
      }

      // Registra el controlador en el enrutador según el método y la ruta
      switch (method.toUpperCase()) {
        case 'GET':
          router.get(path, handler);
          break;
        case 'POST':
          router.post(path, handler);
          break;
        case 'PUT':
          router.put(path, handler);
          break;
        case 'DELETE':
          router.delete(path, handler);
          break;
        case 'PATCH':
          router.patch(path, handler);
          break;
        default:
          print('Método HTTP desconocido: $method');
      }
    });
  });
}

Future<void> main() async {
  // Carga el archivo Swagger JSON
  final swaggerFile = File('assets/example.json');
  final swaggerContent = await swaggerFile.readAsString();
  final swaggerMap = json.decode(swaggerContent) as Map<String, dynamic>;

  final router = Router();

  // Registra las rutas y controladores en función de las definiciones de Swagger
  registerRoutesFromSwagger(swaggerMap, router);

  final handler = const Pipeline().addMiddleware(logRequests())
      .addHandler(router);

  final server = await serve(handler, '192.168.1.8', 7001);
  print('Mock server escuchando en http://${server.address.host}:${server.port}');
}