import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_planning/models/hive_models/shoppinglist_item.dart';
import 'package:meal_planning/screens/shopping_list/bloc/shopping_list_bloc.dart';
import 'package:meal_planning/utils/styles.dart';
import 'package:meal_planning/widgets/error_snackbar.dart';
import 'package:meal_planning/widgets/main_appbar.dart';
import 'package:meal_planning/widgets/main_container.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig sizeConfig = SizeConfig();
    sizeConfig.init(context);
    context.read<ShoppingListBloc>().add(LoadShoppingListEvent());

    return Column(
      children: [
        KAppBarWidget(
          sizeConfig: sizeConfig,
          title: 'Shopping list',
          imgPath: 'assets/icons/app_icons/settings.png',
          syncIconVisibility: true,
          deleteIconVisibility: true,
        ),
        Expanded(
          child: KMainContainerWidget(
            sizeConfig: sizeConfig,
            child: BlocConsumer<ShoppingListBloc, ShoppingListState>(
              listener: (context, state) {
                if (state is NoInternetShoppingListState) {
                  showErrorSnackbar(context, state.error);
                  context.read<ShoppingListBloc>().add(LoadShoppingListEvent());
                }
              },
              builder: (context, state) {
                if (state is ShoppingListItemsLoadedState) {
                  return _buildShoppingItems(state.categorizedItems);
                } else if (state is ShoppingListItemsFailedState) {
                  return _buildLoadFailedState(state);
                } else if (state is ShoppingListLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Container();
              },
            ),
          ),
        ),
      ],
    );
  }

  Center _buildLoadFailedState(ShoppingListItemsFailedState state) {
    return Center(
        child: Text(
      state.error,
      style: kMedText.copyWith(color: Colors.black),
    ));
  }

  ListView _buildShoppingItems(categorizedItems) {
    return ListView.builder(
      padding: const EdgeInsets.only(right: 5),
      itemCount: categorizedItems.length,
      itemBuilder: (context, ind) {
        String itemName = categorizedItems.keys.elementAt(ind);
        List<ShopingListItem> innerItems =
            categorizedItems.values.elementAt(ind);
        double listHeight =
            innerItems.length * (kMinInteractiveDimension + 0.1);

        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: true,
            title: _buildcategoryName(itemName),
            children: [
              _buildItemsListView(listHeight, innerItems),
            ],
          ),
        );
      },
    );
  }

  Container _buildcategoryName(String itemName) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        decoration: BoxDecoration(
          color: kClrSecondary,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          itemName,
          style: kSmallText.copyWith(color: kClrPrimary),
        ));
  }

  Widget _buildItemsListView(
      double listHeight, List<ShopingListItem> innerItems) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: innerItems.length,
      itemBuilder: (context, innerInd) {
        ShopingListItem item = innerItems[innerInd];
        return SizedBox(
          width: 100,
          height: 40,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            minVerticalPadding: 0,
            textColor: Colors.black,
            leading: IconButton(
                onPressed: () => context
                    .read<ShoppingListBloc>()
                    .add(ShoppingListItemRemoveEvent(item: item)),
                icon: const Icon(Icons.remove_circle_outline)),
            title: Text(
              item.name,
              style: kSmallText.copyWith(
                color: Colors.black,
              ),
            ),
            trailing: Text(
              item.quantity,
              style: kSmallText.copyWith(
                color: Colors.black,
              ),
            ),
          ),
        );
        // );
      },
    );
  }
}
