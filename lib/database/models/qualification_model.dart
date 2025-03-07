import 'package:saathi/database/local/const.dart';

class QualificationModel {
  String highestQualification = '';
  String college = '';

  QualificationModel._();

  static final QualificationModel getInstance = QualificationModel._();

  Map<String, dynamic> toMap() {
    return {
      HIGHEST_QUALIFICATION: highestQualification,
      COLLEGE: college,
    };
  }
}