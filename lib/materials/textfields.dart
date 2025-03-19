import 'package:doramed/materials/theme/colors.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String? labelName;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Key? fieldKey;
  final Widget? suffixWidget;
  final int? maxLines;
  final bool aboveLabel;
  final bool enabeld;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChange;

  const MyTextField({
    super.key,
    required this.keyboardType,
    required this.controller,
    this.labelName,
    this.aboveLabel = false,
    this.enabeld = true,
    this.fieldKey,
    this.obscureText = false,
    this.maxLines,
    this.suffixWidget,
    this.validator,
    this.onChange,
  });

  static const BorderRadius borderShape = BorderRadius.all(
    Radius.circular(4),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: labelName != null ? aboveLabel : false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              labelName != null ? labelName! : '',
              style: const TextStyle(
                color: CustomColors.nine,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Directionality(
          textDirection: TextDirection.ltr,
          child: TextFormField(
            key: fieldKey,
            controller: controller,
            // maxLength: 50,
            obscureText: obscureText,
            maxLines: maxLines,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            enabled: enabeld,
            onChanged: onChange,
            textAlignVertical: TextAlignVertical.center,
            autofocus: false,
            decoration: InputDecoration(
              // isDense: true,
              suffix: suffixWidget,

              fillColor: enabeld ? CustomColors.one : CustomColors.two,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: CustomColors.two,
                  width: 0.5,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: borderShape,
                borderSide: BorderSide(
                  color: CustomColors.six,
                  width: 0.5,
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: borderShape,
                borderSide: BorderSide(
                  color: CustomColors.two,
                  width: 0.5,
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderRadius: borderShape,
                borderSide: BorderSide(
                  color: CustomColors.tronred,
                  width: 0.5,
                ),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                borderSide: BorderSide(
                  color: CustomColors.tronred,
                  width: 0.5,
                ),
              ),
              disabledBorder: const OutlineInputBorder(
                borderRadius: borderShape,
                borderSide: BorderSide(
                  color: CustomColors.two,
                  width: 0.5,
                ),
              ),
              errorStyle: const TextStyle(
                fontSize: 12,
                color: CustomColors.tronred,
              ),
              labelText: aboveLabel ? null : labelName,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: const TextStyle(
                color: CustomColors.nine,
                // fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            cursorColor: CustomColors.selc,
            style: enabeld
                ? const TextStyle(
                    color: CustomColors.eight,
                    fontSize: 16,
                  )
                : const TextStyle(
                    color: CustomColors.six,
                    fontSize: 16,
                  ),
            keyboardType: keyboardType,
          ),
        ),
      ],
    );
  }
}

class SetTextFormField extends StatelessWidget {
  final TextInputType keyboardType;
  final int? maxLines;
  final String? hintText;
  final TextEditingController controller;
  final Key? fieldKey;
  final String? Function(String?)? validator;
  final void Function(String)? onChange;

  const SetTextFormField({
    super.key,
    required this.keyboardType,
    required this.controller,
    this.hintText,
    this.maxLines,
    this.fieldKey,
    this.validator,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey,
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlignVertical: TextAlignVertical.center,
      cursorColor: CustomColors.eight,
      autofocus: false,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: CustomColors.three,
          fontSize: 16,
        ),
        isDense: true,
        border: InputBorder.none,
        errorStyle: const TextStyle(
          color: CustomColors.tronred,
          fontSize: 12,
        ),
        contentPadding: const EdgeInsets.only(top: 4),
      ),
      style: const TextStyle(
        color: CustomColors.eight,
        fontSize: 16,
      ),
      validator: validator,
      onChanged: onChange,
    );
  }
}
