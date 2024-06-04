import 'package:flutter/material.dart';
import 'package:elder_ring/Screen%20Sharing/elderly_meeting_screen.dart';


class Elderly_HomeScreen extends StatefulWidget{
  const Elderly_HomeScreen({super.key});


  @override
  State<Elderly_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Elderly_HomeScreen>{

  int _page = 0;
  onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }

  List<Widget> pages = [
    Elderly_MeetingScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Screen Share'),
        backgroundColor: const Color.fromRGBO(36, 36, 36, 1),
      ),
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onPageChanged,
        currentIndex: _page,
        
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts_outlined),
            label: 'Contacts'
          ),
  
        ]
      ),
    );
  }
}