import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konsul/features/auth/bloc/auth_cubit.dart';
import 'package:konsul/features/dosen/bloc/mydosen_cubit.dart';
import 'package:konsul/features/dosen/bloc/mydosen_state.dart';
import 'package:konsul/helpers/dialog.dart';
import 'package:konsul/helpers/helpers.dart';
import 'package:konsul/utils/load_status.dart';

class DosenPage extends StatefulWidget {
  const DosenPage({super.key});

  @override
  State<DosenPage> createState() => _DosenPageState();
}

class _DosenPageState extends State<DosenPage> {
  @override
  void initState() {
    super.initState();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocConsumer<MydosenCubit, MydosenState>(
              listener: (context, state) {},
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
                        // Implementasikan fungsi onTap di sini
                        print("Card tapped");
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
                                border:
                                    Border.all(color: Colors.white, width: 2.0),
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
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(right: 6),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot? doc = snapshot.data?.docs[index];

                        String? imageUrl = (doc?.data() as Map<String, dynamic>)
                                .containsKey('image')
                            ? doc!['image']
                            : null;
                        String? name = (doc?.data() as Map<String, dynamic>)
                                .containsKey('name')
                            ? doc!['name']
                            : null;

                        String uid = doc?.id ?? '';

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
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
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
                            trailing: const Icon(Icons.keyboard_arrow_right),
                            subtitle: Text(uid),
                            onTap: () {
                              // showDialogMsg(context, 'Here');
                              showDialogConfirmationDelete(
                                context,
                                () => context.read<MydosenCubit>().setDosen(
                                      BlocProvider.of<AuthCubit>(context)
                                              .state
                                              .userId ??
                                          '',
                                      uid,
                                    ),
                                message:
                                    'Apakah ingin mennganti dosen pembimbing dengan $name?',
                                errorBtn: 'Confirm',
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
