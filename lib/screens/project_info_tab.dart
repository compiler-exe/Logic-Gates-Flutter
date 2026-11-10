import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../data/logic_blocks_data.dart';
import '../data/project_info.dart';
import '../models/block_category.dart';
import '../widgets/app_logo.dart';
import '../widgets/section_card.dart';

// The Home tab: the project details and a short guide.
class ProjectInfoTab extends StatelessWidget {
  const ProjectInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final int gateCount = blocksInCategory(BlockCategory.gates).length;
    final int nandCount = blocksInCategory(BlockCategory.nandCircuits).length;
    final int norCount = blocksInCategory(BlockCategory.norCircuits).length;
    final int adderCount = blocksInCategory(BlockCategory.adders).length;
    final int subtractorCount =
        blocksInCategory(BlockCategory.subtractors).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
      child: Column(
        children: [
          const AppLogo(size: 84),
          const SizedBox(height: 20),
          Text(
            ProjectInfo.appName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: palette.primaryDark,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            ProjectInfo.projectTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: palette.headingText,
              decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(height: 24),
          _buildInfoLine('Topic', ProjectInfo.topic, palette),
          _buildInfoLine('Subject Code', ProjectInfo.subjectCode, palette),
          _buildInfoLine('Made by', ProjectInfo.groupName, palette),
          _buildMembersList(palette),
          const SizedBox(height: 16),
          SectionCard(
            heading: 'How to use this app',
            child: Text(
              'The app has $gateCount logic gates (with their ICs), '
              '$nandCount gate circuits built from NAND gates, '
              '$norCount gate circuits built from NOR gates, '
              '$adderCount adders and $subtractorCount subtractors. '
              'NAND and NOR are called universal gates because every other '
              'gate can be built from them. Open a tab to see each circuit.\n\n'
              'Tap an input circle to switch it between 0 (red) and '
              '1 (green). The output circles change instantly, and the '
              'matching row of the truth table is highlighted.',
              style: TextStyle(
                fontSize: 16,
                height: 1.45,
                color: palette.bodyText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // One line such as "Subject Code : EC2700".
  Widget _buildInfoLine(String name, String value, AppPalette palette) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        '$name : $value',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: palette.bodyText,
        ),
      ),
    );
  }

  // The numbered list of group members with their roll numbers.
  Widget _buildMembersList(AppPalette palette) {
    final TextStyle memberStyle = TextStyle(
      fontSize: 17,
      height: 1.3,
      fontWeight: FontWeight.w600,
      color: palette.bodyText,
    );

    final List<Widget> rows = [];
    for (int i = 0; i < ProjectInfo.members.length; i++) {
      final GroupMember member = ProjectInfo.members[i];
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 28,
                child: Text('${i + 1}.', style: memberStyle),
              ),
              SizedBox(
                width: 104,
                child: Text(member.rollNumber, style: memberStyle),
              ),
              Expanded(
                child: Text(member.name, style: memberStyle),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Group members :',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: palette.bodyText,
                ),
              ),
              const SizedBox(height: 10),
              ...rows,
            ],
          ),
        ),
      ),
    );
  }
}
