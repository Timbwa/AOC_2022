import '../utils/index.dart';

class Day06 extends GenericDay {
  Day06({super.inputUtil}) : super(6);

  @override
  String parseInput() {
    final buffer = input.asString;

    return buffer;
  }

  @override
  int solvePart1() {
    final buffer = parseInput();
    final chars = buffer.split('');

    return getStartOfCharacter(chars, 4);
  }

  @override
  int solvePart2() {
    final buffer = parseInput();
    final chars = buffer.split('');

    return getStartOfCharacter(chars, 14);
  }

  int getStartOfCharacter(List<String> buffer, int packetLength) {
    var j = packetLength - 1;
    for (var i = 0; i < buffer.length - packetLength; i++) {
      var window = buffer.sublist(i, j + 1);
      var windowSet = window.toSet();
      if (windowSet.length == packetLength) {
        return j + 1;
      }
      j++;
    }
    return 0;
  }
}
