import 'package:flutter_test/flutter_test.dart';
import 'package:chorebuddies_flutter/utils/formatters.dart';

void main() {
  group('formatDate', () {
    test('returns correct string', () {
      // Arrange
      final date = DateTime(2023, 10, 5);

      // Act
      final result = formatDate(date);

      // Assert
      expect(result, '2023-10-05');
    });

    test('return empty string for null', () {
      // Act
      final result = formatDate(null);

      // Assert
      expect(result, '');
    });
  });
}