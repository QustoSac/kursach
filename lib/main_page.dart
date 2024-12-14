import 'package:flutter/material.dart';
import 'package:kursach/profile_page.dart';
import 'package:kursach/theme/theme.dart';
import 'vote_page.dart';
import 'results_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>{
  bool isSwitched = false;

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
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const curve = Curves.easeInOut;
                              var tween = Tween<double>(begin: 0.8, end: 1.0).chain(CurveTween(curve: curve));
                              var scaleAnimation = animation.drive(tween);

                              return ScaleTransition(
                                scale: scaleAnimation,
                                child: child,
                              );
                            },
                            transitionDuration: Duration(milliseconds: 1000),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30),
                // Заголовок "Голосования"
                Row(
                  children: [
                    new Flexible(child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: TextField(
                        obscureText: true,
                        decoration: AppStyles.golosovanieDecoration.copyWith(
                          hintText: 'Голосование',
                        ),
                        style: AppStyles.inputTextStyle,
                      ),
                    ),
                    ),
                    SizedBox(width: 40),
                    Switch(
                      value: isSwitched, // Текущее состояние переключателя
                      onChanged: (bool value) {
                        // Логика переключения
                        setState(() {
                          isSwitched = value;
                        });
                      },
                      activeColor: Colors.white,
                      inactiveThumbColor: Colors.grey,
                      activeTrackColor: Colors.black,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Логика переключения организаций
                      },
                      child: Text(
                        'Организации',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // TextField(
                    //   decoration: AppStyles.inputDecoration.copyWith(
                    //     hintText: 'Логин',
                    //   ),
                    //   style: AppStyles.inputTextStyle,
                    // )
                  ],
                ),
                // Список голосований
                Expanded(
                  child: ListView.builder(
                    itemCount: 5, // Количество элементов в списке
                    itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.all(5),
                        child: _buildMenuItem(context, 'Menu Label', 'Menu description')
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
                          Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => ResultsPage(),
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
  Widget _buildMenuItem(BuildContext context, String title, String description) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(_createRouteToVotePage());
      },
      child: ListTile(
        leading: Icon(Icons.star, color: Colors.white),
        title: Text(title, style: AppStyles.inputTextStyle.copyWith(fontSize: 18)),
        subtitle: Text(description, style: AppStyles.footerTextStyle.copyWith(color: Colors.white70)),
        trailing: Icon(Icons.chevron_right, color: Colors.white),
      ),
    );
  }

  Route _createRouteToVotePage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => VotePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Начинается справа
        const end = Offset.zero;       // Окончание в центре
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 1000),
    );
  }
}
