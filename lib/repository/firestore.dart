import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:meal_planning/hive_db/db_functions.dart';
import 'package:meal_planning/models/hive_models/family.dart';
import 'package:meal_planning/models/hive_models/shoppinglist_item.dart';
import 'package:meal_planning/screens/shopping_list/bloc/shopping_list_bloc.dart';

class FireStoreFunctions {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference familyCollection =
      FirebaseFirestore.instance.collection('family');
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  CollectionReference shopppingListCollection =
      FirebaseFirestore.instance.collection('shopping_list');
  final db = FirebaseFirestore.instance;

// user functions
  Future<String> checkIfUserInFam() async {
    final docSnapshot = await usersCollection.doc(userUid).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data()! as Map;
      return data['familyId'] as String;
    } else {
      return "";
    }
  }

  createUser(User user) async {
    await usersCollection.doc(userUid).set({
      'username': user.displayName,
      'email': user.email,
      'familyId': '',
    });
  }

  Future<String> getNameFromUid(String uid) async {
    DocumentSnapshot userDoc = await usersCollection.doc(uid).get();
    if (userDoc.exists) {
      return userDoc['username'];
    } else {
      return 'no name found';
    }
  }

// family functions
  createFamily() async {
    String? userName = FirebaseAuth.instance.currentUser!.displayName;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      DocumentReference docRef = await familyCollection.add({
        'creator': uid,
        'familyId': '',
        'members': [userName],
        'createdOn': Timestamp.now(),
      });
      CollectionReference shoppingListRef = docRef.collection('shopping_list');
      await shoppingListRef.doc('shopping list').set({'items': []});

      await docRef.update({'familyId': docRef.id});
      // update in user doc
      await usersCollection.doc(userUid).update({'familyId': docRef.id});
      // update in hive
      Family familyModel =
          Family(familyId: docRef.id, creator: uid, members: [userUid]);
      await HiveDb.updateFamily(familyModel);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> familyExist(familyId) async {
    DocumentSnapshot docSnap = await familyCollection.doc(familyId).get();
    if (docSnap.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future joinFamily(familyId) async {
    String? userName = FirebaseAuth.instance.currentUser!.displayName;
    DocumentSnapshot docSnapFam = await usersCollection.doc(userUid).get();

    // check if user already in family
    if (docSnapFam['familyId'] != '') return false;

    // add family id to user doc
    await usersCollection.doc(userUid).update({'familyId': familyId});

    // add user to the family
    await familyCollection.doc(familyId).update({
      'members': FieldValue.arrayUnion([userName])
    });
    // get family details from firestore
    DocumentSnapshot docSnap = await familyCollection.doc(familyId).get();
    final data = docSnap.data() as Map;

    // save fam details in hive
    Family family = Family(
        familyId: data['familyId'],
        creator: data['creator'],
        members: data['members']);
    await HiveDb.updateFamily(family);
    print('//joining  current members are $data[members]');
  }

  Future<Family> fetchFamilyDetails() async {
    try {
      // get family id
      DocumentSnapshot docSnapshot = await usersCollection.doc(userUid).get();
      String familyId = docSnapshot.get('familyId');
      // get familt details
      DocumentSnapshot fdocSnapshot =
          await familyCollection.doc(familyId).get();
      Family family = Family(
        familyId: fdocSnapshot.get('familyId'),
        creator: fdocSnapshot.get('creator'),
        members: fdocSnapshot.get('members'),
      );
      await HiveDb.updateFamily(family);
      return family;
    } catch (e) {
      print('Error getting familyId: $e');
      return Family(familyId: 'err', creator: '', members: []);
    }
  }

  exitFromFamily() async {
    // get family id
    DocumentSnapshot docSnapshot = await usersCollection.doc(userUid).get();
    String familyId = docSnapshot.get('familyId');
    String? userName = FirebaseAuth.instance.currentUser!.displayName;

    if (familyId.isEmpty) return false;

    try {
      // remove family id from user db
      await usersCollection.doc(userUid).update({'familyId': ''});
      // remove user from family
      await familyCollection.doc(familyId).update({
        'members': FieldValue.arrayRemove([userName])
      });
      // delte family if no users exist in the family
      // await deleteFamily(familyId);
    } catch (e) {
      print('/// error is $e');
    }
  }

  deleteFamily(familyId) async {
    DocumentSnapshot docSnap = await familyCollection.doc(familyId).get();
    if (docSnap.exists) {
      List members = docSnap.get('members');
      if (members.isEmpty) {
        await familyCollection.doc(familyId).delete();
      }
    }
  }

  // shopping list functions
  Future<void> addItemToFireStore(ShopingListItem listItem) async {
    try {
      DocumentSnapshot docSnapshot = await usersCollection.doc(userUid).get();
      String familyId = docSnapshot.get('familyId');

      DocumentReference docRef = familyCollection
          .doc(familyId)
          .collection('shopping_list')
          .doc('shopping list');

      await firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);

        Map<String, dynamic> item = {
          'name': listItem.name,
          'quantity': listItem.quantity,
          'category': listItem.category,
        };

        if (!snapshot.exists) {
          transaction.set(docRef, {
            'items': [item],
          });
        } else {
          List<dynamic> items = snapshot.get('items');
          bool itemUpdated = false;

          for (int i = 0; i < items.length; i++) {
            int newQty =
                int.parse(items[i]['quantity']) + int.parse(item['quantity']);
            if (items[i]['name'] == item['name']) {
              items[i]['quantity'] = newQty.toString();
              items[i]['category'] = item['category'];
              itemUpdated = true;
              break;
            }
          }

          if (!itemUpdated) {
            items.add(item);
          }

          transaction.update(docRef, {'items': items});
        }
      });
    } catch (e) {
      print('Error adding item to Firestore: $e');
    }
  }

  Future<void> deleteItemFromFirestore(ShopingListItem listItem) async {
    try {
      DocumentSnapshot docSnapshot = await usersCollection.doc(userUid).get();
      String familyId = docSnapshot.get('familyId');

      Map<String, dynamic> item = listItem.toMap();

      await familyCollection
          .doc(familyId)
          .collection('shopping_list')
          .doc('shopping list')
          .update({
        'items': FieldValue.arrayRemove([item])
      });
    } catch (e) {
      print('Error deleting item from Firestore: $e');
    }
  }

  Future clearFirestoreItems() async {
    try {
      DocumentSnapshot famDocSnapshot =
          await usersCollection.doc(userUid).get();
      String familyId = famDocSnapshot.get('familyId');
      // Reference to the Firestore document
      DocumentReference docRef = familyCollection
          .doc(familyId)
          .collection('shopping_list')
          .doc('shopping list');

      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Clear the items list by setting it to an empty array
        await docRef.update({'items': []});
        print('Items list cleared successfully.');
      }
    } catch (e) {
      print('Failed to clear items list: $e');
      return 'Failed to clear items list: $e';
    }
  }

  Future<List<ShopingListItem>> fetchAllItems() async {
    try {
      DocumentSnapshot famDocSnapshot =
          await usersCollection.doc(userUid).get();
      String familyId = famDocSnapshot.get('familyId');

      DocumentReference docRef = familyCollection
          .doc(familyId)
          .collection('shopping_list')
          .doc('shopping list');

      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Get the items array from the document
        List<dynamic> itemsDynamic = docSnapshot.get('items');

        List<Map<String, dynamic>> items = itemsDynamic
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
        List<ShopingListItem> itemsList = [];

        for (var item in items) {
          itemsList.add(ShopingListItem(
            name: item['name'],
            quantity: item['quantity'],
            category: item['category'],
          ));
        }

        print('/// $items');

        return itemsList;
      } else {
        print('Document does not exist.');
        return [];
      }
    } catch (e) {
      print('Failed to fetch items: $e');
      return [];
    }
  }
}
