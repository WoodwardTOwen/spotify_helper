import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_helper/widgets/user_stats_widgets/track_tile.dart';

import '../../providers/user_stats_provider.dart';

class UserStatTrackList extends StatefulWidget {
  final String _trackKey;

  const UserStatTrackList({Key? key, required String trackKey})
      : _trackKey = trackKey,
        super(key: key);

  @override
  State<UserStatTrackList> createState() => _UserStatTrackListState();
}

class _UserStatTrackListState extends State<UserStatTrackList> {
  bool _isShow5More = false;

  Widget _buildTrackList(String timeRange) {
    return Consumer<UserStatsProvider>(
      builder: (ctx, data, _) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: ((ctx, index) => TrackTile(
              trackItem: data.getUserTopTracksMap[timeRange]![index],
              indexValue: index + 1,
            )),
        itemCount: data.getUserTopTracksMap[timeRange]!.length,
      ),
    );
  }

  Widget _buildTextButton(BuildContext context, String key) {
    return TextButton(
        onPressed: () => _onButtonClick(context, key),
        child: Text(_isShow5More ? "Show 5 Less" : "Show 5 More",
            style: const TextStyle(fontSize: 16, color: Colors.black54)));
  }

  void _getMoreItems(BuildContext context, String key) async =>
      await Provider.of<UserStatsProvider>(context, listen: false)
          .fetchMoreItems(key: key)
          .then((value) => setState(() {}));

  void _removeLast5Items(String key) {
    Provider.of<UserStatsProvider>(context, listen: false)
        .removeLast5Items(key);
    setState(() {});
  }

  void _onButtonClick(BuildContext context, String key) {
    _isShow5More = !_isShow5More;
    _isShow5More ? _getMoreItems(context, key) : _removeLast5Items(key);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildTrackList(widget._trackKey),
      _buildTextButton(context, widget._trackKey)
    ]);
  }
}
