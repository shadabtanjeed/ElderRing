import 'package:elder_ring/Screen%20Sharing/home_meeting_button.dart';
import 'package:elder_ring/Screen%20Sharing/jitsi_meet_methods.dart';
import 'package:flutter/material.dart';


class MeetingScreen extends StatelessWidget {
  MeetingScreen({super.key});

  final JitsiMeetMethods _jitsiMeetMethods = JitsiMeetMethods();

  createNewMeeting() async{
    _jitsiMeetMethods.createMeeting(roomName: 'RoomFromElderly', userName: 'Elderly User');
  }

  joinMeeting(BuildContext context)
  {
     _jitsiMeetMethods.createMeeting(roomName: 'RoomFromElderly', userName: 'Care Provider');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment : MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HomeMeetingButton(onPressed: createNewMeeting,
              text: 'Share Screen',
              icon: Icons.screen_share,
              ),
              HomeMeetingButton(onPressed: ()=> joinMeeting(context),
              text: 'View Screen',
              icon: Icons.remove_red_eye_outlined,
              ),
            ],
          )
        ],
      );
  }
}