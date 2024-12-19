// Виджет листа с деталями опроса
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'theme/theme.dart'; // Импортируем файл стилей

class SurveyDetailSheet extends StatefulWidget {
  final int surveyId; // Идентификатор опроса

  SurveyDetailSheet({required this.surveyId});

  @override
  _SurveyDetailSheetState createState() => _SurveyDetailSheetState();
}

// Состояние виджета листа с деталями опроса
class _SurveyDetailSheetState extends State<SurveyDetailSheet> {
  Map<String, dynamic>? _results; // Результаты опроса

  @override
  void initState() {
    super.initState();
    _loadResults(); // Загрузка результатов опроса при инициализации состояния
  }

  // Метод для загрузки результатов опроса из базы данных
  Future<void> _loadResults() async {
    final results = await DatabaseHelper().getSurveyResults(widget.surveyId);
    setState(() {
      _results = results; // Обновление состояния с результатами опроса
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_results == null) {
      return Center(
          child: CircularProgressIndicator()); // Отображение индикатора загрузки, если результаты еще не загружены
    }

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: AppStyles.backgroundGradient,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(

                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context); // Закрытие листа
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  _buildTitle(_results!['surveyTitle']),
                  SizedBox(height: 20),
                  ..._buildResultWidgets(),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 20),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: FloatingActionButton(
                        backgroundColor: Colors.black,
                        onPressed: () {
                          Navigator.pop(context); // Закрытие листа
                        },
                        child: Icon(Icons.home, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: AppStyles.titleTextStyle,
      textAlign: TextAlign.center,
    );
  }
  Widget _buildDescription(String description){
    return Text(
      description,
      style: AppStyles.footerTextStyle.copyWith(color: Colors.white70),
      textAlign: TextAlign.center,
    );
  }

  // Метод для построения виджетов результатов
  List<Widget> _buildResultWidgets() {
    return _results!['questionResults'].map<Widget>((questionResult) {
      final questionText = questionResult['questionText'];
      final optionResults = questionResult['optionResults'] ?? [];
      final multipleOptionIDs = questionResult['optionIDs'] ?? [];
      final textAnswers = questionResult['textAnswers'] ?? [];

      // Подсчет общего количества ответов
      int totalResponses = optionResults.fold<int>(
        0,
            (int sum,
            dynamic option) {
          return sum + (option['responseCount'] != null
              ? (option['responseCount'] as int)
              : 0);
        },
      );

      // Подсчет голосов для множественных вариантов
      Map<int, int> multipleOptionCounts = {};
      for (var optionId in multipleOptionIDs) {
        multipleOptionCounts[optionId] =
            (multipleOptionCounts[optionId] ?? 0) + 1;
      }

      // Подсчет общих голосов, включая множественные варианты
      int totalCountIncludingMultiple = totalResponses;
      optionResults.forEach((option) {
        final optionId = option['OptionID'];
        if (multipleOptionCounts.containsKey(optionId)) {
          totalCountIncludingMultiple += multipleOptionCounts[optionId]!;
        }
      });

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок вопроса
          _buildQuestionBlock(questionText, optionResults, multipleOptionCounts, totalCountIncludingMultiple),
          // Обработка текстовых ответов
          if (textAnswers.isNotEmpty)
            ...textAnswers.map<Widget>((textAnswer) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  textAnswer,
                  style: TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
        ],
      );
    }).toList();
  }

  Widget _buildQuestionBlock(String question, List<dynamic> optionResults, Map<int, int> multipleOptionCounts, int totalCountIncludingMultiple) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                question,
                style: AppStyles.buttonTextStyle,
              ),
            ),
          ),
          SizedBox(height: 10),
          ...optionResults.map<Widget>((optionResult) {
            final optionText = optionResult['optionText'] ?? 'Неизвестный вариант';
            final responseCount = (optionResult['responseCount'] ?? 0) as int;
            final multipleResponseCount = multipleOptionCounts[optionResult['OptionID']] ?? 0;
            final totalCount = responseCount + multipleResponseCount;
            final percentage = totalCountIncludingMultiple > 0
                ? (totalCount / totalCountIncludingMultiple * 100)
                : 0;

            return _buildResultRow(optionText, percentage.toInt());
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, int percentage) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppStyles.listTileTextStyle),
            Text('$percentage%', style: AppStyles.listTileTextStyle),
          ],
        ),
        Slider(
          value: percentage.toDouble(),
          max: 100,
          min: 0,
          onChanged: null, // Неактивный слайдер
          activeColor: Colors.black,
          inactiveColor: Colors.grey,
        ),
      ],
    );
  }
}
