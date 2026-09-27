import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[200], // Светло-серый фон экрана (body)
        body: Center( // Центрируем нашу карточку на экране
          child: Container(
            width: 250,  // Ширина карточки
            height: 350, // Высота карточки
            padding: const EdgeInsets.all(20), // Внутренние отступы макета
            decoration: BoxDecoration(
              color: Colors.white, // Белый фон самой карточки
              borderRadius: BorderRadius.circular(20), // Красивые скругленные углы
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // Легкая тень для объема
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column( // Вертикальный список элементов (матрешка)
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. Наша круглая аватарка (Image внутри Container)
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Простой способ сделать контейнер круглым!
                    border: Border.all(color: Colors.blueAccent, width: 3), // Синий ободок
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/Pusher II.jpeg', // Ваша рабочая локальная картинка
                    fit: BoxFit.cover,
                  ),
                ),
                
                const SizedBox(height: 25), // Невидимый пустой отступ (SizedBox)
                
                // 2. Имя пользователя (Text с красивым стилем из урока)
                const Text(
                  'Богдан',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // 3. Статус или профессия
                Text(
                  'Flutter Разработчик',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
