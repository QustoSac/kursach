import 'package:flutter/material.dart';
import 'package:kursach/profile_page.dart';
import 'package:kursach/theme/theme.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppStyles.backgroundGradient, // Градиент фона
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Верхняя панель с аватаром
                Row(
                  children: [
                    IconButton(
                      icon: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.black,
                      child: Text(
                        'A',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()),
                        );
                      },
                    ),

                  ],
                ),
                SizedBox(height: 30),
                // Заголовок "Голосования"
                Text(
                  'Голосования',
                  style: AppStyles.titleTextStyle.copyWith(fontSize: 28),
                ),
                SizedBox(height: 10),
                Divider(color: Colors.white54, thickness: 1),
                SizedBox(height: 20),
                // Список голосований
                Expanded(
                  child: ListView.builder(
                    itemCount: 5, // Количество элементов в списке
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: Icon(Icons.star, color: Colors.white),
                          title: Text(
                            'Menu Label',
                            style: AppStyles.inputTextStyle.copyWith(fontSize: 18),
                          ),
                          subtitle: Text(
                            'Menu description.',
                            style: AppStyles.footerTextStyle.copyWith(color: Colors.white70),
                          ),
                          trailing: Icon(Icons.text_fields, color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                // Нижняя панель с кнопкой и поиском
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Логика для перехода к результатам
                        },
                        style: AppStyles.elevatedButtonStyle.copyWith(
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12)),
                        ),
                        icon: Icon(Icons.search, color: Colors.white),
                        label: Text(
                          'Посмотреть результаты',
                          style: AppStyles.buttonTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    FloatingActionButton(
                      onPressed: () {
                        // Логика для добавления нового голосования
                      },
                      backgroundColor: Colors.black,
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
