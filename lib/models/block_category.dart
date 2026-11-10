// The groups of circuits shown in the app.
// Each group has its own tab.
enum BlockCategory {
  gates,
  nandCircuits,
  norCircuits,
  adders,
  subtractors,
}

extension BlockCategoryLabel on BlockCategory {
  // Text shown on the tab.
  String get label {
    switch (this) {
      case BlockCategory.gates:
        return 'Gates';
      case BlockCategory.nandCircuits:
        return 'Using NAND';
      case BlockCategory.norCircuits:
        return 'Using NOR';
      case BlockCategory.adders:
        return 'Adders';
      case BlockCategory.subtractors:
        return 'Subtractors';
    }
  }
}
