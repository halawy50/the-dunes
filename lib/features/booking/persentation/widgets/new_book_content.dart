import 'package:flutter/material.dart';
import 'package:the_dunes/features/booking/persentation/widgets/new_book_header.dart';
import 'package:the_dunes/features/booking/persentation/widgets/new_book_table.dart';

class NewBookContent extends StatelessWidget {
  const NewBookContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const NewBookHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: const NewBookTable(),
            ),
          ),
        ],
      ),
    );
  }
}

