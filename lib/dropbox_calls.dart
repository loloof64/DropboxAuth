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

const _customUrlScheme = "http://localhost:2566";
const _redirectUrl = "http://localhost:2566/irh4587sjd";
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
