import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:konsul/features/auth/bloc/auth_cubit.dart';
import 'package:konsul/features/auth/bloc/login_cubit.dart';
import 'package:konsul/features/auth/bloc/login_state.dart';
import 'package:konsul/features/auth/presentations/sign_up_page.dart';
import 'package:konsul/utils/load_status.dart';
import 'package:konsul/widgets/loading_progress.dart';
import 'package:konsul/widgets/my_button.dart';
import 'package:konsul/widgets/my_text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeButton = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(),
      child: buildScreen(context),
    );
  }

  Widget buildScreen(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoadStatus.success) {
            setState(() {
              emailController.text = '';
              passwordController.text = '';
            });
            // Navigasi ke halaman berikutnya atau tampilkan pesan sukses
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login Success')),
            );
            context
                .read<AuthCubit>()
                .setAuthenticated(state.userId, state.data?.name);
          } else if (state.status == LoadStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login Failed: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
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
                            controller: emailController,
                            labelText: 'Email',
                            // errorText: extractErrorMessageFromError(emailError),
                            type: TextFieldType.email,
                            // focusNode: _focusNodeEmail,
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
                              text: "Masuk",
                              verticalPadding: 10,
                              focusNode: _focusNodeButton,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<LoginCubit>().login(
                                        emailController.text,
                                        passwordController.text,
                                      );
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: 'Belum punya akun? ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            TextSpan(
                              text: 'Daftar Sekarang',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const SignUpPage(),
                                    ),
                                  );
                                },
                            )
                          ])),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (state.status == LoadStatus.loading)
                const Center(child: LoadingProgress()),
            ],
          );
        },
      ),
    );
  }
}
