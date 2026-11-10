// Tells the app which picture to draw for a block.
// The seven gates get a single symbol.
// The adders and subtractors get a hand-drawn circuit of several gates.
// The circuits built from NAND or NOR gates are drawn from their CircuitSpec.
enum DiagramType {
  andGate,
  orGate,
  notGate,
  nandGate,
  norGate,
  xorGate,
  xnorGate,
  halfAdder,
  fullAdder,
  halfSubtractor,
  fullSubtractor,
  universalCircuit,
}
