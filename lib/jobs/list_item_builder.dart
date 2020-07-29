//import 'dart:js';
//
//import 'package:TimeTracker/widgets/empty_content_widget.dart';
//import 'package:flutter/material.dart';
//
//typedef itemWidgetBuilder<T> = Widget Function(BuildContext context, T item);
//
//class ListItemBuilder extends StatelessWidget {
//  ListItemBuilder({@required this.snapshot, @required this.itemBuilder});
//  final AsyncSnapshot<List<T>> snapshot;
//  final itemWidgetBuilder<T> itemBuilder;
//
//  @override
//  Widget build(BuildContext context) {
//    if (snapshot.connectionState == ConnectionState.waiting) {
//      return Center(child: CircularProgressIndicator());
//    } else if (snapshot.connectionState == ConnectionState.active) {
//      if (snapshot.data.length != 0) {
//        final List<T> items = snapshot.data;
//        return _buildList(items);
//      } else {
//        return EmptyScreen(
//          title: 'Nothing Here.',
//          message: 'Add a new Job to get started.',
//        );
//      }
//    } else if (snapshot.hasError) {
//      return EmptyScreen(
//        title: "That's an error.",
//        message: 'Something went wrong. Please try later.',
//      );
//    }
//  }
//
//  Widget _buildList(List<T> items) {
//    return ListView.builder(
//      itemCount: items.length,
//      itemBuilder: (context, index) => itemBuilder(context, items[index]),
//    );
//  }
//}
