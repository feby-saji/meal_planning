part of 'family_bloc.dart';

@immutable
sealed class FamilyEvent {}

class CheckIfUserInFamilyEvent extends FamilyEvent {}

class CreateFamilyEvent extends FamilyEvent {}

class ExitFamilyEvent extends FamilyEvent {}

class JoinFamilyEvent extends FamilyEvent {
 final String familyId;
  JoinFamilyEvent({required this.familyId});
}
