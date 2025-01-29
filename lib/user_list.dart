class User {
  final String name;
  final String email;
  final String mobileNumber;
  final String dob;
  final String gender;
  final String city;
  final List<String> hobbies;
  final String password;

  User({
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.dob,
    required this.gender,
    required this.city,
    required this.hobbies,
    required this.password,
  });
}

class UserList {
  static List<User> users = [];

  List<User> getUsers() {
    return users;
  }

  void addUser(User user) {
    users.add(user);
    print(users);
  }

  void editUser(int index, User updateUser) {
    if(index>=0 && index<users.length) {
      users[index] = updateUser;
    }
  }

  void deletedUser(int index) {
    if(index>=0 && index<users.length) {
      users.removeAt(index);
    }
  }
}