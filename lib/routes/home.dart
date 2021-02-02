import 'package:flutter/material.dart';
import '../utils.dart';
import '../widgets.dart';

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
}
