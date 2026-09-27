// ЛР 1 — шесть независимых виджетов.
//
// Как сдавать: скопируйте этот файл целиком себе в main.dart, допишите
// шесть функций ниже вместо TODO, запустите — все шесть элементов должны
// появиться на экране. Пришлите готовый файл на проверку.
//
// Основной виджет трогать не нужно. Редактируйте там, где написано TODO.

import 'package:flutter/material.dart';

void main() {
  runApp(const Lab1App());
}

class Lab1App extends StatelessWidget {
  const Lab1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ЛР 1')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Task 1:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task1(),
              const SizedBox(height: 4),
              const Divider(),
              const SizedBox(height: 4),
              const Text(
                'Task 2:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task2(),

              const SizedBox(height: 4),
              const Divider(),
              const SizedBox(height: 4),
              const Text(
                'Task 3:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task3(),
              const SizedBox(height: 4),
              const Divider(),
              const SizedBox(height: 4),
              const Text(
                'Task 4:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task4(),
              const SizedBox(height: 4),
              const Divider(),
              const SizedBox(height: 4),
              const Text(
                'Task 5:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task5(),
              const SizedBox(height: 4),
              const Divider(),
              const SizedBox(height: 4),
              const Text(
                'Task 6:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              task6(),
            ],
          ),
        ),
      ),
    );
  }
}

// 1. Заголовок — Text, крупный жирный текст чёрного цвета, обрезается в одну строку, если не помещается.
Widget task1() {
  return const Text(
    'Заголовок — Text, крупный жирный текст чёрного цвета, обрезается водну строку, если не помещается.',
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );
}

// 2. Подпись — небольшой, нежирный курсивный текст белого цвета, обрезается в две строки.
// Also реализуйте подложку из тёмно-серого контейнера с закруглениями, чтобы текст было видно
Widget task2() {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.black54,
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Text(
      'Подпись — Text, небольшой нежирный курсивный текст белого цвета, обрезается в две строки; реализуйте подложку из тёмно-серого контейнера с закруглениями, чтобы текст было видно.',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ),
    ),
  );
}

// 3. Иконка — любая Icon на ваш вкус,
// с применением цвета и размером.
Widget task3() {
  return const Icon(
    Icons.app_registration_outlined,
    size: 40,
    color: Colors.deepPurpleAccent,
  );
}

// 4. Кнопка с иконкой избранного — большая иконка сердца красного цвета без фона.
// При нажатии пишет в консоль "Вы добавили в избранное"
Widget task4() {
  return IconButton(
    iconSize: 44,
    color: Colors.red,
    icon: const Icon(Icons.favorite),
    onPressed: () {
      debugPrint('Вы добавили в избранное');
    },
  );
}

// 5. Кнопка «Подробнее» — кнопка с текстом и обводкой, при нажатии пишет в консоль "Узнать детали"
Widget task5() {
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: Colors.grey, width: 1.5),
    ),
    onPressed: () {
      debugPrint('Узнать детали');
    },
    child: const Text('Подробнее'),
  );
}

// 6. Изображение в стиле Polaroid—  выберите любое из каталога по ссылке
// https://picsum.photos (необходим vpn), либо используйте https://flutter.dev
// Добавьте чёрную обводку, а внутри белую рамку в стиле фотографии Polaroid (https://gstatic.com)
// Для реализации используйте Container
Widget task6() {
  return Container(
    width: 200,
    height: 250,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black, width: 2),
    ),
    padding: const EdgeInsets.fromLTRB(12, 12, 12, 35),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38, width: 1),
      ),
      child: Image.network(
        'https://fastly.picsum.photos/id/1077/200/200.jpg?hmac=hiq7UCoz9ZFgr9HcMCpbnKhV-IMyOJqsQtVFyqmqohQ',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.broken_image, color: Colors.red, size: 40),
          );
        },
      ),
    ),
  );
}
