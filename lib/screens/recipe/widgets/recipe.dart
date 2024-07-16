import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_planning/screens/recipe/bloc/recipe_bloc.dart';
import 'package:meal_planning/utils/styles.dart';

class KRecipeWidget extends StatelessWidget {
  const KRecipeWidget({
    Key? key,
    required this.sizeConfig,
    required this.imgPath,
    required this.title,
    required this.onLongPress,
    required this.onTap,
    required this.isFav,
    required this.updateFav,
  }) : super(key: key);

  final SizeConfig sizeConfig;
  final String? imgPath;
  final String title;
  final void Function() onLongPress;
  final void Function() onTap;
  final void Function() updateFav;
  final bool isFav;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        height: sizeConfig.blockSizeVer * 8,

        decoration: BoxDecoration(
            color: kClrSecondary,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            )),
        //
        child: Row(
          children: [
            imgPath != null ? buildRecipeImage() : buildDefaultImage(),
            const SizedBox(width: 10),
            _buildMealTitle(),
            const Spacer(),
            _buildFavIcon(),
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

  GestureDetector _buildFavIcon() {
    return GestureDetector(
      onTap: updateFav,
      child: SizedBox(
          child: isFav
              ? _buildImage('assets/icons/app_icons/fav.png')
              : _buildImage('assets/icons/app_icons/no-fav.png')),
    );
  }

  Image _buildImage(String img) {
    return Image.asset(
      img,
      width: 20,
      height: 20,
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
