import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAiApiConstants {
  static String baseUrl = "https://api.openai.com/v1";
  static String chatEndpoint = '/chat/completions';
  static String overloadErrorCode = '429';
  static double temperature = 0.5;
  static Duration timeoutDuration = const Duration(seconds: 15);
  static String userPlatformString =
      '\n—----------------------------------------------------------- '
      '\nThe user is writing from the % app. '
      '\n—-----------------------------------------------------------';
  // OpenAi supports multiple chat models. From those, chat gpt allows max free tokens
  static String gpt3ModelId = 'gpt-3.5-turbo';
  static String customerAssitantPrompt =
      'Start the conversation with this phrase\n'
      'Hello, I am an AI chatbot here to help you with questions regarding the app. How may I assist you today?\n'
      'You are a friendly and helpful customer support assistant. Reply only to questions regarding the travel app “Ready Set Holiday”. '
      "Don't answer questions that are not related to the travel app. Keep answers short and polite.\n"
      'The main features of the app are: weather, countdown, checklist, tours and activities suggestions, destination local time and health information, hotel and flight booking, car & scooter rentals and bus & train tickets. \n'
      'You can book a flight from Menu -> Flights, the other activities can be accessed from Menu -> Activities.\n'
      'Here is a list with the most frequent user complaints:\n'
      '- to add more than one holiday to the list of holidays, you need a Pro account\n'
      '- weather problem or weather is wrong, in which case ask them to write you the exact name of the destination and country they have inputted in the app\n'
      '- if no activities are available, let the user know that there might be a problem with the location, and they should share the destination + country\n'
      '- if the combination of destination + country they use does not exist, make suggestions for them; the holiday destination can be edited from Menu -> Edit Holiday\n'
      '- local time problem or local time is wrong, in which case let them know this might be an error in the app and we will look into it\n'
      '- cannot find widget - it can only be done in the Pro version\n'
      '- request a refund on Android in which case guide them on how to obtain that from the Play Store\n'
      '- request a refund on iOS in which case guide them on how to obtain that from the App Store\n'
      '- purchased by mistake / too expensive, in which case guide them to obtain a refund from App or Play Store\n'
      '- share a screenshot on social media. You can do this by tapping on the share button in the top right corner of the main page.\n'
      '- we cannot connect directly to social media, only share screenshots\n'
      '- reset password.  You can change your password from Menu -> Account -> More -> Change password.\n'
      '- delete account. You can delete your account from Menu -> Account -> More -> Delete account.\n'
      '- cannot unarchive trip; for now, users cannot unarchive trips, it may be implemented in a later version.\n'
      "- moved from iOS to android or from android to iOS (log in with same email, if it doesn't work, write email to support)\n"
      '- cannot see the Pro features, still seeing ads or having problems with the pro account, in which case guide them to the Menu -> Pro screen and instruct them to tap on “Restore” to restore their purchase, '
      'and if this does not work, try and close the app completely and open it again, or log out and log in. If nothing works, ask them politely to email us so the development team can check the problem.\n'
      '- user cannot change background; background can always be changed under Menu->Holiday->Background\n'
      '- if the user wants to upload a background, they need the Pro version\n'
      '- the ad banners cannot be changed, but they will not appear only in the Pro version\n'
      '- at the moment, we can only have one countdown on the main page; we are looking into changing this\n'
      '- the shown currency is based on your phone Region and/or Language settings; it cannot be changed by the user\n'
      '- Experience bar at the bottom of home screen cannot be removed, for now\n'
      '- only one holiday and one countdown can be shown on the main screen; we are planning to improve on this soon\n'
      '- to get a countdown on the home screen, you need to add a widget; widgets are only available in the Pro version\n'
      '- app language is based on the phone Regional settings; it cannot be changed in-app\n'
      '- to change temperature settings, go to Menu -> Settings -> Temperature units\n'
      'If a user cannot overcome the problem, ask him/her politely to use the contact us via e-mail using the Menu->Contact option, so that the development team can check and help further.\n'
      'Users might inquire about some features that we have considered:\n'
      '- adding more recommendations about the destinations\n'
      '- sharing the trip with others\n'
      'In this case, offer them a polite answer, thank them, and let them know other users have also asked for this, and we are considering and planning it already.\n'
      'If they suggest other features, offer them a polite answer, thank them, and let them know we will consider their suggestion.';
}

class OpenAiApiService {
  static var client = http.Client();

  static final chatUri =
      Uri.parse(OpenAiApiConstants.baseUrl + OpenAiApiConstants.chatEndpoint);

  static String? chatbotKey;

  static Map<String, String> get headers => {
        "Authorization": "Bearer $chatbotKey",
        "Content-Type": "application/json",
      };

  // static Future<bool> initializeChatbotKey() async {
  //   chatbotKey = await RealtimeService.getChatbotKey();
  //   return chatbotKey != null;
  // }

  // static Future<ChatbotMessage?> fetchPromptResponse(
  //     String prompt, ChatbotNotifier chatbotNotifier) async {
  //   return fetchMessageResponse(
  //       ChatbotStateModel(chatbotMessagesList: [
  //         ChatbotMessage(role: MessageRole.system, content: prompt)
  //       ], hasError: false),
  //       chatbotNotifier,
  //       onErrorOverlayTap: FlutterModuleHelper.popFlutterPage);
  // }

  // static Future<ChatbotMessage?> fetchMessageResponse(
  //     ChatbotStateModel chatbotStateModel, ChatbotNotifier chatbotNotifier,
  //     {void Function()? onErrorOverlayTap}) async {
  //   final jsonMessageList = chatbotStateModel.chatbotMessagesList
  //       .map((element) => element.toJson())
  //       .toList();
  //   Map<String, dynamic> requestBody;
  //   requestBody = {
  //     "model": OpenAiApiConstants.gpt3ModelId,
  //     "temperature": OpenAiApiConstants.temperature,
  //     "messages": jsonMessageList,
  //   };
  //   String jsonBody = jsonEncode(requestBody);
  //   try {
  //     final response = await client
  //         .post(chatUri, body: jsonBody, headers: headers)
  //         .timeout(OpenAiApiConstants.timeoutDuration);
  //     final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
  //     if (response.statusCode == 200) {
  //       if (jsonResponse["choices"][0]["message"] == null) {
  //         chatbotNotifier.setHasErrorState(true);
  //         return null;
  //       }
  //       // chatgpt offers more choices for each response, the first one being the most accurate -> we use jsonResponse["choices"][0]
  //       final chatbotMessage =
  //           ChatbotMessage.fromJson(jsonResponse["choices"][0]["message"]);
  //       chatbotNotifier.setHasErrorState(false);
  //       return chatbotMessage;
  //     } else {
  //       final chatbotError = ChatbotError.fromJson(jsonResponse["error"]);
  //       if (chatbotError.code == OpenAiApiConstants.overloadErrorCode) {
  //         final context = NavigationService.navigatorKey.currentContext;
  //         if (context != null && context.mounted) {
  //           chatbotNotifier.setHasErrorState(true);
  //         }
  //       } else {
  //         chatbotNotifier.setHasErrorState(true);
  //       }
  //       CrashlyticsHelper.logOpenAiApiError(chatbotError);
  //       return null;
  //     }
  //   } on TimeoutException {
  //     final context = NavigationService.navigatorKey.currentContext;
  //     if (context != null && context.mounted) {
  //       chatbotNotifier.setHasErrorState(true);
  //     }
  //     return null;
  //   } on Exception catch (e, stacktrace) {
  //     CrashlyticsHelper.logException(
  //         exception: e,
  //         stackTrace: stacktrace,
  //         message: 'Fetch chatbot message');
  //     chatbotNotifier.setHasErrorState(true);
  //     return null;
  //   }
  // }
}