import 'dart:convert';
import 'dart:io';

Map<String, int> getPriorities() {
  Map<String, int> priorities = {};

  final smallCharValues = List.generate(26, (index) => index + 97);
  var priorityValue = 1;

  for (var charValue in smallCharValues) {
    priorities.addAll({String.fromCharCode(charValue): priorityValue++});
  }

  final bigCharValues = List.generate(26, (index) => index + 65);
  for (var charValue in bigCharValues) {
    priorities.addAll({String.fromCharCode(charValue): priorityValue++});
  }

  return priorities;
}

int getPriorityOfCommonItem(String rucksack) {
  var comp1 = rucksack.split('').sublist(0, (rucksack.length ~/ 2));
  var comp2 = rucksack.split('').sublist((rucksack.length ~/ 2), rucksack.length);

  late String commonItem;

  for (int i = 0; i < comp1.length; i++) {
    if (comp2.contains(comp1[i])) {
      commonItem = comp1[i];
      break;
    }
  }

  final priorities = getPriorities();
  final priority = priorities[commonItem]!;

  // print('Common Item: $commonItem, Prioroty: $priority');
  return priority;
}

Future<List<String>> parseInputToLines(String filename) async {
  final lines = utf8.decoder.bind(File(filename).openRead()).transform(const LineSplitter());

  List<String> lineStrings = [];

  await for (final line in lines) {
    lineStrings.add(line);
  }

  return lineStrings;
}

Map<int, Map<int, String>> getGroups(List<String> lines) {
  Map<int, Map<int, String>> groups = {};

  Map<int, String> groupMap = {};

  var groupIndex = 0;
  var elfIndex = 0;

  for (var line in lines) {
    groupMap.addAll({elfIndex++: line});

    if (elfIndex == 3) {
      groups.addAll(
        {
          groupIndex: {...groupMap},
        },
      );

      elfIndex = 0;
      groupIndex++;
      groupMap.clear();
    }
  }

  // print(groups);

  return groups;
}

int getCommonItemInGroups(Map<int, Map<int, String>> groups) {
  int sum = 0;
  final priorities = getPriorities();

  groups.forEach((key, group) {
    final elves = group.values.toList();
    final firstElf = elves.first.split('');
    final secondElf = elves[1].split('');
    final thirdElf = elves[2].split('');

    for (var item in firstElf) {
      if (secondElf.contains(item) && thirdElf.contains(item)) {
        // print('CommonItem for group: $item');
        sum += priorities[item]!;
        break;
      }
    }
  });

  print('Sum is $sum');
  return sum;
}
