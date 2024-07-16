import 'package:flutter/widgets.dart';
import 'package:meal_planning/utils/styles.dart';

class KDetailTileWidget extends StatelessWidget {
  final String img;
  final String title;
  final String value;

  const KDetailTileWidget({
    Key? key,
    required this.img,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          img,
          width: 25,
          height: 25,
        ),
        Text(
          title,
          style: kSmallText.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 15),
        Text(
          value,
          style: kMedText.copyWith(fontSize: 18),
        ),
      ],
    );
  }
}
