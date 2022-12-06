import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../solutions/index.dart';
import 'mocks.dart';

void main() {
  final mockInputUtil = MockInputUtil();
  final day6 = Day06(inputUtil: mockInputUtil);

  group('Part 1', () {
    test('bvwbjplbgvbhsrlpgdmjqwftvncz returns 5', () {
      when(() => mockInputUtil.asString).thenReturn('bvwbjplbgvbhsrlpgdmjqwftvncz');

      expect(day6.solvePart1(), 5);
    });

    test('nppdvjthqldpwncqszvftbrmjlhg returns 6', () {
      when(() => mockInputUtil.asString).thenReturn('nppdvjthqldpwncqszvftbrmjlhg');

      expect(day6.solvePart1(), 6);
    });

    test('nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg returns 10', () {
      when(() => mockInputUtil.asString).thenReturn('nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg');

      expect(day6.solvePart1(), 10);
    });

    test('zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw returns 11', () {
      when(() => mockInputUtil.asString).thenReturn('zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw');

      expect(day6.solvePart1(), 11);
    });
  });

  group('Part 2', () {
    test('mjqjpqmgbljsphdztnvjfqwrcgsmlb returns 19', () {
      when(() => mockInputUtil.asString).thenReturn('mjqjpqmgbljsphdztnvjfqwrcgsmlb');

      expect(day6.solvePart2(), 19);
    });

    test('bvwbjplbgvbhsrlpgdmjqwftvncz returns 23', () {
      when(() => mockInputUtil.asString).thenReturn('bvwbjplbgvbhsrlpgdmjqwftvncz');

      expect(day6.solvePart2(), 23);
    });

    test('nppdvjthqldpwncqszvftbrmjlhg returns 23', () {
      when(() => mockInputUtil.asString).thenReturn('nppdvjthqldpwncqszvftbrmjlhg');

      expect(day6.solvePart2(), 23);
    });

    test('nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg returns 29', () {
      when(() => mockInputUtil.asString).thenReturn('nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg');

      expect(day6.solvePart2(), 29);
    });

    test('zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw returns 26', () {
      when(() => mockInputUtil.asString).thenReturn('zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw');

      expect(day6.solvePart2(), 26);
    });
  });
}
