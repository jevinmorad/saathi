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
  final List<User> _users = [];

  List<User> getUsers() {
    return _users;
  }

  void addUser(User user) {
    _users.add(user);
    print(_users);
  }

  void editUser(int index, User updateUser) {
    if(index>=0 && index<_users.length) {
      _users[index] = updateUser;
    }
  }

  void deletedUser(int index) {
    if(index>=0 && index<_users.length) {
      _users.removeAt(index);
    }
  }
}