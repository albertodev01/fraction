import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group("Testing the correctness of exception objects", () {
    test("Making sure that equality comparison works for exception objects",
        () {
      const fractionException = FractionException("Message");
      const mixedException = MixedFractionException("Message");

      expect(fractionException, equals(const FractionException("Message")));
      expect(mixedException, equals(const MixedFractionException("Message")));
      expect(fractionException, isNot(mixedException));

      expect(fractionException == FractionException("Message"), isTrue);
      expect(mixedException == MixedFractionException("Message"), isTrue);

      expect(fractionException.hashCode,
          equals(FractionException("Message").hashCode));
      expect(mixedException.hashCode,
          equals(MixedFractionException("Message").hashCode));
    });

    test("Making sure that 'FractionException' prints the correct message", () {
      final exception = FractionException("Exception message");
      expect(exception.message, equals("Exception message"));
      expect("$exception", equals("FractionException: Exception message"));
    });

    test("Making sure that 'MixedFractionException' prints the correct message",
        () {
      final exception = MixedFractionException("Exception message");
      expect(exception.message, "Exception message");
      expect("$exception", equals("MixedFractionException: Exception message"));
    });
  });
}
