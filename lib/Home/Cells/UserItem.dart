import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/Utiles/Utiles.dart';

class UserItem extends StatelessWidget {
  final String imageUrl;
  final String username;
  final String message;
  final DateTime? date;
  final int count;
  final bool isSelected;
  final String tag;

  // tap call backs
  final VoidCallback? onCellTap;
  final VoidCallback? onImageTap;
  final VoidCallback? onLongTap;

  const UserItem({
    super.key,
    required this.tag,
    required this.imageUrl,
    required this.username,
    required this.message,
    this.date,
    this.onCellTap,
    this.onImageTap,
    this.onLongTap,
    required this.count,
    this.isSelected = false,
  });



  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onCellTap,
      onLongPress: onLongTap,
      child: Container(
        color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image
              GestureDetector(
                onTap: () {
                  if(onImageTap != null) {
                    onImageTap!();
                  }
                },
                child: Hero(
                  tag: tag,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage('https://picsum.photos/200'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Username and Message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontStyle: FontStyle.normal,fontSize: 13),
                    ),
                  ],
                ),
              ),

              // Spacing
              const SizedBox(width: 10),

              Column(
                children: [
                  if (date != null)
                    Text(
                      Utils.formatAgoTime(date!),
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  if (count > 0)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(4),
                    // Add some padding around the text
                    decoration: BoxDecoration(
                      color: Colors.red, // Background color of the badge
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16, // Minimum width of the badge
                      minHeight: 16, // Minimum height of the badge
                    ),
                    child: Text(
                      Utils.formatCount(count), // The count to display
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


}
