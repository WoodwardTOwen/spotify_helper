import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../screens/settings_screen.dart';
import 'network_image.dart';

class GenericHeader extends StatelessWidget {
  final String imageUrl;
  final String titleText;
  final String subtitleText;
  final bool isUserProfile;

  const GenericHeader(
      {Key? key,
      required this.imageUrl,
      required this.titleText,
      required this.subtitleText,
      this.isUserProfile = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Stack(
        children: [
          Align(
              alignment: Alignment.topRight + const Alignment(0.1, 0),
              child: isUserProfile
                  ? IconButton(
                      icon: const Icon(
                        Icons.settings,
                        size: 26,
                        color: Colors.white,
                      ),
                      onPressed: () => pushNewScreen(context,
                          screen: const SettingsScreen()),
                    )
                  : null),
          Align(
            alignment: Alignment.centerLeft,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 43.0,
              child: CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.transparent,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(40.0),
                    child: MyNetworkImage(imageUrl: imageUrl)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.only(left: 100),
              child: Text(
                titleText,
                style: Theme.of(context).textTheme.headline5,
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight +
                const Alignment(
                  0,
                  0.4,
                ),
            child: Text(
              subtitleText,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ],
      ),
    );
  }
}
