import 'container.dart';
import 'runtime_object.dart';
import 'path.dart';

class ChoicePoint extends RuntimeObject {
  Path? get pathOnChoice {
    // Resolve any relative paths to global ones as we come across them
    if (_pathOnChoice != null && _pathOnChoice!.isRelative) {
      var choiceTargetObj = choiceTarget;
      if (choiceTargetObj != null) {
        _pathOnChoice = choiceTargetObj.path;
      }
    }
    return _pathOnChoice;
  }

  set pathOnChoice(Path? value) {
    _pathOnChoice = value;
  }

  Path? _pathOnChoice;

  Container? get choiceTarget {
    if (_pathOnChoice == null) return null;
    return resolvePath(_pathOnChoice!).container;
  }

  String get pathStringOnChoice => compactPathString(pathOnChoice!);
  set pathStringOnChoice(String value) => pathOnChoice = Path.new3(value);

  bool hasCondition = false;
  bool hasStartContent = false;
  bool hasChoiceOnlyContent = false;
  bool onceOnly = false;
  bool isInvisibleDefault = false;

  int get flags {
    int flags = 0;
    if (hasCondition) flags |= 1;
    if (hasStartContent) flags |= 2;
    if (hasChoiceOnlyContent) flags |= 4;
    if (isInvisibleDefault) flags |= 8;
    if (onceOnly) flags |= 16;
    return flags;
  }

  set flags(int value) {
    hasCondition = (value & 1) > 0;
    hasStartContent = (value & 2) > 0;
    hasChoiceOnlyContent = (value & 4) > 0;
    isInvisibleDefault = (value & 8) > 0;
    onceOnly = (value & 16) > 0;
  }

  ChoicePoint([this.onceOnly = true]);

  @override
  String toString() {
    int? targetLineNum = debugLineNumberOfPath(pathOnChoice);
    String targetString = pathOnChoice.toString();

    if (targetLineNum != null) {
      targetString = " line $targetLineNum($targetString)";
    }

    return "Choice: -> " + targetString;
  }
}
