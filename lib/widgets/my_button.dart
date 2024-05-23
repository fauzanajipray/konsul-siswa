import 'package:flutter/material.dart';

enum TypeButton { outlined, filled, elevated }

class MyButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final double fontSize;
  final double verticalPadding;
  final double horizontalPadding;
  final bool disable;
  final Color? color;
  final Color? textColor;
  final double borderRadius;
  final TypeButton typeButton;
  final FocusNode? focusNode;

  const MyButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.fontSize = 16,
    this.horizontalPadding = 25,
    this.verticalPadding = 20,
    this.borderRadius = 5,
    this.typeButton = TypeButton.filled,
    this.disable = false,
    this.color,
    this.textColor,
    this.focusNode,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  ButtonStyleButton? btn;

  @override
  Widget build(BuildContext context) {
    switch (widget.typeButton) {
      case TypeButton.outlined:
        return SizedBox(width: double.infinity, child: _outlinedButton());
      case TypeButton.filled:
        return SizedBox(width: double.infinity, child: _filledButton());
      case TypeButton.elevated:
        return SizedBox(width: double.infinity, child: _elevatedButton());
    }
  }

  ButtonStyleButton _filledButton() {
    return FilledButton(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding,
            vertical: widget.verticalPadding),
        backgroundColor: widget.color ?? Theme.of(context).colorScheme.primary,
        disabledBackgroundColor: widget.color?.withOpacity(0.5),
        disabledForegroundColor:
            Colors.white, // color : Theme.of(context).colorScheme.primary
      ),
      focusNode: (widget.focusNode != null) ? widget.focusNode : null,
      onPressed: (widget.disable) ? null : widget.onPressed,
      child: Text(
        widget.text,
        style: TextStyle(
          fontSize: widget.fontSize,
          color: widget.textColor ?? Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  ButtonStyleButton _elevatedButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding,
            vertical: widget.verticalPadding),
        backgroundColor: widget.color,
      ),
      focusNode: (widget.focusNode != null) ? widget.focusNode : null,
      onPressed: (widget.disable) ? null : widget.onPressed,
      child: Text(
        widget.text,
        style: TextStyle(
          fontSize: widget.fontSize,
          color: widget.textColor ?? Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  ButtonStyleButton _outlinedButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: widget.color ?? Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding,
            vertical: widget.verticalPadding),
        side: BorderSide(
            color: widget.color ?? Theme.of(context).colorScheme.primary),
      ),
      focusNode: (widget.focusNode != null) ? widget.focusNode : null,
      onPressed: (widget.disable) ? null : widget.onPressed,
      child: Text(
        widget.text,
        style: TextStyle(
          fontSize: widget.fontSize,
          color: widget.textColor ??
              Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
