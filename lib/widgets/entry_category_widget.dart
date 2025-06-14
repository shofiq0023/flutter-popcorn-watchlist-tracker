import 'package:flutter/material.dart';
import 'package:popcorn/models/entities/entry_category.dart';

class EntryCategoryItemWidget extends StatefulWidget {
  final EntryCategory entryCategory;
  const EntryCategoryItemWidget({super.key, required this.entryCategory});

  @override
  State<EntryCategoryItemWidget> createState() => _EntryCategoryItemWidgetState();
}

class _EntryCategoryItemWidgetState extends State<EntryCategoryItemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Text(widget.entryCategory.categoryName),
    );
  }
}
