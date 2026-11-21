import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetpro/bloc/auth_new/bloc/auth_new_bloc.dart';
import 'package:vetpro/common/components/form.dart';
import 'package:vetpro/common/components/sticker.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/data/datasources/auth_local_datasource.dart';
import 'package:vetpro/data/models/user_model.dart';
import 'package:vetpro/views/auth/auth_layout.dart';
import 'package:vetpro/views/auth/login_page.dart';
import 'package:vetpro/views/home/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscure = true;
  bool _submitted = false;
  String? _localError;

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _clearError(String _) {
    if (_localError != null) setState(() => _localError = null);
  }

  void _submit() {
    if (namaController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      setState(() => _localError = 'Lengkapi nama, email, dan kata sandi.');
      return;
    }
    setState(() {
      _localError = null;
      _submitted = true;
    });
    context.read<AuthNewBloc>().add(AuthNewEvent.register(UserData(
          name: namaController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
        )));
  }

  void _toLogin() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthNewBloc, AuthNewState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          registerUser: (credential) {
            AuthLocalDatasource().saveAuthData(credential.data ?? UserData());
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (_) => false,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Akun dibuat. Selamat datang!')),
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
          lead: 'Gabung ke',
          highlight: 'VetPro',
          subtitle: 'Satu akun untuk semua catatan pemeriksaanmu.',
          form: [
            CustomFormField(
              onChanged: _clearError,
              title: 'Nama lengkap',
              hintText: 'mis. drh. Sari Wulandari',
              controller: namaController,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              prefixIcon: const Icon(Icons.person_outline_rounded),
            ),
            const SizedBox(height: 14),
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
              hintText: 'Buat kata sandi',
              controller: passwordController,
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
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
              label: 'Buat akun',
              icon: Icons.person_add_alt_1_rounded,
              loading: loading,
              onPressed: _submit,
            ),
          ],
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sudah punya akun?', style: bodyStyle),
              TextButton(onPressed: _toLogin, child: const Text('Masuk')),
            ],
          ),
        );
      },
    );
  }
}
