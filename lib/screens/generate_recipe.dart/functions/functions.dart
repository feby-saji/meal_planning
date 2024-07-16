import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_planning/screens/generate_recipe.dart/bloc/generate_recipe_bloc.dart';

resetPrompt() {}

submitPrompt() {
  //  make sure atleast one field is not empty
}

pickImage(BuildContext context) async {
  final ImagePicker picker = ImagePicker();
  final XFile? photo = await picker.pickImage(source: ImageSource.camera);
  if (photo != null) {
    context.read<GenerateRecipeBloc>().add(UpdateImageEvent(img: photo));
  }
}
