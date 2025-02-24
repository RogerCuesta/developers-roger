import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/movie_detail/bloc/movie_info_cubit.dart';
import 'package:movie_app/movie_detail/bloc/movie_info_state.dart';
import 'package:movie_app/movie_detail/widgets/movie_detail_appbar.dart';
import 'package:movie_app/movie_detail/widgets/movie_detail_info.dart';
import 'package:movie_app/movie_home/bloc/movies_bloc.dart';
import 'package:movie_app/movie_home/bloc/movies_event.dart';
import 'package:movie_app/repositories/movies_repository.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;
  const MovieDetailPage({super.key, required this.movieId});
  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieInfoCubit(
        theMovieDbRepository:
            RepositoryProvider.of<TheMovieDbRepository>(context),
      )..getMovieInfo(widget.movieId),
      child: BlocBuilder<MovieInfoCubit, MovieInfoState>(
        builder: (context, state) {
          switch (state.movieInfoLoadStatus) {
            case MovieInfoLoadStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case MovieInfoLoadStatus.succeeded:
              return Scaffold(
                body: CustomScrollView(
                  key: const Key('movieDetailScrollView'),
                  slivers: [
                    MovieDetailAppBar(
                      movieInfo: state.movieInfo!,
                    ),
                    MovieDetailInfo(
                      movieInfo: state.movieInfo!,
                    ),
                  ],
                ),
              );
            case MovieInfoLoadStatus.failed:
              return const ErrorView();
          }
        },
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text('Failed to fetch movies'),
        ),
        MaterialButton(
            child: const Icon(
              Icons.replay_circle_filled_rounded,
            ),
            onPressed: () {
              context.read<MoviesBloc>().add(
                    GetPopularMovies(),
                  );
            }),
      ],
    );
  }
}
