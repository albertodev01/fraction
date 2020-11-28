import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  // Tests on constructors
  group("Testing the correctness of exception objects", () {
    test("Making sure that equality comparison works for exception objects", () {
      expect(const FractionException("Message"), equals(const FractionException("Message")));
      expect(const MixedFractionException("Message"), equals(const MixedFractionException("Message")));
      expect(const MixedFractionException("Message"), isNot(const FractionException("Message")));
    });

    test("Making sure that 'FractionException' prints the correct message", () {
      final exception = FractionException("Exception message");
      expect(exception.message, "Exception message");
    });

    test("Making sure that 'MixedFractionException' prints the correct message", () {
      final exception = MixedFractionException("Exception message");
      expect(exception.message, "Exception message");
    });
  });
}
