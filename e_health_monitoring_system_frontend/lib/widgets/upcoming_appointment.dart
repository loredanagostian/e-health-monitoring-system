import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:flutter/material.dart';

class UpcomingAppointment extends StatelessWidget {
  final String doctorName;
  final String appointmentName;
  final String date;
  final String time;
  final void Function() onTap;
  const UpcomingAppointment({
    super.key,
    required this.doctorName,
    required this.appointmentName,
    required this.date,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 340,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: ColorsHelper.mainPurple,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(
                    'assets/images/mockup_doctor.png',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            doctorName,
                            style: TextStyle(
                              fontSize: 16,
                              color: ColorsHelper.mainWhite,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: ColorsHelper.mainWhite,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        appointmentName,
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorsHelper.mainWhite,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(135, 167, 248, 0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 20,
                        color: ColorsHelper.mainWhite,
                      ),
                      SizedBox(width: 5),
                      Text(
                        date,
                        style: TextStyle(
                          color: ColorsHelper.mainWhite,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(135, 167, 248, 0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 20,
                        color: ColorsHelper.mainWhite,
                      ),
                      SizedBox(width: 5),
                      Text(
                        time,
                        style: TextStyle(
                          color: ColorsHelper.mainWhite,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
