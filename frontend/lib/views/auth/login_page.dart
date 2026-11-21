import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetpro/bloc/auth_new/bloc/auth_new_bloc.dart';
import 'package:vetpro/common/components/form.dart';
import 'package:vetpro/common/components/sticker.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/data/datasources/auth_local_datasource.dart';
import 'package:vetpro/data/models/user_model.dart';
import 'package:vetpro/views/auth/auth_layout.dart';
import 'package:vetpro/views/auth/register_page.dart';
import 'package:vetpro/views/home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscure = true;
  bool _submitted = false;
  String? _localError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _clearError(String _) {
    if (_localError != null) setState(() => _localError = null);
  }

  void _submit() {
    final email = emailController.text.trim();
    if (email.isEmpty || passwordController.text.isEmpty) {
      setState(() => _localError = 'Isi email dan kata sandi dulu, ya.');
      return;
    }
    setState(() {
      _localError = null;
      _submitted = true;
    });
    context.read<AuthNewBloc>().add(AuthNewEvent.login(
          UserData(email: email, password: passwordController.text),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthNewBloc, AuthNewState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          loginUser: (credential) {
            AuthLocalDatasource().saveAuthData(credential.data ?? UserData());
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Berhasil masuk. Selamat bekerja!')),
            );
          },
        );
      },
      builder: (context, state) {
        final loading =
            state.maybeWhen(loading: () => true, orElse: () => false);
        final serverError = _submitted
            ? state.maybeWhen(error: (m) => m, orElse: () => null)
            : null;
        final error = _localError ?? serverError;

        return AuthLayout(
          lead: 'Selamat datang di',
          highlight: 'VetPro',
          subtitle: 'Catatan kesehatan hewan, langsung dari kandang.',
          form: [
            CustomFormField(
              onChanged: _clearError,
              title: 'Email',
              hintText: 'nama@email.com',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              prefixIcon: const Icon(Icons.mail_outline_rounded),
            ),
            const SizedBox(height: 14),
            CustomFormField(
              onChanged: _clearError,
              title: 'Kata sandi',
              hintText: 'Kata sandimu',
              controller: passwordController,
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onFieldSubmitted: (_) => _submit(),
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                tooltip: _obscure ? 'Tampilkan' : 'Sembunyikan',
                icon: Icon(_obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            if (error != null) ...[
              const SizedBox(height: 14),
              FormError(error),
            ],
            const SizedBox(height: 20),
            StickerButton(
              label: 'Masuk',
              icon: Icons.login_rounded,
              loading: loading,
              onPressed: _submit,
            ),
          ],
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Belum punya akun?', style: bodyStyle),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                ),
                child: const Text('Daftar di sini'),
              ),
            ],
          ),
        );
      },
    );
  }
}
