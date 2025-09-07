# openapi.api.DefaultApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**calculateCalculatePost**](DefaultApi.md#calculatecalculatepost) | **POST** /calculate | Вычисление значения и сохранение в историю
[**historyHistoryGet**](DefaultApi.md#historyhistoryget) | **GET** /history | Получение истории вычислений
[**livenessLivenessGet**](DefaultApi.md#livenesslivenessget) | **GET** /liveness | Проверка состояния сервиса


# **calculateCalculatePost**
> CalculationSuccess calculateCalculatePost(calculationRequest)

Вычисление значения и сохранение в историю

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final CalculationRequest calculationRequest = ; // CalculationRequest | 

try {
    final response = api.calculateCalculatePost(calculationRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->calculateCalculatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **calculationRequest** | [**CalculationRequest**](CalculationRequest.md)|  | 

### Return type

[**CalculationSuccess**](CalculationSuccess.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **historyHistoryGet**
> BuiltList<HistoryItem> historyHistoryGet(limit, offset, order, fromTimestamp, toTimestamp)

Получение истории вычислений

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();
final int limit = 56; // int | Максимальное количество элементов в ответе.
final int offset = 56; // int | Смещение от начала истории.
final String order = order_example; // String | Порядок сортировки: 'asc' - по возрастанию, 'desc' - по убыванию.
final DateTime fromTimestamp = 2013-10-20T19:20:30+01:00; // DateTime | Начальная временная метка для фильтрации истории (включительно).
final DateTime toTimestamp = 2013-10-20T19:20:30+01:00; // DateTime | Конечная временная метка для фильтрации истории (исключительно).

try {
    final response = api.historyHistoryGet(limit, offset, order, fromTimestamp, toTimestamp);
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->historyHistoryGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Максимальное количество элементов в ответе. | [optional] [default to 25]
 **offset** | **int**| Смещение от начала истории. | [optional] [default to 0]
 **order** | **String**| Порядок сортировки: 'asc' - по возрастанию, 'desc' - по убыванию. | [optional] [default to 'desc']
 **fromTimestamp** | **DateTime**| Начальная временная метка для фильтрации истории (включительно). | [optional] 
 **toTimestamp** | **DateTime**| Конечная временная метка для фильтрации истории (исключительно). | [optional] 

### Return type

[**BuiltList&lt;HistoryItem&gt;**](HistoryItem.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **livenessLivenessGet**
> JsonObject livenessLivenessGet()

Проверка состояния сервиса

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getDefaultApi();

try {
    final response = api.livenessLivenessGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling DefaultApi->livenessLivenessGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

