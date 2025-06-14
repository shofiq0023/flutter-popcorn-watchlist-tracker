import 'package:flutter/material.dart';
import 'package:popcorn/models/entities/entry_category.dart';
import 'package:popcorn/providers/entry_category_provider.dart';
import 'package:popcorn/widgets/entry_category_widget.dart';
import 'package:provider/provider.dart';

class EntryCategoryComponent extends StatefulWidget {
  const EntryCategoryComponent({super.key});

  @override
  State<EntryCategoryComponent> createState() => _EntryCategoryComponentState();
}

class _EntryCategoryComponentState extends State<EntryCategoryComponent> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EntryCategoryProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<List<EntryCategory>>(
          future: provider.categoryList,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No categories found'));
            }

            final entries = snapshot.data!;

            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                left: 5.0,
                right: 5.0,
                top: 5.0,
                bottom: 60.0,
              ),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                return EntryCategoryItemWidget(entryCategory: entries[index]);
              },
            );
          },
        );
      },
    );
  }
}
