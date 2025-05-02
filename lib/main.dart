import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sanaa/CommonFiles/common_function.dart';
import 'package:sanaa/CommonFiles/cubit/common_cubit.dart';
import 'package:sanaa/CommonFiles/image_file.dart';
import 'package:sanaa/Provider/locale_provider.dart';
import 'package:sanaa/Screens/Account/cubit/account_cubit.dart';
import 'package:sanaa/Screens/Account/profile_detail.dart';
import 'package:sanaa/Screens/Account/profile_page.dart';
import 'package:sanaa/Screens/Account/setting_page.dart';
import 'package:sanaa/Screens/DeliveryAddressPage/Model/address_model.dart';
import 'package:sanaa/Screens/DeliveryAddressPage/add_delivery_address.dart';
import 'package:sanaa/Screens/DeliveryAddressPage/delivery_address_page.dart';
import 'package:sanaa/Screens/DeliveryAddressPage/update_delivery.dart';
import 'package:sanaa/Screens/ExcitingOfferPage/cubit/product_cubit.dart';
import 'package:sanaa/Screens/ExcitingOfferPage/exciting_offer_page.dart';
import 'package:sanaa/Screens/FilterPage/cubit/filter_cubit.dart';
import 'package:sanaa/Screens/ForgotPasswordPage/cubit/forgot_password_cubit.dart';
import 'package:sanaa/Screens/ForgotPasswordPage/forgot_password.dart';
import 'package:sanaa/Screens/HomePage/cubit/home_cubit.dart';
import 'package:sanaa/Screens/HomePage/home_page.dart';
import 'package:sanaa/Screens/InternetConnectionPage/internet_connection.dart';
import 'package:sanaa/Screens/LoginPage/cubit/login_cubit.dart';
import 'package:sanaa/Screens/LoginPage/login_page.dart';
import 'package:sanaa/Screens/OTPScreen/cubit/otp_cubit.dart';
import 'package:sanaa/Screens/OTPScreen/otp_page.dart';
import 'package:sanaa/Screens/OnboardPage/onboard_page.dart';
import 'package:sanaa/Screens/OrderDetails/Model/order_model.dart';
import 'package:sanaa/Screens/OrderDetails/Model/place_order_model.dart';
import 'package:sanaa/Screens/OrderDetails/order_details.dart';
import 'package:sanaa/Screens/OrderDetails/order_list.dart';
import 'package:sanaa/Screens/OrderDetails/order_summery.dart';
import 'package:sanaa/Screens/PaymentPage/confirm_order.dart';
import 'package:sanaa/Screens/PaymentPage/cubit/payment_page_cubit.dart';
import 'package:sanaa/Screens/PaymentPage/model/checkout_summary_model.dart';
import 'package:sanaa/Screens/PaymentPage/payment_detail.dart';
import 'package:sanaa/Screens/PaymentPage/payment_screen.dart';
import 'package:sanaa/Screens/PopularItem/popular_item.dart';
import 'package:sanaa/Screens/ProductDetailPage/cubit/product_detail_cubit.dart';
import 'package:sanaa/Screens/ResetPasswordPage/cubit/reset_password_cubit.dart';
import 'package:sanaa/Screens/ResetPasswordPage/reset_password.dart';
import 'package:sanaa/Screens/ShopsPage/our_shop.dart';
import 'package:sanaa/Screens/ShopsPage/shop_detail.dart';
import 'package:sanaa/Screens/SignUpPage/cubit/signup_cubit.dart';
import 'package:sanaa/Screens/SignUpPage/sign_up_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sanaa/Screens/WishlistPage/cubit/wish_list_cubit.dart';
import 'package:sanaa/splash_screen.dart';

import 'Navigation/navigation_service.dart';
import 'Provider/internet_connectivity_provider.dart';
import 'Screens/CouponPage/coupon_page.dart';
import 'Screens/DeliveryAddressPage/cubit/address_cubit.dart';
import 'Screens/FilterPage/filter_page.dart';
import 'Screens/MyCartPage/cubit/cart_cubit.dart';
import 'Screens/OrderDetails/cubit/order_cubit.dart';
import 'Screens/ProductDetailPage/product_detail_page.dart';
import 'Screens/RecommendedPage/recommended.dart';
import 'Screens/ShopsPage/cubit/shops_cubit.dart';
import 'Screens/Tabbar/tabbar.dart';
import 'SharedPrefrence/shared_prefrence.dart';
import 'l10n/l10n.dart';

late NetworkStatusNotifier networkStatus;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferencesHelper.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LocalProvider()),
      ChangeNotifierProvider(create: (context) => NetworkStatusNotifier()),
    ],
    child: FutureBuilder(
      future: Future.wait([
        Firebase.initializeApp(),
        SharedPreferencesHelper.init(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }
        return const SizedBox.shrink(); // Or a loading widget
      },
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        networkStatus = Provider.of<NetworkStatusNotifier>(context, listen: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocalProvider>(context);
    return Builder(builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<SignupCubit>(
              create: (context) => SignupCubit(),
            ),
            BlocProvider<LoginCubit>(
              create: (context) => LoginCubit(),
            ),
            BlocProvider<ForgotPasswordCubit>(
              create: (context) => ForgotPasswordCubit(),
            ),
            BlocProvider<ResetPasswordCubit>(
              create: (context) => ResetPasswordCubit(),
            ),
            BlocProvider<OTPCubit>(
              create: (context) => OTPCubit(),
            ),
            BlocProvider<HomeCubit>(
              create: (context) => HomeCubit(),
            ),
            BlocProvider<AccountCubit>(
              create: (context) => AccountCubit(),
            ),
            BlocProvider<WishListCubit>(
              create: (context) => WishListCubit(),
            ),
            BlocProvider<CommonCubit>(
              create: (context) => CommonCubit(),
            ),
            BlocProvider<CartCubit>(
              create: (context) => CartCubit(),
            ),
            BlocProvider<AddressCubit>(
              create: (context) => AddressCubit(),
            ),
            BlocProvider<OrderCubit>(
              create: (context) => OrderCubit(),
            ),
            BlocProvider<ShopsCubit>(
              create: (context) => ShopsCubit(),
            ),
            BlocProvider<ProductDetailCubit>(
              create: (context) => ProductDetailCubit(),
            ),
            BlocProvider<ProductCubit>(
              create: (context) => ProductCubit(),
            ),
            BlocProvider<FilterCubit>(
              create: (context) => FilterCubit(),
            ),
            BlocProvider<PaymentPageCubit>(
              create: (context) => PaymentPageCubit(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            supportedLocales: L10n.all,
            locale: provider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            navigatorKey: NavigationService.navigatorKey,
            initialRoute: '/',
            routes: {
              '/onBoard': (context) => OnBoardPage(),
              '/signUp': (context) {
                final isFromOnBoard = ModalRoute.of(context)?.settings.arguments as bool;
                return SignUpPage(
                  isFromOnBoard: isFromOnBoard ?? false,
                );
              },
              '/loginPage': (context) {
                final isFromOnBoard = ModalRoute.of(context)?.settings.arguments as bool;
                return LoginPage(
                  isFromOnBoard: isFromOnBoard ?? false,
                );
              },
              '/forgotPage': (context) => const ForgotPasswordPage(),
              '/resetPassword': (context) {
                final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
                return ResetPasswordPage(args);
              },
              '/otpPage': (context) {
                final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
                return OtpPage(args);
              },
              '/mainPage': (context) {
                return Mainpage();
              },
              '/settingPage': (context) => SettingPage(),
              '/profilePage': (context) => const ProfilePage(),
              '/profileDetail': (context) => const ProfileDetailPage(),
              '/deliveryAddress': (context) => const DeliveryAddressPage(),
              '/addDeliveryAddressPage': (context) => const AddDeliveryAddress(),
              '/updateDeliveryAddress': (context) {
                final addressData = ModalRoute.of(context)?.settings.arguments as AddressData;
                return UpdateDeliveryAddress(addressData: addressData);
              },
              '/orderList': (context) {
                final bool isFromOrderConfirmationScreen = ModalRoute.of(context)?.settings.arguments as bool;
                return OrderList(
                  isFromOrdferConfirmationScreen: isFromOrderConfirmationScreen,
                );
              },
              '/orderDetails': (context) {
                final orderID = ModalRoute.of(context)?.settings.arguments as String;
                return OrderDetails(orderID: orderID);
              },
              '/recommendedPage': (context) => const RecommendedPage(),
              '/popularItem': (context) => const PopularItem(),
              '/shopsPage': (context) => const ShopsPage(),
              '/shopDetailPage': (context) {
                final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
                return ShopDetailPage(args);
              },
              '/productDetailPage': (context) {
                final productID = ModalRoute.of(context)?.settings.arguments as String;
                print('${productID} >>>>>>>>>>>.');
                return ProductDetailPage(
                  productID: productID,
                );
              },
              '/couponPage': (context) {
                final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
                return CouponPage(args);
              },
              '/excitingOffer': (context) {
                final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

                return ExcitingOfferPage(
                  title: args['title'] as String,
                  excitingOfferId: (args['offerId']) ?? '',
                  category: (args['category']) ?? '',
                  vendorId: (args['vendorId']) ?? '',
                  view: (args['view']) ?? '',
                );
              },
              '/filterPage': (context) => FilterScreen(),
              '/internetConnection': (context) => NoInternetPage(),
              '/orderSummery': (context) {
                final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
                return OrderSummery(args: args);
              },
              '/paymentScreen': (context) {
                final args = ModalRoute.of(context)?.settings.arguments as String;
                return PaymentScreen(
                  coupon: args,
                );
              },
              '/paymentDetail': (context) {
                final orderData = ModalRoute.of(context)?.settings.arguments as PlaceOrderData;
                return PaymentDetail(
                  orderData: orderData,
                );
              },
              '/orderConfirmScreen': (context) => const OrderConfirmScreen()
            },
            home: const Scaffold(
              body: SafeArea(child: SizedBox.expand(child: SplashScreen())),
            ),
          ),
        ),
      );
    });
  }
}
