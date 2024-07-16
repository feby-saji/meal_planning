import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:meal_planning/functions/network_connection.dart';
import 'package:meal_planning/hive_db/db_functions.dart';
import 'package:meal_planning/models/hive_models/family.dart';
import 'package:meal_planning/models/hive_models/shoppinglist_item.dart';
import 'package:meal_planning/repository/firestore.dart';
import 'package:meal_planning/screens/family/bloc/family_bloc.dart';
import 'package:meal_planning/widgets/snackbar.dart';
import 'package:meta/meta.dart';
part 'shopping_list_event.dart';
part 'shopping_list_state.dart';

class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  Map<String, List<ShopingListItem>> _cachedcategorizedList = {};

  ShoppingListBloc() : super(ShoppingListInitial()) {
    on<ShoppingListAddEvent>(_shoppingListAddEvent);
    on<LoadShoppingListEvent>(_loadShoppingListEvent);
    on<ShoppingListItemRemoveEvent>(_shoppingListItemRemove);
    on<ClearShoppingListItemsEvent>(_clearShoppingListItems);
    on<GetShoppingListItemsFromFirestoreEvent>(
        _getShoppingListItemsFromFirestoreEvent);
  }

  String emptyListTxt = 'Shopping list is empty.';
  final FireStoreFunctions _firestore = FireStoreFunctions();

  _shoppingListAddEvent(
    ShoppingListAddEvent event,
    Emitter<ShoppingListState> emit,
  ) async {
    emit(ShoppingListLoadingState());
    if (await connectedToInternet()) {
      try {
        // Categorize the item
        event.item.category = ingredientCategories[event.item.name] ?? 'others';

        Family? family = await HiveDb.getFamilyHive();
        if (family != null && family.creator.isNotEmpty) {
          // add to firestore
          await _firestore.addItemToFireStore(event.item);
        }

        // add item to DB
        await HiveDb.addNewShoppingItem(event.item);

        if (!_cachedcategorizedList.containsKey(event.item.category)) {
          _cachedcategorizedList[event.item.category] = [];
        }

        int existingInd = _cachedcategorizedList[event.item.category]!
            .indexWhere((element) => element.name == event.item.name);

        // Check if item already exists
        if (existingInd != -1) {
          _cachedcategorizedList[event.item.category]![existingInd].quantity =
              _cachedcategorizedList[event.item.category]![existingInd]
                  .quantity;
        } else {
          // Item doesn't exist, add it to the list
          _cachedcategorizedList[event.item.category]?.add(event.item);
        }

        emit(ShoppingListItemsLoadedState(
          categorizedItems: _cachedcategorizedList,
        ));
      } catch (e) {
        return emit(ShoppingListItemsFailedState(error: e.toString()));
      }
    } else {
      return emit(NoInternetShoppingListState(error: 'no internet connection'));
    }
  }

  _loadShoppingListEvent(
    LoadShoppingListEvent event,
    Emitter<ShoppingListState> emit,
  ) async {
    List<ShopingListItem>? allItems = HiveDb.loadAllShoppingItem();
    if (allItems != null && allItems.isNotEmpty) {
      // categorize items
      _cachedcategorizedList.clear();
      for (var item in allItems) {
        if (!_cachedcategorizedList.containsKey(item.category)) {
          _cachedcategorizedList[item.category] = [];
        }
        _cachedcategorizedList[item.category]?.add(item);
      }

      emit(ShoppingListItemsLoadedState(
          categorizedItems: _cachedcategorizedList));
    } else {
      emit(ShoppingListItemsFailedState(error: emptyListTxt));
    }
  }

  _shoppingListItemRemove(
    ShoppingListItemRemoveEvent event,
    Emitter<ShoppingListState> emit,
  ) async {
    if (await connectedToInternet()) {
      emit(ShoppingListLoadingState());
      try {
        Family? family = await HiveDb.getFamilyHive();
        if (family != null && family.creator.isNotEmpty) {
          // remove in firestore
          await _firestore.deleteItemFromFirestore(event.item);
        }

        // remove in DB
        HiveDb.removeShoppingListItem(event.item);

        // remove in cached list
        int? ind =
            _cachedcategorizedList[event.item.category]?.indexOf(event.item);
        if (ind != null) {
          _cachedcategorizedList[event.item.category]!.removeAt(ind);
        }
        // check if category is empty
        if (_cachedcategorizedList[event.item.category]!.isEmpty) {
          _cachedcategorizedList.remove(event.item.category);
        }
        if (_cachedcategorizedList.isNotEmpty) {
          return emit(
            ShoppingListItemsLoadedState(
                categorizedItems: _cachedcategorizedList),
          );
        } else {
          return emit(ShoppingListItemsFailedState(error: emptyListTxt));
        }
      } catch (e) {
        print('/// deletion failed');
        return emit(
            ShoppingListItemsFailedState(error: 'soemrthing went wrong'));
      }
    } else {
      return emit(NoInternetShoppingListState(error: 'no internet connection'));
    }
  }

  _clearShoppingListItems(
    ClearShoppingListItemsEvent event,
    Emitter<ShoppingListState> emit,
  ) async {
    if (await connectedToInternet()) {
      emit(ShoppingListLoadingState());
      // clear in Db
      HiveDb.clearShoppingListItems();

      // remove in cached list
      _cachedcategorizedList = {};

      Family? family = await HiveDb.getFamilyHive();
      if (family != null && family.creator.isNotEmpty) {
        // clear from firestore
        await fireStore.clearFirestoreItems();
      }

      if (_cachedcategorizedList.isNotEmpty) {
        emit(
          ShoppingListItemsLoadedState(
              categorizedItems: _cachedcategorizedList),
        );
      } else {
        emit(ShoppingListItemsFailedState(error: emptyListTxt));
      }
    } else {
      return emit(NoInternetShoppingListState(error: 'no internet connection'));
    }
  }

  _getShoppingListItemsFromFirestoreEvent(
    GetShoppingListItemsFromFirestoreEvent event,
    Emitter<ShoppingListState> emit,
  ) async {
    if (await connectedToInternet()) {
      emit(ShoppingListLoadingState());

      // clear shopping list before getting items from firestore else quantity might conflict
      HiveDb.clearShoppingListItems();

      Family? family = await HiveDb.getFamilyHive();
      if (family != null && family.creator.isNotEmpty) {
        List<ShopingListItem>? allItemsList = await fireStore.fetchAllItems();

        if (allItemsList.isNotEmpty) {
          for (var item in allItemsList) {
            await HiveDb.addNewShoppingItem(item);
          }
        }
      }
      // call LoadShoppingListEvent after putting shoppping items in hive
      return add(LoadShoppingListEvent());
    } else {
      return emit(NoInternetShoppingListState(error: 'no internet connection'));
    }
  }

//   _syncShoppingListEvent(
//     SyncShoppingListEvent event,
//     Emitter<ShoppingListState> emit,
//   ) async {
//     emit(ShoppingListLoadingState());

//     // write every items to firestore
//     List<ShopingListItem>? allItems = HiveDb.loadAllShoppingItem();

//     if (allItems != null && allItems.isNotEmpty) {
//       try {
//         Map<String, dynamic> shoppingItemsMap = {};

//         for (var item in allItems) {
//           shoppingItemsMap[item.name] = {
//             'category': item.category,
//             'quantity': item.quantity,
//           };
//         }
//         await firestore.writeShoppingListItems(shoppingItemsMap);
//
//       } catch (e) {
//         print(e);
//       }
//     }
//     // put items to hive
//     List<ShopingListItem>? allItemsList =
//         await firestore.readShoppingListItems();
//     //
//     if (allItemsList != null && allItemsList.isNotEmpty) {
//       for (var item in allItemsList) {
//         await HiveDb.addNewShoppingItem(item);
//       }
//     }
//     // call LoadShoppingListEvent after putting shoppping items in hive
//     return add(LoadShoppingListEvent());
//   }
// }
}
