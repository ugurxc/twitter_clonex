/* part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();
  
  @override
  List<Object> get props => [];
}



class MessageInitial extends MessageState {}

class LoadMessagesLoading extends MessageState {}

essagesFailure extends MessageState {}

class SendMessageLoading extends MessageState {}

class SendMessageSuccess extends MessageState {
  final ChatMessageModel message;

  const SendMessageSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class SendMessageFailure extends MessageState {} */