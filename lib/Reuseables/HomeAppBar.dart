import 'package:flutter/material.dart';
import 'package:untitled2/Reuseables/CircleImage.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? tag;
  final String imageUrl;
  final List<PopupMenuEntry<dynamic>> menuItems;
  final void Function(dynamic) onMenuSelect;
  final void Function()? onProfileTap;

  const HomeAppBar({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.menuItems,
    required this.onMenuSelect,
    this.onProfileTap,
    this.tag
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Container(
        padding: const EdgeInsets.all(1),
        margin: const EdgeInsets.only(left: 10),
        child: GestureDetector(
          onTap: onProfileTap,
          child: Hero(
            tag: tag ?? "",
            child: CircleImage(
              imageUrl: imageUrl,
              size: 20,
            ),
          ),
        ),
      ),
      title: Text(title),
      automaticallyImplyLeading: false,
      actions: <Widget>[
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
