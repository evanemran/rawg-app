import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rawg_app/domain/models/games.dart';
import 'package:rawg_app/presentation/providers/games_provider.dart';

class GamesList extends ConsumerWidget{

  final int page;

  const GamesList(this.page, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamesAsync = ref.watch(gamesProvider(0));

    return gamesAsync.when(
        data: (games) {
          if (games.isEmpty) {
            return const Center(child: Text('No Games Found!'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(gamesProvider(0).future),
            child: GridView.builder(
              itemCount: games.length,
              padding: EdgeInsets.all(8),
              // shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // maxCrossAxisExtent: 200,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                childAspectRatio: 1.25, crossAxisCount: 1
              ),
              itemBuilder: (context, index) {
                return _GamesCard(game: games[index]);
              },
            ),
          );
        },
        error: (error, _) => RefreshIndicator(
          onRefresh: () async => ref.refresh(gamesProvider(0).future),
          child: ListView(
            children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'Failed to load news.\n$error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}

class _GamesCard extends StatelessWidget {

  final Games game;

  const _GamesCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(game.backgroundImage.toString(), height: MediaQuery.of(context).size.width/2, width: double.maxFinite, fit: BoxFit.cover,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(game.name.toString(), style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold), maxLines: 2,),
            )
          ],
        ),
      ),
    );
  }
}
