import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerador_senha/main_context.dart';
import 'package:gerador_senha/page/home_page_context.dart';
import 'package:localization/localization.dart';

class HomePage extends StatefulWidget {
  MainContext mainContext;
  HomePage(this.mainContext , { Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePageContext _homePageContext = HomePageContext();
  double maxWidth = 400;

  @override
  void initState() {
    super.initState();
    _homePageContext.init();
  }

  @override
  void dispose() {
    _homePageContext.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !Platform.isAndroid ? null : AppBar(title: Text("title".i18n()), actions: [buildButtonChangeBrightness()],),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 10, right: 10),
          child: Column(
            children: [
              Stack(
              children: [
                buildChangeBrightness(), 
                Center(child: buildInfo())
              ]), 
              buildPassword(), 
              buildCustomize()],
          ),
        ),
      ),
    );
  }

  Widget buildChangeBrightness(){
    return Visibility(
      visible: !Platform.isAndroid,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          buildButtonChangeBrightness()
      ],),
    );
  }

  Widget buildButtonChangeBrightness(){
    return ValueListenableBuilder<Brightness>(
          valueListenable: widget.mainContext.brightnessNotifier,
          builder: (context, snapshot, _) {
            return IconButton(onPressed: (){
              if(snapshot == Brightness.light){
                widget.mainContext.brightnessNotifier.value = Brightness.dark;
              }
              else {
                widget.mainContext.brightnessNotifier.value = Brightness.light;
              }
            }, icon: Icon( snapshot == Brightness.light ? Icons.dark_mode_outlined : Icons.light_mode_outlined));
          }
        );
  }

  Widget buildInfo() {
    return Column(
      children: [
      Visibility(
        visible: !Platform.isAndroid,
        child: Text(
          'title'.i18n(),
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      Text('description'.i18n(),
          style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic))
    ]);
  }

  Widget buildPassword() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      constraints: BoxConstraints(minWidth: 100, maxWidth: maxWidth),
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(children: [
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _homePageContext.passwordNotifier.value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('success-copy'.i18n()))
              );
            }, 
            icon: const Icon(Icons.copy_outlined, color: Colors.deepPurpleAccent,)
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: _homePageContext.generatePassword, 
              icon: const Icon(Icons.refresh_outlined, color: Colors.deepPurpleAccent,)
          ),
          const SizedBox(
            width: 5,
          ),
          Container(
            color: Colors.grey,
            height: 30,
            width: 1,
          ),
          const SizedBox(
            width: 15,
          ),
          ValueListenableBuilder<String>(
          valueListenable: _homePageContext.passwordNotifier,
          builder: (context, snapshot, _) {
            return Flexible(
              child: Text(snapshot, style: const TextStyle(fontSize: 24, overflow: TextOverflow.fade), softWrap: false, maxLines: 1,),
            );
          }
          ),
        ]),
      )),
    );
  }

  Widget buildCustomize() {
    return Container(
        padding: const EdgeInsets.only(top: 10),
        constraints: BoxConstraints(minWidth: 100, maxWidth: maxWidth),
        child: Card(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0, top: 5, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'title-custom'.i18n(), 
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
              ),
              const Divider(thickness: 1),
              TextFormField(
                controller: _homePageContext.countCharactersController,
                onChanged: (value) => _homePageContext.generatePassword(),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(2),
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), 
                  FilteringTextInputFormatter.digitsOnly
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'count-characters'.i18n()),
              ),
              buildCheckBox("numbers".i18n(), _homePageContext.numbersNotifier),
              buildCheckBox("symbols".i18n(), _homePageContext.symbolsNotifier),
              buildCheckBox("letter-lowercase".i18n(), _homePageContext.lettersLowerCaseNotifier),
              buildCheckBox("letter-uppercase".i18n(), _homePageContext.lettersUpperCaseNotifier),
            ],
          ),
        )));
  }

  Widget buildCheckBox(String title, ValueNotifier<bool> notifier){
    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (context, snapshot, _) {
        return CheckboxListTile(
            value: snapshot,
            onChanged: (bool? newValue) => notifier.value = newValue ?? false,
            title: Text(title),
        );
      }
    );
  }
}
