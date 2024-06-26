import 'package:bmi/core/utils/app_util.dart';
import 'package:bmi/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/shared/cache_helper.dart';
import '../../../core/shared/widgets/custom_button.dart';
import '../../../core/utils/strings.dart';
import '../../home/views/home_view.dart';
import '../view_model/auth_cubit.dart';
import '../view_model/auth_state.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginErrorState) {
        }

        if (state is LoginSuccessState) {


          AppUtil.removeUntilNavigator(context, const HomeView());
          AppUtil.showSnackBar(
              context: context, content: AppStrings.loginSuccess);
        }
      },
      builder: (context, state) {
        AuthCubit authCubit = AuthCubit.get(context);
        return SafeArea(
          child: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CompanyLogo(),
                  state is LoginLoadingState
                      ? CustomButton(
                          hasChild: false,
                          size: 25,
                          text: AppStrings.login,
                          onTap: () {},
                          buttomWidth: .75 * MediaQuery.sizeOf(context).width,
                        )
                      : CustomButton(
                          size: 25,
                          text: AppStrings.login,
                          onTap: () {
                            authCubit.signInAnonymous(context: context);
                          },
                          buttomWidth: .75 * MediaQuery.sizeOf(context).width,
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CompanyLogo extends StatelessWidget {
  const CompanyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppUtil.responsiveHeight(context) * 0.2,
      width: AppUtil.responsiveHeight(context) * 0.5,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.assetsONESolution),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
