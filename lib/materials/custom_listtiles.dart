import 'package:doramed/materials/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ItemTileSet extends StatelessWidget {
  const ItemTileSet({
    super.key,
    required this.title,
    this.icon,
    this.trailing,
    this.leading,
    required this.haveBorder,
    required this.ontap,
    this.textTrailing,
    this.selected = false,
    this.dense = true,
    this.backColor = CustomColors.ten,
  });

  final String title;
  final IconData? icon;
  final Widget? trailing;
  final Widget? leading;
  final String? textTrailing;
  final bool haveBorder;
  final Color backColor;
  final bool dense;
  final bool selected;
  final void Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: haveBorder
            ? Border(
                bottom: BorderSide(
                  color: backColor == CustomColors.ten
                      ? CustomColors.back
                      : CustomColors.ten,
                  width: 1,
                ),
              )
            : null,
      ),
      child: Material(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          dense: dense,
          selected: selected,
          selectedTileColor: CustomColors.back,
          shape: const RoundedRectangleBorder(),
          trailing: textTrailing != null
              ? _trailingTextTile(textTrailing!)
              : trailing,
          leading: leading ??
              (icon != null
                  ? HugeIcon(
                      icon: icon!,
                      color: CustomColors.eight,
                      size: 24.0,
                    )
                  : null),
          tileColor: backColor,
          onTap: ontap,
          title: Text(
            title,
            overflow: TextOverflow.fade,
            style: const TextStyle(
              color: CustomColors.eight,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _trailingTextTile(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: CustomColors.six,
        fontSize: 14,
      ),
    );
  }
}
