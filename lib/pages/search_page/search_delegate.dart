import 'package:flutter/material.dart';
import 'package:twitter_clonex/pages/profile_page/user_profile_page.dart';
import 'package:user_repository/user_repository.dart';
class UserSearchDelegate extends SearchDelegate<MyUser> {
  final List<MyUser> allUsers;
  final UserRepository _userRepository;
  UserSearchDelegate(this.allUsers ,this._userRepository);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Arama sorgusunu temizler
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
   
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, MyUser.empty); // Arama ekranını kapatır
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Kullanıcıların listesi Firestore'dan gelecek
    return FutureBuilder<List<MyUser>>(
      future: _userRepository.searchUsers(query), // Firestore'da kullanıcıları arama fonksiyonu
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Sonuç bulunamadı'));
        }
        final results = snapshot.data!;
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(results[index].name),
              subtitle: Text(results[index].email),
              leading:  CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: 
              results[index].picture !=""
              ? NetworkImage(results[index].picture!)
              : const NetworkImage('https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y')
                                
                                  
                                
                              ), 
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                 return UserProfilePage(thisUser: results[index]);
                },)); // Seçilen kullanıcıyı kapatır
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Kullanıcı sorgusuna göre öneriler (sadece sonuçları göster)
    return query.isEmpty
        ? const Center(child: Text('Kullanıcı adını girin'))
        : buildResults(context);
  }
}
