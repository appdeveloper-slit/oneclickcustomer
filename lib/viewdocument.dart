import 'package:flutter/material.dart';
import 'package:one_click/values/dimens.dart';

class viewdocument extends StatefulWidget {
  final img;

  const viewdocument({super.key, this.img});

  @override
  State<viewdocument> createState() => _viewdocumentState();
}

class _viewdocumentState extends State<viewdocument> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: Dim().d350,
          width: double.infinity,
          child: Image.network(widget.img, fit: BoxFit.cover),
        ),
      ],
    );
  }
}
