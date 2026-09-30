import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../cart/presentation/cubic/cubic.dart';
import '../../../cart/presentation/cubic/state.dart';
import '../../domain/entities/coffe.dart';

/// Full-screen details for one drink: photo, tasting note, price in EGP
/// and the add-to-cart action.
class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.coffee});

  final Coffee coffee;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _quantity = 1;

  Coffee get _coffee => widget.coffee;

  double get _totalEgp => _coffee.priceEgp * _quantity;

  void _changeQuantity(int delta) {
    setState(() => _quantity = (_quantity + delta).clamp(1, 20));
  }

  void _addToCart() {
    context.read<CartCubit>().add(_coffee, quantity: _quantity);

    final cart = context.read<CartCubit>().state;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppColors.darkEspresso,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Text(
            '${_coffee.name} added to cart'
            ' — ${cart.totalCount} item(s),'
            ' ${CartState.formattedEgp(cart.totalPriceEgp)}',
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: AppColors.creamPaper,
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkEspresso,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.creamPaper,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImage(),
                      const SizedBox(height: 18),
                      _buildName(),
                      const SizedBox(height: 16),
                      _buildNote(),
                      const SizedBox(height: 16),
                      _buildPrice(),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 20, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back, size: 22),
            color: AppColors.darkEspresso,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تفاصيل المشروب',
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    color: AppColors.darkEspresso,
                  ),
                ),
                Text(
                  ' drink details',
                  style: GoogleFonts.caveat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.coffeeLight,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.local_cafe,
            size: 26,
            color: AppColors.coffeeLight,
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Hero(
      tag: 'drink-${_coffee.id}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 230,
          width: double.infinity,
          child: Image.network(
            _coffee.image,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return ColoredBox(
                color: AppColors.leather,
                child: const Center(
                  child: Icon(
                    Icons.local_cafe,
                    size: 54,
                    color: AppColors.creamPaper,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildName() {
    return Text(
      _coffee.name.toUpperCase(),
      style: GoogleFonts.cairo(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        height: 1.15,
        letterSpacing: 0.5,
        color: AppColors.darkEspresso,
      ),
    );
  }

  /// The "note about the drink": a short tasting description.
  Widget _buildNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.edit_note,
              size: 20,
              color: AppColors.coffeeLight,
            ),
            const SizedBox(width: 6),
            Text(
              'NOTE — ملاحظة',
              style: GoogleFonts.specialElite(
                fontSize: 13,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                color: AppColors.coffeeLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.warmCream,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.darkEspresso.withValues(alpha: 0.15),
            ),
          ),
          child: Text(
            _coffee.description,
            textDirection: TextDirection.rtl,
            style: GoogleFonts.cairo(
              fontSize: 15,
              height: 1.7,
              color: AppColors.coffeeLight,
            ),
          ),
        ),
      ],
    );
  }

  /// The price shown in Egyptian Pounds.
  Widget _buildPrice() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.pastelPink,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'السعر',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.darkEspresso,
              ),
            ),
          ),
          Text(
            _coffee.formattedPriceEgp,
            style: GoogleFonts.specialElite(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: AppColors.darkEspresso,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.creamPaper,
        border: Border(
          top: BorderSide(
            color: AppColors.darkEspresso.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: Row(
        children: [
          _buildQuantitySelector(),
          const SizedBox(width: 14),
          Expanded(child: _buildTotal()),
          const SizedBox(width: 12),
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.darkEspresso.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          _QuantityButton(
            icon: Icons.remove,
            onTap: _quantity > 1 ? () => _changeQuantity(-1) : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              '$_quantity',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.darkEspresso,
              ),
            ),
          ),
          _QuantityButton(
            icon: Icons.add,
            onTap: _quantity < 20 ? () => _changeQuantity(1) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildTotal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'الإجمالي',
          style: GoogleFonts.cairo(
            fontSize: 12,
            color: AppColors.coffeeLight,
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            CartState.formattedEgp(_totalEgp),
            style: GoogleFonts.specialElite(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: AppColors.darkEspresso,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: _addToCart,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkEspresso,
        foregroundColor: AppColors.creamPaper,
        elevation: 4,
        shadowColor: AppColors.darkEspresso.withValues(alpha: 0.4),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: const Icon(Icons.add_shopping_cart, size: 18),
      label: Text(
        'أضف للسلة',
        style: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Icon(
          icon,
          size: 18,
          color: onTap == null
              ? AppColors.darkEspresso.withValues(alpha: 0.3)
              : AppColors.darkEspresso,
        ),
      ),
    );
  }
}
