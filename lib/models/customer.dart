class CustomerModel{

  String firstName;
  String lastName;
  String email;
  String password;

  CustomerModel({this.firstName, this.lastName, this.email, this.password});

  Map<String,dynamic> toJson(){
    Map<String,dynamic> map ={};
    map.addAll({
      'first_name':this.firstName,
      'last_name' : this.lastName,
      'email' : this.email,
      'password' : this.password,
      'user_name' : this.email
    });
    return map;
  }

}