import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:meal_planning/utils/styles.dart';

class KMealTileWidget extends StatelessWidget {
  const KMealTileWidget({
    Key? key,
    required this.imgPath,
    required this.title,
    required this.onTap,
    required this.onLogPress,
  }) : super(key: key);

  final String? imgPath;
  final String title;
  final void Function() onTap;
  final void Function() onLogPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // long press to delete
      onTap: onTap,
      onLongPress: onLogPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        width: double.infinity,
        // should i give a max height?
        // height: height,

        decoration: BoxDecoration(
            border: Border.all(width: 1, color: kClrPrimary),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            )),
        //
        child: Row(
          children: [
            imgPath != null && imgPath!.isNotEmpty
                ? buildRecipeImage()
                : buildDefaultImage(),
            const SizedBox(width: 10),
            _buildMealTitle(),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  SizedBox _buildMealTitle() {
    return SizedBox(
      width: 200,
      child: Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: kSmallText.copyWith(color: kClrPrimary),
      ),
    );
  }

  Image buildDefaultImage() {
    return Image.asset(
      'assets/icons/app_icons/dish.png',
      width: 30,
      height: 30,
    );
  }

  ClipRRect buildRecipeImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Image.file(
        File(imgPath!),
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      ),
    );
  }
}
