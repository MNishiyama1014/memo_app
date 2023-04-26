import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:memo_app/pages/all_memos_page.dart';
import '../models/memo.dart';
import '../widgets/memo_tile.dart';

class MemoListView extends StatefulWidget {
  final List<Memo> memos;
  final Function(Memo) onMemoTapped;
  final Function(Memo) onFavoriteTapped;
  final Function(Memo)? onDeleteTapped;
  final Function(Memo)? onRestoreTapped;
  final Function(Memo)? onDeletePermanentlyTapped;

  const MemoListView({
    super.key,
    required this.memos,
    required this.onMemoTapped,
    required this.onFavoriteTapped,
    this.onDeleteTapped,
    this.onRestoreTapped,
    this.onDeletePermanentlyTapped,
  });

  @override
  State<MemoListView> createState() => _MemoListViewState();
}

class _MemoListViewState extends State<MemoListView> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.memos.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            if (widget.onDeleteTapped != null)
              Dismissible(
                // Each Dismissible must contain a Key. Keys allow Flutter to
                // uniquely identify widgets.
                key: UniqueKey(),
                // Provide a function that tells the app
                // what to do after an item has been swiped away.
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart)
                    // Remove the item from the data source.
                    widget.onDeleteTapped!(widget.memos[index]);

                  // Then show a snackbar.
                  String temp_str = widget.memos[index].title;
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$temp_str deleted')));
                },
                // Show a red background as the item is swiped away.
                background: const ColoredBox(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                ),
                secondaryBackground: const ColoredBox(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                ),
                child: InkWell(
                  child: MemoTile(
                    memo: widget.memos[index],
                    onTap: () {
                      widget.onMemoTapped(widget.memos[index]);
                    },
                    onFavoriteTapped: () {
                      widget.onFavoriteTapped(widget.memos[index]);
                    },
                  ),
                ),
              ),
            if (widget.onRestoreTapped != null ||
                widget.onDeletePermanentlyTapped != null)
              Dismissible(
                // Each Dismissible must contain a Key. Keys allow Flutter to
                // uniquely identify widgets.
                key: UniqueKey(),
                // Provide a function that tells the app
                // what to do after an item has been swiped away.
                onDismissed: (direction) {
                  // Remove the item from the data source.
                  if (direction == DismissDirection.startToEnd)
                    widget.onRestoreTapped!(widget.memos[index]);
                  else if (direction == DismissDirection.endToStart)
                    widget.onDeletePermanentlyTapped!(widget.memos[index]);

                  // Then show a snackbar.
                  String temp_str = widget.memos[index].title;
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$temp_str restored')));
                },
                // Show a red background as the item is swiped away.
                background: const ColoredBox(
                  color: Colors.green,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(Icons.restore, color: Colors.white),
                    ),
                  ),
                ),
                secondaryBackground: const ColoredBox(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                ),
                child: InkWell(
                  child: MemoTile(
                    memo: widget.memos[index],
                    onTap: () {
                      widget.onMemoTapped(widget.memos[index]);
                    },
                    onFavoriteTapped: () {
                      widget.onFavoriteTapped(widget.memos[index]);
                    },
                  ),
                ),
              ),
            const Divider(height: 0),
          ],
        );
      },
    );
  }
}
