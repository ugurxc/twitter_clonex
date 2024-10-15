part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}
class SendMessage extends MessageEvent {
  final ChatMessageModel message;
  final String chatId;

  const SendMessage(this.message, this.chatId);
}

class LoadMessages extends MessageEvent {
  final String chatId;

  const LoadMessages(this.chatId);
}