import 'dart:convert';

import '../utils/index.dart';

class Day13 extends GenericDay {
  Day13() : super(13);

  @override
  Map<int, List<dynamic>> parseInput() {
    final lines = input.getPerLine();
    var index = 0;
    final packetGroups = lines.groupListsBy((element) => element == '' ? index++ : index);
    packetGroups.forEach((key, value) {
      value.removeWhere((element) => element == '');
    });
    final parsedPacketGroups = packetGroups.map<int, List<dynamic>>(
        (key, value) => MapEntry(key, value.map((e) => json.decode(e) as List<dynamic>).toList()));

    return parsedPacketGroups;
  }

  int compareList(dynamic left, dynamic right) {
    if (left is int) {
      if (right is int) {
        return left - right;
      } else {
        return compareList([left], right);
      }
    } else {
      if (right is int) {
        return compareList(left, [right]);
      }
    }
    // both are lists

    for (var v in zip([left as List<dynamic>, right as List<dynamic>])) {
      final value = compareList(v[0], v[1]);
      if (value != 0) {
        return value;
      }
    }

    return left.length - right.length;
  }

  @override
  int solvePart1() {
    final packets = parseInput();

    int indices = 0;
    packets.forEach((key, value) {
      if (compareList(value[0], value[1]) < 0) {
        indices += key + 1;
      }
    });

    return indices;
  }

  @override
  int solvePart2() {
    final packetGroups = parseInput();
    int countOfPacketsBefore2 = 1;
    int countOfPacketsBefore6 = 2;

    final allPackets = [];
    packetGroups.forEach((key, value) {
      value.forEach((element) {
        allPackets.add(element);
      });
    });

    final packet2 = [
      [2]
    ];
    final packet6 = [
      [6]
    ];

    for (var packet in allPackets) {
      if (compareList(packet, packet2) < 0) {
        countOfPacketsBefore2 += 1;
        countOfPacketsBefore6 += 1;
      } else if (compareList(packet, packet6) < 0) {
        countOfPacketsBefore6 += 1;
      }
    }

    // alternate solution
    allPackets.addAll([packet2, packet6]);
    allPackets.sort(compareList);
    final altNumOfPacketsBefore2 = allPackets.indexOf(packet2) + 1;
    final altNumOfPacketsBefore6 = allPackets.indexOf(packet6) + 1;

    print('Answer from alt solution : ${altNumOfPacketsBefore2 * altNumOfPacketsBefore6}');
    return countOfPacketsBefore2 * countOfPacketsBefore6;
  }
}
