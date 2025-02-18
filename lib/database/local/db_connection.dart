import 'dart:io';
import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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
  static const String HOBBIES = 'hobbies';
  static const String SPORTS = 'sports';
  static const String MUSIC = 'music';
  static const String MOVIES = 'movies';
  static const String OTHER_INTERESTS = 'other_interests';

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
          $HEIGHT REAL,
          $DIET TEXT,
          $BIO TEXT,
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
          $HOBBIES TEXT,
          $SPORTS TEXT,
          $MUSIC TEXT,
          $MOVIES TEXT,
          $OTHER_INTERESTS TEXT,
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
    return await db.insert('users', userData);
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

  Future<int> insertInterest(Map<String, dynamic> interestData) async {
    final db = await getDB();
    return await db.insert('interests', interestData);
  }

  Future<int> insertPhoto(int userId, Uint8List photoData, {bool isProfile = false}) async {
    final db = await getDB();
    return await db.insert('photos', {
      'user_id': userId,
      'photo_data': photoData,
      'uploaded_at': DateTime.now().toIso8601String(),
      'is_profile_picture': isProfile ? 1 : 0,
    });
  }
}
