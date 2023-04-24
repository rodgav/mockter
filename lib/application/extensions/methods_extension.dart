import 'package:flutter/material.dart';
import 'package:mockter/domain/model/mockter.dart';

extension MethodsExtension on Methods? {
  String getName() {
    switch (this) {
      case Methods.get:
        return 'GET';
      case Methods.post:
        return 'POST';
      case Methods.put:
        return 'PUT';
      case Methods.patch:
        return 'PATCH';
      case Methods.delete:
        return 'DELETE';
      case Methods.head:
        return 'HEAD';
      case Methods.options:
        return 'OPTIONS';
      default:
        return 'GET';
    }
  }

  Color getColor() {
    switch (this) {
      case Methods.get:
        return Colors.blue;
      case Methods.post:
        return Colors.green;
      case Methods.put:
        return Colors.orange;
      case Methods.patch:
        return Colors.grey;
      case Methods.delete:
        return Colors.red;
      case Methods.head:
        return Colors.purple;
      case Methods.options:
        return Colors.blueAccent;
      default:
        return Colors.blue;
    }
  }
}

extension StringToMethodExtension on String? {
  Methods getMethod() {
    switch (this?.toLowerCase()) {
      case 'get':
        return Methods.get;
      case 'post':
        return Methods.post;
      case 'put':
        return Methods.put;
      case 'patch':
        return Methods.patch;
      case 'delete':
        return Methods.delete;
      case 'head':
        return Methods.head;
      case 'options':
        return Methods.options;
      default:
        return Methods.get;
    }
  }
}
