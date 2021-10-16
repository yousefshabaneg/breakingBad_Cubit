import 'package:flutter/material.dart';
import 'package:flutter_breaking/constants/my_colors.dart';
import 'package:flutter_breaking/data/models/characters.dart';

class CharacterItem extends StatelessWidget {
  final Character character;

  const CharacterItem({Key? key, required this.character}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
      padding: EdgeInsetsDirectional.all(4),
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: GridTile(
        child: Container(
          color: MyColors.grey,
          child: character.image.isNotEmpty
              ? FadeInImage.assetNetwork(
                  placeholder: 'assets/images/loading.gif',
                  image: character.image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                )
              : Image.asset('assets/images/404.gif'),
        ),
        footer: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          color: Colors.black54,
          alignment: Alignment.bottomCenter,
          child: Text(
            character.name,
            style: TextStyle(
              color: MyColors.white,
              fontWeight: FontWeight.bold,
              height: 1.3,
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
