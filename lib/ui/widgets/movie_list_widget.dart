import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kueski_app/ui/blocs/pagination_view/pagination_view_bloc.dart';
import 'package:kueski_app/ui/screens/detail_screen.dart';
import 'package:kueski_app/ui/widgets/movie_card_widget.dart';

class MovieListWidget extends StatelessWidget {
  const MovieListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var paginationBloc = BlocProvider.of<PaginationViewBloc>(
      context,
      listen: false,
    );
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        double total = notification.metrics.maxScrollExtent;
        double position = notification.metrics.pixels;
        paginationBloc.scrollPosition = position;
        if (total - position < 10 &&
            paginationBloc.pageName != PageName.favorite) {
          paginationBloc.add(NearPageEndEvent());
        }
        return true;
      },
      child: BlocConsumer<PaginationViewBloc, PaginationState>(
        listenWhen: (previous, current) => current is ErrorState,
        listener: (context, state) {
          if (state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          }
        },
        buildWhen: (previous, current) => current is! ErrorState,
        builder: (context, state) {
          if (state is ListPaginationState && state.movies.isEmpty) {
            String page = paginationBloc.pageName.toString();
            page = page.split('.')[1];
            return Center(
              child: Text('There are no $page movies.'),
            );
          }
          bool extra = paginationBloc.pageName != PageName.favorite;
          return ListView.builder(
            controller: ScrollController(
              initialScrollOffset: paginationBloc.scrollPosition,
            ),
            itemCount: state.movies.length + (extra ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.movies.length) {
                return const ListTile(
                  title: LinearProgressIndicator(),
                );
              }
              return MovieCardWidget(
                movie: state.movies[index],
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(movie: state.movies[index]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
