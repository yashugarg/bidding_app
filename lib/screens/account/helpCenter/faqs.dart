import 'package:flutter/material.dart';

class FAQs extends StatefulWidget {
  @override
  _FAQsState createState() => _FAQsState();
}

class _FAQsState extends State<FAQs> {
  @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          leading: new IconButton(icon: Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.of(context).pop()),
          backgroundColor: Color(0xFF4A3298),
          title:
              Text('FAQs', style: TextStyle(fontSize: 19, color: Colors.white)),
          actions: <Widget>[
            
            new IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: null)
          ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) =>
            EntryItem(data[index]),
        itemCount: data.length,
      ),
    )
    );
  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
}

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
  Entry(
    'Question',
    <Entry>[
      Entry('Answer '),
    ],
  ),
  Entry(
    'Question',
    <Entry>[
      Entry('Answer'),
    ],
  ),
  Entry(
    'Question',
    <Entry>[
      Entry('Answer'),
    ],
  ),
  Entry(
    'Question',
    <Entry>[
      Entry('Answer'),
    ],
  ),
  Entry(
    'Question',
    <Entry>[
      Entry('Answer'),
    ],
  ),
  Entry(
    'Question',
    <Entry>[
      Entry('Answer'),
    ],
  ),
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty)
      return ListTile(
          title: Text(root.title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500)));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(
        root.title,
        style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400),
      ),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}