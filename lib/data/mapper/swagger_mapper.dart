import 'dart:convert';

import 'package:mockter/application/extensions/methods_extension.dart';
import 'package:uuid/uuid.dart';
import 'package:mockter/domain/model/mockter.dart';

List<Environment> swaggerMapper(String jsonString) {
  const uuid = Uuid();
  final swagger = jsonDecode(jsonString) as Map<String, dynamic>;
  List<Environment> environmentsModel = List.empty(growable: true);
  List<Path> pathsModel = List.empty(growable: true);

  final title = swagger['info']['title'];
  print('Title: $title');
  final description = swagger['info']['description'];
  print('Description: $description');
  final basePath = swagger['basePath'];
  print('Base path: $basePath');

  final paths = swagger['paths'] as Map<String, dynamic>;
  paths.forEach((path, methods) {
    print('Path: $path');

    methods.forEach((method, details) {
      print('  Método: $method');

      final summary = details['summary'];
      print('    Summary: $summary');

      final responses = details['responses'] as Map<String, dynamic>;
      int active = 0;
      List<Response> responsesModel = List.empty(growable: true);
      responses.forEach((responseCode, responseDetails) {
        print('    Response Code: $responseCode');
        print('      Response Details: $responseDetails');

        final schema = responseDetails['schema'];
        /*final type = schema['type'];
        switch(type){
          case 'array':
          case 'object':
          default:
        }*/
        print('schema $schema');
        Map<String, dynamic>? jsonObject;
        if (schema != null) {
          if (schema.containsKey('\$ref')) {
            final ref = schema['\$ref'];
            final definition = extractDefinition(swagger, ref);
            jsonObject = generateJsonFromDefinition(swagger, definition);
            print('      JSON generado a partir de $ref: $jsonObject');
          } else if (schema.containsKey('items')) {
            final ref = schema['items']['\$ref'];
            final definition = extractDefinition(swagger, ref);
            jsonObject = {
              'values': [generateJsonFromDefinition(swagger, definition)]
            };
            print('      JSON generado a partir de $ref: $jsonObject');
          } else {
            jsonObject = generateJsonFromDefinition(swagger, schema);
          }
        }
        responsesModel.add(Response(
            id: uuid.v1(),
            responseCode: int.tryParse(responseCode) ?? 0,
            responseDetails: responseDetails['description'],
            active: active == 0,
            response: jsonObject != null ? jsonEncode(jsonObject) : ''));
        active += 1;
      });
      String newPath = path.replaceAll('{', '');
      newPath = newPath.replaceAll('}', '');
      newPath = newPath.replaceAll(':', '');
      pathsModel.add(Path(
          id: uuid.v1(),
          path: '$basePath$newPath',
          method: method.toString().getMethod(),
          summary: summary,
          responses: responsesModel));
    });
  });
  environmentsModel.add(Environment(
      id: uuid.v1(),
      title: title,
      description: description,
      basePath: basePath,
      paths: pathsModel));
  _checkData(environmentsModel);
  return environmentsModel;
}

Map<String, dynamic> extractDefinition(
    Map<String, dynamic> swagger, String ref) {
  final parts = ref.split('/');
  final definitionKey = parts.last;

  return swagger['definitions'][definitionKey] as Map<String, dynamic>;
}

/*Map<String, dynamic> generateJsonFromDefinition(
    Map<String, dynamic> definition) {
  final properties = definition['properties'] as Map<String, dynamic>;

  final jsonObject = <String, dynamic>{};
  properties.forEach((key, value) {
    final type = value['type'];

    switch (type) {
      case 'integer':
        jsonObject[key] = 0;
        break;
      case 'string':
        jsonObject[key] = '';
        break;
      default:
        jsonObject[key] = '';
    }
  });

  return jsonObject;
}*/
Map<String, dynamic> generateJsonFromDefinition(
    Map<String, dynamic> swagger, Map<String, dynamic> definition) {
  final properties = definition['properties'] as Map<String, dynamic>;

  final jsonObject = <String, dynamic>{};
  properties.forEach((key, value) {
    final type = value['type'];

    switch (type) {
      case 'integer':
        jsonObject[key] = 0;
        break;
      case 'string':
        jsonObject[key] = '';
        break;
      case 'array':
        final items = value['items'] as Map<String, dynamic>;
        if (items.containsKey('\$ref')) {
          final ref = items['\$ref'];
          final definition = extractDefinition(swagger, ref);
          jsonObject[key] = [generateJsonFromDefinition(swagger, definition)];
        } else {
          if (items['type'] == 'object' && items.containsKey('properties')) {
            jsonObject[key] = [
              generateJsonFromDefinition(
                  swagger, {'properties': items['properties']})
            ];
          } else {
            jsonObject[key] = [];
          }
        }
        break;
      case 'object':
        if (value.containsKey('\$ref')) {
          final ref = value['\$ref'];
          final definition = extractDefinition(swagger, ref);
          jsonObject[key] = generateJsonFromDefinition(swagger, definition);
        } else {
          final nestedProperties = value['properties'] as Map<String, dynamic>;
          jsonObject[key] = generateJsonFromDefinition(
              swagger, {'properties': nestedProperties});
        }
        break;
      default:
        jsonObject[key] = '';
    }
  });

  return jsonObject;
}

_checkData(List<Environment> enviromentsModel) {
  for (var environment in enviromentsModel) {
    print('environment title ${environment.title}');
    print('environment basePath ${environment.basePath}');
    print('environment description ${environment.description}');
    for (var path in environment.paths) {
      print('path ${path.path}');
      for (var response in path.responses) {
        print('response active ${response.active}');
        print('response responseDetails ${response.responseDetails}');
        print('response responseCode ${response.responseCode}');
        print('response ${response.response}');
      }
    }
  }
}
