import 'dart:developer';

import 'package:googleapis_auth/auth_io.dart';

class NotificationAccessToken {
  static String? _token;

  //to generate token only once for an app run
  static Future<String?> get getToken async =>
      _token ?? await _getAccessToken();

  // to get admin bearer token
  static Future<String?> _getAccessToken() async {
    try {
      const fMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';

      final client = await clientViaServiceAccount(
        // To get Admin Json File: Go to Firebase > Project Settings > Service Accounts
        // > Click on 'Generate new private key' Btn & Json file will be downloaded

        // Paste Your Generated Json File Content
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "soulee-database",
          "private_key_id": "4e2a359ecc64f34b7c661799f94593aa7bec2f6b",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDE9EBWebml2bEM\nElZISNkuINDj6Wf/Mgj2YyD0PtAhYaIETqJfoTLashMhKiYX4RvT1BxgK1x3v4PQ\n0ZaePqhfJGdfKXyFJmO4WH7qGGemwMya+hsnq8TE59Kr0/UvcPJZUUvOUSShFGc4\nzCuMxM8zKWe6vG2XHmrgP1QUKOqws2qD6/s91JGDNU+Mv5XkXqOHc0ZRPBPqsP+a\nAks3HRStK/0xELZQxpc07w02isHCoRUQjiNURZYmDPqvdrrPo5NafKe+eu0X9A7R\nPOKNhr45jWfW01slWTXC0s3AEK4G3HETKVntDxYwiQCsg80qNchJDbPy3pfF6wIz\n7aTckOMHAgMBAAECggEAGs6kpoCJRcCEahW2274v8qjcdcunmuMHDZjUJppuvr8T\nYSMI08ZU7dJjaytZpadp9QzqUyajvoLOi2YeP5SyBcfRMBvX9dGSAh3oIa8dBePj\nwCD/ADPPeP5AEkuBFFTQZQV9MWxMStvEPu//P3jsO3+iaEF3EyS8kaAyWU9xE4gN\ncgBGv+El3FJEZwbv/p0KWEPb67pTEi+CfMLUH3ADw0IrwGG8CpJ9x2Hq9MG1K/9V\nWxEIlBLnW8TH8wt8IziWGoW6hjbOus4QZ4HV7AZawJvgYt3+wnny41zujb0i6SmH\niKy2RsaDZGo7yJBbTOQG3lLHO08YCvQgl5W8tyfUBQKBgQDz7X7EITcwv0wCls3y\nU0xHcrgZY7pijHB+1P7wNLYKHB1nPSaei9qNy3BwOenDeNTKoNihx2HJDj5Zv06x\nzt1u/GNoTxas5FW6FrlndegIY78bAjW5ueToEyuWrBps+OguOYwS5+W2VOh3bMsc\nZOgBtenDiA5LNabBPINWH+GTDQKBgQDOs5yoOXcJ7X9QQyE0+TvZoCjTBo3Gr7xY\nB0F2qHSyPgrNTpDBSRbw+AvobAYxYE61RXUp2kb6MX5YsrftQm+JyqNpv6ms4a8V\nzwgCmAkL6gVHK3oKRbzh43NUaINqXiQSpiPxtTn+9S9LLvxj/maS4fBbGTo1HXX8\n5B69PavZYwKBgC7M3EuJC+vAaDb+9BiQPsxeiE/mwHXz+Al9mERB+MNLzaBnLSey\nMYaPB82gbudgIYOXBLlVZb+Lig7yE4kt5XJL3k6/DdyyGniPr5bYGmKxsJLgA6rU\nrcSRGQXZk2BhCTsFM4jVEU/ATrHLH9Uczx605lrrmcJ4Urw0fgZiK4dpAoGBAK7j\nNVb4WAmkUqX8RmplvgfiBOiXkPlc00S/ztmwqhvtdoJDSSLgznJPzPN4Ar1gOPgS\nrpEcyBUEL1yoygoKvgid1SmyKsPFp7gSFTrsnCridFjFJlruqmONaJUwYJBs2qSU\nwbDOnyVjGgLI3G9WXj9Ev3K0o5UxOhUghgmj1nT1AoGAabs9T3r34O+sXqYc4P0O\n6dz4MpHvU2zl10D49ONVbDbU4+o0/r5uU1JnCQu3lGuUX3zWzjQrUXqULWmLO7Sa\nM29g7YoVVeW2znNaQjEvty6kyEylRsbAQRU9exTsTSmiZ8wJEWYkoxvWUYZydliz\nnG5Ht0X/w4S39MearHmeZ80=\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-c3cpc@soulee-database.iam.gserviceaccount.com",
          "client_id": "105709954658221042204",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-c3cpc%40soulee-database.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        [fMessagingScope],
      );

      _token = client.credentials.accessToken.data;

      return _token;
    } catch (e) {
      log('$e');
      return null;
    }
  }
}
