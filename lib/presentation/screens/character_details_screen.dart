import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_breaking/business_logic/cubit/characters_cubit.dart';
import 'package:flutter_breaking/constants/my_colors.dart';
import 'package:flutter_breaking/data/models/characters.dart';
import 'package:flutter_breaking/presentation/widgets/show_progress_indicator.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailsScreen({Key? key, required this.character})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context).getQuotes(character.name);
    return Scaffold(
      backgroundColor: MyColors.grey,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: EdgeInsets.fromLTRB(14, 14, 14, 0),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      characterInfo('Job : ', character.jobs.join(' / ')),
                      buildDivider(335),
                      characterInfo(
                          'Appeared In : ', character.categoryForTwoSeries),
                      buildDivider(265),
                      character.apperanceOfSeasons.length != 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                characterInfo('Seasons : ',
                                    character.apperanceOfSeasons.join(' / ')),
                                buildDivider(300),
                              ],
                            )
                          : Container(),
                      characterInfo('Status : ', character.statusIfDeadOrAlive),
                      buildDivider(310),
                      character.betterCallSaulApperance.length != 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                characterInfo(
                                    'Better Call Saul Appearance : ',
                                    character.betterCallSaulApperance
                                        .join(' / ')),
                                buildDivider(140),
                              ],
                            )
                          : Container(),
                      characterInfo('Actor/Actress : ', character.actorName),
                      buildDivider(250),
                      BlocBuilder<CharactersCubit, CharactersState>(
                          builder: (context, state) =>
                              checkIfQuotesAreLoaded(state)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 330,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget checkIfQuotesAreLoaded(state) => state is QuotesLoaded
      ? displayRandomQuoteOrEmptySpace(state)
      : showLoadingIndicator();

  Widget displayRandomQuoteOrEmptySpace(state) {
    var quotes = state.quotes;
    if (quotes.length != 0) {
      int randomQuoteIndex = Random().nextInt(quotes.length - 1);
      return Center(
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: 20,
            color: MyColors.white,
            shadows: [
              Shadow(
                blurRadius: 7,
                color: MyColors.yellow,
                offset: Offset(0, 0),
              )
            ],
          ),
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              FlickerAnimatedText(quotes[randomQuoteIndex].quote)
            ],
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
    return Container();
  }

  Widget characterInfo(String title, String value) => RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(children: [
          TextSpan(
              text: title,
              style: TextStyle(
                color: MyColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          TextSpan(
              text: value,
              style: TextStyle(
                color: MyColors.white,
                fontSize: 16,
              ))
        ]),
      );

  Widget buildDivider(double endIndent) => Divider(
        color: MyColors.yellow,
        height: 30,
        endIndent: endIndent,
        thickness: 2,
      );

  Widget buildSliverAppBar() => SliverAppBar(
        expandedHeight: 560,
        pinned: true,
        stretch: true,
        backgroundColor: MyColors.grey,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text(
            character.nickname,
            style: TextStyle(
              color: MyColors.white,
            ),
          ),
          background: Hero(
            tag: character.charId,
            child: Image.network(
              character.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
}
