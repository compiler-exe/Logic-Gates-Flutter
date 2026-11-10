// Describes the 14 pins of one IC chip (DIP-14 package).
class IcPinInfo {
  // Example: 'IC7408'.
  final String icNumber;

  // Example: 'Quad 2-input AND gate'.
  final String chipDescription;

  // The name of every pin. Index 0 is pin 1, index 13 is pin 14.
  final List<String> pinLabels;

  const IcPinInfo({
    required this.icNumber,
    required this.chipDescription,
    required this.pinLabels,
  });
}
