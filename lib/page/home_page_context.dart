import 'dart:math';

import 'package:flutter/material.dart';

class HomePageContext {
  TextEditingController countCharactersController = TextEditingController(text: "10");
  ValueNotifier<bool> numbersNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> symbolsNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> lettersUpperCaseNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> lettersLowerCaseNotifier = ValueNotifier<bool>(true);
  ValueNotifier<String> passwordNotifier = ValueNotifier<String>("ic31&q8EAcRV");

  final String _letters = "abcdefghijklmnopqrstuvxz";
  final String _numbers = "0123456789";
  final String _symbols = "?[]/{}|~`!@#%^&*()_=-";

  void init(){
    _createListener(numbersNotifier);
    _createListener(symbolsNotifier);
    _createListener(lettersUpperCaseNotifier);
    _createListener(lettersLowerCaseNotifier);
  }

  void dispose(){
    _disposeNotifier(numbersNotifier);
    _disposeNotifier(symbolsNotifier);
    _disposeNotifier(lettersUpperCaseNotifier);
    _disposeNotifier(lettersLowerCaseNotifier);
  }

  void _createListener(ValueNotifier notifier){
    notifier.addListener(generatePassword);
  }
  
  void _disposeNotifier(ValueNotifier notifier){
    notifier.dispose();
  }

  void generatePassword(){
    int passwordCount = int.tryParse(countCharactersController.text) ?? 0;
    String password = "";
    List<String Function()> functionsList = [];
    if(numbersNotifier.value){
      functionsList.add(_generateRandomNumbers);
    }
    if(symbolsNotifier.value){
      functionsList.add(_generateRandomSymbols);
    }
    if(lettersUpperCaseNotifier.value){
      functionsList.add(() => _generateRandomLetters(true));
    }
    if(lettersLowerCaseNotifier.value){
      functionsList.add(() => _generateRandomLetters(false));
    }
    if(functionsList.isEmpty){
      passwordNotifier.value = '';
      return;
    }
    for(int count = 0; count < passwordCount; count++){
      int random = Random().nextInt(functionsList.length);
      password += functionsList[random]();
    }
    passwordNotifier.value = password;
  }

  String _generateRandomLetters(bool upperCase){
    int random = Random().nextInt(_letters.length);
    String letter = _letters[random];
    return upperCase ? letter.toUpperCase() : letter.toLowerCase();
  }

  String _generateRandomNumbers(){
    int random = Random().nextInt(_numbers.length);
    return _numbers[random];
  }

  String _generateRandomSymbols(){
    int random = Random().nextInt(_symbols.length);
    return _symbols[random];
  }
}