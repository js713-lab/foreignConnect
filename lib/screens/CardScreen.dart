import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'Card_Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'CardDetailScreen.dart';
// import 'package:wallet_manager/wallet_manager.dart';

// card_details.dart
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
      nickname: nickname,
      cardColor: cardColor ?? this.cardColor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nickname': nickname,
      'type': type,
      'number': number,
      'expiry': expiry,
      'bankName': bankName,
      'balance': balance,
      'cardColor': cardColor.value,
    };
  }

  factory CardDetails.fromJson(Map<String, dynamic> json) {
    return CardDetails(
      id: json['id'],
      name: json['name'],
      nickname: json['nickname'],
      type: json['type'],
      number: json['number'],
      expiry: json['expiry'],
      bankName: json['bankName'],
      balance: json['balance'].toDouble(),
      cardColor: Color(json['cardColor']),
    );
  }
}

class CardScreen extends StatefulWidget {
  final String initialName;
  final String initialCardNumber;
  final String initialBalance;
  final String initialBankName;
  final List<CardDetails> cards;
  final CardDetails? defaultCard;
  final Function(List<CardDetails>, CardDetails?) onCardUpdated;
  final Future<void> Function(List<CardDetails>, CardDetails?, CardDetails)
      setDefaultCard;

  const CardScreen({
    super.key,
    required this.initialName,
    required this.initialCardNumber,
    required this.initialBalance,
    required this.initialBankName,
    required this.cards,
    required this.defaultCard,
    required this.onCardUpdated,
    required this.setDefaultCard,
  });

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  bool isPassportSelected = true;
  List<CardDetails> cards = [];
  String? avatarImagePath;
  CardDetails? defaultCard;

  // Passport details
  String passportNumber = '';
  String countriesVisited = '22/195';
  String passportCountry = 'Malaysia';
  String workingVisaNumber = '';
  String workingVisaExpiry = '';
  String workingVisaCountry = '';

  void _showAddCardModal(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String firstName = '';
    String lastName = '';
    String cardNumber = '';
    String expireDate = '';
    String? nickname;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Card',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'First Name',
                onChanged: (value) => firstName = value,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Last Name',
                onChanged: (value) => lastName = value,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Card Number',
                hintText: 'XXXX-XXXX-XXXX-XXXX',
                onChanged: (value) {
                  cardNumber = CardUtils.formatCardNumber(value);
                },
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  if (value!.replaceAll(' ', '').length != 16) {
                    return 'Invalid card number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Expire-Date',
                      hintText: 'MM/YY',
                      onChanged: (value) {
                        expireDate = CardUtils.formatExpiryDate(value);
                      },
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      label: 'CVV',
                      maxLength: 3,
                      obscureText: true,
                      onChanged:
                          (value) {}, // Just handle the value in validation
                      validator: (value) =>
                          (value?.length ?? 0) != 3 ? 'Invalid CVV' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Card Nickname (Optional)',
                onChanged: (value) => nickname = value.isEmpty ? null : value,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    setState(() {
                      cards.add(CardDetails(
                        id: DateTime.now().toString(),
                        name: '$firstName $lastName',
                        number: cardNumber,
                        expiry: expireDate,
                        type: CardUtils.getCardBrand(cardNumber).toString(),
                        bankName: 'New Bank',
                        balance: 0.0,
                        nickname: nickname,
                      ));
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCE7D66),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Add'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCards();
    // Initialize with default card if no cards exist
    if (cards.isEmpty) {
      cards.add(
        CardDetails(
          id: '1',
          name: widget.initialName,
          number: widget.initialCardNumber,
          expiry: '08/2029',
          type: CardUtils.getCardBrand(widget.initialCardNumber).toString(),
          bankName: widget.initialBankName,
          balance: double.parse(widget.initialBalance.replaceAll(',', '')),
        ),
      );
    }
  }

  Future<void> _loadCards() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cardsJsonStr = prefs.getString('cards');
      final defaultCardId = prefs.getString('default_card_id');

      if (cardsJsonStr != null) {
        final cardsList = jsonDecode(cardsJsonStr) as List;
        setState(() {
          cards = cardsList.map((card) => CardDetails.fromJson(card)).toList();
          if (defaultCardId != null && cards.isNotEmpty) {
            defaultCard = cards.firstWhere(
              (card) => card.id == defaultCardId,
              orElse: () => cards.first,
            );
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading default card: $e');
    }
  }

  Future<void> _saveCards() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cardsJsonStr =
          jsonEncode(cards.map((card) => card.toJson()).toList());
      await prefs.setString('cards', cardsJsonStr);

      if (defaultCard != null) {
        await prefs.setString('default_card_id', defaultCard!.id);
      }

      widget.onCardUpdated(cards, defaultCard);
    } catch (e) {
      debugPrint('Error loading default card: $e');
    }
  }

  // Add this method to handle setting default card
  Future<void> _handleSetAsDefault(CardDetails card) async {
    setState(() {
      defaultCard = card;
    });
    await _saveCards();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarImagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Account and card'),
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: isPassportSelected
                ? _buildPassportView()
                : _buildCardListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isPassportSelected = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isPassportSelected
                      ? const Color(0xFFCE7D66)
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    'Passport',
                    style: TextStyle(
                      color: isPassportSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isPassportSelected = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isPassportSelected
                      ? const Color(0xFFCE7D66)
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    'Card',
                    style: TextStyle(
                      color: !isPassportSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassportView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              backgroundImage: avatarImagePath != null
                  ? FileImage(File(avatarImagePath!))
                  : null,
              child: avatarImagePath == null
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.initialName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A0DAB), // Match design's blue color
            ),
          ),
          const SizedBox(height: 32),
          _buildPassportSection(),
          const SizedBox(height: 32),
          _buildWorkingVisaSection(),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => _showModifyPassportModal(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCE7D66),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Modify'),
          ),
        ],
      ),
    );
  }

  Widget _buildPassportSection() {
    return Column(
      children: [
        _buildInfoRow('Passport', passportNumber),
        _buildInfoRow('Country You Had Been', countriesVisited),
        _buildInfoRow('Passport Country', passportCountry),
      ],
    );
  }

  Widget _buildWorkingVisaSection() {
    return Column(
      children: [
        _buildBankInfoRow('Working Visa', workingVisaNumber),
        _buildInfoRow('Expire', workingVisaExpiry),
        _buildInfoRow('Country', workingVisaCountry),
      ],
    );
  }

  Widget _buildCardListView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ...cards.map((card) => GestureDetector(
                onTap: () => _navigateToCardDetail(card),
                child: _buildCardItem(card),
              )),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showAddCardModal(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCE7D66),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Add card'),
          ),
        ],
      ),
    );
  }

  Widget _buildCardItem(CardDetails card) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFCE7D66), const Color(0xFFE9967A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            card.bankName,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 24),
          Text(
            card.number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${card.balance.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'VISA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToCardDetail(CardDetails card) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardDetailScreen(
          card: card,
          cards: widget.cards, // Use widget.cards instead of cards
          defaultCard: widget.defaultCard, // Use widget.defaultCard
          onRemove: () {
            setState(() {
              widget.cards.removeWhere((c) => c.id == card.id);
              widget.onCardUpdated(widget.cards, widget.defaultCard);
            });
            Navigator.pop(context);
          },
          onUpdate: (updatedCard) {
            setState(() {
              final index =
                  widget.cards.indexWhere((c) => c.id == updatedCard.id);
              if (index != -1) {
                widget.cards[index] = updatedCard;
                widget.onCardUpdated(widget.cards, widget.defaultCard);
              }
            });
          },
          setDefaultCard: widget.setDefaultCard,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBankInfoRow(String bank, String number) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            bank,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(number),
        ],
      ),
    );
  }

  void _showModifyPassportModal(BuildContext context) {
    String tempPassportNumber = passportNumber;
    String tempCountriesVisited = countriesVisited;
    String tempPassportCountry = passportCountry;
    String tempVisaNumber = workingVisaNumber;
    String tempVisaExpiry = workingVisaExpiry;
    String tempVisaCountry = workingVisaCountry;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Modify Passport Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                labelText: 'Passport Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => tempPassportNumber = value,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Countries Visited',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => tempCountriesVisited = value,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Passport Country',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => tempPassportCountry = value,
            ),
            const SizedBox(height: 24),
            const Text(
              'Working Visa Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Visa Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => tempVisaNumber = value,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Expiry Date',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => tempVisaExpiry = value,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Country',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => tempVisaCountry = value,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  passportNumber = tempPassportNumber;
                  countriesVisited = tempCountriesVisited;
                  passportCountry = tempPassportCountry;
                  workingVisaNumber = tempVisaNumber;
                  workingVisaExpiry = tempVisaExpiry;
                  workingVisaCountry = tempVisaCountry;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCE7D66),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Save Changes'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Enums and Constants
enum CardBrand { visa, mastercard, amex, discover, other }

class CardConstants {
  static const Map<CardBrand, String> brandIcons = {
    CardBrand.visa: 'assets/visa_logo.png',
    CardBrand.mastercard: 'assets/mastercard_logo.png',
    CardBrand.amex: 'assets/amex_logo.png',
    CardBrand.discover: 'assets/discover_logo.png',
  };

  static const Map<CardBrand, List<Color>> brandColors = {
    CardBrand.visa: [Color(0xFFCE7D66), Color(0xFFE9967A)],
    CardBrand.mastercard: [Color(0xFF2962FF), Color(0xFF448AFF)],
    CardBrand.amex: [Color(0xFF00695C), Color(0xFF00897B)],
    CardBrand.discover: [Color(0xFFFF6F00), Color(0xFFFF9800)],
  };

  static CardBrand detectBrand(String cardNumber) {
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
}

Future<void> _handleAddToAppleWallet(BuildContext context) async {
  try {
    // Simulate adding to Apple Wallet
    await Future.delayed(const Duration(seconds: 1));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully added to Apple Wallet'),
          backgroundColor: Colors.green,
        ),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to Apple Wallet: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class CardEditDialog extends StatefulWidget {
  final CardDetails card;
  final Function(CardDetails) onUpdate;

  const CardEditDialog({
    super.key,
    required this.card,
    required this.onUpdate,
  });

  @override
  State<CardEditDialog> createState() => _CardEditDialogState();
}

class _CardEditDialogState extends State<CardEditDialog> {
  late TextEditingController _nicknameController;
  late TextEditingController _balanceController;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.card.nickname);
    _balanceController = TextEditingController(
      text: widget.card.balance.toString(),
    );
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Card Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            label: 'Card Nickname',
            controller: _nicknameController,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Balance',
            controller: _balanceController,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedCard = widget.card.copyWith(
              nickname: _nicknameController.text.isEmpty
                  ? null
                  : _nicknameController.text,
              balance: double.tryParse(_balanceController.text) ??
                  widget.card.balance,
            );
            widget.onUpdate(updatedCard);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFCE7D66),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
