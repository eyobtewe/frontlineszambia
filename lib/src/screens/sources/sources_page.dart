import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../external_src/random_color/random_color.dart';
import '../../bloc/apis_provider.dart';
import '../../domain/schemas/schema.dart';
import '../../helpers/theme_provider.dart';
import '../widgets/widgets.dart';
import 'article_sources_based.dart';

class SourcesPage extends StatefulWidget {
  const SourcesPage({Key? key}) : super(key: key);

  @override
  _SourcesPageState createState() => _SourcesPageState();
}

class _SourcesPageState extends State<SourcesPage> {
  late ApisBloc bloc;
  late Size size;

  @override
  Widget build(BuildContext context) {
    bloc = ApisProvider.of(context);
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        title: const Text('News Sources'),
      ),
      bottomNavigationBar: const BottomBar(index: 2),
      body: FutureBuilder(
        future: bloc.getNewsSources(),
        initialData: bloc.newsSources,
        builder: (_, AsyncSnapshot<List<NewsSource>?> snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container();
          } else {
            return buildSources(snapshot.data!, context);
          }
        },
      ),
    );
  }

  Widget buildSources(List<dynamic> categories, BuildContext context) {
    RandomColor _randomColor = RandomColor();

    bool isDark = Provider.of<ThemeNotifier>(context).darkTheme;
    List<Color> backgroundColors = _randomColor.randomColors(
      count: categories.length,
      colorBrightness: isDark ? ColorBrightness.dark : ColorBrightness.light,
      colorSaturation: ColorSaturation.monochrome,
    );

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        return buildSourceCard(context, categories, index, backgroundColors);
      },
    );
  }

  InkWell buildSourceCard(BuildContext context, List<dynamic> categories,
      int index, List<Color> backgroundColors) {
    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return ArticleSourcesBased(newsSource: categories[index].name);
            },
          ),
        );
      },
      child: Card(
        color: backgroundColors[index],
        child: ClipRRect(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        categories[index].name,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
