import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_breaking/business_logic/cubit/characters_cubit.dart';
import 'package:flutter_breaking/constants/my_colors.dart';
import 'package:flutter_breaking/data/models/characters.dart';
import 'package:flutter_breaking/presentation/widgets/character_item.dart';

class CharactersScreen extends StatefulWidget {
  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late List<Character> allCharacters;

  @override
  void initState() {
    super.initState();
    allCharacters =
        BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.yellow,
        title: Text(
          'Characters',
          style: TextStyle(color: MyColors.grey),
        ),
      ),
      body: buildBlocWidget(),
    );
  }

  Widget buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
        builder: (context, state) {
      if (state is CharactersLoaded) {
        allCharacters = state.characters;
        return buildLoadedListWidgets();
      } else {
        return showLoadingIndicator();
      }
    });
  }

  Widget showLoadingIndicator() => Center(
        child: CircularProgressIndicator(
          color: MyColors.yellow,
        ),
      );

  Widget buildLoadedListWidgets() => SingleChildScrollView(
        child: Container(
          color: MyColors.grey,
          child: Column(
            children: [
              buildCharactersList(),
            ],
          ),
        ),
      );

  Widget buildCharactersList() => GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: allCharacters.length,
        itemBuilder: (context, index) => CharacterItem(
          character: allCharacters[index],
        ),
      );
}
