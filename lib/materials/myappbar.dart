import 'package:doramed/materials/theme/colors.dart';
import 'package:flutter/material.dart';

class PublicAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String pageName;
  final Widget? leading;
  final TextStyle? titleStyle;
  final List<Widget>? actions;
  final bool activeCheckButton;
  final void Function()? onTapCheckButton;

  const PublicAppBar({
    super.key,
    required this.pageName,
    this.leading,
    this.titleStyle,
    this.activeCheckButton = false,
    this.onTapCheckButton,
    this.actions,
  });

  @override
  State<PublicAppBar> createState() => _PublicAppBarState();

  @override
  Size get preferredSize {
    return const Size.fromHeight(kToolbarHeight + 0);
  }
}

class _PublicAppBarState extends State<PublicAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CustomColors.back,
      leading: widget.leading,
      title: Text(
        widget.pageName,
        style: widget.titleStyle ??
            const TextStyle(
              fontSize: 18,
              color: CustomColors.nine,
              fontWeight: FontWeight.w600,
            ),
      ),
      actions: widget.activeCheckButton
          ? <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.check,
                  color: CustomColors.selc,
                ),
                onPressed: widget.onTapCheckButton,
              ),
            ]
          : widget.actions,
    );
  }
}
