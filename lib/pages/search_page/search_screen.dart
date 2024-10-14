
import 'package:flutter/material.dart';
import 'package:twitter_clonex/pages/search_page/search_delegate.dart';
import 'package:user_repository/user_repository.dart';
 class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepository = FirebaseUserRepository();
    return Scaffold(
      appBar: AppBar(
        leading: const Text(""),
        title: const Text('Kullanıcı Arama'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: UserSearchDelegate([],userRepository), // Boş bir kullanıcı listesi başlangıç için
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Arama yapmak için üstteki arama ikonuna tıklayın'),
      ),
    );
  }
} 