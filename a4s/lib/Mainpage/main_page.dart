import 'package:a4s/notification.dart';
import 'package:a4s/sleepInfo/sleepInfo.dart';
import 'package:a4s/therapy/therapy.dart';
import 'package:flutter/material.dart';
import 'package:a4s/alarm/alarm.dart';
import 'package:a4s/data/repository/auth_repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:a4s/data/view/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:a4s/myPage/profile.dart';
import 'package:a4s/model/alarm.dart';
import 'package:a4s/provider/alarm_list_provider.dart';
import 'package:a4s/service/alarm_scheduler.dart';
import 'package:provider/provider.dart';


class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _Root();
}

class _Root extends ConsumerState<MainPage> with SingleTickerProviderStateMixin {
  late final TabController controller;
  late List<GlobalKey<NavigatorState>> _navigatorKeyList;

  void onPressed() {
    authRepositoryProvider.signOut();
    Navigator.pop(context);
  }

  int _selectedIdx = 1;
  final List _pages = [const TherapyPage(), const AlarmPage(), const SleepInfo()];

  @override
  void initState() {
    // 초기화
    FlutterLocalNotification.init();
    
    super.initState();

    controller = TabController(length: 3, vsync: this, initialIndex: 1);
    _navigatorKeyList =
        List.generate(_pages.length, (index) => GlobalKey<NavigatorState>());

  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userViewModelProvider);
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return !(await _navigatorKeyList[_selectedIdx]
            .currentState!
            .maybePop());
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            elevation: 0.0,
            leadingWidth: 0,
            titleSpacing: 0,
            title: Container(
              height: 80,
              child: Image.asset(
                "assets/logo.png",
                width: 150,
                height: double.maxFinite,
              ),
            ),
          ),
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 250,
                child: UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(user.user!.gender == '여자'
                        ? 'assets/women.png'
                        : 'assets/man.png'),
                  ),
                  accountName: Text(
                    user.user!.name!,
                    style: TextStyle(
                        fontSize: const AdaptiveTextSize()
                            .getadaptiveTextSize(context, 18),
                        fontWeight: FontWeight.w600),
                  ),
                  accountEmail: Text(user.user!.email!),
                  decoration: BoxDecoration(
                    color: Color(0xff6694ff),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.grey[850],
                ),
                title: Text("내 프로필 수정"),
                onTap: () {
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Edit()));
                      // 회원정보 수정 페이지로 이동
                },
                trailing: Icon(
                  Icons.add,
                  color: Colors.grey[850],
                ),
              )
            ],
          ),
        ),
        body: IndexedStack(
          index: _selectedIdx,
          children: _pages.map((page) {
            int idx = _pages.indexOf(page);
            return Navigator(
              key: _navigatorKeyList[idx],
              onGenerateRoute: (_) {
                return MaterialPageRoute(builder: (context) => page);
              },
            );
          }).toList(),
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: TabBar(
            controller: controller,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Color(0xff6694ff)),
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            labelStyle:
                const TextStyle(fontSize: 10, fontWeight: FontWeight.w100),
            labelPadding: EdgeInsets.symmetric(vertical: 5),
            onTap: (index) {
              setState(() {
                _selectedIdx = index;
              });
            },
            tabs: [
              Tab(
                icon: Image.asset(
                  'assets/navbar/therapy.png',
                  width: 24,
                  height: 24,
                  color: controller.index == 0 ? Colors.white : Colors.grey,
                ),
              ),
              Tab(
                icon: Image.asset(
                  'assets/navbar/alarm.png',
                  width: 24,
                  height: 24,
                  color: controller.index == 1 ? Colors.white : Colors.grey,
                ),
              ),
              Tab(
                icon: Image.asset(
                  'assets/navbar/sleep.png',
                  width: 24,
                  height: 24,
                  color: controller.index == 2 ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
