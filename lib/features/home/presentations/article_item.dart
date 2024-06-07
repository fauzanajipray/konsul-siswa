import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleItem extends StatelessWidget {
  const ArticleItem({
    super.key,
    required this.article,
  });

  final DocumentSnapshot<Object?>? article;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        String? url = article?['shortUrl'];
        if (url != null) {
          _launchURL(context, Uri.parse(url));
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4, bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 100.0,
                      height: 100.0,
                      child: Image.network(
                        article?['imageUrl'] ?? '-',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                              child: Text(
                            'Error',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.outline),
                          ));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(article?['title'] ?? '-',
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(article?['description'] ?? '-',
                            maxLines: 4,
                            style: TextStyle(
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis,
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _launchURL(BuildContext context, Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
