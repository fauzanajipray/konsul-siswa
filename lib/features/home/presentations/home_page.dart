import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konsul/features/auth/bloc/auth_cubit.dart';
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
      appBar: AppBar(
          // title: const Text('Title'),
          ),
      body: Center(
        child: Column(
          children: [
            const Text("Home"),
            MyButton(
                onPressed: () {
                  context.read<AuthCubit>().setUnauthenticated();
                },
                text: 'Logout'),
          ],
        ),
      ),
    );
  }
}
