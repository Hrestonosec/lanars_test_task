import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lanars_test_task/UI/home_screen/bloc/home_bloc.dart';

import 'services/pexel_api_service.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic> userData;
  final TextEditingController _searchController = TextEditingController();

  HomeScreen({Key? key, required this.userData}) : super(key: key);

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Вихід з акаунта'),
          content: Text('Ви впевнені, що хочете вийти з акаунта?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закриває діалогове вікно
              },
              child: Text('Скасувати'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закриває діалогове вікно
                Navigator.of(context)
                    .pushReplacementNamed('/login'); // Виконує вихід
              },
              child: Text(
                'Вийти',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(PexelsApiService())..add(FetchPhotosEvent()),
      child: Scaffold(
        appBar: AppBar(
          leading: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeSearchingState) {
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    context.read<HomeBloc>().add(SearchCancelled());
                  },
                );
              }
              return Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              );
            },
          ),
          title: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeSearchingState) {
                return TextField(
                  autofocus: true,
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        context.read<HomeBloc>().add(SearchPhotosEvent(''));
                        _searchController.clear();
                      },
                    ),
                  ),
                  onChanged: (value) {
                    context.read<HomeBloc>().add(SearchPhotosEvent(value));
                  },
                );
              }
              return Text('Home Screen');
            },
          ),
          actions: [
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is! HomeSearchingState) {
                  return IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      context.read<HomeBloc>().add(ToggleSearchEvent());
                    },
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          NetworkImage(userData['picture']['large']),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${userData['name']['first']} ${userData['name']['last']}',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Text(
                      userData['email'],
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () => _logout(context),
              ),
            ],
          ),
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is HomeLoadedState) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(FetchPhotosEvent());
                },
                child: ListView.builder(
                  itemCount: state.loadedPhotos.length,
                  itemBuilder: (context, index) {
                    final group = state.loadedPhotos[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Назва групи (літера) з фіксованою шириною
                          Container(
                            width: 50, // Ширина для літери
                            alignment: Alignment.topCenter,
                            child: Text(
                              group.key, // Літера групи
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          // Список фотографій у групі
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: group.value
                                  .map(
                                    (photo) => ListTile(
                                      contentPadding: EdgeInsets.all(10),
                                      title: Text(photo.photographer),
                                      subtitle: Text(photo.alt),
                                      leading: Image.network(photo.url),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else if (state is HomeSearchingState) {
              if (state.searchedPhotos.isEmpty) {
                // Якщо список порожній, відображаємо повідомлення
                return Center(
                  child: Text(
                    'Жодних даних не було знайдено',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              } else {
                // Якщо список не порожній, відображаємо його
                return ListView.builder(
                  itemCount: state.searchedPhotos.length,
                  itemBuilder: (context, index) {
                    final photo = state.searchedPhotos[index];
                    return ListTile(
                      contentPadding: EdgeInsets.all(10),
                      title: Text(photo.photographer),
                      subtitle: Text(photo.alt),
                      leading: Image.network(photo.url),
                    );
                  },
                );
              }
            } else if (state is HomeEmptyState) {
              return Center(
                child: Text(
                  'Жодних даних не було отримано',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            } else if (state is HomeErrorState) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
