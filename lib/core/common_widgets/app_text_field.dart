import 'package:flutter/material.dart';
import 'package:ecommerce/core/resources/app_colors.dart';
import 'package:ecommerce/core/resources/app_text_style.dart';
import 'package:ecommerce/core/utils/app_validation.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.isPassword = false,
    required this.hint,
    required this.controller,
    this.validator,  this.isReadOnly = false,
  });

  final String label;
  final bool isPassword;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isReadOnly;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyle.darkGreyColor14Medium),
        TextFormField(readOnly: widget.isReadOnly ?? false,
          validator:
              widget.validator ??
              (value) => AppValidation.validateNotEmpty(
                widget.controller.text,
                widget.label,
              ),
          controller: widget.controller,
          keyboardType: widget.isPassword
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
          obscureText: widget.isPassword && !isVisible,
          decoration: InputDecoration(
            hintText: widget.hint,
            filled: true,
            fillColor: AppColors.lightPurpleColor,
            border: _getBorder(),
            enabledBorder: _getBorder(),
            focusedBorder: _getBorder(color: AppColors.greenColor),
            errorBorder: _getBorder(color: AppColors.redColor),
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    icon: isVisible
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _getBorder({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );
  }
}
