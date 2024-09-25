import 'package:flutter/material.dart';
class TabBarExample extends StatelessWidget {
  const TabBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              title: const Text('TabBar Örneği'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Sekme 1'),
                  Tab(text: 'Sekme 2'),
                  Tab(text: 'Sekme 3'),
                ],
              ),
            ),
            const SizedBox(
              height: 400, // Her sekmenin içeriği için belirli bir yükseklik
              child: TabBarView(
                children: [
                  Center(child: Text('Sekme 1 İçeriği')),
                  Center(child: Text('Sekme 2 İçeriği')),
                  Center(child: Text('Sekme 3 İçeriği')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}