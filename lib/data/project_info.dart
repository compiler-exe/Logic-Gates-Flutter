// One member of the group.
class GroupMember {
  final String rollNumber;
  final String name;

  const GroupMember({required this.rollNumber, required this.name});
}

// The details shown on the Home tab.
class ProjectInfo {
  static const String appName = 'Logic-Gates-Flutter';
  static const String groupName = 'Group 3';
  static const String projectTitle = 'BASIC ELECTRONICS LAB PROJECT';
  static const String topic = 'IMPLEMENTATION OF LOGIC GATES, ADDERS & SUBTRACTORS';
  static const String subjectCode = 'EC2700';

  // The five members, in the order shown on the Home tab.
  static const List<GroupMember> members = [
    GroupMember(rollNumber: '125CS0104', name: 'Subhrajit Giri'),
    GroupMember(rollNumber: '125CS0105', name: 'Nelli Varshini'),
    GroupMember(rollNumber: '125CS0106', name: 'Luiston Nayak'),
    GroupMember(rollNumber: '125CS0107', name: 'Amrut Kalappa Yadavannavar'),
    GroupMember(rollNumber: '125CS0108', name: 'Gadum Roopesh Dora'),
  ];
}
