import '../models/ic_pin_info.dart';

// Pin layouts of the seven ICs, taken from the standard 74-series
// datasheets. All of them use a 14-pin DIP package:
// pin 7 is GND and pin 14 is VCC.
//
// Naming: 1A and 1B are the inputs of gate 1, 1Y is its output.

// IC7400, IC7408, IC7432 and IC7486 share the same pin layout.
const List<String> _standardQuadGatePins = [
  '1A', '1B', '1Y', '2A', '2B', '2Y', 'GND',
  '3Y', '3A', '3B', '4Y', '4A', '4B', 'VCC',
];

// IC7402 (NOR) has the outputs in front of the inputs.
const List<String> _norQuadGatePins = [
  '1Y', '1A', '1B', '2Y', '2A', '2B', 'GND',
  '3A', '3B', '3Y', '4A', '4B', '4Y', 'VCC',
];

// IC7404 (NOT) holds six inverters, each with one input A and one output Y.
const List<String> _hexInverterPins = [
  '1A', '1Y', '2A', '2Y', '3A', '3Y', 'GND',
  '4Y', '4A', '5Y', '5A', '6Y', '6A', 'VCC',
];

// IC74266 (XNOR) has the output of gate 2 next to the output of gate 1.
const List<String> _xnorQuadGatePins = [
  '1A', '1B', '1Y', '2Y', '2A', '2B', 'GND',
  '3A', '3B', '3Y', '4Y', '4A', '4B', 'VCC',
];

const IcPinInfo ic7408Pins = IcPinInfo(
  icNumber: 'IC7408',
  chipDescription: 'Quad 2-input AND gate',
  pinLabels: _standardQuadGatePins,
);

const IcPinInfo ic7432Pins = IcPinInfo(
  icNumber: 'IC7432',
  chipDescription: 'Quad 2-input OR gate',
  pinLabels: _standardQuadGatePins,
);

const IcPinInfo ic7404Pins = IcPinInfo(
  icNumber: 'IC7404',
  chipDescription: 'Hex inverter (6 NOT gates)',
  pinLabels: _hexInverterPins,
);

const IcPinInfo ic7400Pins = IcPinInfo(
  icNumber: 'IC7400',
  chipDescription: 'Quad 2-input NAND gate',
  pinLabels: _standardQuadGatePins,
);

const IcPinInfo ic7402Pins = IcPinInfo(
  icNumber: 'IC7402',
  chipDescription: 'Quad 2-input NOR gate',
  pinLabels: _norQuadGatePins,
);

const IcPinInfo ic7486Pins = IcPinInfo(
  icNumber: 'IC7486',
  chipDescription: 'Quad 2-input XOR gate',
  pinLabels: _standardQuadGatePins,
);

const IcPinInfo ic74266Pins = IcPinInfo(
  icNumber: 'IC74266',
  chipDescription: 'Quad 2-input XNOR gate (open-collector outputs)',
  pinLabels: _xnorQuadGatePins,
);
