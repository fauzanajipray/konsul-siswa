import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:konsul/features/auth/bloc/auth_cubit.dart';
import 'package:konsul/features/dosen/bloc/mydosen_cubit.dart';
import 'package:konsul/features/dosen/bloc/mydosen_state.dart';
import 'package:konsul/helpers/dialog.dart';
import 'package:konsul/helpers/helpers.dart';
import 'package:konsul/services/app_router.dart';
import 'package:konsul/utils/load_status.dart';

class DosenPage extends StatefulWidget {
  const DosenPage({super.key});

  @override
  State<DosenPage> createState() => _DosenPageState();
}

class _DosenPageState extends State<DosenPage> {
  bool isAlreadyAccpeted = false;
  String? dosenId;

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {
    context
        .read<MydosenCubit>()
        .getDosen(BlocProvider.of<AuthCubit>(context).state.userId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text('Pembimbing'),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => initData()),
        child:
            BlocBuilder<MydosenCubit, MydosenState>(builder: (context, state) {
          return ListView(
            children: [
              BlocConsumer<MydosenCubit, MydosenState>(
                listener: (context, state) {
                  if (state.status == LoadStatus.success) {
                    setState(() {
                      isAlreadyAccpeted = state.isAlreadyAccpeted;
                      dosenId = state.user?.id;
                    });
                  }
                },
                builder: (context, state) {
                  if (state.status == LoadStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == LoadStatus.failure) {
                    return Container(
                      color: Theme.of(context).colorScheme.surface,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.center,
                      child: Text(
                        '${state.error}',
                        style: const TextStyle(),
                      ),
                    );
                  }

                  String? imageUrl = state.user?.imageUrl;
                  imageUrl = (imageUrl == '') ? null : imageUrl;

                  return Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: Card(
                      color: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: InkWell(
                        onTap: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (ctx) {
                              return SafeArea(
                                child: CupertinoActionSheet(
                                  actions: [
                                    CupertinoActionSheetAction(
                                      onPressed: () async {
                                        Navigator.of(ctx).pop();
                                        context.push(
                                            Destination.dosenAvailSelectPath);
                                      },
                                      child: const Text('Jadwalkan Konsultasi'),
                                    ),
                                    CupertinoActionSheetAction(
                                      onPressed: () async {
                                        Navigator.of(ctx).pop();
                                        if (!isAlreadyAccpeted) {
                                          if (dosenId != null) {
                                            context
                                                .read<MydosenCubit>()
                                                .deleteDosen(
                                                    BlocProvider.of<AuthCubit>(
                                                                context)
                                                            .state
                                                            .userId ??
                                                        '',
                                                    dosenId!);
                                          }
                                        } else {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Anda sedang ada jadwal bimbingan')));
                                          });
                                        }
                                      },
                                      child: Text('Hapus',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error)),
                                    ),
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Text('Cancel',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error)),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 60.0,
                                height: 60.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white, width: 2.0),
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundImage: imageUrl != null
                                      ? NetworkImage(imageUrl)
                                          as ImageProvider<Object>
                                      : const AssetImage(
                                              'assets/images/user_image.png')
                                          as ImageProvider<Object>,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.outline,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        capitalize(state.user?.name ?? ""),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "Ada yang ingin di konsultasikan?",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Container(
                color: Theme.of(context).colorScheme.primary,
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  'Pembimbing',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('type', isEqualTo: 'dosen')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
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
                            'No data found',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }

                    // Filter the snapshots to exclude the document with the unwanted UID
                    List<DocumentSnapshot> filteredDocs = snapshot.data!.docs
                        .where((doc) => doc.id != dosenId)
                        .toList();

                    if (filteredDocs.isEmpty) {
                      return Container(
                        height: 80,
                        color: Theme.of(context).colorScheme.primary,
                        child: const Center(
                          child: Text(
                            'No data found',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }

                    return Container(
                      color: Theme.of(context).colorScheme.primary,
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot? doc = filteredDocs[index];

                          String? imageUrl =
                              (doc.data() as Map<String, dynamic>)
                                      .containsKey('imageUrl')
                                  ? doc['imageUrl']
                                  : null;
                          String? name = (doc.data() as Map<String, dynamic>)
                                  .containsKey('name')
                              ? doc['name']
                              : null;

                          String uid = doc.id;

                          return Container(
                            margin: const EdgeInsets.only(top: 8, bottom: 4),
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  width: 60.0,
                                  height: 60.0,
                                  child: ExtendedImage.network(
                                    imageUrl ?? '',
                                    compressionRatio: kIsWeb ? null : 0.2,
                                    clearMemoryCacheWhenDispose: true,
                                    cache: true,
                                    fit: BoxFit.cover,
                                    loadStateChanged:
                                        (ExtendedImageState state) {
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
                              trailing: const Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                showDialogConfirmation(
                                  context,
                                  () {
                                    if (!isAlreadyAccpeted) {
                                      context.read<MydosenCubit>().setDosen(
                                            BlocProvider.of<AuthCubit>(context)
                                                    .state
                                                    .userId ??
                                                '',
                                            uid,
                                          );
                                    } else {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Anda sedang ada jadwal bimbingan')));
                                      });
                                    }
                                  },
                                  message:
                                      'Apakah ingin mennganti dosen pembimbing dengan $name?',
                                  positiveText: 'Confirm',
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }),
            ],
          );
        }),
      ),
    );
  }
}
