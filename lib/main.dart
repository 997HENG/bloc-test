import 'package:bloc_testing/views/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.amber[300]),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ),
  );
}

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Home Page',
//           style: TextStyle(
//             color: Colors.grey[600],
//           ),
//         ),
//         backgroundColor: Theme.of(context).primaryColor,
//       ),
//     );
//   }
// }


// void main() {
//   runApp(
//     MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(primaryColor: Colors.amber[300]),
//       debugShowCheckedModeBanner: false,
//       home: const HomePage(),
//     ),
//   );
// }
