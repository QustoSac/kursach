import 'package:flutter/material.dart';
import 'main_page.dart'; // Импорт MainPage
import 'registration_page.dart';
import 'theme/theme.dart';

class LoginPage extends StatelessWidget {
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Авторизация',
                        style: AppStyles.titleTextStyle,
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: TextField(
                          decoration: AppStyles.inputDecoration.copyWith(
                            hintText: 'Логин',
                          ),
                          style: AppStyles.inputTextStyle,
                        ),
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: TextField(
                          obscureText: true,
                          decoration: AppStyles.inputDecoration.copyWith(
                            hintText: 'Пароль',
                          ),
                          style: AppStyles.inputTextStyle,
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Переход на MainPage
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                    MainPage(),
                                transitionsBuilder:
                                    (context, animation, secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0); // Анимация снизу вверх
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
                                transitionDuration: Duration(milliseconds: 1000), // Длительность анимации
                              ),
                            );
                          },
                          style: AppStyles.elevatedButtonStyle,
                          child: Text(
                            'Войти',
                            style: AppStyles.buttonTextStyle,
                          ),
                        ),
                      ),
                    ],
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
                  SizedBox(height: 5),
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
}
