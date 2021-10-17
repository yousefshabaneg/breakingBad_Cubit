import 'package:flutter/material.dart';
import 'package:flutter_breaking/constants/my_colors.dart';
import 'package:flutter_breaking/data/models/characters.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailsScreen({Key? key, required this.character})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
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
