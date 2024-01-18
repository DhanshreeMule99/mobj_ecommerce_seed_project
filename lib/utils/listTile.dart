import 'package:flutter/material.dart';

class MobjListTile extends StatefulWidget {
  final GestureTapCallback onTap;
  final String title;
  final Widget? leading;
final Widget? trailing;
  const MobjListTile({
    Key? key,
    required this.onTap,
    required this.title,  this.leading, this.trailing,
  }) : super(key: key);

  @override
  State<MobjListTile> createState() => _MobjListTiletate();
}

class _MobjListTiletate extends State<MobjListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: widget.leading,
        title: Text(widget.title),
        trailing: widget.trailing,
        onTap: widget.onTap);
  }
}
