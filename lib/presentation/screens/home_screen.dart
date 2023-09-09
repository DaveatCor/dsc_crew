import 'package:event_crew/event_crew.dart' as evtCrew;
import 'package:mdw_crew/index.dart';

class HomeScreen extends StatelessWidget {
  
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final HomeUcImpl homeUcImpl = HomeUcImpl();

    homeUcImpl.setBuildContext = context;

    homeUcImpl.initState();
    
    return Scaffold(
      backgroundColor: evtCrew.AppUtil.convertHexaColor("#F2F2F2"),
      body: SafeArea(
        child: PageView(
          controller: homeUcImpl.controller,
          onPageChanged: (value) {
            homeUcImpl.active.value = homeUcImpl.controller.page!.toInt();
            if (homeUcImpl.controller.page!.toInt() == 0){
              homeUcImpl.color = Colors.blue.withOpacity(0.3);
            } else if ((homeUcImpl.controller.page!.toInt() == 1)){
              homeUcImpl.color = Colors.red.withOpacity(0.3);
            }
          },
          children: const [
            // Check(tabType: 'Check',),
            CheckInScreen(),
            MembershipScreen(),
            General()
            // const CheckOut(),
          ],
        ),
      ),
      // bottomNavigationBar: bottomAppBar(context: context, controller: controller, active: active)
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: homeUcImpl.active,
        builder: (context, active, wg) {
          return evtCrew.bottomAppBarNoCheck(
            context: context, 
            controller: homeUcImpl.controller, 
            itemsList: homeUcImpl.model.itemsList,
            active: active,
            onTap: homeUcImpl.bottomOnChange
          );
        }
      )
    );
  }
}
