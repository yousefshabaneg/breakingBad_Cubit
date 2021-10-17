import 'package:flutter/material.dart';
import 'package:flutter_breaking/constants/my_colors.dart';

Widget showLoadingIndicator() => Center(
      child: CircularProgressIndicator(
        color: MyColors.yellow,
      ),
    );
