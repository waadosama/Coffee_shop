import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/cart_item.dart';
import '../cubic/cubic.dart';
import '../cubic/state.dart';

/// The shopping cart: every line item with its quantity stepper, the EGP
/// running total and the checkout action.
///
/// Reads and writes the shared [CartCubit] provided above the Navigator, so
/// changes here are immediately reflected in the menu header badge.
class CartPage extends StatelessWidget {
  const CartPage({super.key});

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
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _CartHeader(state: state),
                  Expanded(
                    child: state.isEmpty
                        ? const _EmptyCart()
                        : _CartList(state: state),
                  ),
                  if (!state.isEmpty) _SummaryBar(state: state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Back button + page title, plus a "clear all" action while the cart has
/// something in it.
class _CartHeader extends StatelessWidget {
  const _CartHeader({required this.state});

  final CartState state;

  @override
  Widget build(BuildContext context) {
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
                  'سلة المشتريات',
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    color: AppColors.darkEspresso,
                  ),
                ),
                Text(
                  ' your cart',
                  style: GoogleFonts.caveat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.coffeeLight,
                  ),
                ),
              ],
            ),
          ),
          if (state.isEmpty)
            const Icon(
              Icons.shopping_basket_outlined,
              size: 26,
              color: AppColors.coffeeLight,
            )
          else
            Text(
              '${state.totalCount} منتج',
              textDirection: TextDirection.rtl,
              style: GoogleFonts.specialElite(
                fontSize: 13,
                letterSpacing: 1.2,
                color: AppColors.coffeeLight,
              ),
            ),
          if (!state.isEmpty) ...[
            const SizedBox(width: 4),
            IconButton(
              onPressed: () => _confirmClear(context),
              tooltip: 'تفريغ السلة',
              icon: const Icon(Icons.delete_sweep_outlined, size: 22),
              color: AppColors.coffeeLight,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
            ),
          ],
        ],
      ),
    );
  }

  /// Emptying the whole cart is destructive, so it asks first.
  void _confirmClear(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.creamPaper,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: Text(
            'تفريغ السلة؟',
            textDirection: TextDirection.rtl,
            style: GoogleFonts.cairo(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.darkEspresso,
            ),
          ),
          content: Text(
            'سيتم حذف كل المشروبات من السلة.',
            textDirection: TextDirection.rtl,
            style: GoogleFonts.cairo(
              fontSize: 14,
              height: 1.6,
              color: AppColors.coffeeLight,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'إلغاء',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: AppColors.coffeeLight,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<CartCubit>().clear();
              },
              child: Text(
                'تفريغ',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkEspresso,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Scrollable list of the drinks currently in the cart.
class _CartList extends StatelessWidget {
  const _CartList({required this.state});

  final CartState state;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      itemCount: state.items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return _CartItemTile(item: state.items[index]);
      },
    );
  }
}

/// One cart line: photo, name, unit price, quantity stepper, line subtotal
/// and a button that drops the line entirely.
class _CartItemTile extends StatelessWidget {
  const _CartItemTile({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final coffee = item.coffee;
    final cart = context.read<CartCubit>();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warmCream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.darkEspresso.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 66,
              height: 66,
              child: Image.network(
                coffee.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const ColoredBox(
                    color: AppColors.leather,
                    child: Icon(
                      Icons.local_cafe,
                      size: 26,
                      color: AppColors.creamPaper,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        coffee.name.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                          height: 1.2,
                          color: AppColors.darkEspresso,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () => cart.remove(coffee.id),
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.coffeeLight,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  coffee.formattedPriceEgp,
                  style: GoogleFonts.specialElite(
                    fontSize: 13,
                    letterSpacing: 1,
                    color: AppColors.coffeeLight,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _QuantitySelector(item: item),
                    const Spacer(),
                    Text(
                      CartState.formattedEgp(item.subtotalEgp),
                      style: GoogleFonts.specialElite(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: AppColors.darkEspresso,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// `-  n  +` stepper bound to the shared cart.
class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartCubit>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.darkEspresso.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          _StepperButton(
            icon: Icons.remove,
            onTap: () => cart.decrease(item.coffee.id),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              '${item.quantity}',
              style: GoogleFonts.cairo(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.darkEspresso,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add,
            onTap: item.quantity < 20
                ? () => cart.increase(item.coffee.id)
                : null,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        child: Icon(
          icon,
          size: 17,
          color: onTap == null
              ? AppColors.darkEspresso.withValues(alpha: 0.3)
              : AppColors.darkEspresso,
        ),
      ),
    );
  }
}

/// Order summary pinned to the bottom: item count, EGP total and checkout.
class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.state});

  final CartState state;

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'الإجمالي · ${state.totalCount} منتج',
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: AppColors.coffeeLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      CartState.formattedEgp(state.totalPriceEgp),
                      style: GoogleFonts.specialElite(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: AppColors.darkEspresso,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.receipt_long,
                size: 30,
                color: AppColors.coffeeLight,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () => _checkout(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkEspresso,
              foregroundColor: AppColors.creamPaper,
              elevation: 4,
              shadowColor: AppColors.darkEspresso.withValues(alpha: 0.4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.coffee, size: 18),
            label: Text(
              'إتمام الطلب',
              textDirection: TextDirection.rtl,
              style: GoogleFonts.cairo(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Confirms the order, empties the cart and returns to the menu with a
  /// short receipt-style message.
  void _checkout(BuildContext context) {
    final cart = context.read<CartCubit>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final summary =
        '${state.totalCount} item(s),'
        ' ${CartState.formattedEgp(state.totalPriceEgp)}';

    cart.clear();

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppColors.darkEspresso,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Text(
            'تم تأكيد طلبك — order placed: $summary',
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: AppColors.creamPaper,
            ),
          ),
        ),
      );

    navigator.maybePop();
  }
}

/// Shown instead of the list when there is nothing to buy yet.
class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: AppColors.coffeeLight,
          ),
          const SizedBox(height: 14),
          Text(
            'السلة فارغة',
            textDirection: TextDirection.rtl,
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.darkEspresso,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'your cart is empty.',
            style: GoogleFonts.caveat(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.coffeeLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أضف مشروبك المفضل من المنيو',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 14,
              height: 1.6,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).maybePop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.darkEspresso,
              side: BorderSide(
                color: AppColors.darkEspresso.withValues(alpha: 0.5),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.restaurant_menu, size: 18),
            label: Text(
              'تصفّح المنيو',
              textDirection: TextDirection.rtl,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
