import 'package:flutter/material.dart';
import 'package:news_retry_app/bloc/get_sources_bloc.dart';
import 'package:news_retry_app/elements/error_element.dart';
import 'package:news_retry_app/elements/loader_element.dart';
import 'package:news_retry_app/models/source_model.dart';
import 'package:news_retry_app/models/source_response.dart';

class TopChannelsWidget extends StatefulWidget {
  @override
  _TopChannelsWidgetState createState() => _TopChannelsWidgetState();
}

class _TopChannelsWidgetState extends State<TopChannelsWidget> {
  @override
  void initState() {
    super.initState();
    getSourcesBloc.getSources();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SourceResponse>(
      stream: getSourcesBloc.subject.stream,
      builder: (context, AsyncSnapshot<SourceResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return buildErrorWidget(snapshot.data.error);
          }
          return buildTopChannels(snapshot.data);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.data.error);
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Container buildTopChannels(SourceResponse data) {
    List<Source> sources = data.sources;
    Size size = MediaQuery.of(context).size;
    if (sources.length == 0) {
      return Container(
        width: size.width,
        child: Column(
          children: [
            Text("No Sources"),
          ],
        ),
      );
    } else {
      return Container(
        height: 135.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.only(top: 10),
              width: 80,
              child: buildChannelWidget(sources[index]),
            );
          },
          itemCount: sources.length,
        ),
      );
    }
  }

  GestureDetector buildChannelWidget(Source source) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: source.id,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(1, 1),
                  )
                ],
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/ch_icon.PNG"),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            source.name,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 10,
                height: 1.4,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 3,
          ),
          // category Name
          Text(
            source.category,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          )
        ],
      ),
    );
  }
}
