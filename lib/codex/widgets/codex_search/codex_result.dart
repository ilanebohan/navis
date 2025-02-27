import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:navis_ui/navis_ui.dart';
import 'package:wfcd_client/entities.dart';

class CodexResult extends StatelessWidget {
  const CodexResult({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    String? description;

    if (item is Mod) {
      final levelStats = (item as Mod).levelStats;

      if (levelStats != null) {
        description = levelStats.last['stats']!.fold('', (p, e) {
          return p == null ? '$e ' : '$p $e ';
        });
      }

      if (description != null) {
        description = description.parseHtmlString();
      }
    }

    return AppCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: Hero(
          tag: item.uniqueName,
          child: CircleAvatar(
            backgroundImage: item.imageName != null
                ? CachedNetworkImageProvider(item.imageUrl)
                : null,
            backgroundColor: Theme.of(context).canvasColor,
          ),
        ),
        title: Text(item.name),
        subtitle: Text(
          description?.trim() ?? item.description?.parseHtmlString() ?? '',
        ),
        isThreeLine: true,
        dense: true,
      ),
    );
  }
}
