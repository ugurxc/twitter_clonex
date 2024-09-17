
import 'package:flutter/material.dart';
import 'package:twitter_clonex/pages/home_page/home_screen.dart';
import 'package:twitter_clonex/pages/message_page/message_screen.dart';
import 'package:twitter_clonex/pages/notifications_page/notifications_screen.dart';
import 'package:twitter_clonex/pages/search_page/search_screen.dart';


class MobileLayout extends StatefulWidget {
  const MobileLayout({super.key});

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  final PageController _pageController = PageController();
  var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
             
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(""),
                    ),
                    Text(
                      "ugur",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text("@ugur343434",
                        style: TextStyle(
                          color: Color.fromARGB(255, 96, 96, 96),
                          fontSize: 14,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text("0 Takip edilen    0 Takipçi",
                        style: TextStyle(
                          color: Color.fromARGB(255, 96, 96, 96),
                          fontSize: 14,
                        ))
                  ],
                )),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              leading: const Icon(Icons.home),
              title: const Text('Anasayfa'),
              onTap: () {
                // Anasayfa aksiyonu
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'),
              onTap: () {
                // Ayarlar aksiyonu
              },
            ),
             ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              leading: const Icon(Icons.home),
              title: const Text('Anasayfa'),
              onTap: () {
                // Anasayfa aksiyonu
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'),
              onTap: () {
                // Ayarlar aksiyonu
              },
            ),
             ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              leading: const Icon(Icons.home),
              title: const Text('Anasayfa'),
              onTap: () {
                // Anasayfa aksiyonu
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'),
              onTap: () {
                // Ayarlar aksiyonu
              },
            ),
             ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              leading: const Icon(Icons.home),
              title: const Text('Anasayfa'),
              onTap: () {
                // Anasayfa aksiyonu
              },
            ),

          ],
        ),
      ),
        body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),

        children: const [
            HomeScreen(),
            SearchScreen(),
            NotificationsScreen(),
            MessageScreen()
        ],
      ),
     bottomNavigationBar: BottomNavigationBar(
  backgroundColor: const Color(0xFFF5F8FA),
  currentIndex: _currentIndex,
  onTap: (int index) {
    _pageController.jumpToPage(index);
    setState(() => _currentIndex = index);
  },
  type: BottomNavigationBarType.fixed,
  showSelectedLabels: false,  // Label'leri gizle
  showUnselectedLabels: false, // Seçilmeyen item label'lerini de gizle
  selectedItemColor: Colors.black, // Seçili olan item rengi
  unselectedItemColor: Colors.black.withOpacity(0.6), // Seçili olmayan itemlar için siyah
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined,), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.search_outlined), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.notifications_none_outlined), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: ''),
  ],
)

      // drawerEdgeDragWidth: MediaQuery.of(context).size.width, // Ekranın tamamını kaydırarak açma
    );
  }
}
