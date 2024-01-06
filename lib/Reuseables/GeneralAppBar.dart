import 'package:flutter/material.dart';

import 'CircleImage.dart';

class GeneralAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String imageUrl;
  final String? status;
  final String? tag;
  final List<PopupMenuEntry<dynamic>> menuItems;
  final void Function(dynamic) onMenuSelect;
  final void Function()? onProfileTap;
  final void Function()? onSearchTap;

  const GeneralAppBar({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.menuItems,
    required this.onMenuSelect,
    this.onProfileTap,
    this.onSearchTap,
    this.status,
    this.tag
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 90,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BackButton(), // Default back button
          GestureDetector(
            onTap: onProfileTap,
            child: Hero(
              tag: tag ?? "",
              child: CircleImage(
                imageUrl: imageUrl,
                size: 40,
              ),
            ),
          ),
        ],
      ),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (status != null)
              Text(
                status!,
              style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: onSearchTap,
        ),
        PopupMenuButton<dynamic>(
          icon: const Icon(Icons.more_vert),
          onSelected: onMenuSelect,
          itemBuilder: (BuildContext context) => menuItems,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
