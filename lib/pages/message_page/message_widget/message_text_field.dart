import 'package:flutter/material.dart';

class MessageTextField extends StatefulWidget {
  final TextEditingController controller;

  final String hintText;
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final Widget prefixIcon;
  final Widget prefixIcon2;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final String? errMessage;
  final String? Function(String?)? onChanged;

  const MessageTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.labelText,
      required this.obscureText,
      required this.keyboardType,
      this.suffixIcon,
      this.onTap,
      required this.prefixIcon,
      this.validator,
      this.focusNode,
      this.errMessage,
      this.onChanged, required this.prefixIcon2});

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
    
  @override
  Widget build(BuildContext context) {
    
    return Container(
       constraints: const BoxConstraints(maxHeight: 200),
      child: TextFormField(
        expands: false,
        maxLines: null,
        minLines: 1,
        cursorColor: Colors.blue,
        validator: widget.validator,
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        focusNode: widget.focusNode,
        onTap: widget.onTap,
        textInputAction: TextInputAction.next,
        onChanged: widget.onChanged,
        
        decoration: InputDecoration(
            
            
            filled: true, // Arka planı doldurmak için true yapıyoruz
            fillColor: const Color.fromARGB(130, 238, 237, 237),
      
            border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)), // Köşeleri yuvarlar
      ),
          
          disabledBorder:  const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)), // Köşeleri yuvarlar
      ),
          floatingLabelStyle: const TextStyle(color:Colors.blue),
          suffixIcon: widget.suffixIcon,
          prefixIcon: SizedBox(
        width: 80, // İki ikonun sığabileceği genişlik
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
              widget.prefixIcon,// İlk ikon
              widget.prefixIcon2
                // İkinci ikon
          ],
        ),
      ),
          
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(130, 238, 237, 237),width: 1),
             borderRadius: BorderRadius.all(Radius.circular(30.0)),
            
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color:Color.fromARGB(130, 238, 237, 237),width: 2),
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
      
          ),
          focusedErrorBorder: const OutlineInputBorder(
             borderSide: BorderSide(color: Colors.red,width: 2),
             borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          focusedBorder:  const OutlineInputBorder(
            borderSide: BorderSide(color:Color.fromARGB(130, 238, 237, 237),width: 1),
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
           floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: widget.hintText,
          
          errorStyle: const TextStyle(color: Colors.red),
          labelStyle: const TextStyle(color: Colors.grey ,),
          hintStyle: const TextStyle(color: Colors.grey)
        ),
      ),
    );
  }
}
