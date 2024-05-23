import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konsul/features/auth/bloc/register_cubit.dart';
import 'package:konsul/features/auth/bloc/register_state.dart';
import 'package:konsul/utils/load_status.dart';
import 'package:konsul/widgets/loading_progress.dart';
import 'package:konsul/widgets/my_button.dart';
import 'package:konsul/widgets/my_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nisnController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeNisn = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeButton = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (context) => RegisterCubit(),
      child: buildScreen(context),
    );
  }

  Widget buildScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
          if (state.status == LoadStatus.success) {
            setState(() {
              nameController.text = '';
              nisnController.text = '';
              emailController.text = '';
              passwordController.text = '';
            });
            // Navigasi ke halaman berikutnya atau tampilkan pesan sukses
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration Successful')),
            );
          } else if (state.status == LoadStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration Failed: ${state.error}')),
            );
          }
        }, builder: (context, state) {
          return Center(
            child: Stack(
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  alignment: Alignment.center,
                  child: Form(
                    key: formKey,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      width: 350,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.amber.shade400,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 80,
                            ),
                          ),
                          const SizedBox(height: 24),
                          MyTextField(
                            controller: nameController,
                            labelText: 'Nama',
                            // errorText: extractErrorMessageFromError(emailError),
                            type: TextFieldType.normal,
                            focusNode: _focusNodeName,
                            // prefixIcon: const Icon(Icons.person_outline),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                            filled: false,
                            onEditingComplete: () {
                              _focusNodeName.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_focusNodeNisn);
                            },
                            textColor: Theme.of(context).colorScheme.onSurface,
                          ),
                          const SizedBox(height: 24),
                          MyTextField(
                            controller: nisnController,
                            labelText: 'NISN',
                            // errorText: extractErrorMessageFromError(emailError),
                            type: TextFieldType.normal,
                            focusNode: _focusNodeNisn,
                            // prefixIcon: const Icon(Icons.person_outline),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'NISN tidak boleh kosong';
                              }
                              return null;
                            },
                            filled: false,
                            onEditingComplete: () {
                              _focusNodeNisn.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_focusNodeEmail);
                            },
                            textColor: Theme.of(context).colorScheme.onSurface,
                          ),
                          const SizedBox(height: 24),
                          MyTextField(
                            controller: emailController,
                            labelText: 'Email',
                            // errorText: extractErrorMessageFromError(emailError),
                            type: TextFieldType.email,
                            focusNode: _focusNodeEmail,
                            // prefixIcon: const Icon(Icons.person_outline),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              // Use a regular expression to validate the email format
                              final emailRegExp = RegExp(
                                  r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                              if (!emailRegExp.hasMatch(value)) {
                                return 'Email tidak valid';
                              }
                              return null;
                            },
                            filled: false,
                            onEditingComplete: () {
                              _focusNodeEmail.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_focusNodePassword);
                            },
                            textColor: Theme.of(context).colorScheme.onSurface,
                          ),
                          const SizedBox(height: 24),
                          MyTextField(
                            controller: passwordController,
                            labelText: 'Password',
                            // errorText: extractErrorMessageFromError(passwordError),
                            type: TextFieldType.password,
                            focusNode: _focusNodePassword,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              return null;
                            },
                            // prefixIcon: const Icon(Icons.password_outlined),
                            filled: false,
                            onEditingComplete: () {
                              _focusNodePassword.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_focusNodeButton);
                            },
                          ),
                          const SizedBox(height: 38),
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: MyButton(
                              text: "Daftar",
                              verticalPadding: 10,
                              focusNode: _focusNodeButton,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<RegisterCubit>().register(
                                        emailController.text,
                                        passwordController.text,
                                        nameController.text,
                                        nisnController.text,
                                      );
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ),
                if (state.status == LoadStatus.loading)
                  const Center(child: LoadingProgress()),
              ],
            ),
          );
        }),
      ),
    );
  }
}
