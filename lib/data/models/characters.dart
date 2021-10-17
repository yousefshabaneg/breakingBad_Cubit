class Character {
  late int charId;
  late String name;
  late String nickname;
  late String birthday;
  late String image;
  late List<dynamic> jobs;
  late String statusIfDeadOrAlive;
  late List<dynamic> apperanceOfSeasons;
  late String actorName;
  late String categoryForTwoSeries;
  late List<dynamic> betterCallSaulApperance;

  Character.fromJson(Map<String, dynamic> json) {
    charId = json['char_id'];
    name = json['name'];
    birthday = json['birthday'];
    jobs = json['occupation'];
    image = json['img'];
    statusIfDeadOrAlive = json['status'];
    nickname = json['nickname'];
    apperanceOfSeasons = json['appearance'];
    categoryForTwoSeries = json["category"];
    betterCallSaulApperance = json['better_call_saul_appearance'];
    actorName = json['portrayed'];
  }
}
