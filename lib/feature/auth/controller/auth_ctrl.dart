// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:e_com/core/core.dart';
import 'package:e_com/feature/auth/repository/auth_repo.dart';
import 'package:e_com/feature/cart/controller/carts_ctrl.dart';
import 'package:e_com/feature/settings/provider/settings_provider.dart';
import 'package:e_com/feature/user_dash/controller/dash_ctrl.dart';
import 'package:e_com/feature/user_dash/provider/user_dash_provider.dart';
import 'package:e_com/models/auth/auth_model.dart';
import 'package:e_com/models/base/api_res_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final acceptedTNCProvider = Provider<bool>((ref) {
  return ref.watch(authRepoProvider).didAcceptedTNC() ?? false;
});

final authCtrlProvider =
    NotifierProvider<AuthCtrlNotifier, bool>(AuthCtrlNotifier.new);

class AuthCtrlNotifier extends Notifier<bool> {
  @override
  bool build() {
    final loggedIn = _repo.getAccessToken();
    return loggedIn != null;
  }

  AuthRepo get _repo => ref.watch(authRepoProvider);

  /// Returns [true] if otp verification is needed
  Future<bool> _etherFold(
    Either<Failure, ApiResponse<AuthAccessToken>> res,
  ) async {
    return await res.fold(
      (l) async {
        Toaster.showError(l);
        state = false;
        return false;
      },
      (r) async {
        var accessToken = r.data.accessToken;
        if (accessToken != null) {
          await _repo.setAccessToken(accessToken);
          Toaster.showSuccess(r.message);
          state = true;
          await ref.read(userDashCtrlProvider.notifier).reload();
          ref.read(cartCtrlProvider.notifier).transferFromGuest();
          return false;
        } else {
          Toaster.showInfo(r.data.message);
          return true;
        }
      },
    );
  }

  Future<void> verifyOTP(String otp) async {
    final res = await _repo.verifyOTP(otp);
    await _etherFold(res);
  }

  Future<bool> forgetPassword(String email) async {
    final res = await _repo.forgetPassword(email);
    return res.fold(
      (l) {
        Toaster.showError(l);
        return false;
      },
      (r) {
        Toaster.showSuccess(r.data.message);
        return true;
      },
    );
  }

  Future<bool> passwordResetVerification(String email, String otp) async {
    final res = await _repo.passwordResetVerification(email, otp);
    return res.fold(
      (l) {
        Toaster.showError(l);
        return false;
      },
      (r) {
        Toaster.showSuccess(r.data.message);
        return true;
      },
    );
  }

  Future<bool> resetPassword(
    String email,
    String otp,
    String password,
    String confirm,
  ) async {
    final res = await _repo.resetPassword(email, otp, password, confirm);
    return res.fold(
      (l) {
        Toaster.showError(l);
        return false;
      },
      (r) {
        Toaster.showSuccess(r.data.message);
        return true;
      },
    );
  }

  Future<void> setWildAccessToken(String accessToken) async {
    await _repo.setAccessToken(accessToken);
    await ref.read(userDashCtrlProvider.notifier).reload();
    state = true;
  }

  Future<void> updatePassword(Map<String, dynamic> passwords) async {
    final res = await _repo.updatePassword(passwords);

    res.fold(
      (l) => Toaster.showError(l),
      (r) => Toaster.showSuccess(r.message),
    );
  }

  Future<bool> manualLogin(String email, String pass) async {
    final res = await _repo.login(email: email, pass: pass);

    return await _etherFold(res);
  }

  Future<void> googleLogin(BuildContext context) async {
    try {
      final sCID = ref.read(
        settingsProvider.select((x) => x?.settings.googleOAuth?.gClientId),
      );
      final googleSignIn = GoogleSignIn(
        clientId: Platform.isIOS ? clientIdIOS : null,
        serverClientId: Platform.isIOS ? sCID : null,
      );

      final googleAccount = await googleSignIn.signIn();

      if (googleAccount == null) {
        Toaster.showError(Translator.somethingWentWrong(context));
        state = false;
        return;
      }

      await googleAccount.authentication;

      final res = await _repo.login(
        email: googleAccount.email,
        type: LoginType.oAuth,
        oAuthId: googleAccount.id,
      );

      await _etherFold(res);
    } on Exception catch (e) {
      Toaster.showError(e.toString());
    }
  }

  Future<void> facebookLogin() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) {
        return;
      }
      final accessToken = result.accessToken!;

      final res = await _repo.login(
        email: accessToken.grantedPermissions
                ?.firstWhere((x) => x.contains('email')) ??
            '',
        type: LoginType.oAuth,
        oAuthId: accessToken.token,
      );

      await _etherFold(res);
    } on Exception catch (e) {
      Toaster.showError(e.toString());
    }
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String phone,
    required String pass,
    required String confirmPass,
  }) async {
    if (!didAcceptTNC()) {
      Toaster.showError('Please accept Terms & Conditions first to continue');
      return false;
    }
    final res = await _repo.signUp(name, email, phone, pass, confirmPass);
    return await _etherFold(res);
  }

  Future<void> _googleLogOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  Future<void> logOut() async {
    await _googleLogOut();
    final res = await _repo.logOut();
    res.fold(
      (l) {
        state = false;
        Toaster.showError(l);
      },
      (r) {
        state = true;
        Toaster.showSuccess(r.message);
      },
    );
    await _cleanUp();
  }

  Future<void> _cleanUp() async {
    final pref = ref.watch(sharedPrefProvider);
    await pref.remove(CachedKeys.userDash);
    await _repo.clearAccessToken();
    await _repo.resetTNCAcceptance();
    ref.invalidate(acceptedTNCProvider);
    ref.invalidate(userDashProvider);
    ref.invalidateSelf();
  }

  clearPref() async => await _repo.clearPref();

  Future<void> toggleTNCCheck(bool value) async {
    await _repo.setTNCAcceptance(value);
    ref.invalidate(acceptedTNCProvider);
  }

  bool didAcceptTNC() {
    final tncPage = ref.read(settingsProvider.select((x) => x?.tncPage));

    if (tncPage == null) return true;
    return ref.refresh(acceptedTNCProvider);
  }
}
