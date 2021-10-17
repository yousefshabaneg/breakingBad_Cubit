import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_breaking/business_logic/cubit/characters_cubit.dart';
import 'package:flutter_breaking/constants/my_colors.dart';
import 'package:flutter_breaking/data/models/characters.dart';
import 'package:flutter_breaking/presentation/widgets/character_item.dart';
import 'package:flutter_breaking/presentation/widgets/show_progress_indicator.dart';
import 'package:flutter_offline/flutter_offline.dart';

class CharactersScreen extends StatefulWidget {
  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late List<Character> allCharacters;
  late List<Character> searchedForCharacters;
  bool _isSearching = false;
  FocusNode _focusSearch = new FocusNode();
  final _searchController = TextEditingController();
  bool connected = true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.yellow,
        leading: _isSearching
            ? BackButton(
                color: MyColors.grey,
              )
            : null,
        title: _isSearching ? _buildSearchField() : _buildAppBarTitle(),
        actions: connected ? _buildAppBarActions() : null,
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          connected = connectivity != ConnectivityResult.none;
          return connected ? buildBlocWidget() : buildNoInternetWidget();
        },
        child: showLoadingIndicator(),
      ),
    );
  }

  Widget buildNoInternetWidget() => Center(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'No connection ... Check your Internet',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: MyColors.grey,
                ),
              ),
              Image.asset('assets/images/no_internet.png'),
            ],
          ),
        ),
      );

  Widget buildBlocWidget() =>
      BlocBuilder<CharactersCubit, CharactersState>(builder: (context, state) {
        if (state is CharactersLoaded) {
          allCharacters = state.characters;
          return buildLoadedListWidgets();
        } else {
          return showLoadingIndicator();
        }
      });

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
        itemCount: _searchController.text.isNotEmpty
            ? searchedForCharacters.length
            : allCharacters.length,
        itemBuilder: (context, index) => CharacterItem(
          character: _searchController.text.isNotEmpty
              ? searchedForCharacters[index]
              : allCharacters[index],
        ),
      );

  Widget _buildAppBarTitle() => Text(
        'Characters',
        style: TextStyle(color: MyColors.grey),
      );

  Widget _buildSearchField() => TextField(
        controller: _searchController,
        focusNode: _focusSearch,
        cursorColor: MyColors.grey,
        decoration: InputDecoration(
          hintText: 'Find a character...',
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: MyColors.grey,
            fontSize: 18,
          ),
        ),
        style: TextStyle(
          color: MyColors.grey,
          fontSize: 18,
        ),
        onChanged: (searchedCharacter) {
          addSearchedForItemsToSearchedList(searchedCharacter);
        },
      );

  void addSearchedForItemsToSearchedList(searchedCharacter) {
    searchedForCharacters = allCharacters
        .where((character) =>
            character.name.toLowerCase().startsWith(searchedCharacter))
        .toList();
    setState(() {});
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            _clearSearch();
            Navigator.pop(context);
          },
          icon: Icon(Icons.clear, color: MyColors.grey),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearch,
          icon: Icon(
            Icons.search,
            color: MyColors.grey,
          ),
        ),
      ];
    }
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    _focusSearch.requestFocus();

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearch();
    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
    });
  }
}
