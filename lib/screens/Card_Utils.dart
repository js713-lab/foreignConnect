// card_utils.dart
import 'package:flutter/material.dart';

enum CardBrand { visa, mastercard, amex, discover, other }

class CardUtils {
  static String formatCardNumber(String input) {
    if (input.isEmpty) return '';
    input = input.replaceAll(RegExp(r'\D'), '');
    List<String> groups = [];
    for (int i = 0; i < input.length; i += 4) {
      int end = i + 4;
      if (end > input.length) end = input.length;
      groups.add(input.substring(i, end));
    }
    return groups.join(' ');
  }

  static String formatExpiryDate(String input) {
    if (input.isEmpty) return '';
    input = input.replaceAll(RegExp(r'\D'), '');
    if (input.length > 4) input = input.substring(0, 4);
    if (input.length >= 2) {
      return '${input.substring(0, 2)}/${input.substring(2)}';
    }
    return input;
  }

  static CardBrand getCardBrand(String cardNumber) {
    cardNumber = cardNumber.replaceAll(' ', '');
    if (cardNumber.startsWith('4')) {
      return CardBrand.visa;
    } else if (cardNumber.startsWith('5')) {
      return CardBrand.mastercard;
    } else if (cardNumber.startsWith('3')) {
      return CardBrand.amex;
    } else if (cardNumber.startsWith('6')) {
      return CardBrand.discover;
    }
    return CardBrand.other;
  }

  static Color getCardColor(CardBrand brand) {
    switch (brand) {
      case CardBrand.visa:
        return const Color(0xFFCE7D66);
      case CardBrand.mastercard:
        return const Color(0xFF2962FF);
      case CardBrand.amex:
        return const Color(0xFF00695C);
      case CardBrand.discover:
        return const Color(0xFFFF6F00);
      default:
        return const Color(0xFFCE7D66);
    }
  }
}

class CardDetails {
  final String id;
  final String name;
  final String number;
  final String expiry;
  final String type;
  final String bankName;
  final double balance;
  final String? nickname;
  final Color cardColor;

  CardDetails({
    required this.id,
    required this.name,
    required this.number,
    required this.expiry,
    required this.type,
    required this.bankName,
    required this.balance,
    this.nickname,
    Color? cardColor,
  }) : cardColor =
            cardColor ?? CardUtils.getCardColor(CardUtils.getCardBrand(number));

  CardDetails copyWith({
    String? id,
    String? name,
    String? number,
    String? expiry,
    String? type,
    String? bankName,
    double? balance,
    String? nickname,
    Color? cardColor,
  }) {
    return CardDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      expiry: expiry ?? this.expiry,
      type: type ?? this.type,
      bankName: bankName ?? this.bankName,
      balance: balance ?? this.balance,
      nickname: nickname ?? this.nickname,
      cardColor: cardColor ?? this.cardColor,
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final int? maxLength;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.maxLength,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        counterText: '',
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      maxLength: maxLength,
      validator: validator,
    );
  }
}
