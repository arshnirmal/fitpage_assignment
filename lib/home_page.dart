import 'dart:convert';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:fitpage_assignment/data_model.dart';
import 'package:fitpage_assignment/details_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Items> items = [];
  bool isDataLoading = false;

  getData() async {
    setState(() {
      isDataLoading = true;
    });
    final response = await http.get(Uri.parse('http://coding-assignment.bombayrunning.com/data.json'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        items.addAll(data.map<Items>((json) => Items.fromJson(json)).toList());
        isDataLoading = false;
      });
    }
    // debugPrint(response.body);
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Page',
        ),
      ),
      body: isDataLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                color: Theme.of(context).primaryColor,
                child: ListView.builder(
                  itemCount: items.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsPage(
                                  item: item,
                                ),
                              ),
                            );
                          },
                          title: Text(
                            item.name,
                            style: Theme.of(context).textTheme.titleMedium!.merge(
                                  const TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                  ),
                                ),
                          ),
                          subtitle: Text(
                            item.tag,
                            style: Theme.of(context).textTheme.titleSmall!.merge(
                                  TextStyle(
                                    color: item.color == 'red'
                                        ? const Color.fromRGBO(255, 0, 0, 1)
                                        : item.color == 'green'
                                            ? const Color.fromRGBO(0, 255, 0, 1)
                                            : const Color.fromRGBO(0, 0, 255, 1),
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                  ),
                                ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: DottedDecoration(
                            shape: Shape.line,
                            linePosition: LinePosition.bottom,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
    );
  }
}