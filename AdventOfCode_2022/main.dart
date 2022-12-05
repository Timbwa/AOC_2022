import 'solutions/index.dart';
import 'utils/index.dart';

/// List holding all the solution classes.
final days = <GenericDay>[
  Day03(),
  Day04(),
  Day05(),
];

void main(List<String?> args) {
  bool onlyShowLast = true;

  if (args.length == 1 && args[0].isHelperArgument()) {
    printHelper();
    return;
  }

  if (args.length == 1 && args[0].isAllArgument()) {
    onlyShowLast = false;
  }

  if (args.length == 1 && args[0].isTestArgument()) {
    isTest = true;
  }

  onlyShowLast ? days.last.printSolutions() : days.forEach((day) => day.printSolutions());
}

void printHelper() {
  print(
    '''
Usage: dart main.dart <command>

Global Options:
  -h, --help    Show this help message
  -a, --all     Show all solutions
  -t, --test    Run with test input
''',
  );
}

extension ArgsMatcher on String? {
  bool isHelperArgument() {
    return this == '-h' || this == '--help';
  }

  bool isAllArgument() {
    return this == '-a' || this == '--all';
  }

  bool isTestArgument() {
    return this == '-t' || this == '--test';
  }
}
