import 'package:doramed/materials/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ScreenWidget extends StatelessWidget {
  final List<Widget> content;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;

  const ScreenWidget({
    super.key,
    required this.content,
    this.padding,
    this.height,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding == null
          ? const EdgeInsets.symmetric(horizontal: 12, vertical: 12)
          : padding!,
      child: SingleChildScrollView(
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: mainAxisAlignment == null
                ? MainAxisAlignment.start
                : mainAxisAlignment!,
            crossAxisAlignment: crossAxisAlignment == null
                ? CrossAxisAlignment.center
                : crossAxisAlignment!,
            children: content,
          ),
        ),
      ),
    );
  }
}

// used in main page(home screen)
class BoxWidget extends StatelessWidget {
  final Widget child;
  final Color backColor;

  const BoxWidget({
    super.key,
    required this.child,
    required this.backColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: const BoxConstraints(
      //   maxWidth: 480,
      // ),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

class ChangeBoxSetWidget extends StatelessWidget {
  final String? title;
  final bool actiaveTitlePadding;
  final Widget content;
  final String? description;
  final String? upDescription;

  const ChangeBoxSetWidget({
    super.key,
    this.title,
    this.actiaveTitlePadding = false,
    required this.content,
    this.description,
    this.upDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: upDescription != null,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 0,
              bottom: 12,
            ),
            child: SizedBox(
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  upDescription != null ? upDescription! : '',
                  maxLines: 10,
                  textAlign: TextAlign.justify,
                  softWrap: true,
                  style: const TextStyle(
                    color: CustomColors.six,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Visibility(
        //   visible: upDescription != null,
        //   child: const SizedBox(height: 12),
        // ),
        Container(
          width: double.infinity,
          color: CustomColors.ten,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                visible: title != null,
                child: Padding(
                  padding: actiaveTitlePadding
                      ? const EdgeInsets.only(
                          bottom: 12,
                        )
                      : EdgeInsets.zero,
                  child: Text(
                    title != null ? title! : '',
                    style: const TextStyle(
                      color: CustomColors.selc,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              content,
            ],
          ),
        ),
        Visibility(
          visible: description == null,
          child: const SizedBox(height: 12),
        ),
        Visibility(
          visible: description != null,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 6,
              bottom: 12,
            ),
            child: SizedBox(
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  description != null ? description! : '',
                  maxLines: 10,
                  textAlign: TextAlign.justify,
                  softWrap: true,
                  style: const TextStyle(
                    color: CustomColors.six,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

void showCustomMBottomSheet({
  required BuildContext context,
  required Widget content,
  String? pageName,
  void Function()? onOut,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    backgroundColor: CustomColors.back,
    isScrollControlled: true,
    builder: (context) {
      return IntrinsicHeight(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 24,
                left: 12,
                right: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  IconButton(
                    onPressed: onOut,
                    padding: EdgeInsets.zero,
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                    ),
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedCancel01,
                      color: CustomColors.eight,
                      size: 24.0,
                    ),
                  ),
                  const Spacer(),
                  Visibility(
                    visible: pageName != null ? true : false,
                    child: Text(
                      pageName ?? '',
                      style: const TextStyle(
                        color: CustomColors.nine,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            content,
          ],
        ),
      );
    },
  );
}
