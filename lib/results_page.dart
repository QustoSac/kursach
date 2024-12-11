import 'package:flutter/material.dart';
import 'package:kursach/main_page.dart';
import 'profile_page.dart';
import 'view_results_page.dart';
import 'theme/theme.dart';

class ResultsPage extends StatefulWidget {
  @override
  _ReaultsPageState createState() => _ReaultsPageState();
}

  class _ReaultsPageState extends State<ResultsPage>{
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppStyles.backgroundGradient,
        child: SafeArea(child: Padding(padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //SizedBox(height: kToolbarHeight + 20), // Отступ под AppBar
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
                GestureDetector(
                  onTap: () {
                    // Логика переключения голосований
                  },
                  child: Text(
                    'Голосования',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
                  activeTrackColor: Color(0xFF195158),
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
              ],
            ),
            //Divider(color: Colors.white, thickness: 1),
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child : Align(
                alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                onPressed: () {
                  // Логика кнопки "домой"
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => MainPage(),
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
                  );
                },
                backgroundColor: Colors.black,
                child: Icon(Icons.home, color: Colors.white),
              ),
            ),
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
      pageBuilder: (context, animation, secondaryAnimation) => ViewResultsPage(),
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
