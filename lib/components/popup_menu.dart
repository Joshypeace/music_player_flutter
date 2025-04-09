import 'package:audio_player/providers/music_provider.dart';
import 'package:audio_player/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopMenu extends StatefulWidget {
  const PopMenu({super.key});

  @override
  State<PopMenu> createState() => _PopMenuState();
}

class _PopMenuState extends State<PopMenu> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final musicProvider = Provider.of<MusicProvider>(context);

    return PopupMenuButton(
      color: theme.surface, // Adjusted transparency
      iconColor: theme.inversePrimary, // Themed icon color
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            onTap: () {
              _showSortOptions(context, musicProvider);
            },
            child: ListTile(
              title: Text(
                'Sort Order',
                style: TextStyle(
                  color: theme.onSurface.withAlpha(200),
                  fontSize: 18,
                ),
              ),
              trailing: Icon(
                Icons.arrow_right,
                color: theme.onSurface.withAlpha(200),
                size: 26,
              ),
            ),
          ),
          PopupMenuItem(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
            child: ListTile(
              title: Text(
                'Settings',
                style: TextStyle(
                  color: theme.onSurface.withAlpha(200),
                  fontSize: 18,
                ),
              ),
              trailing: Icon(
                Icons.arrow_right,
                color: theme.onSurface.withAlpha(200),
                size: 26,
              ),
            ),
          ),
        ];
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      popUpAnimationStyle: AnimationStyle(
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _showSortOptions(BuildContext context, MusicProvider musicProvider) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = overlay.localToGlobal(Offset.zero);

    final theme = Theme.of(context).colorScheme;

    await showMenu(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: theme.surface,
      position: RelativeRect.fromLTRB(position.dx + 50, position.dy + 40, 0, 0),
      items: SortOrder.values.map((sortOption) {
        return PopupMenuItem(
          value: sortOption,
          child: RadioListTile<SortOrder>(
            fillColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) {
                if (states.contains(WidgetState.selected)) {
                  return theme.inversePrimary;
                }
                return theme.outline;
              },
            ),
            title: Text(
              _getSortOrderText(sortOption),
              style: TextStyle(
                color: theme.onSurface.withAlpha(200),
                fontSize: 16,
              ),
            ),
            value: sortOption,
            groupValue: musicProvider.selectedSortOrder,
            onChanged: (SortOrder? value) {
              if (value != null) {
                musicProvider.changeSortOrder(value);
                Navigator.pop(context);
              }
            },
          ),
        );
      }).toList(),
    );
  }

  String _getSortOrderText(SortOrder sortOrder) {
    switch (sortOrder) {
      case SortOrder.ascending:
        return "Ascending";
      case SortOrder.descending:
        return "Descending";
      case SortOrder.dateModified:
        return "Date Modified";
      case SortOrder.defaultOrder:
        return "Default (Shuffle)";
    }
  }
}
