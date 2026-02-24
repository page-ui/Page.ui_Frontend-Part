part of 'email_verfication_cubit.dart';

@immutable
sealed class EmailVerficationState {}

final class EmailVerficationInitial extends EmailVerficationState {}

final class EmailVerficationFailure extends EmailVerficationState {
  final String message;

  EmailVerficationFailure({required this.message});
}

final class EmailVerficationLoading extends EmailVerficationState {}

final class EmailVerficationSuccess extends EmailVerficationState {}

final class ResendTheCodeSuccess extends EmailVerficationState {}
