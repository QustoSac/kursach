import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'main_page.dart';
import 'registration_page.dart';
import 'theme/theme.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _dobController = TextEditingController();
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppStyles.backgroundGradient,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isLogin ? 'Авторизация' : 'Регистрация',
                          style: AppStyles.titleTextStyle,
                        ),
                        SizedBox(height: 30),
                        // Поле логина
                        SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            controller: _loginController,
                            decoration: AppStyles.inputDecoration.copyWith(
                              hintText: 'Логин',
                            ),
                            style: AppStyles.inputTextStyle,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Введите логин';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 15),
                        // Поле пароля
                        SizedBox(
                          width: double.infinity,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: AppStyles.inputDecoration.copyWith(
                              hintText: 'Пароль',
                            ),
                            style: AppStyles.inputTextStyle,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Введите пароль';
                              }
                              return null;
                            },
                          ),
                        ),
                        //if (!_isLogin) ..._buildRegistrationFields(), // Поля регистрации
                        SizedBox(height: 20),
                        // Кнопка Войти/Зарегистрироваться
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _handleSubmit,
                            style: AppStyles.elevatedButtonStyle,
                            child: Text(
                              _isLogin ? 'Войти' : 'Зарегистрироваться',
                              style: AppStyles.buttonTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Еще нет аккаунта?',
                    style: AppStyles.footerTextStyle,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Переход на страницу регистрации
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              RegistrationPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0); // Анимация справа налево
                            const end = Offset.zero;
                            const curve = Curves.easeOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                          transitionDuration: Duration(milliseconds: 1000),
                        ),
                      );
                    },
                    child: Text(
                      'Зарегистрироваться',
                      style: AppStyles.linkTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Логика обработки входа и регистрации
  void _handleSubmit() async {
    await DatabaseHelper().checkUsers();
    if (_formKey.currentState!.validate()) {
      if (_isLogin) {
        final login = _loginController.text;
        final password = _passwordController.text;
        final user = await DatabaseHelper().getUserByLogin(login);
        if (user != null && user['Password'] == password) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => MainPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeOut;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 1000),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Неверный логин или пароль')),
          );
        }
      } else {
        await DatabaseHelper().registerUser(
          fullName: _fullNameController.text,
          login: _loginController.text,
          password: _passwordController.text,
          dateOfBirth: _dobController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Пользователь зарегистрирован!')),
        );
        setState(() {
          _isLogin = true;
        });
      }
    }
  }

  // Поля для регистрации
//   List<Widget> _buildRegistrationFields() {
//     return [
//       SizedBox(height: 15),
//       SizedBox(
//         width: double.infinity,
//         child: TextFormField(
//           controller: _fullNameController,
//           decoration: AppStyles.inputDecoration.copyWith(
//             hintText: 'Полное имя',
//           ),
//           style: AppStyles.inputTextStyle,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Введите полное имя';
//             }
//             return null;
//           },
//         ),
//       ),
//       SizedBox(height: 15),
//       SizedBox(
//         width: double.infinity,
//         child: TextFormField(
//           controller: _dobController,
//           decoration: AppStyles.inputDecoration.copyWith(
//             hintText: 'Дата рождения (ГГГГ-ММ-ДД)',
//           ),
//           style: AppStyles.inputTextStyle,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Введите дату рождения';
//             }
//             return null;
//           },
//         ),
//       ),
//     ];
//   }
}
