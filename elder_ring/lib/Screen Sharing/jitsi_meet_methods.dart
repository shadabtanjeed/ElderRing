import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
//import 'package:the_final_zoom_clone/utils/auth_methods.dart';

class JitsiMeetMethods {
  Future<void> createMeeting({required String roomName, required String userName}) async {
    final JitsiMeet jitsiMeet = JitsiMeet();
    //final AuthMethods _authMethods = AuthMethods();
    try {
      var options = JitsiMeetConferenceOptions(
        
        room: roomName,
        serverURL: 'https://jitsi.riot.im/',
        configOverrides: {
          'startWithAudioMuted': true,
          'startWithVideoMuted': true,
          //'userEmail': _authMethods,
          //'userDisplayName': 'Elderly User',
          FeatureFlags.resolution: FeatureFlagVideoResolutions.resolution720p,
          FeatureFlags.welcomePageEnabled: false,
          FeatureFlags.carModeEnabled: false,
        },
      );

      await jitsiMeet.join(options);
    } catch (e) {
      // Handle the exception
      print('Error Starting Meeting, Details: $e');
    }
  }
}
