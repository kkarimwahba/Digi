import 'package:flutter/material.dart';

Widget buildSegmentedProgressBar(
    {required List<String> questions, required int currentQuestionIndex}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: List.generate(
        questions.length,
        (index) => Expanded(
          child: Container(
            height: 10,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5),
              color: (index <= currentQuestionIndex)
                  ? Colors.black
                  : Colors.transparent,
            ),
          ),
        ),
      ),
    ),
  );
}
