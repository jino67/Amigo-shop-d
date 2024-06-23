import 'package:flutter/material.dart';

class AutoFillHintList {
  AutoFillHintList._();

  static const List<String> address = [
    AutofillHints.streetAddressLevel1,
    AutofillHints.streetAddressLine2,
    AutofillHints.streetAddressLine3,
    AutofillHints.streetAddressLine1,
    AutofillHints.streetAddressLine2,
    AutofillHints.streetAddressLine3,
    AutofillHints.fullStreetAddress,
    AutofillHints.postalAddress,
  ];

  static const List<String> city = [
    AutofillHints.addressCity,
    AutofillHints.addressState,
    AutofillHints.addressCityAndState,
  ];
  static const List<String> state = [
    AutofillHints.addressState,
    AutofillHints.addressCity,
    AutofillHints.addressCityAndState,
  ];
  static const List<String> name = [
    AutofillHints.namePrefix,
    AutofillHints.name,
    AutofillHints.middleName,
    AutofillHints.familyName,
    AutofillHints.givenName,
    AutofillHints.nickname,
    AutofillHints.nameSuffix,
  ];
  static const List<String> lastName = [
    AutofillHints.middleName,
    AutofillHints.givenName,
    AutofillHints.nickname,
    AutofillHints.nameSuffix,
    AutofillHints.name,
  ];
  static const List<String> firstName = [
    AutofillHints.namePrefix,
    AutofillHints.name,
    AutofillHints.familyName,
  ];
  static const List<String> phone = [
    AutofillHints.telephoneNumber,
    AutofillHints.telephoneNumberCountryCode,
    AutofillHints.telephoneNumberDevice,
    AutofillHints.telephoneNumberNational,
  ];
  static const List<String> email = [AutofillHints.email];
  static const List<String> password = [AutofillHints.password];
  static const List<String> newPassword = [AutofillHints.newPassword];
  static const List<String> zip = [
    AutofillHints.postalCode,
    AutofillHints.postalAddressExtendedPostalCode,
    AutofillHints.postalAddress,
    AutofillHints.postalAddressExtended,
  ];
}
