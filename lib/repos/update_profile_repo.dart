import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music/utils/common.dart';


class UpdateProfileRepo {
  Dio dio = Dio();
  Future<dynamic> updateProfile({FormData? data,String header='',}) async {

    print("***********Data: $data***************8");
    print("***********Header: $header***************8");


    try {
      dio.options.headers= {
        'Authorization': header,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      Response respose = await dio.post(
          generateUrl('update-profile').toString(),
           data: data,
      );
      if (respose.statusCode == 200) {
        print("Error:${respose.data}");
        Fluttertoast.showToast(msg: respose.data['message']);
        // if(respose.data['data']['status']==true)
        // {
        //   return respose;
        // }
        // else
        // {
        //   return respose;
        // }
        return respose;

      } else {
        throw Exception("Error while fetching data");
      }
    } catch (e) {
      print(e);
      print("**********Not Fetched...*********");
    }
  }
}
