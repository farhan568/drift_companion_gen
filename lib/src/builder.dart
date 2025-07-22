import 'package:build/build.dart';
import 'package:drift_companion_gen/src/to_companion_generator.dart';
import 'package:source_gen/source_gen.dart';


Builder toCompanionBuilder(BuilderOptions options) =>
    PartBuilder([ToCompanionGenerator()], '.comp_gen.dart');
