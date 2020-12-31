import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tesi_simone_zanin_140833/PersistentData.dart';

class PictureSummaryCard extends StatelessWidget {

  final ScrollController scroller = ScrollController();
  final PictureRecord record;

  PictureSummaryCard(this.record);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8,),
        Expanded(
          child: Card(
            elevation: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      children: record.getChipTags(),
                      spacing: 5.0,
                    )
                ),
                Expanded(
                  child: Scrollbar(
                    isAlwaysShown: true,
                    controller: scroller,
                    thickness: 10,
                    child: SingleChildScrollView(
                      controller: scroller,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          child: record.getTextDescription(),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Align(
                          child: Text("LAT: ${record.getLatitude()}, LON: ${record.getLongitude()}"),
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: FutureBuilder(
                          future: context.watch<DatabaseInterface>().getByPath(record.getFilePath()),
                          builder: (ctx, snap) {
                            Icon ico = Icon(Icons.cloud, color: Colors.grey, key: UniqueKey(),);
                            if (snap.hasData) {
                              if (snap.data.uploadedTo != null && snap.data.uploadedTo.isNotEmpty) {
                                ico = Icon(Icons.cloud_done, color: Colors.green, key: UniqueKey(),);
                              } else {
                                ico = Icon(Icons.cloud_upload, color: Colors.orangeAccent, key: UniqueKey(),);
                              }
                            }
                            return Hero(
                              tag: "status-icon_${record.getFilePath()}",
                              child: AnimatedSwitcher(
                                child: ico,
                                duration: Duration(milliseconds: 200),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}