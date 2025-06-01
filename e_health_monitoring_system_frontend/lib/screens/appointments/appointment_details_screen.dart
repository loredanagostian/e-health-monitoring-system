import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/date_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/styles_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/widgets_helper.dart';
import 'package:e_health_monitoring_system_frontend/screens/main_screen.dart';
import 'package:e_health_monitoring_system_frontend/services/appointment_service.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_appbar.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_button.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_opacity_button_with_border_color.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_row_icon_string.dart';
import 'package:e_health_monitoring_system_frontend/widgets/doctor_card.dart';
import 'package:e_health_monitoring_system_frontend/widgets/price_tile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppointmentDetailsScreen extends StatefulWidget {
  final String appointmentId;
  final String medicalHistory;
  final bool isUpcoming;
  const AppointmentDetailsScreen({
    super.key,
    required this.appointmentId,
    required this.medicalHistory,
    required this.isUpcoming,
  });

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  final TextEditingController medicalHistoryController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    medicalHistoryController.text = widget.medicalHistory;
    medicalHistoryController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    medicalHistoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppointmentService.getAppointmentDetails(widget.appointmentId),
      builder:
          (ctx, snapshot) => Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            appBar: CustomAppbar(
              appBarTitle:
                  widget.isUpcoming
                      ? StringsHelper.upcomingAppointment
                      : StringsHelper.appointmentDetails,
              implyLeading: true,
            ),
            body:
                snapshot.hasData
                    ? SafeArea(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DoctorCard(
                              doctorName: snapshot.data!.doctorName,
                              doctorSpecialization: [],
                              detailsList: [
                                CustomRowIconText(
                                  icon: Icons.history,
                                  text:
                                      "${DateHelper.formatDate(snapshot.data!.date)} ${DateHelper.formatTime(snapshot.data!.date)}",
                                ),
                                CustomRowIconText(
                                  icon: Icons.medical_information_outlined,
                                  text: snapshot.data!.appointmentType,
                                ),
                              ],
                              doctorPhotoPath: snapshot.data!.doctorPicture,
                            ),
                            SizedBox(height: 20),
                            getReasonToVisit(snapshot.data!.appointmentType),
                            SizedBox(height: 20),
                            getTotalCost(snapshot.data!.totalCost),
                            SizedBox(height: 20),
                            getMedicalHistory(snapshot.data!.medicalHistory),
                            SizedBox(height: 20),
                            Visibility(
                              visible: !widget.isUpcoming,
                              child: getDiagnostic(snapshot.data!.diagnostic),
                            ),
                            SizedBox(height: 20),
                            Visibility(
                              visible: !widget.isUpcoming,
                              child: getRecommendation(
                                snapshot.data!.recommendation,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.1,
                            ),
                            Visibility(
                              visible: widget.isUpcoming,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: CustomButton(
                                  backgroundColor:
                                      medicalHistoryController.text.isNotEmpty
                                          ? ColorsHelper.mainPurple
                                          : ColorsHelper.mediumGray,
                                  text: StringsHelper.update,
                                  onPressed:
                                      () =>
                                          medicalHistoryController.text.isEmpty
                                              ? null
                                              : AppointmentService.updateAppointment(
                                                widget.appointmentId,
                                                medicalHistoryController.text,
                                              ).then((streamedResponse) async {
                                                final response = await http
                                                    .Response.fromStream(
                                                  streamedResponse,
                                                );

                                                if (response.statusCode ==
                                                    200) {
                                                  WidgetsHelper.showCustomSnackBar(
                                                    message:
                                                        StringsHelper.success,
                                                    backgroundColor:
                                                        Colors.green,
                                                  );

                                                  navigator.pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                      builder:
                                                          (
                                                            context,
                                                          ) => MainScreen(
                                                            bottomNavigatorIndex:
                                                                1,
                                                          ),
                                                    ),
                                                    (route) => false,
                                                  );
                                                } else {
                                                  WidgetsHelper.showCustomSnackBar(
                                                    message:
                                                        StringsHelper
                                                            .internalError,
                                                  );
                                                }
                                              }),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget.isUpcoming,
                              child: CustomOpacityButtonWithBorderColor(
                                text: StringsHelper.cancel,
                                backgroundColor: ColorsHelper.mainRed,
                                // TODO: implement
                                onPressed: () {},
                              ),
                            ),
                            Visibility(
                              visible: !widget.isUpcoming,
                              child: CustomButton(
                                text: StringsHelper.bookAgain,
                                backgroundColor: ColorsHelper.mainPurple,
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    : Container(),
          ),
    );
  }

  Widget getReasonToVisit(String appointmentType) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(StringsHelper.reasonToVisit, style: StylesHelper.titleStyle),
        SizedBox(height: 15),
        PriceTile(consultationType: appointmentType, price: ""),
      ],
    );
  }

  Widget getTotalCost(int totalCost) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(StringsHelper.totalCost, style: StylesHelper.titleStyle),
            Spacer(),
            Text(
              "${totalCost.toString()} LEI",
              style: TextStyle(fontSize: 16, color: ColorsHelper.mainDark),
            ),
          ],
        ),
      ],
    );
  }

  Widget getMedicalHistory(String medicalHistory) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(StringsHelper.medicalHistory, style: StylesHelper.titleStyle),
        SizedBox(height: 15),
        widget.isUpcoming
            ? Container(
              decoration: BoxDecoration(
                color: ColorsHelper.lightGray,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: ColorsHelper.mediumGray),
              ),
              child: TextField(
                controller: medicalHistoryController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: TextStyle(color: ColorsHelper.mainDark, fontSize: 14),
                decoration: InputDecoration(
                  hintText: StringsHelper.enterMedicalHistory,
                  hintStyle: TextStyle(
                    color: ColorsHelper.mediumGray,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  filled: true,
                  fillColor: ColorsHelper.lightGray,
                  contentPadding: EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            )
            : PriceTile(consultationType: medicalHistory, price: ""),
      ],
    );
  }

  Widget getDiagnostic(String diagnostic) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(StringsHelper.diagnostic, style: StylesHelper.titleStyle),
        PriceTile(consultationType: diagnostic, price: ""),
      ],
    );
  }

  Widget getRecommendation(String recommendation) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(StringsHelper.recommendation, style: StylesHelper.titleStyle),
        PriceTile(consultationType: recommendation, price: ""),
      ],
    );
  }
}
