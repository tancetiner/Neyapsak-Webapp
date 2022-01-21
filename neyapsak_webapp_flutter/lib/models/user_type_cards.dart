import 'package:flutter/material.dart';
import 'package:neyapsak_webapp_flutter/neyapsak_theme.dart';

class Card1 extends StatelessWidget {
  const Card1({Key? key}) : super(key: key);
  // 1
  final String category = 'Editor\'s Choice';
  final String title = 'Standart Kullanıcı';
  final String description = 'NeYapsak sorusuna cevap bulmak için.';
  final String chef = 'Buraya yazı';

  // 2
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: Stack(
        children: [
          Text(
            category,
            style: NeyapsakTheme.darkTextTheme.bodyText1,
          ),
          Positioned(
            child: Text(
              title,
              style: NeyapsakTheme.darkTextTheme.headline2,
            ),
            top: 20,
          ),
          Positioned(
            child: Text(
              description,
              style: NeyapsakTheme.darkTextTheme.bodyText1,
            ),
            bottom: 30,
            right: 0,
          ),
          Positioned(
            child: Text(
              chef,
              style: NeyapsakTheme.darkTextTheme.bodyText1,
            ),
            bottom: 10,
            right: 0,
          )
        ],
      ),
      padding: const EdgeInsets.all(30),
      constraints: const BoxConstraints.expand(
        width: 350,
        height: 450,
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('pierrot1.jpg'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    ));
  }
}

class Card2 extends StatelessWidget {
  const Card2({Key? key}) : super(key: key);
  // 1
  final String category = 'Editor\'s Choice';
  final String title = 'Organizatör Kullanıcı';
  final String description =
      'Etkinliklerini NeYapsak\'ta kullanıcılarla buluşturmak için.';
  final String chef = 'Buraya başka yazı';

  // 2
  @override
  Widget build(BuildContext context) {
    // 3
    return Center(
        child: Container(
      child: Stack(
        children: [
          // 8
          Text(
            category,
            style: NeyapsakTheme.darkTextTheme.bodyText1,
          ),
          // 9
          Positioned(
            child: Text(
              title,
              style: NeyapsakTheme.darkTextTheme.headline2,
            ),
            top: 20,
          ),
          // 10
          Positioned(
            child: Text(
              description,
              style: NeyapsakTheme.darkTextTheme.bodyText1,
            ),
            bottom: 30,
            right: 0,
          ),
          // 11
          Positioned(
            child: Text(
              chef,
              style: NeyapsakTheme.darkTextTheme.bodyText1,
            ),
            bottom: 10,
            right: 0,
          )
        ],
      ),
      // 1
      padding: const EdgeInsets.all(16),
      // 2
      constraints: const BoxConstraints.expand(
        width: 350,
        height: 450,
      ),
      // 3
      decoration: const BoxDecoration(
        // 4
        image: DecorationImage(
          // 5
          image: AssetImage('pierrot2.jpg'),
          // 6
          fit: BoxFit.cover,
        ),
        // 7
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    ));
  }
}

class Card3 extends StatelessWidget {
  const Card3({Key? key}) : super(key: key);
  // 1
  final String category = '';
  final String title = 'Editör Kullanıcı';
  final String description =
      'NeYapsak blogda etkinlikler hakkında yazılar yazmak için.';
  final String chef = '';

  // 2
  @override
  Widget build(BuildContext context) {
    // 3
    return Center(
        child: Container(
      child: Stack(
        children: [
          // 8
          Text(
            category,
            style: NeyapsakTheme.darkTextTheme.bodyText1,
          ),
          // 9
          Positioned(
            child: Text(
              title,
              style: NeyapsakTheme.darkTextTheme.headline2,
            ),
            top: 20,
          ),
          // 10
          Positioned(
            child: Text(
              description,
              style: NeyapsakTheme.darkTextTheme.bodyText1,
            ),
            bottom: 30,
            right: 0,
          ),
          // 11
          Positioned(
            child: Text(
              chef,
              style: NeyapsakTheme.darkTextTheme.bodyText1,
            ),
            bottom: 10,
            right: 0,
          )
        ],
      ),
      // 1
      padding: const EdgeInsets.all(16),
      // 2
      constraints: const BoxConstraints.expand(
        width: 350,
        height: 450,
      ),
      // 3
      decoration: const BoxDecoration(
        // 4
        image: DecorationImage(
          // 5
          image: AssetImage('pierrot3.jpg'),
          // 6
          fit: BoxFit.cover,
        ),
        // 7
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    ));
  }
}
