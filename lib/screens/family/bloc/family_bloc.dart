import 'package:bloc/bloc.dart';
import 'package:meal_planning/functions/network_connection.dart';
import 'package:meal_planning/hive_db/db_functions.dart';
import 'package:meal_planning/main.dart';
import 'package:meal_planning/models/hive_models/family.dart';
import 'package:meal_planning/repository/firestore.dart';
import 'package:meal_planning/screens/shopping_list/bloc/shopping_list_bloc.dart';
import 'package:meta/meta.dart';
part 'family_event.dart';
part 'family_state.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  final FireStoreFunctions _firestore = FireStoreFunctions();
  late ShoppingListBloc _shoppingListBloc;
  FamilyBloc(ShoppingListBloc shoppingListBloc) : super(LoadingStateFamily()) {
    _shoppingListBloc = shoppingListBloc;
    on<CheckIfUserInFamilyEvent>(_checkIfUserInFamily);
    on<CreateFamilyEvent>(_createFamilyEvent);
    on<JoinFamilyEvent>(_joinFamilyEvent);
    on<ExitFamilyEvent>(_exitFamilyEvent);
  }

  _checkIfUserInFamily(
      CheckIfUserInFamilyEvent event, Emitter<FamilyState> emit) async {
    if (await connectedToInternet()) {
      emit(LoadingStateFamily());
      final inFamily = await _firestore.checkIfUserInFam();

      if (inFamily.isNotEmpty) {
        Family? family;
        if (await connectedToInternet()
        //  && userType == UserType.premium
         ) {
          // get family info from firestore to hive
          family = await _firestore.fetchFamilyDetails();
        } else {
          family = await HiveDb.getFamilyHive();
        }
        return emit(UserInFamily(family: family!));
      } else {
        return emit(UserNotInFamily());
      }
    } else {
      print('/// no internet');
      return emit(ErrorStateFamily(error: 'no internet'));
    }
  }

  _createFamilyEvent(CreateFamilyEvent event, Emitter<FamilyState> emit) async {
    if (await connectedToInternet()) {
      emit(LoadingStateFamily());
      await _firestore.createFamily();
      return add(CheckIfUserInFamilyEvent());
    } else {
      return emit(ErrorStateFamily(error: 'no internet'));
    }
  }

  _joinFamilyEvent(JoinFamilyEvent event, Emitter<FamilyState> emit) async {
    if (await connectedToInternet()) {
      emit(LoadingStateFamily());
      if (await _firestore.familyExist(event.familyId)) {
        var result = await _firestore.joinFamily(event.familyId);
        // false if user already in family
        if (result == false) {
          emit(ErrorStateFamily(error: 'Already in Family'));

          // pass the family obj
          Family family = await _firestore.fetchFamilyDetails();
          return emit(UserInFamily(family: family));
        } else {
          // if joined in the family add current shopping list items to family list
          _shoppingListBloc.add(AddExistingItemsToFireStoreEvent());
          return add(CheckIfUserInFamilyEvent());
        }
      } else {
        return emit(ErrorStateFamily(error: 'No family found'));
      }
    } else {
      return emit(ErrorStateFamily(error: 'no internet'));
    }
  }

  _exitFamilyEvent(ExitFamilyEvent event, Emitter<FamilyState> emit) async {
    if (await connectedToInternet()) {
      emit(LoadingStateFamily());
      // exit from family
      var result = await _firestore.exitFromFamily();
      if (result == false) {
        return emit(ErrorStateFamily(error: 'Not in Family'));
      }
      return add(CheckIfUserInFamilyEvent());
    } else {
      return emit(ErrorStateFamily(error: 'no internet'));
    }
  }
}
