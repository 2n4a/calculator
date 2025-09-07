# openapi.model.CalculationError

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**result** | **String** | Статус ответа, всегда 'error'. | [optional] [default to 'error']
**kind** | **String** | Тип ошибки, всегда 'CalculationError'. | [optional] [default to 'CalculationError']
**message** | **String** | Описание ошибки, человеко-читаемое. | 
**span** | [**Span**](Span.md) |  | [optional] 
**operatorSpan** | [**Span**](Span.md) |  | [optional] 
**operands** | [**BuiltList&lt;OperandMeta&gt;**](OperandMeta.md) |  | [optional] 
**parenthesized** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


