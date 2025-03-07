import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saathi/database/local/shared_pref_helper.dart';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';

class DBConnect {
  static const String USER_ID = 'user_id';

  static const String TABLE_USERS = 'users';
  static String FNAME = 'first_name';
  static String LNAME = 'last_name';
  static const String GENDER = 'gender';
  static const String MOBILE = 'mobile';
  static const String EMAIL = 'email';
  static const String DATE_OF_BIRTH = 'date_of_birth';
  static const String RELIGION = 'religion';
  static const String COMMUNITY = 'community';
  static const String SUB_COMMUNITY = 'sub_community';
  static const String LIVING_IN = 'living_in';
  static const String CITY = 'city';
  static const String STATE = 'state';
  static const String MARITAL_STATUS = 'marital_status';
  static const String HEIGHT = 'height';
  static const String DIET = 'diet';
  static const String BIO = 'bio';

  static const String TABLE_PREFERENCES = 'preferences';
  static const String PREFERENCE_ID = 'preference_id';
  static const String PREFERRED_RELIGION = 'preferred_religion';
  static const String PREFERRED_COMMUNITY = 'preferred_community';
  static const String PREFERRED_HEIGHT_MIN = 'preferred_height_min';
  static const String PREFERRED_HEIGHT_MAX = 'preferred_height_max';
  static const String PREFERRED_DIET = 'preferred_diet';
  static const String PREFERRED_OCCUPATION = 'preferred_occupation';
  static const String PREFERRED_MARITAL_STATUS = 'preferred_marital_status';
  static const String PREFERRED_LIVING_IN = 'preferred_living_in';
  static const String PREFERRED_CITY = 'preferred_city';
  static const String PREFERRED_STATE = 'preferred_state';
  static const String PREFERRED_COUNTRY = 'preferred_country';

  static const String TABLE_EDUCATION = 'education';
  static const String EDUCATION_ID = 'education_id';
  static const String HIGHEST_QUALIFICATION = 'highest_qualification';
  static const String COLLEGE = 'college';
  static const String DEGREE = 'degree';
  static const String FIELD_OF_STUDY = 'field_of_study';
  static const String GRADUATION_YEAR = 'graduation_year';

  static const String TABLE_PROFESSION = 'profession';
  static const String PROFESSION_ID = 'profession_id';
  static const String WORK_DETAILS = 'work_details';
  static const String OCCUPATION = 'occupation';
  static const String COMPANY = 'company';
  static const String INCOME = 'income';

  static const String TABLE_INTERESTS = 'interests';
  static const String INTEREST_ID = 'interest_id';
  static const String INTERESTS = 'INTERESTS';

  static const String TABLE_PHOTOS = 'photos';
  static const String PHOTO_ID = 'photo_id';
  static const String PHOTO_DATA = 'photo_data';
  static const String UPLOADED_AT = 'uploaded_at';

  DBConnect._();
  static final DBConnect getInstance = DBConnect._();
  Database? myDB;

  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, 'user_data.db');

    return await openDatabase(dbPath, version: 1,
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $TABLE_USERS (
          $USER_ID INTEGER PRIMARY KEY AUTOINCREMENT,
          $FNAME TEXT,
          $LNAME TEXT,
          $GENDER TEXT,
          $MOBILE TEXT,
          $EMAIL TEXT,
          $DATE_OF_BIRTH TEXT,
          $RELIGION TEXT,
          $COMMUNITY TEXT,
          $SUB_COMMUNITY TEXT,
          $LIVING_IN TEXT,
          $CITY TEXT,
          $STATE TEXT,
          $MARITAL_STATUS TEXT,
          $HEIGHT TEXT,
          $DIET TEXT,
          $BIO TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE $TABLE_PREFERENCES (
          $PREFERENCE_ID INTEGER PRIMARY KEY AUTOINCREMENT,
          $USER_ID INTEGER,
          $PREFERRED_RELIGION TEXT,
          $PREFERRED_COMMUNITY TEXT,
          $PREFERRED_HEIGHT_MIN REAL,
          $PREFERRED_HEIGHT_MAX REAL,
          $PREFERRED_DIET TEXT,
          $PREFERRED_OCCUPATION TEXT,
          $PREFERRED_MARITAL_STATUS TEXT,
          $PREFERRED_LIVING_IN TEXT,
          $PREFERRED_CITY TEXT,
          $PREFERRED_STATE TEXT,
          $PREFERRED_COUNTRY TEXT,
          FOREIGN KEY ($USER_ID) REFERENCES $TABLE_USERS($USER_ID) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE $TABLE_EDUCATION (
          $EDUCATION_ID INTEGER PRIMARY KEY AUTOINCREMENT,
          $USER_ID INTEGER,
          $HIGHEST_QUALIFICATION TEXT,
          $COLLEGE TEXT,
          FOREIGN KEY ($USER_ID) REFERENCES $TABLE_USERS($USER_ID) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE $TABLE_PROFESSION (
          $PROFESSION_ID INTEGER PRIMARY KEY AUTOINCREMENT,
          $USER_ID INTEGER,
          $WORK_DETAILS TEXT,
          $OCCUPATION TEXT,
          $COMPANY TEXT,
          $INCOME TEXT,
          FOREIGN KEY ($USER_ID) REFERENCES $TABLE_USERS($USER_ID) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE $TABLE_INTERESTS (
          $INTEREST_ID INTEGER PRIMARY KEY AUTOINCREMENT,
          $USER_ID INTEGER,
          $INTERESTS TEXT, 
          FOREIGN KEY ($USER_ID) REFERENCES $TABLE_USERS($USER_ID) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE $TABLE_PHOTOS (
          $PHOTO_ID INTEGER PRIMARY KEY AUTOINCREMENT,
          $USER_ID INTEGER,
          $PHOTO_DATA BLOB,
          $UPLOADED_AT TEXT,
          FOREIGN KEY ($USER_ID) REFERENCES $TABLE_USERS($USER_ID) ON DELETE CASCADE
        )
      ''');
    });
  }

  Future<int> insertUser(Map<String, dynamic> userData) async {
    final db = await getDB();
    int userId = await db.insert('users', userData);
    if (userId > 0) {
      await SharedPrefHelper.saveUserId(userId);
    }
    return userId;
  }

  Future<int> insertPreference(Map<String, dynamic> preferenceData) async {
    final db = await getDB();
    return await db.insert('preferences', preferenceData);
  }

  Future<int> insertEducation(Map<String, dynamic> educationData) async {
    final db = await getDB();
    return await db.insert('education', educationData);
  }

  Future<int> insertProfession(Map<String, dynamic> professionData) async {
    final db = await getDB();
    return await db.insert('profession', professionData);
  }

  Future<int> insertInterest(int userId, List<String> interests) async {
    final db = await getDB();

    Map<String, dynamic> interestData = {
      USER_ID: userId,
      INTERESTS: jsonEncode(interests),
    };
    return await db.insert('interests', interestData);
  }


  Future<int> insertPhoto(int userId, Uint8List photoData,
      {bool isProfile = false}) async {
    final db = await getDB();
    return await db.insert('photos', {
      'user_id': userId,
      'photo_data': photoData,
      'uploaded_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<int>> getAllUserIds() async {
    final db = await getDB();
    List<Map<String, dynamic>> result = await db.query(
      TABLE_USERS,
      columns: [USER_ID],
    );
    return result.map((row) => row[USER_ID] as int).toList();
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await getDB();
    return await db.query(TABLE_USERS);
  }

  Future<Map<String, dynamic>?> getUser(int userId) async {
    final db = await getDB();
    List<Map<String, dynamic>> result = await db.query(
      TABLE_USERS,
      where: '$USER_ID = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getPreferences(int userId) async {
    final db = await getDB();
    List<Map<String, dynamic>> result = await db.query(
      TABLE_PREFERENCES,
      where: '$USER_ID = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getEducation(int userId) async {
    final db = await getDB();
    List<Map<String, dynamic>> result = await db.query(
      TABLE_EDUCATION,
      where: '$USER_ID = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getProfession(int userId) async {
    final db = await getDB();
    List<Map<String, dynamic>> result = await db.query(
      TABLE_PROFESSION,
      where: '$USER_ID = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<String>> getInterests(int userId) async {
    final db = await getDB();
    List<Map<String, dynamic>> result = await db.query(
      TABLE_INTERESTS,
      where: '$USER_ID = ?',
      whereArgs: [userId],
    );

    if (result.isEmpty) return [];
    return List<String>.from(jsonDecode(result.first[INTERESTS] ?? '[]'));
  }

  Future<List<Map<String, dynamic>>> getAllUsersWithPhoto() async {
    final db = await getDB();

    List<Map<String, dynamic>> users = await db.query(TABLE_USERS);
    List<Map<String, dynamic>> usersWithPhotos = [];

    for (var user in users) {
      Map<String, dynamic> userData = Map<String, dynamic>.from(user);

      List<Map<String, dynamic>> photos = await db.query(
        TABLE_PHOTOS,
        where: "$USER_ID = ?",
        whereArgs: [user[USER_ID]],
      );

      // Use only the first photo if available
      userData['PHOTO'] = photos.isNotEmpty ? photos.first[PHOTO_DATA] : null;

      usersWithPhotos.add(userData);
    }

    // Reverse the list to get the last row data at index 0
    return usersWithPhotos.reversed.toList();
  }

  Future<void> deleteUser(int userId) async {
    final db = await getDB();

    // Start a transaction to ensure atomicity
    await db.transaction((txn) async {
      // Delete from the photos table
      await txn.delete(
        TABLE_PHOTOS,
        where: '$USER_ID = ?',
        whereArgs: [userId],
      );

      // Delete from the interests table
      await txn.delete(
        TABLE_INTERESTS,
        where: '$USER_ID = ?',
        whereArgs: [userId],
      );

      // Delete from the profession table
      await txn.delete(
        TABLE_PROFESSION,
        where: '$USER_ID = ?',
        whereArgs: [userId],
      );

      // Delete from the education table
      await txn.delete(
        TABLE_EDUCATION,
        where: '$USER_ID = ?',
        whereArgs: [userId],
      );

      // Delete from the preferences table
      await txn.delete(
        TABLE_PREFERENCES,
        where: '$USER_ID = ?',
        whereArgs: [userId],
      );

      // Finally, delete from the users table
      await txn.delete(
        TABLE_USERS,
        where: '$USER_ID = ?',
        whereArgs: [userId],
      );
    });
  }

  Future<int> updateUser(int userId, Map<String, dynamic> userData) async {
    final db = await getDB();
    return await db.update(
      TABLE_USERS,
      userData,
      where: '$USER_ID = ?',
      whereArgs: [userId],
    );
  }

  Future<int> updatePreferences(
      int userId, Map<String, dynamic> preferenceData) async {
    final db = await getDB();
    return await db.update(
      TABLE_PREFERENCES,
      preferenceData,
      where: '$USER_ID = ?',
      whereArgs: [userId],
    );
  }

  Future<int> updateEducation(
      int userId, Map<String, dynamic> educationData) async {
    final db = await getDB();
    return await db.update(
      TABLE_EDUCATION,
      educationData,
      where: '$USER_ID = ?',
      whereArgs: [userId],
    );
  }

  Future<int> updateProfession(
      int userId, Map<String, dynamic> professionData) async {
    final db = await getDB();
    return await db.update(
      TABLE_PROFESSION,
      professionData,
      where: '$USER_ID = ?',
      whereArgs: [userId],
    );
  }

  Future<int> updateInterest(int userId, List<String> interests) async {
    final db = await getDB();

    return await db.update(
      TABLE_INTERESTS,
      {'interests': jsonEncode(interests)},
      where: '$USER_ID = ?',
      whereArgs: [userId],
    );
  }

  Future<int> updatePhoto(int userId, Uint8List photoData) async {
    final db = await getDB();
    return await db.update(
      TABLE_PHOTOS,
      {
        'photo_data': photoData,
        'uploaded_at': DateTime.now().toIso8601String(),
      },
      where: '$USER_ID = ?',
      whereArgs: [userId],
    );
  }
}
