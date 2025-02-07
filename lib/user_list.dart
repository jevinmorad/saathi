class User {
  final String name;
  final String email;
  final String mobileNumber;
  final String dob;
  final String gender;
  final String city;
  final List<String> hobbies;
  final String password;
  bool isFavourite;

  User({
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.dob,
    required this.gender,
    required this.city,
    required this.hobbies,
    required this.password,
    required this.isFavourite,
  });
}

class UserList {
  final List<User> _users = [
    User(
      name: 'Jevin',
      email: 'jevinmorad@gmail.com',
      mobileNumber: '9714630965',
      dob: '29/01/2006',
      gender: 'Male',
      city: 'Rajkot',
      hobbies: ['playing', 'reading', 'eating'],
      password: '123456',
      isFavourite: false,
    ),
  ];

  List<User> getUsers() {
    return _users;
  }

  User getUserAt(int index) {
    return _users[index];
  }

  void addUser(User user) {
    _users.insert(0, user);
  }

  void editUser(int index, User updateUser) {
    if(index>=0 && index<_users.length) {
      _users[index] = updateUser;
    }
  }

  void deleteUser(int index) {
    if(index>=0 && index<_users.length) {
      _users.removeAt(index);
    }
  }
}