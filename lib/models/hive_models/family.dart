import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/adapters.dart';
part 'family.g.dart';

@HiveType(typeId: 5)
class Family {
  @HiveField(1)
  String familyId;
  @HiveField(2)
  String creator;
  @HiveField(3)
  List members;

  Family({
    required this.familyId,
    required this.creator,
    required this.members,
  });
}
