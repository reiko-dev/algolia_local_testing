import 'package:algolia_local_testing/hits_and_facet_search.dart';
import 'package:algolia_local_testing/hits_and_facet_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Algolia Helpers for Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider.value(
        value: HitsAndFacetSearchController(),
        child: const HitsAndFacetSearch(),
      ),
    );
  }
}
