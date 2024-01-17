part of 'sungai_bloc.dart';

sealed class SungaiBlocEvent extends Equatable {
  const SungaiBlocEvent();

  @override
  List<Object> get props => [];
}

class GetListSungai extends SungaiBlocEvent {
  const GetListSungai();
}

class GetDataSungai extends SungaiBlocEvent {
  const GetDataSungai({String? idSungai})
      : _idSungai = idSungai ?? 'axBPVZsdXUAjFyWOlXnt';

  // ignore: unused_field
  final String _idSungai;
}

class GetDataRealtimeSensor extends SungaiBlocEvent {
  const GetDataRealtimeSensor(this.id);

  final String id;
}

class UpdateDataRealtimeSensor extends SungaiBlocEvent {
  const UpdateDataRealtimeSensor({required this.data});

  final DataSensorNew data;
}

class GetDataHistorySensor extends SungaiBlocEvent {
  const GetDataHistorySensor(this.id, this.date);

  final String id;
  final String date;
}
