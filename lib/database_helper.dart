import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Синглтон для управления базой данных
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  int? currentUserId;

  // Фабричный конструктор для возврата экземпляра синглтона
  factory DatabaseHelper() => _instance;

  // Приватный конструктор для предотвращения создания экземпляров напрямую
  DatabaseHelper._internal();

  // Метод для получения экземпляра базы данных
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    checkData();
    return _database!;
  }

  // Метод для инициализации базы данных
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'survey_voting.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db);
      },
    );
  }
  // Метод для установки текущего пользователя
  Future<void> setCurrentUser(String login) async {
    final user = await getUserByLogin(login);
    if (user != null) {
      currentUserId = user['UserID'];
    } else {
      throw Exception('Пользователь не найден');
    }
    print('-------------------------------------');
    print('userID: ${currentUserId}');
    print('-------------------------------------');
  }
  // Метод для создания таблиц в базе данных
  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE Users (
        UserID INTEGER PRIMARY KEY AUTOINCREMENT,
        FullName TEXT NOT NULL,
        Login TEXT UNIQUE NOT NULL,
        Password TEXT NOT NULL,
        DateOfBirth DATE NOT NULL,
        Avatar BLOB
      );
    ''');

    await db.execute('''
      CREATE TABLE Organizations (
        OrganizationID INTEGER PRIMARY KEY AUTOINCREMENT,
        Name TEXT NOT NULL,
        AdminUserID INTEGER NOT NULL,
        OrganizationImage BLOB,
        FOREIGN KEY (AdminUserID) REFERENCES Users(UserID)
      );
    ''');

    await db.execute('''
      CREATE TABLE OrganizationMembers (
        OrganizationID INTEGER NOT NULL,
        UserID INTEGER NOT NULL,
        PRIMARY KEY (OrganizationID, UserID),
        FOREIGN KEY (OrganizationID) REFERENCES Organizations(OrganizationID),
        FOREIGN KEY (UserID) REFERENCES Users(UserID)
      );
    ''');

    await db.execute('''
      CREATE TABLE Surveys (
        SurveyID INTEGER PRIMARY KEY AUTOINCREMENT,
        Title TEXT NOT NULL,
        Description TEXT,
        CreatorUserID INTEGER NOT NULL,
        OrganizationID INTEGER,
        StartDate DATE NOT NULL,
        EndDate DATE NOT NULL,
        IsPublic BOOLEAN NOT NULL,
        FOREIGN KEY (CreatorUserID) REFERENCES Users(UserID),
        FOREIGN KEY (OrganizationID) REFERENCES Organizations(OrganizationID)
      );
    ''');

    await db.execute('''
      CREATE TABLE Questions (
        QuestionID INTEGER PRIMARY KEY AUTOINCREMENT,
        SurveyID INTEGER NOT NULL,
        QuestionText TEXT NOT NULL,
        QuestionType TEXT NOT NULL,
        Image BLOB,
        FOREIGN KEY (SurveyID) REFERENCES Surveys(SurveyID)
      );
    ''');

    await db.execute('''
      CREATE TABLE Options (
        OptionID INTEGER PRIMARY KEY AUTOINCREMENT,
        QuestionID INTEGER NOT NULL,
        OptionText TEXT NOT NULL,
        FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID)
      );
    ''');

    await db.execute('''
      CREATE TABLE Responses (
        ResponseID INTEGER PRIMARY KEY AUTOINCREMENT,
        UserID INTEGER,
        OrganizationID INTEGER,
        SurveyID INTEGER NOT NULL,
        QuestionID INTEGER NOT NULL,
        OptionID INTEGER,
        TextAnswer TEXT,
        OptionIDs TEXT,
        FOREIGN KEY (UserID) REFERENCES Users(UserID),
        FOREIGN KEY (OrganizationID) REFERENCES Organizations(OrganizationID),
        FOREIGN KEY (SurveyID) REFERENCES Surveys(SurveyID),
        FOREIGN KEY (QuestionID) REFERENCES Questions(QuestionID),
        FOREIGN KEY (OptionID) REFERENCES Options(OptionID)
      );
    ''');

    await db.execute('''
      CREATE TABLE SurveyResults (
        ResultID INTEGER PRIMARY KEY AUTOINCREMENT,
        SurveyID INTEGER NOT NULL,
        UserID INTEGER,
        OrganizationID INTEGER,
        Summary TEXT,
        FOREIGN KEY (SurveyID) REFERENCES Surveys(SurveyID),
        FOREIGN KEY (UserID) REFERENCES Users(UserID),
        FOREIGN KEY (OrganizationID) REFERENCES Organizations(OrganizationID)
      );
    ''');
  }

  // Метод для очистки базы данных
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('Users');
    await db.delete('Organizations');
    await db.delete('OrganizationMembers');
    await db.delete('Surveys');
    await db.delete('Questions');
    await db.delete('Options');
    await db.delete('Responses');
    await db.delete('SurveyResults');
  }

  // Метод для закрытия базы данных
  Future<void> close() async {
    final db = await database;
    db.close();
  }

  // Метод для создания опроса
  Future<void> createSurvey({
    required String title,
    String? description,
    required int creatorUserID,
    int? organizationID,
    required DateTime startDate,
    required DateTime endDate,
    required bool isPublic,
    required List<Map<String, dynamic>> questions, // [{questionText, type, options: []}]
  }) async {
    final db = await database;

    // Вставляем опрос
    final surveyId = await db.insert('Surveys', {
      'Title': title,
      'Description': description,
      'CreatorUserID': creatorUserID,
      'OrganizationID': organizationID,
      'StartDate': startDate.toIso8601String(),
      'EndDate': endDate.toIso8601String(),
      'IsPublic': isPublic ? 1 : 0,
    });

    // Вставляем вопросы и варианты
    for (var question in questions) {
      final questionId = await db.insert('Questions', {
        'SurveyID': surveyId,
        'QuestionText': question['questionText'],
        'QuestionType': question['type'],
      });

      for (var option in question['options']) {
        await db.insert('Options', {
          'QuestionID': questionId,
          'OptionText': option,
        });
      }
    }
  }

  // Метод для проверки данных в базе данных
  Future<void> checkData() async {
    final Database db = await database;
    final List<Map<String, dynamic>> responses = await db.query('Responses');

    for (var response in responses) {
      print('ResponseID: ${response['ResponseID']}');
      print('UserID: ${response['UserID']}');
      print('OrganizationID: ${response['OrganizationID']}');
      print('SurveyID: ${response['SurveyID']}');
      print('QuestionID: ${response['QuestionID']}');
      print('OptionID: ${response['OptionID']}');
      print('TextAnswer: ${response['TextAnswer']}');
      print('OptionIDs: ${response['OptionIDs']}');
      print('-------------------------------------');
    }

    // Дополнительные проверки данных
    final List<Map<String, dynamic>> options = await db.query('Options');
    for (var option in options) {
      final optionId = option['OptionID'];
      final multipleResponseCount = await getMultipleResponseCount(db, optionId);

      print('Multiple response count for OptionID $optionId: $multipleResponseCount');
    }
  }

  // Метод для получения количества множественных ответов для данного варианта
  Future<int> getMultipleResponseCount(Database db, int optionId) async {
    final responses = await db.query('Responses', columns: ['OptionIDs']);
    int count = 0;

    for (var response in responses) {
      final optionIDs = response['OptionIDs'];
      if (optionIDs != null && optionIDs is String) {
        List<dynamic> ids = jsonDecode(optionIDs);
        if (ids.contains(optionId)) {
          count++;
        }
      }
    }

    return count;
  }

  // Метод для отправки ответа на опрос
  Future<void> submitResponse({
    required int userID,
    required int surveyID,
    required List<Map<String, dynamic>> answers,
  }) async {
    final db = await database;

    for (var answer in answers) {
      final questionID = answer['questionID'];
      final optionID = answer['optionID'];
      final optionIDs = answer['optionIDs'];
      final textAnswer = answer['textAnswer'];

      await db.insert('Responses', {
        'UserID': userID,
        'SurveyID': surveyID,
        'QuestionID': questionID,
        'OptionID': optionID,
        'TextAnswer': textAnswer,
        // Добавляем поле для множественного выбора
        'OptionIDs': optionIDs != null ? jsonEncode(optionIDs) : null,
      });
    }
  }

  // Метод для регистрации пользователя
  Future<void> registerUser({
    required String fullName,
    required String login,
    required String password,
    required String dateOfBirth,
  }) async {
    final db = await database;
    await db.insert('Users', {
      'FullName': fullName,
      'Login': login,
      'Password': password,
      'DateOfBirth': dateOfBirth,
    });
  }

  // Метод для получения доступных опросов
  Future<List<Map<String, dynamic>>> getAvailableSurveys() async {
    final db = await database;
    return await db.query('Surveys', where: 'IsPublic = ?', whereArgs: [1]); // Assuming 1 represents public surveys
  }

  // Метод для получения вариантов ответа по идентификатору вопроса
  Future<List<Map<String, dynamic>>> getOptionsByQuestionId(int questionId) async {
    final db = await database;
    return await db.query('Options', where: 'QuestionID = ?', whereArgs: [questionId]);
  }

  // Метод для получения опроса по идентификатору
  Future<Map<String, dynamic>?> getSurveyById(int surveyId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Surveys',
      where: 'SurveyID = ?',
      whereArgs: [surveyId],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  // Метод для получения вопросов по идентификатору опроса
  Future<List<Map<String, dynamic>>> getQuestionsBySurveyId(int surveyId) async {
    final db = await database;
    return await db.query(
      'Questions',
      where: 'SurveyID = ?',
      whereArgs: [surveyId],
    );
  }

  // Метод для получения результатов опроса
  Future<Map<String, dynamic>?> getSurveyResults(int surveyId) async {
    final db = await database;

    print('--- Getting Survey Results ---');
    print('SurveyID: $surveyId');

    try {
      final survey = await getSurveyById(surveyId);
      if (survey == null) {
        print('Survey not found!');
        return null;
      }
      print('Survey Title: ${survey['Title']}');

      final questions = await getQuestionsBySurveyId(surveyId);
      print('Questions found: ${questions.map((q) => q['QuestionText']).toList()}');

      final questionResults = <Map<String, dynamic>>[];

      for (var question in questions) {
        final questionId = question['QuestionID'];
        final questionText = question['QuestionText'];
        final questionType = question['QuestionType']; // Получаем тип вопроса
        print('Processing Question: $questionText (ID: $questionId)');

        // Определяем список для хранения результатов вариантов ответа
        final optionResults = <Map<String, dynamic>>[];
        int totalResponses = 0;

        if (questionType == 'text') {
          // Если вопрос текстовый, извлекаем текстовые ответы
          final textResponses = await db.query(
            'Responses',
            where: 'SurveyID = ? AND QuestionID = ?',
            whereArgs: [surveyId, questionId],
          );

          // Обработка текстовых ответов
          final textAnswerResults = textResponses.map((response) => response['TextAnswer']).toList();

          questionResults.add({
            'questionText': questionText,
            'textAnswers': textAnswerResults,
            'totalResponses': textAnswerResults.length, // Общее количество текстовых ответов
          });
        } else {
          // Обработка обычных вопросов с вариантами
          final options = await getOptionsByQuestionId(questionId);
          print('Options: ${options.map((o) => o['OptionText']).toList()}');

          for (var option in options) {
            final optionId = option['OptionID'];
            final responseCount = Sqflite.firstIntValue(await db.rawQuery(
              'SELECT COUNT(*) FROM Responses WHERE SurveyID = ? AND QuestionID = ? AND OptionID = ? ',
              [surveyId, questionId, optionId],
            )) ?? 0;

            final multipleResponseCount = await getMultipleResponseCount(db, optionId);

            print('Количество ответов: $multipleResponseCount');
            totalResponses += responseCount + multipleResponseCount;

            print('Option: ${option['OptionText']} (ID: $optionId) -> Count: ${responseCount + multipleResponseCount}');

            optionResults.add({
              'OptionID': optionId,
              'optionText': option['OptionText'],
              'responseCount': responseCount + multipleResponseCount,
            });
          }

          // Добавляем результаты опроса с вариантами
          questionResults.add({
            'questionText': questionText,
            'optionResults': optionResults,
            'totalResponses': totalResponses,
          });
        }
      }

      print('Results computed successfully.');
      return {
        'surveyTitle': survey['Title'],
        'questionResults': questionResults,
      };
    } catch (e) {
      print('Error in getSurveyResults: $e');
      return null;
    }
  }

  // Метод для получения пользователя по логину
  Future<Map<String, dynamic>?> getUserByLogin(String login) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Users',
      where: 'Login = ?',
      whereArgs: [login],
    );
    if (maps.isNotEmpty) {
      return maps.first;

    } else {
      return null;
    }
  }

  // Метод для вставки варианта ответа
  Future<void> insertOption(int questionId, String optionText) async {
    final db = await database;
    await db.insert(
      'Options',
      {
        'QuestionID': questionId,
        'OptionText': optionText,
      },
    );
  }

  // Метод для добавления вариантов ответа к вопросу
  Future<void> addOptionsToQuestion(int questionId, List<String> options) async {
    final db = await database;

    for (String option in options) {
      await db.insert(
        'Options',
        {
          'QuestionID': questionId,
          'OptionText': option,
        },
      );
    }
  }
}