import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase.instance.ref();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isEmailValid = true;
  bool _isAgeValid = true;
  bool _isPasswordValid = true;

  String? _selectedGender;
  String? _deviceName;

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  // device Info
  Future<void> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        _deviceName = '${androidInfo.brand} ${androidInfo.model}';
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('알 수 없는 오류: 앱을 다시 시작하세요.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(), // 기본 테두리 스타일
                errorText:
                    !_isEmailValid ? '유효한 이메일 주소를 입력하세요' : null, // 에러 메시지
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.blue, width: 2), // 포커스 시 색상 변경
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _isEmailValid
                        ? Colors.grey
                        : Colors.red, // 유효성에 따른 테두리 색상 변경
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _isEmailValid = _validateEmail(value);
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
                errorText: !_isAgeValid ? '유효한 나이를 입력하세요' : null,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _isAgeValid ? Colors.grey : Colors.red,
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _isAgeValid = _validateAge(value);
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                errorText: !_isPasswordValid ? '비밀번호는 6자 이상이어야 합니다' : null,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _isPasswordValid ? Colors.grey : Colors.red,
                  ),
                ),
              ),
              obscureText: true, // 비밀번호 가리기
              onChanged: (value) {
                setState(() {
                  _isPasswordValid = _validatePassword(value);
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              hint: Text('Select Gender'),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: ['Male', 'Female'].map((gender) {
                return DropdownMenuItem(
                  child: Text(gender),
                  value: gender,
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey,
                disabledForegroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16), // 버튼 내부 여백
                minimumSize: Size(double.infinity, 0), // 버튼 크기
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 버튼 모서리 둥글기
                ),
              ),
              onPressed: _isFormValid()
                  ? _signUp
                  : null, // 검증이 성공하면 _signUp 호출, 실패하면 비활성화
              child: Text(
                'Sign Up',
                style: TextStyle(fontSize: 18), // 텍스트 크기
              ),
            )
          ],
        ),
      ),
    );
  }

  bool _isFormValid() {
    var isValid = _validateEmail(_emailController.text) &&
        _validateAge(_ageController.text) &&
        _validatePassword(_passwordController.text) &&
        _selectedGender != null;
    print("isValid: $isValid");
    return isValid;
  }

  bool _validateEmail(String email) {
    String emailPattern = r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+$';
    return RegExp(emailPattern).hasMatch(email);
  }

  bool _validateAge(String age) {
    int? parsedAge = int.tryParse(age);
    return parsedAge != null && parsedAge > 0;
  }

  bool _validatePassword(String password) {
    return password.length >= 6;
  }

  Future<void> _signUp() async {
    String email = _emailController.text.trim(); // 공백을 제거하여 email 가져오기
    String password = _passwordController.text.trim(); // 공백을 제거하여 password 가져오기
    int age = int.parse(_ageController.text.trim()); // 공백을 제거하여 age 가져오기
    String? gender = _selectedGender; // gender 가져오기
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password, // 비밀번호는 임시로 설정하고 나중에 변경하게 할 수 있습니다.
      );

      String userId = userCredential.user!.uid;
      String? deviceName = _deviceName; // 기기 이름은 직접 가져오거나 설정

      // Firebase Realtime Database에 데이터 저장
      await _database.child('users').child(userId).set({
        'UUID': userId,
        'email': email,
        'age': age,
        'gender': gender,
        'device': deviceName,
        'app_usage': [],
        'notifications': [],
        'health_data': []
      });

      Navigator.pushReplacementNamed(context, '/home');

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('회원가입 완료!')));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('회원가입 실패: 다시 시도하세요.')));
    }
  }
}
