import 'package:bloc/bloc.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:equatable/equatable.dart';
import 'package:message_repository/message_repository.dart';

part 'message_event.dart';
part 'message_state.dart';

/* class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final FirebaseChatRepository _messageRepository;
  MessageBloc({required FirebaseChatRepository messageRepository}) :   _messageRepository= messageRepository,super(MessageInitial()) {
    on<SendMessage>((event, emit)async {
      emit(SendMessageLoading());
      try {
        await _messageRepository.sendMessage(event.message, event.chatId);
      emit(SendMessageSuccess(event.message));
      add(LoadMessages(event.chatId));
      } catch (e) {
        emit(SendMessageFailure());
      }
     
    });
    on<LoadMessages>((event, emit)async {
      emit(LoadMessagesLoading());
      try {
          await for (final fetchedMessages in _messageRepository.getMessages(event.chatId)) {
      // Akıştan gelen mesajları ChatMessage formatına çeviriyoruz
      final messages = fetchedMessages.map((messageModel) => ChatMessage(
        text: messageModel.text,
        user: ChatUser(id: messageModel.senderId),
        createdAt: messageModel.createdAt,
      )).toList();
      
      emit(LoadMessagesSuccess(messages));
    }
  
      } catch (e) {
        emit(LoadMessagesFailure());
      }
    },);
  }
}
 */


class MessageBloc extends Bloc<MessageEvent, MessageState> {
  List<ChatMessage> currentMessages = []; 
  final FirebaseChatRepository _messageRepository;

  MessageBloc({required FirebaseChatRepository messageRepository}) 
      : _messageRepository = messageRepository,
        super(MessageInitial()) {
    on<SendMessage>((event, emit) async {
      emit(SendMessageLoading());
      try {
        // Mesajı gönderiyoruz
        await _messageRepository.sendMessage(event.message, event.chatId);
        // Gönderilen mesajı listeye ekliyoruz
        currentMessages.add(convertToChatMessage(event.message));
        emit(LoadMessagesSuccess(currentMessages));
      } catch (e) {
        emit(SendMessageFailure());
      }
    });

    on<LoadMessages>((event, emit) async {
      emit(LoadMessagesLoading());
      try {
        await for (final fetchedMessages in _messageRepository.getMessages(event.chatId)) {
          // Akıştan gelen mesajları ChatMessage formatına çeviriyoruz
          currentMessages = fetchedMessages.map(convertToChatMessage).toList();
          emit(LoadMessagesSuccess(currentMessages));
        }
      } catch (e) {
        emit(LoadMessagesFailure());
      }
    });
  }

  // ChatMessageModel'den ChatMessage'a dönüştürme fonksiyonu
  ChatMessage convertToChatMessage(ChatMessageModel messageModel) {
    return ChatMessage(
      text: messageModel.text,
      user: ChatUser(id: messageModel.senderId), // Burada senderId kullanarak kullanıcıyı oluşturuyoruz
      createdAt: messageModel.createdAt,
    );
  }
}
