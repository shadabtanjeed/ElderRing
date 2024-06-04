import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget{
  final String text;
  

  final VoidCallback onPressed;
  const CustomButton({super.key, required this.text, required this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(14, 114, 236, 1),
      ),
      child:  Text(text, style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),

      ),
    );
  }
}