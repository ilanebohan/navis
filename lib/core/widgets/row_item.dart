import 'package:flutter/material.dart';

class RowItem extends StatelessWidget {
  const RowItem({
    this.icons = const <Widget>[],
    @required this.text,
    @required this.child,
    this.padding,
    this.size,
  });

  factory RowItem.richText(
      {String title, String richText, Color color, double size}) {
    return RowItem(
      text: Text(title),
      child: Text(
        richText,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: size,
          color: color,
        ),
      ),
    );
  }

  final List<Widget> icons;
  final Widget text;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double size;

  @override
  Widget build(BuildContext context) {
    final _icons = icons.map((icon) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: icon,
      );
    });

    return Container(
      margin: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          ..._icons,
          text,
          const Spacer(),
          Expanded(child: child)
        ],
      ),
    );
  }
}
