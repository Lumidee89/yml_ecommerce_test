import 'package:yml_ecommerce_test/data/model/api_response.dart';
abstract class RepoInterface{

  /// Its fetch data related your feature
  ///don't need to specific which feature data you gonna fetch from api or server
  Future<ApiResponse> get();


  /// Its uses to add or created related feature
  ///don't need to [add] specify which feature is create
  ///just override this method and implementation you logic
  Future<ApiResponse> add(Map<String, dynamic> body);


  /// Its uses to update or edit related feature
  ///don't need to specify which feature is update
  ///just override this method and implementation you logic
  Future<ApiResponse> update(Map<String, dynamic> body);


  /// Its uses to delete or remove related feature
  ///delete all data from collection or without any parameter
  Future<ApiResponse> delete();


  /// Its uses to delete a single entity related feature
  ///
  ///delete a single item from collection using id
  Future<ApiResponse> deleteById(String id);


  /// Its uses to fetch or get a single item from a collection related feature
  ///fetch a single item from collection using id
  Future<ApiResponse> getById(String id);

}