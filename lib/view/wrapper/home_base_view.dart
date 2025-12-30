import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/mixins/view_state_mixin.dart';
import 'package:cinebond/utils/loading/loading_cubit.dart';
import 'package:cinebond/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:cinebond/constants/images-icons/images_icons.dart';
import 'package:cinebond/utils/loading/loading_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBaseView extends StatefulWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final bool resizeToAvoidBottomInset;
  final double horizontalPadding;
  final double verticalPadding;
  final bool isLoadingActive;
  final bool isAppbarActive;

  const HomeBaseView({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
    this.horizontalPadding = 6,
    this.verticalPadding = 6,
    this.isLoadingActive = false,
    this.isAppbarActive = true,
  });

  @override
  State<HomeBaseView> createState() => _HomeBaseViewState();
}

class _HomeBaseViewState extends State<HomeBaseView> with ViewStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: widget.bottomNavigationBar,
      appBar: widget.isAppbarActive ? widget.appBar ?? buildAppbar() : null,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Container(
                color: const Color.fromARGB(255, 15, 15, 15),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.horizontalPadding,
                vertical: widget.verticalPadding,
              ),
              child: widget.body,
            ),
            if (widget.isLoadingActive)
              BlocBuilder<LoadingCubit, LoadingState>(
                builder: (context, state) {
                  return state.isLoading
                      ? LoadingOverlay()
                      : SizedBox.shrink();
                },
              ),

          ],
        ),
      ),
    );
  }
}
