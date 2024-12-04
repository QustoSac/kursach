import 'package:flutter/material.dart';
import 'theme/theme.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppStyles.titleTextStyle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Обработка уведомлений
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
        SizedBox(height: 10),
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
}
