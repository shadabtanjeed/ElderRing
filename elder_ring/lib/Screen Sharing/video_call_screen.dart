import 'package:elder_ring/Screen%20Sharing/colors.dart';
import 'package:flutter/material.dart';


class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {

  late TextEditingController meetingIdController;

  @override
  void initState() {
    meetingIdController = TextEditingController();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Shared Screen', style: TextStyle(
          fontSize: 18,
        ),),
        elevation: 0,
        backgroundColor: backgroundColor,
        centerTitle: true,
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            
          )
        ],
      ),
    );
  }
}