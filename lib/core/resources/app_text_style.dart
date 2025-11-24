import 'package:flutter/material.dart';
import 'package:ecommerce/core/resources/app_colors.dart';

class AppTextStyle {
  AppTextStyle._();

  static const TextStyle darkGreyColor24ExtraBold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.darkGreyColor,
  );
  static const TextStyle darkGreyColor14Medium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.darkGreyColor,
  );
  static const TextStyle whiteColor16Bold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.whiteColor,
  );
}
