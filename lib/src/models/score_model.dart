
 class ScoreModel{

  final int totalPassed;
  final int totalFailed;
  final bool scoreReady;

  ScoreModel({this.totalPassed=0,this.totalFailed=0,this.scoreReady=false});

  int get totalPlayed => totalPassed+totalFailed;
 }