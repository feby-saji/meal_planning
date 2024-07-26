import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_planning/repository/firestore.dart';
import 'package:meal_planning/screens/account/account.dart';
import 'package:meal_planning/screens/family/family.dart';
import 'package:meal_planning/screens/meal_plan.dart/functions/show_del_dialog.dart';
import 'package:meal_planning/screens/recipe/bloc/recipe_bloc.dart';
import 'package:meal_planning/screens/shopping_list/bloc/shopping_list_bloc.dart';
import 'package:meal_planning/utils/styles.dart';

class KAppBarWidget extends StatelessWidget {
  const KAppBarWidget({
    super.key,
    required this.sizeConfig,
    required this.title,
    required this.imgPath,
    this.backBtn = false,
    this.deleteIconVisibility = false,
    this.syncIconVisibility = false,
    this.sortIconVisibility = false,
  });

  final SizeConfig sizeConfig;
  final String title;
  final String? imgPath;
  final bool backBtn;
  final bool deleteIconVisibility;
  final bool syncIconVisibility;
  final bool sortIconVisibility;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: sizeConfig.blockSizeVer * 12,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 45),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBackBtn(context),
              Text(
                title,
                style: kMedText.copyWith(color: kClrPrimary),
              ),
              Row(
                children: [
                  _buildSyncShoppingListIcon(context),
                  _buildDeleteIcon(context),
                  _buildSortIcon(context),
                  const SizedBox(width: 10),
                  _buildSettingsIcon(context),
                ],
              )
            ],
          ),
        ));
  }

  Visibility _buildBackBtn(BuildContext context) {
    return Visibility(
        visible: backBtn,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            'assets/icons/app_icons/left-chevron.png',
            width: 38,
          ),
        ));
  }

  Visibility _buildDeleteIcon(BuildContext context) {
    return Visibility(
      visible: deleteIconVisibility,
      child: IconButton(
          onPressed: () => showDeleteConfirmation(
                context: context,
                contetText: 'Are you sure you want to clear Shopping List? ',
                onPressed: () => [
                  context
                      .read<ShoppingListBloc>()
                      .add(ClearShoppingListItemsEvent()),
                  Navigator.pop(context)
                ],
              ),
          icon: Icon(
            Icons.delete,
            color: kClrPrimary,
          )),
    );
  }

  Visibility _buildSortIcon(BuildContext context) {
    return Visibility(
        visible: sortIconVisibility,
        child: IconButton(
          onPressed: () {
            // Get the position of the sort icon
            final RenderBox overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;
            final RenderBox button = context.findRenderObject() as RenderBox;
            final Offset position =
                button.localToGlobal(Offset.zero, ancestor: overlay);

            // Calculate the horizontal position for the dropdown menu
            final double screenWidth = MediaQuery.of(context).size.width;
            const double menuWidth = 200.0;
            final double menuX = (screenWidth - menuWidth) / 2;
            // Show the dropdown menu
            showMenu<String>(
              context: context,
              position: RelativeRect.fromLTRB(
                  menuX, position.dy + button.size.height, 0, 0),
              items: <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: '1',
                  child: Text('All recipes'),
                ),
                const PopupMenuItem<String>(
                  value: '2',
                  child: Text('Favorite'),
                ),
              ],
            ).then((String? value) {
              if (value != null) {
                isFavPage = value == '1' ? false : true;
                context
                    .read<RecipeBloc>()
                    .add(SortRecipesEvent(fav: value == '1' ? false : true));
              }
            });
          },
          icon: Icon(
            Icons.sort,
            color: kClrPrimary,
          ),
        ));
  }

  GestureDetector _buildSettingsIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AccountScreen()));
      },
      child: imgPath != null
          ? Image.asset(
              imgPath!,
              width: 25,
              height: 25,
            )
          : const SizedBox(),
    );
  }

  _buildSyncShoppingListIcon(BuildContext context) {
    return Visibility(
      visible: syncIconVisibility,
      child: GestureDetector(
          onTap: () async {
            String inFamily = await FireStoreFunctions().checkIfUserInFam();
            if (inFamily.isEmpty) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FamilyScreen()));
            } else {
              context
                  .read<ShoppingListBloc>()
                  .add(GetShoppingListItemsFromFirestoreEvent());
            }
          },
          child: Icon(
            Icons.sync,
            color: kClrPrimary,
          )),
    );
  }
}
