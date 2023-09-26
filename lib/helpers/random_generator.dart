import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';


class RandomGenerator {
// md5 hashing a random number
  static String md5RandomString() {
    final randomNumber = Random().nextDouble();
    final randomBytes = utf8.encode(randomNumber.toString());
    final randomString = md5.convert(randomBytes).toString();
    return randomString;
  }
}