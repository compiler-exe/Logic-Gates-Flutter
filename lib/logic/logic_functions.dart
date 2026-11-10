// All the digital logic of the project lives in this file.
// true means 1 and false means 0.
// Nothing here knows about the screen, so it is easy to test.

// ---------------------------------------------------------------
// The basic gates.
// ---------------------------------------------------------------

bool andOf(bool a, bool b) {
  return a && b;
}

bool orOf(bool a, bool b) {
  return a || b;
}

bool notOf(bool a) {
  return !a;
}

bool nandOf(bool a, bool b) {
  return notOf(andOf(a, b));
}

bool norOf(bool a, bool b) {
  return notOf(orOf(a, b));
}

// XOR is 1 only when the two inputs are different.
bool xorOf(bool a, bool b) {
  return a != b;
}

// XNOR is 1 only when the two inputs are the same.
bool xnorOf(bool a, bool b) {
  return notOf(xorOf(a, b));
}

// ---------------------------------------------------------------
// One function per block.
// Each takes the list of inputs and returns the list of outputs.
// ---------------------------------------------------------------

List<bool> computeAndGate(List<bool> inputValues) {
  final bool a = inputValues[0];
  final bool b = inputValues[1];
  return [andOf(a, b)];
}

List<bool> computeOrGate(List<bool> inputValues) {
  final bool a = inputValues[0];
  final bool b = inputValues[1];
  return [orOf(a, b)];
}

List<bool> computeNotGate(List<bool> inputValues) {
  final bool a = inputValues[0];
  return [notOf(a)];
}

List<bool> computeNandGate(List<bool> inputValues) {
  final bool a = inputValues[0];
  final bool b = inputValues[1];
  return [nandOf(a, b)];
}

List<bool> computeNorGate(List<bool> inputValues) {
  final bool a = inputValues[0];
  final bool b = inputValues[1];
  return [norOf(a, b)];
}

List<bool> computeXorGate(List<bool> inputValues) {
  final bool a = inputValues[0];
  final bool b = inputValues[1];
  return [xorOf(a, b)];
}

List<bool> computeXnorGate(List<bool> inputValues) {
  final bool a = inputValues[0];
  final bool b = inputValues[1];
  return [xnorOf(a, b)];
}

// Half adder: Sum = A XOR B, Carry = A AND B.
// Returns [sum, carry].
List<bool> computeHalfAdder(List<bool> inputValues) {
  final bool a = inputValues[0];
  final bool b = inputValues[1];
  final bool sum = xorOf(a, b);
  final bool carry = andOf(a, b);
  return [sum, carry];
}

// Full adder = two half adders and an OR gate.
// Inputs: [a, b, carryIn]. Returns [sum, carryOut].
List<bool> computeFullAdder(List<bool> inputValues) {
  final bool a = inputValues[0];
  final bool b = inputValues[1];
  final bool carryIn = inputValues[2];

  // First half adder adds A and B.
  final bool firstSum = xorOf(a, b);
  final bool firstCarry = andOf(a, b);

  // Second half adder adds the first sum and the carry-in.
  final bool sum = xorOf(firstSum, carryIn);
  final bool secondCarry = andOf(firstSum, carryIn);

  // The OR gate combines the two carries.
  final bool carryOut = orOf(firstCarry, secondCarry);
  return [sum, carryOut];
}

// Half subtractor: Difference = A XOR B, Borrow = (NOT A) AND B.
// Returns [difference, borrow].
List<bool> computeHalfSubtractor(List<bool> inputValues) {
  final bool a = inputValues[0];
  final bool b = inputValues[1];
  final bool difference = xorOf(a, b);
  final bool borrow = andOf(notOf(a), b);
  return [difference, borrow];
}

// Full subtractor = two half subtractors and an OR gate.
// Inputs: [a, b, borrowIn]. Returns [difference, borrowOut].
List<bool> computeFullSubtractor(List<bool> inputValues) {
  final bool a = inputValues[0];
  final bool b = inputValues[1];
  final bool borrowIn = inputValues[2];

  // First half subtractor works on A and B.
  final bool firstDifference = xorOf(a, b);
  final bool firstBorrow = andOf(notOf(a), b);

  // Second half subtractor works on the first difference and the borrow-in.
  final bool difference = xorOf(firstDifference, borrowIn);
  final bool secondBorrow = andOf(notOf(firstDifference), borrowIn);

  // The OR gate combines the two borrows.
  final bool borrowOut = orOf(firstBorrow, secondBorrow);
  return [difference, borrowOut];
}
