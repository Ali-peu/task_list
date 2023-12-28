import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_list/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:task_list/constants/app_text_styles.dart';
import 'package:task_list/screens/login_scren/widgets/my_text_field.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart'
    as formatter;

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // инициализацию в init()
  TextEditingController emailController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeadPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  IconData iconOpenPassword = Icons.lock_open;
  bool obscurePassword = true;
  bool signUpRequired = false;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      // стейт менеджмент вынести в блок
      listener: (context, state) {
        // WTF?
        if (state is SignUpProcess) {
          setState(() {
            signUpRequired = false;
          });
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          return;
        }
      },
      child: Form(
        key: formKey,
        child: Column(
          children: [
            // Здесь можно обойтись без SizedBox. Вообще так можно конечно делать, но это костыль
            const SizedBox(height: 20),
            companyNameTextField(context),
            const SizedBox(height: 20),
            phoneNumberTextField(context),
            const SizedBox(height: 20),
            emailTextField(context),
            const SizedBox(height: 20),
            passwordTextField(context),
            !signUpRequired
                ? loginTextButton(context)
                : const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }

  // Вынести бизнес логик в Блок,
  // Вынести
  SizedBox loginTextButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: TextButton(
          onPressed: () {
            // Не смешивай Бизнес-логику с вью
            if (formKey.currentState!.validate()) {
              MyUser myUser = MyUser.empty;
              myUser = myUser.copyWith(
                  userId: DateTime.now().toString(),
                  companyName: companyNameController.text,
                  email: emailController.text,
                  phoneNumber: phoneNumberController.text);
              setState(() {
                context
                    .read<SignUpBloc>()
                    .add(SignUpRequired(myUser, passwordController.text));
              });
            }
            print(
                'We must to going try register if server response good go HomePage,else show SnackBar with error ');
          },
          child: Text(
            AppLocalizations.of(context)!.loginButton,
            style: AppTextStyles.loginButtonText,
          )),
    );
  }

  // "MyTextField" очень плохое именование для проекта больше чем на 1 вечер.
  MyTextField passwordTextField(BuildContext context) {
    return MyTextField(
      controller: passwordController,
      hintText: 'Password',
      obscureText: obscurePassword,
      keyboardType: TextInputType.visiblePassword,
      prefixIcon: const Icon(Icons.lock),
      errorMsg: _errorMsg,
      // Валидаторы лучше вынести в отдельный файл,
      validator: (val) {
        if (val!.isEmpty) {
          return AppLocalizations.of(context)!.loginEmpty;
        } else if (!RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
            .hasMatch(val)) {
          return AppLocalizations.of(context)!.loginPasswordValidator;
        }
        return null;
      },
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            obscurePassword = !obscurePassword;
            if (obscurePassword) {
              iconOpenPassword = Icons.lock;
            } else {
              iconOpenPassword = Icons.lock_open;
            }
          });
        },
        icon: Icon(iconOpenPassword),
      ),
    );
  }

  MyTextField emailTextField(BuildContext context) {
    return MyTextField(
        controller: emailController,
        hintText: 'Email',
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
        prefixIcon: const Icon(Icons.email),
        errorMsg: _errorMsg,
        validator: (val) {
          if (val!.isEmpty) {
            return AppLocalizations.of(context)!.loginEmpty;
          } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
              .hasMatch(val)) {
            return AppLocalizations.of(context)!.loginEmailValidator;
          }
          return null;
        });
  }

  TextFormField phoneNumberTextField(BuildContext context) {
    return TextFormField(
        controller: phoneNumberController,
        inputFormatters: [formatter.MaskedInputFormatter('+7 (###) ###-##-##')],
        // Вынести в тему
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.secondary),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: '+7 (###) ###-##-##',
          hintStyle: TextStyle(color: Colors.grey[500]),
          errorText: _errorMsg,
        ),
        obscureText: false,
        keyboardType: TextInputType.phone,
        validator: (val) {
          if (val!.isEmpty) {
            return AppLocalizations.of(context)!.loginEmpty;
          }
          return null;
        });
  }

  MyTextField companyNameTextField(BuildContext context) {
    return MyTextField(
        controller: companyNameController,
        hintText: AppLocalizations.of(context)!.loginCompanyName,
        obscureText: false,
        keyboardType: TextInputType.name,
        prefixIcon: const Icon(Icons.person),
        errorMsg: _errorMsg,
        validator: (val) {
          if (val!.isEmpty) {
            return AppLocalizations.of(context)!.loginEmpty;
          }
          return null;
        });
  }
}
