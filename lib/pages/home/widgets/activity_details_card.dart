import 'package:flutter/material.dart';
import 'package:calendar_dashboard/responsive.dart';
import 'package:calendar_dashboard/model/health_model.dart';
import 'package:calendar_dashboard/widgets/custom_card.dart';
import 'package:flutter_svg/svg.dart';

class ActivityDetailsCard extends StatelessWidget {
  final List<HealthModel> healthDetails;

  const ActivityDetailsCard(
      {super.key,
      this.healthDetails = const [
        HealthModel(
          icon: 'assets/svg/burn.svg',
          value: "305",
          title: "Calories burned",
          hebrew: '',
        ),
        HealthModel(
          icon: 'assets/svg/steps.svg',
          value: "10,983",
          title: "Steps",
          hebrew: '',
        ),
        HealthModel(
          icon: 'assets/svg/distance.svg',
          value: "7km",
          title: "Distance",
          hebrew: '',
        ),
        HealthModel(
          icon: 'assets/svg/sleep.svg',
          value: "7h48m",
          title: "Sleep",
          hebrew: '',
        ),
      ]});

  // final List<HealthModel> healthDetails = const [
  //   HealthModel(
  //       icon: 'assets/svg/burn.svg', value: "305", title: "Calories burned"),
  //   HealthModel(icon: 'assets/svg/steps.svg', value: "10,983", title: "Steps"),
  //   HealthModel(
  //       icon: 'assets/svg/distance.svg', value: "7km", title: "Distance"),
  //   HealthModel(icon: 'assets/svg/sleep.svg', value: "7h48m", title: "Sleep"),
  // ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: healthDetails.length,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              Responsive.isMobile(context) ? 2 : healthDetails.length,
          crossAxisSpacing: !Responsive.isMobile(context) ? 15 : 12,
          mainAxisSpacing: 12.0),
      itemBuilder: (context, i) {
        return CustomCard(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              healthDetails[i].hebrew != ''
                  ? Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 4),
                      child: Text(
                        healthDetails[i].hebrew,
                        style: TextStyle(
                            fontSize: Responsive.isMobile(context) ? 10 : 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  : SvgPicture.asset(healthDetails[i].icon),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 4),
                child: Text(
                  healthDetails[i].value,
                  style: TextStyle(
                      fontSize: Responsive.isMobile(context) ? 10 : 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                healthDetails[i].title,
                style: TextStyle(
                    fontSize: Responsive.isMobile(context) ? 9 : 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
        );
      },
    );
  }
}
