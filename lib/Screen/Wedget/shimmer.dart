import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmer() {
  return ListView.builder(
    itemCount: 5,
    itemBuilder: (_, __) => Padding(
      padding: const EdgeInsets.all(10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          children: [
            CircleAvatar(radius: 30, backgroundColor: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 10, color: Colors.white),
                  SizedBox(height: 6),
                  Container(height: 10, width: 150, color: Colors.white),
                  SizedBox(height: 6),
                  Container(height: 10, width: 100, color: Colors.white),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}