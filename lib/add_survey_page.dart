import 'package:flutter/material.dart';
import 'package:kursach/main_page.dart';
import 'theme/theme.dart';
import 'database_helper.dart';

class CreateSurveyPage extends StatefulWidget {
  @override
  _CreateSurveyPageState createState() => _CreateSurveyPageState();
}

class _CreateSurveyPageState extends State<CreateSurveyPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _questionController = TextEditingController();
  List<Map<String, dynamic>> _questions = [];
  String _currentQuestionText = '';
  String _currentQuestionType = 'text';
  List<String> _currentQuestionOptions = [];
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final userId = DatabaseHelper().currentUserId;
    if (userId != null) {
      setState(() {
        _userId = userId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: AppStyles.backgroundGradient, // Градиент фона
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(), // Верхняя часть с кнопкой назад

                    SizedBox(height: 20),
                    _buildTextInput(
                        controller: _titleController, hint: 'Название'),

                    SizedBox(height: 12),
                    _buildTextInput(
                        controller: _descriptionController, hint: 'Описание'),

                    SizedBox(height: 12),
                    _buildTextInput(
                        controller: _questionController, hint: 'Введите вопрос',
                        onChanged: (value) {
                          setState(() => _currentQuestionText = value);
                        }),

                    SizedBox(height: 12),
                    _buildDropdown(),

                    SizedBox(height: 12),
                    if (_currentQuestionType != 'text') _buildOptionsInput(),

                    SizedBox(height: 20),
                    _buildButton('Добавить вопрос', _addQuestion),
                    SizedBox(height: 12),
                    _buildButton('Создать опрос', _createSurvey),

                    SizedBox(height: 12),
                    ..._buildQuestionList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: ()
            {
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
            }
        ),
      ],
    );
  }

  Widget _buildTextInput(
      {required TextEditingController controller,
        required String hint,
        Function(String)? onChanged}) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      style: AppStyles.inputTextStyle,
      decoration: AppStyles.inputDecoration.copyWith(
        hintText: hint,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Пожалуйста, заполните это поле';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _currentQuestionType,
      dropdownColor: Colors.black,
      style: AppStyles.inputTextStyle,
      onChanged: (value) {
        setState(() {
          _currentQuestionType = value!;
          _currentQuestionOptions = [];
        });
      },
      decoration: AppStyles.inputDecoration.copyWith(
        hintText: 'Выберите тип ответа',
      ),
      items: [
        DropdownMenuItem(value: 'text', child: Text('Текст')),
        DropdownMenuItem(value: 'single_choice', child: Text('Одиночный выбор')),
        DropdownMenuItem(value: 'multiple_choice', child: Text('Множественный выбор')),
      ],
    );
  }

  Widget _buildOptionsInput() {
    return Column(
      children: [
        ..._currentQuestionOptions.asMap().entries.map((entry) {
          int index = entry.key;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: _buildTextInput(
              controller: TextEditingController(text: entry.value),
              hint: 'Вариант ответа ${index + 1}',
              onChanged: (text) {
                setState(() {
                  _currentQuestionOptions[index] = text;
                });
              },
            ),
          );
        }).toList(),
        TextButton(
          onPressed: () {
            setState(() => _currentQuestionOptions.add(''));
          },
          child: Text(
            'Добавить вариант ответа',
            style: AppStyles.linkTextStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: AppStyles.elevatedButtonStyle,
      onPressed: onPressed,
      child: Text(text, style: AppStyles.buttonTextStyle),
    );
  }

  void _addQuestion() {
    setState(() {
      _questions.add({
        'questionText': _currentQuestionText,
        'type': _currentQuestionType,
        'options': _currentQuestionOptions,
      });
      _currentQuestionText = '';
      _currentQuestionType = 'text';
      _currentQuestionOptions = [];
      _questionController.clear();
    });
  }

  void _createSurvey() async {
    if (_formKey.currentState!.validate()) {
      await DatabaseHelper().createSurvey(
        title: _titleController.text,
        description: _descriptionController.text,
        creatorUserID: _userId!,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 7)),
        isPublic: true,
        questions: _questions,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Опрос успешно создан!')),
      );
    }
  }

  List<Widget> _buildQuestionList() {
    return _questions.map((q) {
      return Card(
        color: Colors.black54,
        child: ListTile(
          title: Text(
            q['questionText'],
            style: AppStyles.listTileTextStyle,
          ),
          subtitle: Text(
            q['type'] == 'text'
                ? 'Ответ: Текст'
                : 'Ответы: ${q['options'].join(', ')}',
            style: AppStyles.listTileTextStyle,
          ),
        ),
      );
    }).toList();
  }
}