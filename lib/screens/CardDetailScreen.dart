import 'package:flutter/material.dart';
import 'CardScreen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CardDetailScreen extends StatefulWidget {
  final CardDetails card;
  final VoidCallback onRemove;
  final Function(CardDetails) onUpdate;
  final List<CardDetails> cards;
  final CardDetails? defaultCard;
  final Function(List<CardDetails>, CardDetails?, CardDetails) setDefaultCard;

  const CardDetailScreen({
    super.key,
    required this.card,
    required this.onRemove,
    required this.onUpdate,
    required this.cards,
    required this.defaultCard,
    required this.setDefaultCard,
  });

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  CardDetails? defaultCard;

  @override
  void initState() {
    super.initState();
    defaultCard = widget.defaultCard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.card.nickname ?? widget.card.type),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCardView(),
          const SizedBox(height: 24),
          _buildWalletButton(context),
          const SizedBox(height: 16),
          _buildSetDefaultButton(context),
          _buildCardDetails(),
          const Spacer(),
          _buildRemoveButton(context),
        ],
      ),
    );
  }

  Widget _buildSetDefaultButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () =>
            widget.setDefaultCard(widget.cards, defaultCard, widget.card),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFCE7D66),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Set as Default Card'),
      ),
    );
  }

  Future<void> setDefaultCard(List<CardDetails> cards, CardDetails? defaultCard,
      CardDetails card) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('default_card_id', card.id);

      setState(() {
        this.defaultCard = card;
      });
      await saveCards(cards, this.defaultCard);
    } catch (e) {
      print('Error setting default card: $e');
    }
  }

  Future<void> saveCards(
      List<CardDetails> cards, CardDetails? defaultCard) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cardsJson = jsonEncode(cards.map((card) => card.toJson()).toList());
      await prefs.setString('cards', cardsJson);

      if (defaultCard != null) {
        await prefs.setString('default_card_id', defaultCard.id);
      }
    } catch (e) {
      debugPrint('Error saving cards: $e');
    }
  }

  Widget _buildCardView() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.card.cardColor,
            widget.card.cardColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: widget.card.cardColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.card.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.card.nickname != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.card.nickname!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    widget.card.bankName,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '575',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            widget.card.number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.card.expiry,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.card.type,
                  style: TextStyle(
                    color: widget.card.cardColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleAddToWallet(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/apple_wallet.png',
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'Add To Apple Wallet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardDetails() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            'Available Balance',
            '\$${widget.card.balance.toStringAsFixed(2)}',
          ),
          const Divider(height: 24),
          _buildDetailRow('Card Type', widget.card.type),
          const SizedBox(height: 12),
          _buildDetailRow('Card Number',
              '•••• ${widget.card.number.substring(widget.card.number.length - 4)}'),
          const SizedBox(height: 12),
          _buildDetailRow('Expiry Date', widget.card.expiry),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildRemoveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () => _showRemoveConfirmation(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[400],
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Remove Card'),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CardEditDialog(
        card: widget.card,
        onUpdate: widget.onUpdate,
      ),
    );
  }

  Future<void> _handleAddToWallet(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (context.mounted) {
        Navigator.pop(context); // Remove loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully added to Apple Wallet'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Remove loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add to Apple Wallet: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showRemoveConfirmation(BuildContext context) {
    // Add context parameter
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Card'),
        content: const Text(
          'Are you sure you want to remove this card? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onRemove();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
