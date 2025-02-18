import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget centerSvgIcon({required String path, String? text}) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.only(top: 3, bottom: 7),
        child: SvgPicture.asset(
          path,
          width: 80,
          height: 80,
        ),
      ),
      if(text!=null) ...[
        SizedBox(height: 7),
        Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ],
  );
}

Widget centerPngIcon({required String path, String? text}) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 3),
        child: Image.asset(
          path,
          width: 80,
          height: 80,
        ),
      ),
      if(text!=null) ...[
        SizedBox(height: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ],
  );
}