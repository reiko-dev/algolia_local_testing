import 'package:algolia_local_testing/hits_and_facet_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HitsAndFacetSearch extends StatefulWidget {
  const HitsAndFacetSearch({super.key});

  @override
  State<HitsAndFacetSearch> createState() => _HitsAndFacetSearchState();
}

class _HitsAndFacetSearchState extends State<HitsAndFacetSearch> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HitsAndFacetSearchController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextField(
              onChanged: (input) {
                // facetSearcher.query(input);
                controller.search(input);
              }, // 3. Run your search operations
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      body: Column(children: [
        // const Header(title: 'Brands'),
        // Expanded(
        //   child: StreamBuilder<FacetSearchResponse>(
        //     // Listen and display facet search results
        //     stream: facetSearcher.responses,
        //     builder: (
        //       BuildContext context,
        //       AsyncSnapshot<FacetSearchResponse> snapshot,
        //     ) {
        //       if (snapshot.hasData) {
        //         final response = snapshot.data;
        //         final facets = response?.facetHits.toList() ?? [];
        //         return ListView.builder(
        //           itemCount: facets.length,
        //           itemBuilder: (BuildContext context, int index) {
        //             final facet = facets[index];
        //             return ListTile(
        //               title: RichText(
        //                 text: TextSpan(
        //                   style: Theme.of(context).textTheme.titleSmall,
        //                   children: facet.getHighlightedString().toInlineSpans()
        //                     ..add(TextSpan(text: '(${facet.count})')),
        //                 ),
        //               ),
        //             );
        //           },
        //         );
        //       } else {
        //         return const CircularProgressIndicator();
        //       }
        //     },
        //   ),
        // ),
        // const FiltersWidget(),
        const Divider(),
        const Header(title: 'Items'),
        Expanded(
          child: StreamBuilder<List<Company>>(
            // Listen and display hits search results
            stream: controller.companies,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                final list = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    final company = list[index];
                    return ListTile(
                      title: Text(
                        company.name ?? company.cnpj ?? company.id,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        )
      ]),
    );
  }
}

class Header extends StatelessWidget {
  final String title;

  const Header({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
