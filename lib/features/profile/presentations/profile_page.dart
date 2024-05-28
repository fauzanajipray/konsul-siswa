import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:konsul/features/auth/bloc/auth_cubit.dart';
import 'package:konsul/features/profile/bloc/data_state.dart';
import 'package:konsul/features/profile/bloc/profile_cubit.dart';
import 'package:konsul/features/profile/model/profile.dart';
import 'package:konsul/helpers/helpers.dart';
import 'package:konsul/services/app_router.dart';
import 'package:konsul/utils/load_status.dart';
import 'package:konsul/widgets/loading_progress.dart';
import 'package:konsul/widgets/my_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    context
        .read<ProfileCubit>()
        .getProfile(BlocProvider.of<AuthCubit>(context).state.userId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: BlocBuilder<ProfileCubit, DataState<Profile>>(
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                  child: Column(
                children: [
                  const SizedBox(height: 8),
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
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () => context
                                .push(Destination.updateProfilePath)
                                .then((value) {
                              if (value is bool) {
                                if (value) {
                                  context.read<ProfileCubit>().getProfile(
                                      BlocProvider.of<AuthCubit>(context)
                                              .state
                                              .userId ??
                                          '');
                                }
                              }
                            }),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 24,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                radius: 80,
                                backgroundImage: const AssetImage(
                                    'assets/images/user_image.png'),
                                backgroundColor:
                                    Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildItem(
                                name: 'Nama', value: '${state.item?.name}'),
                            const SizedBox(height: 16),
                            _buildItem(
                                name: 'NISN', value: '${state.item?.nisn}'),
                            const SizedBox(height: 16),
                            _buildItem(
                                name: 'Email', value: '${state.item?.email}'),
                            const SizedBox(height: 16),
                            _buildItem(
                                name: 'Nomor',
                                value: state.item?.number ?? '-'),
                            const SizedBox(height: 16),
                            _buildItem(
                                name: 'Tanggal Lahir',
                                value:
                                    formatDateTimeCustom(state.item?.birthday)),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 120,
                    height: 50,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: MyButton(
                      color: Theme.of(context).colorScheme.error,
                      textColor: Theme.of(context).colorScheme.onError,
                      verticalPadding: 0,
                      text: 'Logout',
                      onPressed: () {
                        context.read<AuthCubit>().setUnauthenticated();
                      },
                    ),
                  ),
                ],
              )),
              if (state.status == LoadStatus.loading) const LoadingProgress()
            ],
          );
        },
      ),
    );
  }

  Widget _buildItem({String name = '', String value = ''}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
