// import 'package:flutter/material.dart';

// class TransactionCard extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final String amount;
//   final bool isCredit;

//   TransactionCard({
//     required this.title,
//     required this.subtitle,
//     required this.amount,
//     required this.isCredit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Card(
//       color: theme.cardColor, // Adapt card color
//       margin: const EdgeInsets.only(bottom: 15),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: isCredit
//               ? Colors.red.withOpacity(0.1)
//               : Colors.green.withOpacity(0.1),
//           child: Icon(
//             isCredit ? Icons.arrow_downward : Icons.arrow_upward,
//             color: isCredit ? Colors.red : Colors.green,
//           ),
//         ),
//         title: Text(
//           title,
//           style: theme.textTheme.titleLarge, // Adapt text color
//         ),
//         subtitle: Text(
//           subtitle,
//           style: theme.textTheme.bodyMedium, // Adapt text color
//         ),
//         trailing: Text(
//           amount,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: isCredit ? Colors.red : Colors.green,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final bool isCredit;
  final IconData arrowIcon;
  final Color arrowColor;

  const TransactionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isCredit,
    required this.arrowIcon,
    required this.arrowColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          // Leading icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: arrowColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              arrowIcon,
              color: arrowColor,
              size: 20,
            ),
          ),

          const SizedBox(width: 14),

          // Title + Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  // overflow: TextOverflow.ellipsis,
                  softWrap: true, // Allows wrapping to a new line
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Amount
          Text(
            amount,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: arrowColor,
            ),
          ),
        ],
      ),
    );
  }
}
