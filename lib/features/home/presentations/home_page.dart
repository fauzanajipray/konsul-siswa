import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:konsul/features/auth/bloc/auth_cubit.dart';
import 'package:konsul/features/auth/bloc/auth_state.dart';
import 'package:konsul/features/home/presentations/article_item.dart';
import 'package:konsul/services/app_router.dart';
import 'package:konsul/widgets/my_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
              return Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.0),
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/user.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(children: [
                            const TextSpan(
                              text: "Hai, ",
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: "${state.name}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ]),
                        ),
                        Text(
                          "Bagaimana perasaan mu hari ini? ",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('articles')
                    .limit(3)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Container(
                        padding: const EdgeInsets.all(16),
                        child: Center(child: Text('Error: ${snapshot.error}')));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Container(
                      height: 80,
                      color: Theme.of(context).colorScheme.primary,
                      child: const Center(
                        child: Text(
                          'No articles found',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }

                  return Container(
                    color: Theme.of(context).colorScheme.primary,
                    width: double.infinity,
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        ...snapshot.data!.docs.map((DocumentSnapshot document) {
                          return ArticleItem(article: document);
                        }),
                        Container(
                          color: Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.only(bottom: 16, top: 8),
                          child: Center(
                            child: SizedBox(
                              width: 180,
                              height: 40,
                              child: MyButton(
                                onPressed: () =>
                                    context.go(Destination.articlePath),
                                text: 'Lihat lebih banyak',
                                verticalPadding: 0,
                                horizontalPadding: 4,
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.surface,
                                textColor:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('type', isEqualTo: 'dosen')
                  .limit(4) // Ambil hanya 4 data
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError || snapshot.data == null) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Container(
                    height: 80,
                    color: Theme.of(context).colorScheme.surface,
                    child: Center(
                      child: Text(
                        'Tidak ada siswa bimbingan',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  );
                }

                return Container(
                  color: Theme.of(context).colorScheme.surface,
                  width: double.infinity,
                  child: Column(
                    children: [
                      ...snapshot.data!.docs.map((DocumentSnapshot document) {
                        String? imageUrl =
                            (document.data() as Map<String, dynamic>)
                                    .containsKey('image')
                                ? document['image']
                                : null;
                        String? name = (document.data() as Map<String, dynamic>)
                                .containsKey('name')
                            ? document['name']
                            : null;
                        return Container(
                          margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4.0,
                                spreadRadius: 2.0,
                              ),
                            ],
                          ),
                          child: ListTile(
                            minVerticalPadding: 5,
                            title: Text(
                              name ?? '-',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 60.0,
                                height: 60.0,
                                child: ExtendedImage.network(
                                  imageUrl ?? '',
                                  compressionRatio: kIsWeb ? null : 0.2,
                                  clearMemoryCacheWhenDispose: true,
                                  cache: true,
                                  fit: BoxFit.cover,
                                  loadStateChanged: (ExtendedImageState state) {
                                    if (state.extendedImageLoadState ==
                                        LoadState.completed) {
                                      return state.completedWidget;
                                    } else {
                                      return Center(
                                        child: Text(
                                          name != null
                                              ? name.length == 1
                                                  ? name.toUpperCase()
                                                  : name
                                                      .substring(0, 2)
                                                      .toUpperCase()
                                              : '',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      Container(
                        padding: const EdgeInsets.only(bottom: 16, top: 16),
                        child: Center(
                          child: SizedBox(
                            width: 280,
                            height: 40,
                            child: MyButton(
                              onPressed: () =>
                                  context.go(Destination.dosenPath),
                              text: 'Lihat Seluruh Pembimbinng',
                              verticalPadding: 0,
                              horizontalPadding: 4,
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                              textColor:
                                  Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
