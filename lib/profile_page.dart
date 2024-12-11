import 'package:flutter/material.dart';
import 'package:kursach/login_page.dart';
import 'theme/theme.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Прозрачный AppBar
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Логика уведомлений
            },
          ),
        ],
      ),
      body: Container(
        decoration: AppStyles.backgroundGradient,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/avatar_placeholder.png'), // Путь к изображению
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Обработка изменения аватара
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Изменить аватарку', style: AppStyles.buttonTextStyle),
              ),
              SizedBox(height: 30),
              _buildSection(context, 'Данные', [
                _buildMenuItem(context, 'Логин'),
                _buildMenuItem(context, 'Пароль'),
                _buildMenuItem(context, 'ФИО'),
              ]),
              _buildSection(context, 'Организации', [
                _buildMenuItem(context, 'Мои организации', icon: Icons.favorite),
                _buildMenuItem(context, 'Добавить организацию', icon: Icons.download),
              ]),
              _buildSection(context, 'Настройки', [
                _buildMenuItem(context, 'Язык', icon: Icons.language),
                _buildMenuItem(context, 'Darkmode', icon: Icons.dark_mode),
                _buildMenuItem(context, 'Only Download via Wifi', icon: Icons.wifi),
              ]),
              SizedBox(height: 40), // Отступ перед кнопкой
              _buildLogoutButton(context), // Добавление кнопки выхода
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            title,
            style: AppStyles.sectionTitleTextStyle,
          ),
        ),
        ...items,
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, String label, {IconData? icon}) {
    return ListTile(
      leading: icon != null
          ? Icon(icon, color: Colors.white)
          : SizedBox(width: 24), // Пустое пространство для выравнивания
      title: Text(label, style: AppStyles.listTileTextStyle),
      trailing: Icon(Icons.chevron_right, color: Colors.white),
      onTap: () {
        // Обработка нажатия на элемент
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton(
        onPressed: () {
          // Переход на страницу авторизации
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(-1.0, 0.0); // Анимация справа налево
                const end = Offset.zero;
                const curve = Curves.easeOut;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 1000),
            ),
          );// Маршрут для LoginPage
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red, // Цвет кнопки "Выйти"
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
        child: Center(
          child: Text(
            'Выйти из аккаунта',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
