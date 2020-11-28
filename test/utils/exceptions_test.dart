import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  // Tests on constructors
  group("Testing the correctness of exception objects", () {
    test("Making sure that equality comparison works for exception objects",
        () {
      const fractionException = FractionException("Message");
      const mixedException = MixedFractionException("Message");

      expect(fractionException, equals(const FractionException("Message")));
      expect(mixedException, equals(const MixedFractionException("Message")));
      expect(fractionException, isNot(mixedException));

      expect(fractionException.hashCode, FractionException("Message").hashCode);
      expect(
          mixedException.hashCode, MixedFractionException("Message").hashCode);
    });

    test("Making sure that 'FractionException' prints the correct message", () {
      final exception = FractionException("Exception message");
      expect(exception.message, "Exception message");
    });

    test("Making sure that 'MixedFractionException' prints the correct message",
        () {
      final exception = MixedFractionException("Exception message");
      expect(exception.message, "Exception message");
    });
  });
}
