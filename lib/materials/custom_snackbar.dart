import 'package:doramed/materials/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

void showAdvancedSnackBar(
  BuildContext context,
  bool isMainCoin,
  String message,
) {
  final snackBar = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        HugeIcon(
          icon: HugeIcons.strokeRoundedInformationCircle,
          color: isMainCoin ? CustomColors.tronred : CustomColors.usdt,
          size: 18.0,
        ),
        const SizedBox(width: 6),
        Text(
          message,
          overflow: TextOverflow.ellipsis,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 12,
            color: isMainCoin ? CustomColors.eight : CustomColors.ten,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
    dismissDirection: DismissDirection.horizontal,
    backgroundColor: isMainCoin
        ? CustomColors.three.withOpacity(0.9)
        : CustomColors.six.withOpacity(0.9),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showTopSnackBar(BuildContext context, String message) {
  // Create an OverlayEntry to insert the Snackbar at the top of the screen
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50, // Position the SnackBar at the top, adjust as needed
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl, // Set your text direction here
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedInformationCircle,
                  color: CustomColors.tronred,
                  size: 18.0,
                ),
                const SizedBox(width: 6),
                Text(
                  message,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 12,
                    color: CustomColors.ten,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  // Insert the OverlayEntry into the Overlay
  overlay.insert(overlayEntry);

  // Remove the Snackbar after a delay (e.g., 3 seconds)
  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}
