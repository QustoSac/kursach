import 'package:flutter/material.dart';
import 'package:kursach/login_page.dart';
import 'theme/theme.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: AppStyles.backgroundGradient,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/DefaultPhoto.png'),
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
                _buildMenuItem(context, 'Логин', onTap: () {
                  _showMessageDialog(context, 'Ваш текущий логин: example_user');
                }),
                _buildMenuItem(context, 'Пароль'),
                _buildMenuItem(context, 'ФИО', onTap: (){
                  _showMessageDialog(context, 'Ваше ФИО: example_FIO');
                }),
              ]),

              SizedBox(height: 320),
              _buildLogoutButton(context),
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

  Widget _buildMenuItem(BuildContext context, String label, {IconData? icon, VoidCallback? onTap}) {
    return ListTile(
      leading: icon != null
          ? Icon(icon, color: Colors.white)
          : SizedBox(width: 24),
      title: Text(label, style: AppStyles.listTileTextStyle),
      trailing: Icon(Icons.chevron_right, color: Colors.white),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(-1.0, 0.0);
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
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
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

  void _showMessageDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) =>
        AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),

    );
  }
}
