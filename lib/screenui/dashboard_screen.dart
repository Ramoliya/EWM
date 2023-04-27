import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:ewm/employeeModel.dart';
import 'package:ewm/utils/colors_app.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/constant_class.dart';


// this is dashboard and here we retrieve the csv file and identifies the pair of employees who have worked together on common projects for the longest period of time
class DashboardScreen extends StatefulWidget{
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();

}

class _DashboardScreenState extends State<DashboardScreen>{

  var isAPICall = false;

  var employeeData;
  var loadDAta;

  List<employeeModel> arrEmployee = [];
  List<employeeModel> arrEmployeePair = [];

  List<PlatformFile>? pickedFile;
  FilePickerResult? pickedFile2;

  // this is dashboard screen ui and here we design ui of employee list
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorsApp.colorWhite,

      appBar: AppBar(
        title: Text('EWM'),
        centerTitle: true,

        actions: [

          InkWell(
            onTap: (){
              selectFileFromStorage();
            },

            child: Container(
              margin: EdgeInsets.only(right: 10),

                child: Icon(Icons.add, size: 30,)
            ),
          )
        ],
      ),

      body: Stack(
        children: [

          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 10, bottom: 10),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  arrEmployee != null && arrEmployee.length > 0
                      ?
                  Column(
                    children: [

                      const SizedBox(height: 20,),

                      Text('Input CSV File',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),

                      const SizedBox(height: 20,),

                      Container(
                        padding: EdgeInsets.only(top:5, bottom:5),

                        child: Row(

                          children: [

                            Container(
                              width: MediaQuery.of(context).size.width * 0.15,

                              child: Text("EmpID",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),

                            Container(
                              width: MediaQuery.of(context).size.width * 0.15,

                              child: Text("ProjectID",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold
                                ),),
                            ),

                            Container(
                              width: MediaQuery.of(context).size.width * 0.25,

                              child: Text("DateFrom",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),

                            Container(
                              width: MediaQuery.of(context).size.width * 0.25,

                              child: Text("DateTo",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),

                            Container(
                              width: MediaQuery.of(context).size.width * 0.20 - 10,

                              child: Text("Duration",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        children: [

                          // input csv file list in which store all employee list
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: arrEmployee.length, itemBuilder: (_, index) {

                            return Row(

                              children: [
                                Container(width: MediaQuery.of(context).size.width * 0.15, padding: EdgeInsets.only(top: 2, bottom: 2), child: Text(arrEmployee[index].EmpID.toString())),
                                Container(width: MediaQuery.of(context).size.width * 0.15, padding: EdgeInsets.only(top: 2, bottom: 2), child: Text(arrEmployee[index].ProjectID.toString())),
                                Container(width: MediaQuery.of(context).size.width * 0.25, padding: EdgeInsets.only(top: 2, bottom: 2), child: Text(arrEmployee[index].DateFrom.toString())),
                                Container(width: MediaQuery.of(context).size.width * 0.25, padding: EdgeInsets.only(top: 2, bottom: 2), child: Text(arrEmployee[index].DateTo.toString())),
                                Container(width: MediaQuery.of(context).size.width * 0.20 - 10, padding: EdgeInsets.only(top: 2, bottom: 2), child: Text(arrEmployee[index].Duration.toString())),
                              ],
                            );
                          }),

                          const SizedBox(height: 20,),

                          Text('Output CSV File',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),

                          const SizedBox(height: 20,),

                          Container(
                            padding: EdgeInsets.only(top:5, bottom:5,left: 10),

                            child: Row(

                              children: [

                                Container(
                                  width: MediaQuery.of(context).size.width * 0.25,

                                  child: Text("Emp 1",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),

                                Container(
                                  width: MediaQuery.of(context).size.width * 0.25,

                                  child: Text("Emp 2",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                    ),),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.25,

                                  child: Text("ProjectID",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                    ),),
                                ),

                                Container(
                                  width: MediaQuery.of(context).size.width * 0.25-20,

                                  child: Text("Duration",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // output csv file list in which the pair of employees who have worked together on common projects for the longest period of time
                          Container(
                            padding: EdgeInsets.only(left: 10),

                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: arrEmployeePair.length, itemBuilder: (_, index) {

                              return arrEmployeePair[index].EmpID != arrEmployeePair[index].EmpID2 ? Row(
                                children: [
                                  Container(width: MediaQuery.of(context).size.width * 0.25, padding: EdgeInsets.only(top: 2, bottom: 2), child: Text(arrEmployeePair[index].EmpID.toString())),
                                  Container(width: MediaQuery.of(context).size.width * 0.25, padding: EdgeInsets.only(top: 2, bottom: 2), child: Text(arrEmployeePair[index].EmpID2.toString())),
                                  Container(width: MediaQuery.of(context).size.width * 0.25, padding: EdgeInsets.only(top: 2, bottom: 2), child: Text(arrEmployeePair[index].ProjectID.toString())),
                                  Container(width: MediaQuery.of(context).size.width * 0.25-20 , padding: EdgeInsets.only(top: 2, bottom: 2), child: Text(arrEmployeePair[index].Duration.toString())),
                                ],
                              )
                                  :
                              const SizedBox();
                            }),
                          ),
                        ],
                      ),
                    ],
                  )
                      :
                  const SizedBox()
                ],
              ),
            ),
          ),

          isAPICall ? ConstantClass.apiLoadingAnimation(context) : const SizedBox()
        ],
      ),
    );
  }

  // select file from storage
  void selectFileFromStorage() async {

    try {

      pickedFile = (await FilePicker.platform.pickFiles(type: FileType.custom, allowMultiple: false, allowedExtensions: ['csv']))?.files;

    } catch (ex) {

      // error when retrieve csv file from storage
      ConstantClass.ToastMessage("Error:- " + ex.toString());

    }

    if (pickedFile == null){
      // return process if picked file from storage is null or not valid
      return;
    }

    setState(() {
      // csv file retrieve successfully than open selected csv file
      openFile(pickedFile![0].path);
    });

  }

  // open csv file for read data
  openFile(filepath) async
  {

    try{

      // start progress bar
      setState(() {
        isAPICall = true;
      });

      var isValid=false;

      File f = File(filepath);

      // read csv file
      final input = f.openRead();

      if(input.toString().isNotEmpty){

        // convert csv file to list
        employeeData = await input.transform(utf8.decoder).transform(CsvToListConverter(eol: "\n")).toList();

        arrEmployee.clear();
        arrEmployeePair.clear();

        for(var i in employeeData){
          setState(() {

            // check file format is valid or not
            if(i[0]=='EmpID' && i[1] == "ProjectID" && i[2] == "DateFrom" && i[3] == "DateTo") {

              isValid = true;

            }else{

              if(isValid==true) {

                DateTime dateFrom = DateTime.parse(i[2]);

                // check whether dateTo is null or not and if null than add current date
                DateTime dateTo = DateTime.parse(i[3].toString() != "NULL" && i[3].toString() != "" ? i[3].toString() : DateTime.now().toString());

                final difference = dateTo.difference(dateFrom).inDays;

                // store all employee record to list
                arrEmployee.add(employeeModel(i[0],i[0], i[1], i[2], i[3], difference));

                // find index of common project id from pair employee array
                var tmp_pair_ind = arrEmployeePair?.indexWhere((element) => element.ProjectID==i[1]);

                if(tmp_pair_ind! >= 0) {

                  // update pair employee record to list and store maximum duration
                  var tmp_duration= arrEmployeePair[tmp_pair_ind].Duration > difference ?  arrEmployeePair[tmp_pair_ind].Duration : difference;
                  arrEmployeePair[tmp_pair_ind].EmpID2=i[0];
                  arrEmployeePair[tmp_pair_ind].Duration=tmp_duration;

                } else {

                  // store pair employee record to list
                  arrEmployeePair.add(employeeModel(i[0],i[0], i[1], i[2], i[3], difference));
                }

                // descending order of list according to duration of project
                arrEmployeePair.sort((a, b) => b.Duration.compareTo(a.Duration));
              }
            }
          });
        }

        // finish progress bar
        setState(() {
          isAPICall = false;
        });

      }else{

        // finish progress bar
        setState(() {
          isAPICall = false;
        });

        // toast message for file format is invalid
        ConstantClass.ToastMessage("CSV File Format is invalid.");
      }
    }catch(e){

      // finish progress bar
      setState(() {
        isAPICall = false;
      });

      // toast message for error in reading csv file
      ConstantClass.ToastMessage("Reading csv file error:- " + e.toString());
    }
  }
}