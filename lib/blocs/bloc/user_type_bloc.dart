import 'package:bloc/bloc.dart';
import 'package:meal_planning/functions/checkUserType.dart';
import 'package:meal_planning/db_functions/hive_func.dart';
import 'package:meal_planning/main.dart';
import 'package:meta/meta.dart';
part 'user_type_event.dart';
part 'user_type_state.dart';

class UserTypeBloc extends Bloc<UserTypeEvent, UserTypeState> {
  UserTypeBloc() : super(UserTypeInitial()) {
    on<CheckUserType>(_checkUserType);
  }
  _checkUserType(CheckUserType event, Emitter<UserTypeState> emit) async {
    emit(UserTypeLoadingState());
    if (userType == UserType.free) {
      // change this and see if everything is accessible
      // emit(FreeUserState());
      emit(PremiumUserState());
      userType == UserType.premium;
      print('emitting usertype $userType');
      return;
    } else {
      print('emitting usertype $userType');
      emit(PremiumUserState());
      return;
    }
  }
}
