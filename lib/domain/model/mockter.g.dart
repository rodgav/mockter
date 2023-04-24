// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mockter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MockTerAdapter extends TypeAdapter<MockTer> {
  @override
  final int typeId = 0;

  @override
  MockTer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MockTer(
      host: fields[0] as String,
      port: fields[1] as int,
      environments: (fields[2] as List).cast<Environment>(),
    );
  }

  @override
  void write(BinaryWriter writer, MockTer obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.host)
      ..writeByte(1)
      ..write(obj.port)
      ..writeByte(2)
      ..write(obj.environments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MockTerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EnvironmentAdapter extends TypeAdapter<Environment> {
  @override
  final int typeId = 1;

  @override
  Environment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Environment(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      basePath: fields[3] as String,
      paths: (fields[4] as List).cast<Path>(),
    );
  }

  @override
  void write(BinaryWriter writer, Environment obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.basePath)
      ..writeByte(4)
      ..write(obj.paths);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnvironmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PathAdapter extends TypeAdapter<Path> {
  @override
  final int typeId = 2;

  @override
  Path read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Path(
      id: fields[0] as String,
      path: fields[1] as String,
      method: fields[2] as Methods?,
      summary: fields[3] as String,
      responses: (fields[4] as List).cast<Response>(),
    );
  }

  @override
  void write(BinaryWriter writer, Path obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.method)
      ..writeByte(3)
      ..write(obj.summary)
      ..writeByte(4)
      ..write(obj.responses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PathAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ResponseAdapter extends TypeAdapter<Response> {
  @override
  final int typeId = 4;

  @override
  Response read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Response(
      id: fields[0] as String,
      responseCode: fields[1] as int,
      responseDetails: fields[2] as String,
      active: fields[3] as bool,
      response: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Response obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.responseCode)
      ..writeByte(2)
      ..write(obj.responseDetails)
      ..writeByte(3)
      ..write(obj.active)
      ..writeByte(4)
      ..write(obj.response);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MethodsAdapter extends TypeAdapter<Methods> {
  @override
  final int typeId = 3;

  @override
  Methods read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Methods.get;
      case 1:
        return Methods.post;
      case 2:
        return Methods.put;
      case 3:
        return Methods.patch;
      case 4:
        return Methods.delete;
      case 5:
        return Methods.head;
      case 6:
        return Methods.options;
      default:
        return Methods.get;
    }
  }

  @override
  void write(BinaryWriter writer, Methods obj) {
    switch (obj) {
      case Methods.get:
        writer.writeByte(0);
        break;
      case Methods.post:
        writer.writeByte(1);
        break;
      case Methods.put:
        writer.writeByte(2);
        break;
      case Methods.patch:
        writer.writeByte(3);
        break;
      case Methods.delete:
        writer.writeByte(4);
        break;
      case Methods.head:
        writer.writeByte(5);
        break;
      case Methods.options:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MethodsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
