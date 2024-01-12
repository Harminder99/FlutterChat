import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/Reuseables/CircleImage.dart';

import '../Home/HomeScreenViewModel.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? tag;
  final String imageUrl;
  final List<PopupMenuEntry<dynamic>> menuItems;
  final void Function(dynamic) onMenuSelect;
  final void Function()? onProfileTap;
  final void Function()? onAddUsers;
  final void Function()? onDeleteUsers;

  const HomeAppBar({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.menuItems,
    required this.onMenuSelect,
    this.onAddUsers,
    this.onProfileTap,
    this.tag,
    this.onDeleteUsers
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeScreenViewModel = Provider.of<HomeScreenViewModel>(context);
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
        if(homeScreenViewModel.selectedUserIds == null || homeScreenViewModel.selectedUserIds!.isEmpty)
       Row(
         children: [
           IconButton(
             icon: const Icon(
               Icons.add,
               color: Colors.white, // Color of the plus icon
             ),
             onPressed: onAddUsers,
           ),
           PopupMenuButton<dynamic>(
             icon: const Icon(Icons.more_vert),
             onSelected: onMenuSelect,
             itemBuilder: (BuildContext context) => menuItems,
           )
         ],
       ),
        if(homeScreenViewModel.selectedUserIds != null && homeScreenViewModel.selectedUserIds!.isNotEmpty)
        IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.white, // Color of the plus icon
          ),
          onPressed: onDeleteUsers,
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
