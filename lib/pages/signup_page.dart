 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/api_service.dart';
import 'package:grocery_app/models/customer.dart';
import 'package:grocery_app/utils/form_helper.dart';
import 'package:grocery_app/utils/progress_hud.dart';
import 'package:grocery_app/utils/validator_service.dart';
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

 ApiService apiService;
 CustomerModel model;
 GlobalKey<FormState> globalKey = new GlobalKey<FormState>();
 bool hidePassword =true;
 bool isApiCallProcess = false;

 @override
  void initState() {
    apiService = ApiService();
    model = CustomerModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
         backgroundColor: Colors.red,
        title: Text('SignUp'),
        automaticallyImplyLeading: true,
      ),
      body: ProgressHUD(
        child: new Form(child:_formUi() ,key: globalKey,),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
      )
    );
  }

  Widget _formUi() {
   return SingleChildScrollView(
     child: Padding(
        padding: EdgeInsets.all(10),
       child: Container(
         child: Align(
           alignment: Alignment.topLeft,
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               FormHelper.fieldLabel("first name"),
               FormHelper.textInput(context,
                   model.firstName,
                   (value)=>{
                      this.model.firstName = value
                   },
                 onValidate: (value){
                 if(value.toString().isEmpty){
                   return 'please enter first Name';
                 }
                 return null;
                 },
               ),
               FormHelper.fieldLabel('Last Name'),
               FormHelper.textInput(context,
                   model.lastName,
                   (value)=>{
                     this.model.firstName = value
                   },
                 onValidate: (value)=>null
               ),
               FormHelper.fieldLabel('Email'),
               FormHelper.textInput(context,
                   model.email,
                   (value)=>this.model.email = value,
                 onValidate: (value){
                    if(value.toString().isEmpty){
                      return 'please enter valid email';
                    }
                    if(value.toString().isNotEmpty && value.toString().isValidEmail()){
                      return 'please enter avalid email';
                    }
                    else
                      return null;
                 }
               ),

               FormHelper.fieldLabel("password"),
               FormHelper.textInput(context,
                   model.password,
                   (value)=>this.model.password = value ,
                 onValidate: (value)=>(value.toString().isEmpty)?'please enter your password' : null,
                 obscureText: hidePassword,
                 suffixIcon: IconButton(
                   onPressed: (){
                     hidePassword = !hidePassword;
                   },
                   color: Theme.of(context).accentColor.withOpacity(0.4),
                   icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
                 )
               ),
               SizedBox(
                 height: 20,
               ),
               Center(
                 child: FormHelper.saveButton(
                     'Register',
                     (){
                      if(validateAndSave()){
                          print(model.toJson());
                          setState(() {
                            isApiCallProcess =true;
                          });
                      }
                      apiService.CreateCustomer(model).then(
                        (ret){
                          setState(() {
                            isApiCallProcess = false;
                          });
                          print('***********');
                          print(ret);
                          if(ret){
                            FormHelper.showMessage(context,
                                'woocommerce app',
                                'Registration successfully',
                                'Ok',
                                (){
                                  Navigator.of(context).pop();
                                },
                            );
                          }
                          else{
                            FormHelper.showMessage(context,
                              'woocommerce app',
                              'email id already register',
                              'Ok',
                                  (){
                                Navigator.of(context).pop();
                              },
                            );
                          }
                        }
                        );
                     }
                 ),
               ),
             ],
           ),
         ),
       ),
     ),
   );
  }

  bool validateAndSave(){
   final form =  globalKey.currentState;

    if(form.validate()){
      form.save();
      return true;
    }else
    return false;
  }
}
