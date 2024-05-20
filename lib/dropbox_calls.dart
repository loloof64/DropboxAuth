import 'dart:io';

import 'package:oauth2_client/oauth2_helper.dart';

import 'secrets.dart';
import 'package:oauth2_client/oauth2_client.dart';

class DropBoxClient extends OAuth2Client {
  DropBoxClient({required super.redirectUri, required super.customUriScheme})
      : super(
          authorizeUrl: 'https://www.dropbox.com/oauth2/authorize',
          tokenUrl: 'https://api.dropboxapi.com/oauth2/token',
        );
}

final _customUrlScheme = Platform.isAndroid ? "myauth2783" : "http://localhost:2566";
final _redirectUrl = Platform.isAndroid
    ? "myauth2783://landingpage"
    : "http://localhost:2566/irh4587sjd";
final _scopes = [
  'account_info.read',
  'files.metadata.write',
  'files.metadata.read',
  'files.content.write',
  'files.content.read'
];

OAuth2Helper getDropboxHelper() {
  OAuth2Client dropboxClient = DropBoxClient(
    redirectUri: _redirectUrl,
    customUriScheme: _customUrlScheme,
  );

  return OAuth2Helper(
    dropboxClient,
    grantType: OAuth2Helper.authorizationCode,
    clientId: identifier,
    clientSecret: secret,
    scopes: _scopes,
  );
}
