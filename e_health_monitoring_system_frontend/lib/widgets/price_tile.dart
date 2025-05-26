import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:flutter/widgets.dart';

class PriceTile extends StatelessWidget {
  final String consultationType;
  final String price;
  const PriceTile({
    super.key,
    required this.consultationType,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: ColorsHelper.lightGray,
          border: Border.all(color: ColorsHelper.mediumGray),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                consultationType,
                softWrap: true,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorsHelper.darkGray,
                ),
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorsHelper.darkGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
