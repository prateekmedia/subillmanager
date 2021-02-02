import 'package:flutter/material.dart';
import '../utils.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AwesomePopCard(
      context,
      headerChildren: [
        Column(
          children: [
            Text(
              "₹150.0",
              style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white),
            ),
            Text(
              "Last month bill",
              style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.grey.shade300),
            ),
          ],
        ),
        CircleAvatar(child: Icon(Icons.account_circle)),
      ],
      footerChildren: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Text("Recent Bills",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: primaryColor, fontWeight: FontWeight.w600)),
            ),
            FlatButton(onPressed: () {}, child: Text("See All")),
          ],
        ),
        Row(
          children: [
            FlatButton(
              onPressed: () {},
              child: Text("All", style: TextStyle(color: primaryColor)),
            ),
            FlatButton(
              onPressed: () {},
              child: Text("Person 1", style: TextStyle(color: Colors.grey)),
            ),
            FlatButton(
              onPressed: () {},
              child: Text("Person 2", style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
        SizedBox(height: 20),
        AwesomeMonthBill(
          context,
          title: "February",
          children: [
            AwesomeListTile(
              context,
              icon: Icons.person_outlined,
              title: "Person 1",
              subtitle: "Feb 1",
              trailing: "₹100",
            ),
            AwesomeListTile(
              context,
              icon: Icons.person_outlined,
              title: "Person 2",
              subtitle: "Feb 1",
              trailing: "₹50",
            ),
          ],
        ),
        AwesomeMonthBill(
          context,
          title: "January",
          children: [
            AwesomeListTile(
              context,
              icon: Icons.person_outlined,
              title: "Person 1",
              subtitle: "Jan 1",
              trailing: "₹150",
            ),
            AwesomeListTile(
              context,
              icon: Icons.person_outlined,
              title: "Person 2",
              subtitle: "Jan 1",
              trailing: "₹150",
            ),
          ],
        ),
        AwesomeMonthBill(
          context,
          title: "December",
          children: [
            AwesomeListTile(
              context,
              icon: Icons.person_outlined,
              title: "Person 1",
              subtitle: "Dec 1",
              trailing: "₹150",
            ),
            AwesomeListTile(
              context,
              icon: Icons.person_outlined,
              title: "Person 2",
              subtitle: "Dec 1",
              trailing: "₹150",
            ),
          ],
        ),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget AwesomeMonthBill(BuildContext context, {String title, List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        Container(
          child: Column(children: children),
        ),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  ListTile AwesomeListTile(BuildContext context,
      {IconData icon, String title, String subtitle, String trailing}) {
    return ListTile(
      tileColor: Colors.white,
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(
              icon,
              color: primaryColor,
            ),
          ),
        ],
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, color: primaryColor),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: primaryColor),
      ),
      trailing: Text(
        trailing,
        style: TextStyle(fontWeight: FontWeight.w600, color: primaryColor, fontSize: 18),
      ),
      contentPadding: EdgeInsets.all(10),
    );
  }

  // ignore: non_constant_identifier_names
  Widget AwesomePopCard(BuildContext context,
      {List<Widget> headerChildren,
      List<Widget> footerChildren,
      double cardBorderRadius = 25,
      EdgeInsets footerPadding = const EdgeInsets.symmetric(horizontal: 15)}) {
    return Column(
      children: [
        Container(
          color: primaryColor,
          padding: EdgeInsets.fromLTRB(10, 40, 10, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: headerChildren,
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 30,
                color: primaryColor,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(cardBorderRadius),
                      topLeft: Radius.circular(cardBorderRadius)),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.brighten(30).withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                  color: context.isDark ? Colors.grey[900].brighten(5) : grey,
                ),
                padding: footerPadding,
                width: double.infinity,
                child: ListView(
                  children: footerChildren,
                  physics: BouncingScrollPhysics(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
