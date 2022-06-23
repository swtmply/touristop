import 'package:flutter/material.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/theme/app_spacing.dart';

class Filters extends StatefulWidget {
  final List<String> filterItems;
  final List<String>? selectedItems;
  final Function(String val) onChange;
  const Filters(
      {Key? key,
      required this.filterItems,
      this.selectedItems,
      required this.onChange})
      : super(key: key);

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  @override
  Widget build(BuildContext context) {
    final filterItems = widget.filterItems;
    final selectedItems = widget.selectedItems ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filters:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.darkGray,
          ),
        ),
        const SizedBox(
          height: AppSpacing.small,
        ),
        SizedBox(
          width: double.infinity,
          height: 35,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filterItems
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          widget.onChange(item);
                        },
                        child: FilterButton(
                          item: item,
                          isSelected: selectedItems.contains(item),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton({Key? key, required this.item, required this.isSelected})
      : super(key: key);

  final String item;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: isSelected
            ? null
            : Border.all(
                color: Colors.black,
              ),
        gradient:
            isSelected ? const LinearGradient(colors: AppColors.sToCB) : null,
      ),
      child: Center(
        child: Text(
          item,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : null,
          ),
        ),
      ),
    );
  }
}
