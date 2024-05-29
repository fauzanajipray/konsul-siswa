import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:konsul/features/auth/bloc/auth_cubit.dart';
import 'package:konsul/features/dosen/bloc/add_promise_cubit.dart';
import 'package:konsul/features/dosen/bloc/avail_cubit.dart';
import 'package:konsul/features/dosen/bloc/mydosen_cubit.dart';
import 'package:konsul/features/dosen/bloc/mydosen_state.dart';
import 'package:konsul/features/dosen/model/promise.dart';
import 'package:konsul/features/profile/bloc/data_state.dart';
import 'package:konsul/helpers/dialog.dart';
import 'package:konsul/helpers/helpers.dart';
import 'package:konsul/utils/load_status.dart';
import 'package:konsul/widgets/loading_progress.dart';
import 'package:konsul/widgets/my_button.dart';
import 'package:konsul/widgets/my_text_field.dart';

class DosenAvailSelectPage extends StatefulWidget {
  const DosenAvailSelectPage({super.key});

  @override
  State<DosenAvailSelectPage> createState() => _DosenAvailSelectPageState();
}

class _DosenAvailSelectPageState extends State<DosenAvailSelectPage> {
  final _dateController = TextEditingController();
  DateTime? _dateTime;
  bool isLoading = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = context.read<AuthCubit>().state.userId;
    context
        .read<MydosenCubit>()
        .getDosen(BlocProvider.of<AuthCubit>(context).state.userId ?? '');
  }

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Jadwal'),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: BlocConsumer<MydosenCubit, MydosenState>(
        listener: (context, state) {
          if (state.status == LoadStatus.success) {
            context.read<AvailCubit>().get(state.user?.id, userId);
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
          return BlocConsumer<AddPromiseCubit, DataState>(
              listener: (context, state) {
            if (state.status == LoadStatus.failure) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showSnackBar(context, "${state.error}");
              });
            } else if (state.status == LoadStatus.success) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showSnackBar(context, "Berhasil menambahkan jadwal bimbingan");
                context.pop();
              });
            }
          }, builder: (context, stateAdd) {
            return BlocBuilder<AvailCubit, DataState<Promise>>(
                builder: (context, stateAvail) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.surface,
                          padding: const EdgeInsets.only(top: 16),
                          child: Card(
                            color: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            capitalize(state.user?.name ?? ""),
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            stateAvail.item == null
                                                ? "Pilih jadwal bimbingan"
                                                : "Siapkan materi untuk bimbingannya ya",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (stateAvail.item == null)
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('schedules')
                                .where('userId', isEqualTo: state.user?.id)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
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
                                padding: const EdgeInsets.only(top: 16),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot? doc =
                                        snapshot.data?.docs[index];
                                    String uid = doc?.id ?? '';

                                    Timestamp? timestamp =
                                        (doc?.data() as Map<String, dynamic>)
                                                .containsKey('time')
                                            ? doc!['time']
                                            : null;

                                    return Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          16, 8, 16, 4),
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                                          timestamp != null
                                              ? formatTimestampToTime(timestamp)
                                              : 'No Time',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface),
                                        ),
                                        trailing: const Icon(
                                            Icons.keyboard_arrow_right),
                                        onTap: () {
                                          showAdaptiveDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Pilih Jadwal'),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    MyTextField(
                                                      controller:
                                                          _dateController,
                                                      labelText: 'Tanggal',
                                                      type: TextFieldType.none,
                                                      fillColor: Colors.white,
                                                      textColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onSurface,
                                                      onTap: () async => {
                                                        showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              _dateTime ??
                                                                  DateTime
                                                                      .now(),
                                                          firstDate:
                                                              DateTime.now(),
                                                          lastDate:
                                                              DateTime(2100),
                                                        ).then((value) {
                                                          if (value != null) {
                                                            setState(() {
                                                              _dateController
                                                                  .text = DateFormat(
                                                                      'dd-MM-yyyy')
                                                                  .format(
                                                                      value);
                                                              _dateTime = value;
                                                            });
                                                          }
                                                        })
                                                      },
                                                    ),
                                                    const SizedBox(height: 16),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: SizedBox(
                                                        width: 100,
                                                        child: MyButton(
                                                          typeButton: TypeButton
                                                              .elevated,
                                                          textColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          verticalPadding: 8,
                                                          onPressed: () {
                                                            if (_dateTime ==
                                                                    null ||
                                                                timestamp ==
                                                                    null) {
                                                              showSnackBar(
                                                                  context,
                                                                  'Tanggal tidak boleh kosong');
                                                              return;
                                                            } else {
                                                              context
                                                                  .read<
                                                                      AddPromiseCubit>()
                                                                  .saveData(
                                                                    _dateTime!,
                                                                    timestamp,
                                                                    state.user
                                                                        ?.id,
                                                                    context
                                                                        .read<
                                                                            AuthCubit>()
                                                                        .state
                                                                        .userId,
                                                                  );
                                                              context.pop();
                                                            }
                                                          },
                                                          text: 'Pilih',
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        if (stateAvail.item != null)
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            margin: const EdgeInsets.all(16.0),
                            width: double.infinity,
                            constraints: const BoxConstraints(maxWidth: 600),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outline
                                      .withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                    'Konseling diadakan pada ${formatDateTimeCustom(stateAvail.item?.date)}'),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyButton(
                                        onPressed: () {},
                                        text: 'Batalkan',
                                        verticalPadding: 12,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: MyButton(
                                        onPressed: () {},
                                        text: 'Konseling',
                                        verticalPadding: 12,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (stateAdd.status == LoadStatus.loading)
                    const LoadingProgress()
                ],
              );
            });
          });
        },
      ),
    );
  }
}
