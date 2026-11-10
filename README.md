# Logic-Gates-Flutter

**Basic Electronics Lab Project (EC2700)** by Group 3
Topic: Implementation of Logic Gates, Adders & Subtractors

## What the project is

Logic-Gates-Flutter is an Android app, written in Dart with the Flutter framework, that teaches how basic digital circuits work. Every circuit has its picture, a written description, a truth table, and an interactive demo that you can play with on the phone.

## What is inside

The app has six tabs.

| Tab | Content |
|---|---|
| Home | Project details and a short guide |
| Gates | AND (IC7408), OR (IC7432), NOT (IC7404), NAND (IC7400), NOR (IC7402), XOR (IC7486), XNOR (IC74266) |
| Using NAND | NOT, AND, OR, NOR, XOR and XNOR gates, each built from NAND gates only |
| Using NOR | NOT, OR, AND, NAND, XNOR and XOR gates, each built from NOR gates only |
| Adders | Half Adder and Full Adder |
| Subtractors | Half Subtractor and Full Subtractor |

Every section shows:

1. **The circuit.** A gate symbol for the seven gates, and a complete gate-level circuit for the other tabs.
2. **A description** of what the circuit does.
3. **A truth table** with every combination of inputs.
4. **An interactive demo** (see below).
5. **A pin diagram** of the IC chip, for the seven gates. It shows all 14 pins, with the IC notch at the top, VCC on pin 14 and GND on pin 7.

## Universal gates

NAND and NOR are called universal gates, because every other gate can be built from NAND gates alone, or from NOR gates alone. The Using NAND and Using NOR tabs show how:

| Gate | Made of NAND gates | Made of NOR gates |
|---|---|---|
| NOT | 1 gate, inputs joined | 1 gate, inputs joined |
| AND | 2 gates | 3 gates |
| OR | 3 gates | 2 gates |
| NAND | (itself) | 4 gates |
| NOR | 4 gates | (itself) |
| XOR | 4 gates | 5 gates |
| XNOR | 5 gates | 4 gates |

In these circuits the wires change colour while you use the app: a green wire carries 1 and a dark wire carries 0. When you tap an input, you can follow the signal through every gate.

## How the interactive demo works

Every circuit has input circles and output circles. A red circle means 0 and a green circle means 1.

- Tap an **input** circle to switch it between 0 and 1.
- The **output** circles change instantly, because the circuit is calculated again every time an input changes.
- The row of the **truth table** that matches the current inputs is highlighted.
- The **Reset** button sets every input back to 0.
- The **moon / sun button** in the top bar switches between the dark and the light version of the app. The app starts in the dark version. The red and green circles keep their colours in both versions, and the circuits keep working.

In the NAND and NOR circuits the wires of the drawing also change colour.

The outputs are never stored. They are always calculated from the inputs by the logic function of the circuit, and the truth table is built from the same function. For this reason the truth table, the circles and the logic can never disagree with each other.

## How the code is organised

The code is split into small modules so that each part can be explained on its own.

```
lib/
  main.dart                     Starts the app.
  app/
    logic_gates_app.dart        The MaterialApp (title, light and dark theme, and the dark mode switch).
    app_theme.dart              The light and dark colors (AppPalette) and the red/green LED colors.
  models/
    logic_block.dart            One circuit: its name, inputs, outputs, description and logic function.
    block_category.dart         The five groups, one per tab: gates, using NAND, using NOR, adders, subtractors.
    diagram_type.dart           Which picture to draw for a circuit.
    gate_kind.dart              The seven gate symbols.
    circuit_spec.dart           A circuit described as a list of gates and the wires between them.
    ic_pin_info.dart            The 14 pin names of an IC chip.
  logic/
    logic_functions.dart        The logic of every gate, adder and subtractor.
    circuit_evaluator.dart      Calculates every wire of a circuit built from NAND or NOR gates.
    truth_table_builder.dart    Builds a truth table from a circuit.
  data/
    logic_blocks_data.dart      The list of all circuits with their descriptions.
    universal_circuit_specs.dart  The six circuit shapes that are built from NAND or NOR gates.
    universal_gate_blocks.dart  The twelve gates built from NAND or NOR gates.
    ic_pinouts.dart             The pin layout of the seven ICs.
    project_info.dart           The text of the Home tab.
  painters/
    gate_shapes.dart            Draws the seven gate symbols.
    gate_symbol_painter.dart    The picture of one single gate.
    circuit_painter.dart        The adder and subtractor circuits, built from gate shapes.
    netlist_circuit_painter.dart  The NAND and NOR circuits; routes the wires and colours them by value.
    ic_pin_painter.dart         The 14-pin chip diagram.
    painter_text.dart           Helper that writes text on a drawing.
  screens/
    home_screen.dart            The screen with the six tabs.
    project_info_tab.dart       The Home tab.
    block_list_tab.dart         The Gates, Using NAND, Using NOR, Adders and Subtractors tabs.
  widgets/
    block_section.dart          One full section; it owns the input values.
    description_card.dart       The description card.
    truth_table_card.dart       The truth table card.
    interactive_card.dart       The input and output circles with the Reset button.
    led_indicator.dart          One red/green circle.
    pin_diagram_card.dart       The IC pin diagram card.
    diagram_view.dart           Chooses between a gate symbol and the two kinds of circuit.
    section_card.dart           The white rounded card used by all sections.
    app_logo.dart               The round logo.
test/                           Automated tests of the logic, the truth tables, the pin layouts and the tapping.
```

### How the pieces work together

1. `logic_blocks_data.dart` holds the 23 `LogicBlock` objects. Each one knows its inputs, its outputs and a logic function from `logic_functions.dart`.
2. A `BlockSection` is created for every block. It keeps the list `inputValues` (all 0 at the start).
3. When an input circle is tapped, `toggleInput` flips that value and the screen is rebuilt.
4. During the rebuild the section calls `block.computeOutputs(inputValues)` to get `outputValues`, and `rowIndexFromInputs(inputValues)` to find the truth table row to highlight.
5. The `InteractiveCard` draws the circles from these values, and the `TruthTableCard` highlights the row.

### How the NAND and NOR circuits work

Each of these circuits is described by a `CircuitSpec`: a list of gates, where every gate says which wires go into it, which wire comes out, and where it is placed. Two modules use the same description:

- `circuit_evaluator.dart` walks through the gates in order and calculates the value of every wire. The last wire is the output of the circuit.
- `netlist_circuit_painter.dart` draws the gates, routes the wires and colours each wire by the value that the evaluator calculated.

So the output LED, the truth table and the coloured wires of the drawing all come from one calculation.

### The logic of the adders and subtractors

- **Half Adder:** Sum = A XOR B, Carry = A AND B.
- **Full Adder:** two half adders and an OR gate. Sum = A XOR B XOR Cin, Cout = (A AND B) OR ((A XOR B) AND Cin).
- **Half Subtractor:** Difference = A XOR B, Borrow = (NOT A) AND B.
- **Full Subtractor:** two half subtractors and an OR gate. Difference = A XOR B XOR Bin, Bout = ((NOT A) AND B) OR (NOT(A XOR B) AND Bin).
