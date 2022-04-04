import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safe_rent_house/Models/AdvInfo.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget{
  final AdvInfo advInfo;
  const DetailScreen(this.advInfo);

  @override
  State<StatefulWidget> createState() => _DetailScreen();
}

class _DetailScreen extends State<DetailScreen>{



  @override
  Widget build(BuildContext context) {

    print('image2=' + widget.advInfo.image2);

    return Scaffold(
        appBar: AppBar(title: const Text("刊登案件"),
      centerTitle: true,
      backgroundColor: Colors.green.shade800,
      automaticallyImplyLeading: true,
    ),
    resizeToAvoidBottomInset: true,
    backgroundColor: Colors.green.shade50,
    body: Container(
        child: Column(
          children: [
            const SizedBox(height: 15,),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(widget.advInfo.city, textAlign: TextAlign.center,style: const TextStyle(fontSize: 22))
                ),
                Expanded(
                  flex: 1,
                  child: Text(widget.advInfo.town , textAlign: TextAlign.center,style: const TextStyle(fontSize: 22),)
                )
            ],),
            const SizedBox(height: 15,),
            Row(
              children: [
                Expanded(flex: 2, child: Text(widget.advInfo.addr , textAlign: TextAlign.center , style: const TextStyle(fontSize: 22)))
              ],
            ),
            const SizedBox(height: 20,),
            const Divider(
              height: 20,
              thickness: 5,
            ),
            const SizedBox(height: 20,),
            Row(
              children: [
                Expanded(flex: 1, child: GestureDetector(
                  child: const Text('圖檔1',textAlign: TextAlign.center , style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue,fontSize: 22)),
                  onTap: () async {
                    String url = widget.advInfo.image1;
                    if (await canLaunch(url)) launch(url);
                  },
                )),
                Expanded(flex: 1, child: GestureDetector(
                  child: Text((widget.advInfo.image2.length == 4 ? '無圖檔' : '圖檔2'),textAlign: TextAlign.center ,
                      style: TextStyle(
                          decoration: (widget.advInfo.image2 == 'http' ? TextDecoration.none : TextDecoration.underline),
                          color: (widget.advInfo.image2 == 'http' ? Colors.black : Colors.blue) ,
                          fontSize: 22)),
                  onTap: () async {
                    String url = widget.advInfo.image2;
                    if (await canLaunch(url)) launch(url);
                  },
                ))
              ],
            ),
            const SizedBox(height: 20,),
            const Divider(
              height: 20,
              thickness: 5,
            ),
            Row(
              children: const [
                Expanded(flex: 1,
                  child: Text('房東怎麼了：',textAlign: TextAlign.center , style: TextStyle(fontSize: 20)),),
              ],
            ),
            const SizedBox(height: 20,),
            Row(
              children: [
                Expanded(flex: 1,
                  child: Text(widget.advInfo.body ,
                      textAlign: TextAlign.center , style: const TextStyle(fontSize: 18 , fontStyle: FontStyle.italic)),),
              ],
            ),
            const Divider(
              height: 20,
              thickness: 5,
            ),
            Row(
              children: [
                Expanded(flex: 1,
                  child: ListTile(
                    title: Text('刊登於 ' + widget.advInfo.CreateDate.substring(0,10)),
                    subtitle: Text('來自 ' + widget.advInfo.IP),

                  ),)
              ],

            )

          ],
        ),
    ),

    );

  }

}