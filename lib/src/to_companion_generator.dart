import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:drift_companion_gen/generate_to_companion.dart';
import 'package:source_gen/source_gen.dart';

class ToCompanionGenerator extends GeneratorForAnnotation<GenerateToCompanion> {
  @override
  FutureOr<String> generateForAnnotatedElement(Element element,
      ConstantReader annotation,
      BuildStep buildStep,) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'Generator can only be used on classes',
        element: element,
      );
    }

    final className = element.name;
    final tableName = className.replaceFirst('Entity', 'LocalDto');
    final companionClass = '${tableName}Companion';
    final buffer = StringBuffer();

    buffer.writeln('extension ${className}ToCompanion on $className {');
    buffer.writeln('  $companionClass toCompanion() {');
    buffer.writeln('    return $companionClass(');

    // Look for the unnamed factory constructor
    final factoryConstructor = element.constructors.firstWhere(
          (c) => c.isFactory && c.name.isEmpty,
      orElse: () =>
      throw InvalidGenerationSourceError(
        'No unnamed factory constructor found for class $className',
        element: element,
      ),
    );

    for (final param in factoryConstructor.parameters) {
      final fieldName = param.name;
      if (param.isNamed) {
        buffer.writeln('      $fieldName: Value($fieldName),');
      } else {
        buffer.writeln('      Value($fieldName),');
      }
    }

    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln('}');

    return buffer.toString();
  }
}
