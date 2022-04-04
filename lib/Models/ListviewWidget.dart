import 'package:flutter/material.dart';
import 'package:safe_rent_house/Models/AdvInfo.dart';
import 'AdvHelper.dart';
import 'DataOperator.dart';
import 'LoginHelper.dart';
import 'package:safe_rent_house/detail.dart';

class SearchResultList extends StatefulWidget {
  final List<AdvInfo> dataList;
  final bool isRetrieve;

  SearchResultList(this.dataList , this.isRetrieve);
  // SearchResultList({ Key key, required text}) : super(key: key);

  @override
  _SearchResultList createState() => _SearchResultList();
}

class _SearchResultList extends State<SearchResultList> {

  @override
  Widget build(BuildContext context) {
    double dHeight = MediaQuery.of(context).size.height;
    String dateStr;
    print('count=' + widget.dataList.length.toString());
    if(widget.isRetrieve && widget.dataList.length == 0){
      return Flexible(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: dHeight - 320,),
          child: const Text('還沒爆料~搶先刊登' , style: TextStyle(fontSize: 20),)
        )
      );
    }

    return Flexible(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: dHeight - 320,),
      child:ListView.builder(
          // scrollDirection: Axis.vertical,
          itemCount: widget.dataList.length,
          itemBuilder: (BuildContext context,int index) {
            dateStr = widget.dataList[index].CreateDate.substring(0, 10);
            // print('rowcount=' + widget.dataList.length.toString());

            return  Card(
                child:ListTile(
                    title: Text(widget.dataList[index].addr),
                    subtitle: Text(dateStr),
                    leading: Text((index + 1).toString() , style: const TextStyle(fontSize: 24),),
                    trailing: Text('看更多' , style: TextStyle(color: Colors.green.shade800,fontSize: 16),),
                  onTap: () async {
                      print('click' + widget.dataList[index].Id.toString());
                      const SizedBox(child: Center(child: CircularProgressIndicator(),),height: 20,width: 20,);

                      String access = '';
                      String refresh = DataOperator.readData('refresh');
                      await doRefresh(refresh).then((value) {
                        access = value.access;
                        DataOperator.saveData('access', 'value.access');
                      });

                      await doAdvDetail(widget.dataList[index].Id.toString(),access).then((value) {
                        print(value.IP);

                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DetailScreen(value)));


                      });

                  },

                )
            );

            // return ListTile(
            //     trailing: const Text("更多", style: TextStyle(color: Colors.green,fontSize: 18),),
            //     title:Text(widget.dataList[index].addr + ' ' + dateStr + ' 刊登')
            // );
            // }, separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.grey,thickness: 1,),
          }
      ),
    )
    );
  }
}