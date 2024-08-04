// ignore_for_file: must_be_immutable

part of 'shopping_list_bloc.dart';

@immutable
sealed class ShoppingListEvent {}

class LoadShoppingListEvent extends ShoppingListEvent {}

class GetShoppingListItemsFromFirestoreEvent extends ShoppingListEvent {}

class ShoppingListAddEvent extends ShoppingListEvent {
  ShopingListItem item;
  ShoppingListAddEvent({required this.item});
}

class ShoppingListRemoveEvent extends ShoppingListEvent {}

class ShoppingListRemoveAllEvent extends ShoppingListEvent {}

class ShoppingListItemRemoveEvent extends ShoppingListEvent {
  ShopingListItem item;
  ShoppingListItemRemoveEvent({required this.item});
}

class ClearShoppingListItemsEvent extends ShoppingListEvent {}

class AddExistingItemsToFireStoreEvent extends ShoppingListEvent {}