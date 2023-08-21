import 'package:buyer/features/cart/data/models/cart_model.dart';
import 'package:buyer/features/cart/presentation/pages/cart_screen.dart';
import 'package:buyer/features/category/presentation/pages/category_screen.dart';
import 'package:buyer/features/favarate/presentation/pages/favarate_screen.dart';
import 'package:buyer/features/groups/presentation/pages/group_cart_screen.dart';
import 'package:buyer/features/groups/presentation/pages/group_chat_screen.dart';
import 'package:buyer/features/groups/presentation/pages/group_info_screen.dart';
import 'package:buyer/features/groups/presentation/pages/group_join_screen.dart';
import 'package:buyer/features/groups/presentation/pages/group_members_screen.dart';
import 'package:buyer/features/groups/presentation/pages/group_qr_code_generator.dart';
import 'package:buyer/features/groups/presentation/pages/groups_screen.dart';
import 'package:buyer/features/introduction/presentation/pages/introduction_screen.dart';
import 'package:buyer/features/list_products/presentation/pages/list_products_screen.dart';
import 'package:buyer/features/login/presentation/widgets/textfields_login.dart';
import 'package:buyer/features/main_page_navigator.dart';
import 'package:buyer/features/order_history/data/models/order_model.dart';
import 'package:buyer/features/order_history/persentation/pages/order_process_screen.dart';
import 'package:buyer/features/order_history/persentation/pages/order_review_screen.dart';
import 'package:buyer/features/order_history/persentation/pages/order_status_screen.dart';
import 'package:buyer/features/order_history/persentation/pages/orders_history_list_screen.dart';
import 'package:buyer/features/order_history/persentation/pages/select_order_products_screen.dart';
import 'package:buyer/features/product_details/presentation/pages/product_details_screen.dart';
import 'package:buyer/features/sign_up/presentation/pages/sign_up_data_collection_screen.dart';
import 'package:buyer/features/sign_up/presentation/pages/sign_up_screen.dart';
import 'package:buyer/l10n/select_language_screen.dart';
import 'package:buyer/utilities/drawer/about_screen.dart';
import 'package:buyer/utilities/drawer/coin_screen.dart';
import 'package:buyer/utilities/drawer/profile_screen.dart';
import 'package:flutter/material.dart';

import 'package:buyer/features/Home/presentation/pages/home_screen.dart';

class AppRoute {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        {
          return MaterialPageRoute(
              builder: (_) =>
                  HomeScreen(argument: settings.arguments.toString()));
        }
      case '/login':

        //for login Screen
        return MaterialPageRoute(builder: (_) => TextFieldLogin());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case '/selectLanguageScreen':
        return MaterialPageRoute(builder: (_) => SelectLanguageScreen());
      case '/introductionScreen':
        return MaterialPageRoute(builder: (_) => IntroductionScreen());
      case '/mainPageNavigator':
        {
//here we will send user Id
          return MaterialPageRoute(
              builder: (_) => MainPageNavigator(
                    argument: settings.arguments,
                  ));
        }
      case '/signupDataCollectionScreen':
        {
          //here we will send Gmail Id and User Id

          return MaterialPageRoute(
            builder: (_) => SignupDataCollectionScreen(
                userdata: settings.arguments as Map<String, String>),
          );
        }
      case '/homeScreen':
        {
          return MaterialPageRoute(
              builder: (_) =>
                  HomeScreen(argument: settings.arguments.toString()));
        }
      case '/categoryScreen':
        {
          return MaterialPageRoute(
              builder: (_) => CategoryScreen(
                  argument: settings.arguments as Map<String, String>));
        }
      case '/listProductsScreen':
        {
          //here we should send navigate and argument

          return MaterialPageRoute(
              builder: (_) => ListProductsScreen(
                  argument: settings.arguments as Map<String, String>));
        }
      case '/productDetailsScreen':
        {
          //here we should send productId and productCate

          return MaterialPageRoute(
              builder: (_) => ProductDetailsScreen(
                  argument: settings.arguments as Map<String, String>));
        }
      case '/cartScreen':
        return MaterialPageRoute(builder: (_) => CartScreen());
      case '/favarateScreen':
        return MaterialPageRoute(builder: (_) => FavarateScreen());
      case '/orderHistoryListScreen':
        {
          //here we should send _isGroupHistoryOrder , groupId

          return MaterialPageRoute(
              builder: (_) => OrderHistoryListScreen(
                  argument: settings.arguments as Map<String, dynamic>));
        }
      case '/orderProcessScreen':
        {
          //here we should send List<CartModel> and isGroup

          return MaterialPageRoute(
              builder: (_) => OrderProcessScreen(
                  argument: settings.arguments as Map<String, dynamic>));
        }
      case '/orderStatusScreen':
        {
          //here we should send OrderModel

          return MaterialPageRoute(
              builder: (_) => OrderStatusScreen(
                  argument: settings.arguments as OrderModel));
        }
      case '/orderReviewScreen':
        {
          //here we should send CartModel

          return MaterialPageRoute(
              builder: (_) =>
                  OrderReviewScreen(argument: settings.arguments as CartModel));
        }
      case '/selectOrderProductsScreen':
        {
          // here we should send List<CartModel>

          return MaterialPageRoute(
              builder: (_) => SelectOrderProductsScreen(
                  argument: settings.arguments as List<CartModel>));
        }
      case '/profileScreen':
        {
          // here we should send List<CartModel>

          return MaterialPageRoute(
              builder: (_) => ProfileScreen(
                  argument: settings.arguments as Map<String, dynamic>));
        }
      case '/coinScreen':
        {
          // here we should send List<CartModel>

          return MaterialPageRoute(
              builder: (_) => CoinScreen(
                  argument: settings.arguments as Map<String, dynamic>));
        }
      case '/aboutScreen':
        return MaterialPageRoute(builder: (_) => AboutScreen());

      case '/groupScreen':
        return MaterialPageRoute(builder: (_) => GroupScreen());

      case '/groupChatScreen':
        {
          //here we should send groupId

          return MaterialPageRoute(
              builder: (_) => GroupChatScreen(
                    argument: settings.arguments,
                  ));
        }

      case '/groupInfoScreen':
        {
          //here we should send group name

          return MaterialPageRoute(
              builder: (_) => GroupInfoScreen(
                    argument: settings.arguments,
                  ));
        }
      case '/groupJoinScreen':
        {
          //here we should send user Id

          return MaterialPageRoute(
              builder: (_) => GroupJoinScreen(
                    argument: settings.arguments,
                  ));
        }
      case '/groupQrCodeGenarator':
        {
          // here we should send groupId ,group name

          return MaterialPageRoute(
              builder: (_) => GroupQrCodeGenarator(
                    argument: settings.arguments as Map<String, dynamic>,
                  ));
        }

      case '/groupCartScreen':
        {
          //here we should send _groupName and _groupId

          return MaterialPageRoute(
              builder: (_) => GroupCartScreen(
                    argument: settings.arguments as Map<String, String>,
                  ));
        }
      case '/groupMembersScreen':
        {
          //here we should send  _groupId

          return MaterialPageRoute(
              builder: (_) => GroupMembersScreen(argument: settings.arguments));
        }

      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ));
    }
  }
}
