import '../utils/index.dart';

class Command {
  final String name;
  final String? param1;
  List<String> output;

  Command(
    this.name, {
    this.output = const [],
    this.param1,
  });

  @override
  String toString() {
    return 'Command{name: $name, param1: $param1, output: $output}';
  }

  bool isListCommand() => name == 'ls';

  bool isChangeDirectoryAndMoveIn() => name == 'cd' && param1 != null && param1 != '..' && param1 != '/';

  bool isChangeDirectoryAndMoveOut() => name == 'cd' && param1 != null && param1 == '..';

  void addOutput(List<String> output) {
    this.output = [...output];
  }
}

class DeviceItem {
  DeviceItem? parent;
}

class DeviceFile extends DeviceItem {
  final String name;
  final int size;

  DeviceFile(this.name, this.size);

  @override
  String toString() {
    return 'DeviceFile{name: $name, size: $size}';
  }
}

class DeviceDirectory extends DeviceItem implements Comparable<DeviceDirectory> {
  final String name;
  List<DeviceFile> files;
  List<DeviceDirectory> directories;

  DeviceDirectory(
    this.name, {
    this.files = const [],
    this.directories = const [],
  });

  int get size =>
      files.fold(0, (acc, element) => acc + element.size) + directories.fold(0, (acc, element) => acc + element.size);

  int get fileSize => files.fold(0, (acc, element) => acc + element.size);

  int get directorySize => directories.fold(0, (acc, element) => acc + element.size);

  int get totalSize => fileSize + directorySize;

  void populateFiles(List<DeviceFile> files) {
    if (files.isNotEmpty) {
      this.files = [...files];
    }
  }

  void populateDirectories(List<DeviceDirectory> directories) {
    if (directories.isNotEmpty) {
      this.directories = [...directories];
    }
  }

  @override
  String toString() {
    return 'DeviceDirectory{name: $name, size: $size, fileSize: $fileSize, directorySize: $directorySize}';
  }

  @override
  int compareTo(DeviceDirectory other) {
    return size.compareTo(other.size);
  }
}

extension FileTypeX on String {
  bool isDirectory() => this.startsWith('dir');
}

extension CommandTypeX on String {
  bool isCommand() => this.startsWith('\$', 0);

  String removeTerminalPrefix() => this.replaceFirst('\$ ', '');
}

class DeviceExplorer {
  final List<DeviceDirectory> directories;
  DeviceDirectory currentDirectory;

  DeviceExplorer(this.currentDirectory) : directories = <DeviceDirectory>[]..add(currentDirectory);

  int get size => directories.fold(0, (acc, directory) => acc + directory.fileSize);

  void applyCommand(Command command) {
    if (command.isListCommand()) {
      final files = command.output
          .map((e) {
            if (!e.isDirectory()) {
              final fileDetails = e.split(' ');
              final file = DeviceFile(fileDetails[1], int.parse(fileDetails[0]));
              return file;
            }
          })
          .whereNotNull()
          .toList();

      final directories = command.output
          .map((e) {
            if (e.isDirectory()) {
              final details = e.split(' ');
              final dir = DeviceDirectory(details[1]);
              return dir;
            }
          })
          .whereNotNull()
          .toList();

      currentDirectory.populateFiles(files);
      currentDirectory.populateDirectories(directories);
    } else if (command.isChangeDirectoryAndMoveIn()) {
      final directory = currentDirectory.directories.firstWhere((element) {
        return element.name == command.param1!;
      }, orElse: () {
        return DeviceDirectory(command.param1!);
      });

      directory.parent = currentDirectory;
      directories.add(directory);
      currentDirectory = directory;
    } else if (command.isChangeDirectoryAndMoveOut()) {
      currentDirectory = currentDirectory.parent! as DeviceDirectory;
    }
  }

  @override
  String toString() {
    return 'DeviceExplorer{directories: $directories, currentDirectory: $currentDirectory}';
  }
}

class Day07 extends GenericDay {
  Day07() : super(7);

  @override
  DeviceExplorer parseInput() {
    final lines = input.getPerLine().skip(1).toList();

    final firstDirectory = DeviceDirectory('/');
    final deviceExplorer = DeviceExplorer(firstDirectory);

    var index = -1;
    final commandsAndOutput = lines.groupListsBy<int>((line) => line.isCommand() ? ++index : index);

    commandsAndOutput.forEach((index, commandAndOutput) {
      final commandLine = commandAndOutput[0];
      final commandNameAndParam = commandLine.removeTerminalPrefix().split(' ');
      if (commandAndOutput.length > 1) {
        final command = Command(commandNameAndParam[0], output: commandAndOutput.sublist(1));
        deviceExplorer.applyCommand(command);
      } else {
        final command = Command(commandNameAndParam[0], param1: commandNameAndParam[1]);
        deviceExplorer.applyCommand(command);
      }
    });

    return deviceExplorer;
  }

  @override
  int solvePart1() {
    final deviceExplorer = parseInput();

    var sum = 0;
    for (var directory in deviceExplorer.directories) {
      if (directory.size <= 100000) {
        sum += directory.size;
      }
    }

    return sum;
  }

  @override
  int solvePart2() {
    const totalSpace = 70000000;
    const requiredSpace = 30000000;
    final deviceExplorer = parseInput();

    final unusedSpace = totalSpace - deviceExplorer.size;
    final minSize = requiredSpace - unusedSpace;

    final sortedDirectories = deviceExplorer.directories..sort();

    for (var directory in sortedDirectories) {
      if (directory.size >= minSize) {
        return directory.size;
      }
    }

    return -1;
  }
}
