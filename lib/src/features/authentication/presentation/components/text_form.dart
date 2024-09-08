
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/constants/theme.dart';

class TextForm extends StatefulWidget {
  final String value;
  final String hintText;
  final bool? error;
  final String? password;
  final Widget? suffix;
  final bool? visible;
  final Function(String) onChanged;
  final Function(bool) onValidated;

  const TextForm({
    super.key, 
    required this.value,
    required this.hintText,
    this.error,
    this.password,
    this.suffix,
    this.visible,
    required this.onChanged,
    required this.onValidated,
  });

  @override
  State<TextForm> createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _validate() {
    final text = _controller.text.trim();
    bool isValid = text.isNotEmpty;
    if(widget.hintText == "E-pasts"){
      isValid = isValid && text.contains("@");
    } else if(widget.hintText == "Parole"){
      isValid = isValid && text.length >= 8 && RegExp(r'\d').hasMatch(text);
    } else if(widget.hintText == "Atkārto paroli"){
      isValid = isValid && text == widget.password;
    }
    setState(() => _hasError = !isValid);
    widget.onValidated(isValid);
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration decoration = InputDecoration(
      filled: true,
      fillColor: background,
      contentPadding: EdgeInsets.all(20.r),
      errorStyle: TextStyle(
        color: errorRed.withOpacity(0.5),
        fontSize: 16.r,
        fontWeight: FontWeight.w400,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(
          width: 2.r,
          color: errorRed.withOpacity(0.5),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(
          color: _hasError
            ? errorRed.withOpacity(0.5) 
            : onBackground.withOpacity(0.3),
          width: 2.r,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(
          color: _hasError
            ? errorRed.withOpacity(0.5) 
            : onBackground,
          width: 2.r,
        ),
      ),
      hintText: widget.hintText,
      hintStyle: TextStyle(
        color: _hasError
          ? errorRed.withOpacity(0.5) 
          : onBackground.withOpacity(0.7),
        fontSize: 16.r,
        fontWeight: FontWeight.w400,
      )
    );

    if(widget.suffix != null){
      decoration = decoration.copyWith(suffixIcon: widget.suffix);
    }

    if(widget.error != null) {
      if(widget.error!) _hasError = widget.error!;
    }

    return Column(
      children: [
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: _hasError ? errorRed.withOpacity(0.7) : onBackground,
            fontSize: 16.r,
            fontWeight: FontWeight.w400,
          ),
          obscureText: widget.visible ?? false,
          decoration: decoration,
          cursorColor: _hasError
            ? errorRed.withOpacity(0.7) 
            : onBackground.withOpacity(0.3),
          onTapOutside: (event) {
            _focusNode.unfocus();
            _validate();
          },
          onChanged: (value) {
            widget.onChanged(value);
            _validate();
          },
        ),
        if(_hasError && (widget.hintText == "Parole" || widget.hintText == "Atkārto paroli"))
          Padding(
            padding: EdgeInsets.only(top:5.h, left: 10.w, right: 10.w),
            child: Text(
              widget.hintText == "Parole"
                ? "Parolei jābūt minimāli 8 simbolu garumā un jāsatur 1 ciparu!"
                : "Parolēm jābūt vienādām!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.r,
                color: errorRed
              ),
            ),
          )
      ],
    );
  }
}