
import 'package:coinstart_wallet_extension/dapp/page/dapp_all_page.dart';
import 'package:coinstart_wallet_extension/dapp/page/dapp_details_page.dart';
import 'package:coinstart_wallet_extension/dapp/page/dapp_page.dart';
import 'package:coinstart_wallet_extension/gameFi/page/gamefi_page.dart';
import 'package:coinstart_wallet_extension/home_page.dart';
import 'package:coinstart_wallet_extension/nft/page/nft_details_page.dart';
import 'package:coinstart_wallet_extension/nft/page/nft_index_page.dart';
import 'package:coinstart_wallet_extension/nft/page/nft_page.dart';
import 'package:coinstart_wallet_extension/nft/page/nft_transfer_page.dart';
import 'package:coinstart_wallet_extension/register/page/create_new_wallet_page.dart';
import 'package:coinstart_wallet_extension/register/page/forgot_password_page.dart';
import 'package:coinstart_wallet_extension/register/page/import_wallet_page.dart';
import 'package:coinstart_wallet_extension/register/page/register_page.dart';
import 'package:coinstart_wallet_extension/setup/page/about_us_page.dart';
import 'package:coinstart_wallet_extension/setup/page/add_wallet_page.dart';
import 'package:coinstart_wallet_extension/setup/page/binding_mail_page.dart';
import 'package:coinstart_wallet_extension/setup/page/edit_wallet_settings_page.dart';
import 'package:coinstart_wallet_extension/setup/page/general_info_page.dart';
import 'package:coinstart_wallet_extension/setup/page/need_password_page.dart';
import 'package:coinstart_wallet_extension/setup/page/node_setting_page.dart';
import 'package:coinstart_wallet_extension/setup/page/select_language_page.dart';
import 'package:coinstart_wallet_extension/setup/page/select_para_page.dart';
import 'package:coinstart_wallet_extension/setup/page/select_wallet_page.dart';
import 'package:coinstart_wallet_extension/setup/page/setup_page.dart';
import 'package:coinstart_wallet_extension/setup/page/view_mnemonic_page.dart';
import 'package:coinstart_wallet_extension/setup/page/view_private_key_page.dart';
import 'package:coinstart_wallet_extension/setup/page/wallet_info_page.dart';
import 'package:coinstart_wallet_extension/trade/page/trade_page.dart';
import 'package:coinstart_wallet_extension/wallet/page/receive_qr_page.dart';
import 'package:coinstart_wallet_extension/wallet/page/record_page.dart';
import 'package:coinstart_wallet_extension/wallet/page/swap_page.dart';
import 'package:coinstart_wallet_extension/wallet/page/swap_record_details_page.dart';
import 'package:coinstart_wallet_extension/wallet/page/swap_record_page.dart';
import 'package:coinstart_wallet_extension/wallet/page/token_transfer_page.dart';
import 'package:coinstart_wallet_extension/wallet/page/wallet_page.dart';
import 'package:flutter/material.dart';

final routes = {

  "/HomePage": (context, {arguments}) =>HomePage(arguments: arguments),

  "/RegisterPage": (context, {arguments}) =>RegisterPage(arguments: arguments),
  //???????????????
  "/CreateNewWalletPage": (context, {arguments}) =>CreateNewWalletPage(arguments: arguments),
  //????????????
  '/ImportWalletPage': (context, {arguments}) =>ImportWalletPage(arguments: arguments),

  "/WalletPage": (context, {arguments}) =>WalletPage(arguments: arguments),
  //????????????
  "/RecordPage": (context, {arguments}) =>RecordPage(arguments: arguments),
  //???????????????
  "/ReceiveQRPage": (context, {arguments}) =>ReceiveQRPage(arguments: arguments),
  //??????Token
  "/TokenTransferPage": (context, {arguments}) =>TokenTransferPage(arguments: arguments),
  //SWAP
  '/SwapPage': (context, {arguments}) =>SwapPage(arguments: arguments),
  //SWAP - ??????
  '/SwapRecordPage': (context, {arguments}) =>SwapRecordPage(arguments: arguments),
  //SWAP - ????????????
  '/SwapRecordDetailsPage': (context, {arguments}) =>SwapRecordDetailsPage(arguments: arguments),

  //NFT tab
  '/NFTIndexPage': (context, {arguments}) =>NFTIndexPage(arguments: arguments),
  //NFTTransferPage
  "/NFTTransferPage": (context, {arguments}) =>NFTTransferPage(arguments: arguments),
  //NFT
  '/NFTPage': (context, {arguments}) =>NFTPage(arguments: arguments),
  //NFT - ??????
  '/NFTDetailsPage': (context, {arguments}) =>NFTDetailsPage(arguments: arguments),

  //Trade
  '/TradePage': (context, {arguments}) =>TradePage(arguments: arguments),

  //GameFi
  '/GameFiPage': (context, {arguments}) =>GameFiPage(arguments: arguments),

  //DApp
  '/DAppPage': (context, {arguments}) =>DAppPage(arguments: arguments),
  //DApp - All
  "/DAppAllPage": (context, {arguments}) =>DAppAllPage(arguments: arguments),
  //DAppDetailsPage
  "/DAppDetailsPage": (context, {arguments}) =>DAppDetailsPage(arguments: arguments),

  //????????????
  '/GeneralInfoPage': (context, {arguments}) =>GeneralInfoPage(arguments: arguments),

  //??????
  '/SetupPage': (context, {arguments}) =>SetupPage(arguments: arguments),
  //????????????
  '/WalletInfoPage': (context, {arguments}) =>WalletInfoPage(arguments: arguments),
  //????????????
  '/NodeSettingPage': (context, {arguments}) =>NodeSettingPage(arguments: arguments),
  //????????????
  '/BinDingMailPage': (context, {arguments}) =>BinDingMailPage(arguments: arguments),
  //??????????????????
  '/NeedPasswordPage': (context, {arguments}) =>NeedPasswordPage(arguments: arguments),
  //????????????
  '/AboutUsPage': (context, {arguments}) =>AboutUsPage(arguments: arguments),
  //????????????
  '/ForgotPasswordPage': (context, {arguments}) =>ForgotPasswordPage(arguments: arguments),
  //????????????
  "/SelectWalletPage": (context, {arguments}) =>SelectWalletPage(arguments: arguments),
  //????????????
  "/SelectLanguagePage": (context, {arguments}) =>SelectLanguagePage(arguments: arguments),
  //????????????
  '/SelectParaPage': (context, {arguments}) =>SelectParaPage(arguments: arguments),
  //????????????
  "/EditWalletSettingPage": (context, {arguments}) =>EditWalletSettingPage(arguments: arguments),
  //??????
  "/ViewPrivateKeyPage" : (context, {arguments}) =>ViewPrivateKeyPage(arguments: arguments),
  //?????????
  "/ViewMnemonicPage" : (context, {arguments}) =>ViewMnemonicPage(arguments: arguments),
  //????????????
  "/AddWalletPage" : (context, {arguments}) =>AddWalletPage(arguments: arguments),
};

// ignore: top_level_function_literal_block, missing_return
var onGenerateRoute = (RouteSettings settings){
  final String? name = settings.name;

  final Function? pageContentBuilder = routes[name];

  if (settings.arguments != null) {
    final Route route = MaterialPageRoute(builder: (context) => pageContentBuilder!(context, arguments: settings.arguments),
    );
    return route;
  } else {
    final Route route = MaterialPageRoute(builder: (context) => pageContentBuilder!(context));
    return route;
  }
};