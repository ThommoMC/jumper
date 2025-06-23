// Needed for you will get complaints about it
// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:yaml/yaml.dart';
import 'package:build/build.dart';



class CladEmmitor implements Builder {

  @override
  final buildExtensions = const {
    '.yaml': ['.g.dart']
  };


  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final yamlContent = await buildStep.readAsString(inputId);
    final yaml = loadYaml(yamlContent) as YamlMap;
    final versions = yaml['versions'] as YamlMap;
    final YamlMap? enums = yaml['enums'] as YamlMap?;


    final buffer = StringBuffer()
    ..writeln("//GENERATED CODE - DO NOT MODIFY")
    ..writeln("//CREATED FROM $inputId")
    ..writeln('import "dart:typed_data";');

    if (enums != null) {
      for (final enumstruct in enums.entries) {
      final enumKey = enumstruct.key;
      buffer.writeln('enum $enumKey {');
      for (final enumEntry in enumstruct.value) {
        buffer.writeln('$enumEntry,');
      }
      buffer.writeln('}');
      }
    }

    for (final version in versions.entries) {
      final versionKey = version.key;
      buffer.writeln('class $versionKey {');

      //Make class vars for the things
      for (final param in version.value) {
        final paramName = param['name'];
        final paramType = convertToDartType(param['type']); 
        buffer.writeln('final $paramType $paramName;');
      }

      buffer.writeln('$versionKey(');
      for (final param in version.value) {
        final paramName = param['name'];
        buffer.write('this.$paramName, ');
      }
      buffer.writeln(');');

      //create factory for this class
      buffer.writeln('factory $versionKey.fromBytes(Uint8List bytes) {');
      buffer.writeln('final byteViewer = ByteData.sublistView(bytes);');
      for (final param in version.value) {
        final paramName = param['name'];
        final paramType = param['type'];
        final paramOffset = param['offset'];
        if (paramType == 'enum') {
          final paramEnum = param['enum'];
          buffer.writeln('final $paramName = $paramEnum.values[byteViewer.getUint8($paramOffset)];');
          continue;
        }
        buffer.writeln('final $paramName = byteViewer.get$paramType($paramOffset);');
      }

      buffer.writeln("return $versionKey(");
      for (final param in version.value) {
        buffer.write(param['name'] + ', ');
      }
      buffer.write(');');
      buffer.writeln('}');

      buffer.writeln('}');
    }

    final outputId = inputId.changeExtension('.g.dart');
    await buildStep.writeAsString(outputId, buffer.toString());
  }
}

String convertToDartType(String type) {
  switch (type) {
    case 'Uint8':
      return 'int';
  }
  return "";
}

Builder cladEmmitorBuilder(BuilderOptions options) => CladEmmitor();