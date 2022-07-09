
import 'package:gameplugin/src/settings/ball_count.dart';

extension BallCountExtension on BallCount{

  int get getValue => index==0?2:index==1?3:index==2?4:8;

}