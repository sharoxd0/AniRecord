import 'package:anirecord/presentation/utils/const.dart';
import 'package:flutter/material.dart';

Widget pointSecction(String title) {
  return Padding(
    padding: const EdgeInsets.only(left: 14, top: 8),
    child: Row(
      children: [
        Container(
          color: Colors.white,
          child: const Icon(
            Icons.circle,
            color:colorPrimaryInverted,
            size: 20,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        )
      ],
    ),
  );
}

Widget secction(int count) {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0),
    child: Row(
      children: [
        Container(
          color: Colors.white,
          child: const Icon(
          Icons.add_box,
            color: colorPrimaryInverted,
            size: 30,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Text(
            "$count NUEVAS SERIES",
            style: const TextStyle(fontSize: 16,),
          ),
        )
      ],
    ),
  );
}

Widget divider() {
  return const Padding(
    padding: EdgeInsets.only(left: 16.0),
    child: VerticalDivider(
      thickness: 3,
      color: Color(0xffd7d7d7),
    ),
  );
}
