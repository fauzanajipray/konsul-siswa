import 'package:flutter/material.dart';

enum TextFieldType { password, email, normal, number, none }

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? initialValue;
  final String hintText;
  final String? labelText;
  final String? errorText;
  final TextFieldType type;
  final bool obscureText;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final Function(String value)? onChange;
  final Function(String? value)? validator;
  final FocusNode? focusNode;
  final bool filled;
  final bool readOnly;
  final Color? textColor;

  const MyTextField({
    super.key,
    required this.controller,
    this.initialValue,
    this.labelText,
    this.hintText = '',
    this.errorText,
    this.type = TextFieldType.normal,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.onEditingComplete,
    this.filled = true,
    this.textColor,
    this.onChange,
    this.validator,
    this.readOnly = false,
    this.onTap,
  });

  @override
  MyTextFieldState createState() => MyTextFieldState();
}

class MyTextFieldState extends State<MyTextField> {
  bool obscureState = false;

  @override
  void initState() {
    super.initState();
    obscureState = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    Widget? suffixIcon;
    if (widget.obscureText) {
      suffixIcon = IconButton(
        onPressed: () {
          setState(() {
            obscureState = !obscureState;
          });
        },
        icon: Icon(
          obscureState
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
      );
    } else if (widget.suffixIcon != null) {
      suffixIcon = widget.suffixIcon;
    }
    TextInputType? inputType;
    if (widget.type == TextFieldType.email) {
      inputType = TextInputType.emailAddress;
    } else if (widget.type == TextFieldType.password) {
      inputType = TextInputType.visiblePassword;
    } else if (widget.type == TextFieldType.number) {
      inputType = TextInputType.number;
    } else if (widget.type == TextFieldType.none) {
      inputType = TextInputType.none;
    } else {
      inputType = TextInputType.text;
    }
    return _pointer(inputType, suffixIcon);
  }

  Widget _pointer(inputType, suffixIcon) {
    if (inputType == TextInputType.none) {
      return InkWell(
        onTap: widget.onTap,
        child: IgnorePointer(
          child: textFormField(inputType, suffixIcon),
        ),
      );
    }
    return textFormField(inputType, suffixIcon);
  }

  Widget textFormField(TextInputType inputType, Widget? suffixIcon) {
    return TextFormField(
      initialValue: widget.initialValue,
      controller: widget.controller,
      keyboardType: inputType,
      obscureText: obscureState,
      validator: (value) {
        if (widget.validator != null) {
          return widget.validator!(value);
        } else {
          return null;
        }
      },
      readOnly: widget.readOnly,
      focusNode: (widget.focusNode != null) ? widget.focusNode : null,
      onChanged: (value) {
        (widget.onChange != null) ? widget.onChange!(value) : null;
      },
      onEditingComplete: widget.onEditingComplete,
      onTap: () {
        return (widget.onTap != null) ? widget.onTap!() : null;
      },
      style: TextStyle(
        color: widget.textColor ?? Theme.of(context).colorScheme.onSurface,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8, // Adjust this value
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(5),
        //   borderSide: BorderSide(
        //     color: Theme.of(context).colorScheme.onSurfaceVariant,
        //   ),
        // ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        filled: widget.filled,
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorText: widget.errorText,
        errorMaxLines: 3,
        suffixIcon: suffixIcon,
        prefixIcon: (widget.prefixIcon != null) ? widget.prefixIcon : null,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        // fontStyle:  TextStyle(
        //   color: Theme.of(context).colorScheme.error,,

        // ),
      ),
    );
  }
}
