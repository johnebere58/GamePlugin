
 class ScoreModel{

  final int totalPassed;
  final int totalFailed;

  ScoreModel({this.totalPassed=0,this.totalFailed=0});

  int get totalPlayed => totalPassed+totalFailed;
 }