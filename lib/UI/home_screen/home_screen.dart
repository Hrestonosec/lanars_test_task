import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lanars_test_task/UI/home_screen/bloc/home_bloc.dart';

import 'services/pexel_api_service.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic> userData;
  const HomeScreen({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(userData['picture']['large']),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${userData['name']['first']} ${userData['name']['last']}',
            ),
            Text(
              userData['email'],
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: BlocProvider(
        create: (_) => HomeBloc(PexelsApiService())..add(PhotosLoaded()),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PhotosLoadedState) {
              return RefreshIndicator(
                  onRefresh: () async {
                    context.read<HomeBloc>().add(PhotosLoaded());
                  },
                  child: ListView.builder(
                    itemCount: state.photos.length,
                    itemBuilder: (context, index) {
                      final photo = state.photos[index];
                      return ListTile(
                        contentPadding: EdgeInsets.all(10),
                        title: Text(photo.photographer),
                        subtitle: Text(photo.alt),
                        leading: Image.network(photo.url),
                      );
                    },
                  ));
            } else if (state is HomeError) {
              return Center(child: Text(state.error));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
