import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/date_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/image_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/styles_helper.dart';
import 'package:e_health_monitoring_system_frontend/models/api_models/patient_profile.dart';
import 'package:e_health_monitoring_system_frontend/models/api_models/upcoming_appointment_dto.dart';
import 'package:e_health_monitoring_system_frontend/screens/appointments/doctor_profile_screen.dart';
import 'package:e_health_monitoring_system_frontend/screens/appointments/upcoming_appointment_screen.dart';
import 'package:e_health_monitoring_system_frontend/screens/appointments/appointments_list_screen.dart';
import 'package:e_health_monitoring_system_frontend/screens/onboarding/complete_profile_screen.dart';
import 'package:e_health_monitoring_system_frontend/services/appointment_service.dart';
import 'package:e_health_monitoring_system_frontend/services/doctor_service.dart';
import 'package:e_health_monitoring_system_frontend/services/patient_service.dart';
import 'package:e_health_monitoring_system_frontend/widgets/book_now_button.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_row_icon_string.dart';
import 'package:e_health_monitoring_system_frontend/widgets/doctor_card.dart';
import 'package:e_health_monitoring_system_frontend/widgets/medical_report.dart';
import 'package:e_health_monitoring_system_frontend/widgets/upcoming_appointment.dart';
import 'package:e_health_monitoring_system_frontend/widgets/info_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final PatientProfile patientProfile;
  const HomeScreen({required this.patientProfile, super.key});

  @override
  ConsumerState<HomeScreen> createState() =>
      _HomeScreenState(patientProfile: patientProfile);
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  PatientProfile patientProfile;
  _HomeScreenState({required this.patientProfile});

  List<AppointmentDto> _upcomingAppointments = [];
  List<AppointmentDto> _recentVisits = [];
  bool _isLoadingAppointments = true;
  bool _isLoadingRecentVisits = true;

  @override
  void initState() {
    super.initState();
    _loadUpcomingAppointments();
    _loadRecentVisits();
  }

  void _loadUpcomingAppointments() async {
    final appointments = await AppointmentService.getUpcomingAppointments();
    setState(() {
      _upcomingAppointments = appointments;
      _isLoadingAppointments = false;
    });
  }

  void _loadRecentVisits() async {
    final appointments = await AppointmentService.getPastVisits();
    setState(() {
      _recentVisits = appointments;
      _isLoadingRecentVisits = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getUpcomingAppointments(),
              SizedBox(height: 30),
              getRecentVisits(),
              // SizedBox(height: 30),
              // getMedicalReports(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 40),
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
        child: AppBar(
          backgroundColor: ColorsHelper.mainWhite,
          leading: InkWell(
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: ColorsHelper.mediumPurple,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "${patientProfile.firstName[0]}${patientProfile.lastName[0]}"
                      .toUpperCase(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ColorsHelper.mainWhite,
                  ),
                ),
              ),
            ),
            onTap:
                () async => await navigator
                    .push(
                      MaterialPageRoute(
                        builder:
                            (_) => Scaffold(
                              body: SafeArea(child: UpdateProfileScreen()),
                            ),
                      ),
                    )
                    .then((_) async {
                      var profile = await PatientService().getPatientProfile();
                      setState(() {
                        patientProfile = profile ?? widget.patientProfile;
                      });
                    }),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${StringsHelper.hi},",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: ColorsHelper.darkGray,
                ),
              ),
              Text(
                "${patientProfile.firstName} ${patientProfile.lastName}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorsHelper.mainDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getUpcomingAppointments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getSectionTitle(
          StringsHelper.upcomingAppointments,
          isViewAllButtonVisible: _upcomingAppointments.isNotEmpty,
          onPressed: () async {
            if (!_isLoadingAppointments) {
              await navigator.push(
                MaterialPageRoute(
                  builder:
                      (_) => AppointmentsListScreen(
                        title: StringsHelper.upcomingAppointments,
                        appointments: _upcomingAppointments,
                      ),
                ),
              );
            }
          },
        ),
        SizedBox(height: 20),
        _isLoadingAppointments
            ? Padding(
              padding: const EdgeInsets.only(left: 25),
              child: CircularProgressIndicator(),
            )
            : _upcomingAppointments.isEmpty
            ? Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text("No upcoming appointments"),
            )
            : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 25),
              child: Row(
                children:
                    _upcomingAppointments.map((appointment) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: UpcomingAppointment(
                          doctorName: appointment.doctorName,
                          appointmentName: appointment.appointmentType,
                          date: DateHelper.formatDate(appointment.date),
                          time: DateHelper.formatTime(appointment.date),
                          onTap:
                              () => navigator.push(
                                MaterialPageRoute(
                                  builder:
                                      (_) => AppointmentDetailsScreen(
                                        appointmentId: appointment.id,
                                        title:
                                            StringsHelper.upcomingAppointment,
                                      ),
                                ),
                              ),
                        ),
                      );
                    }).toList(),
              ),
            ),
      ],
    );
  }

  Widget getRecentVisits() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getSectionTitle(
          onPressed: () async {
            await navigator.push(
              MaterialPageRoute(
                builder:
                    (_) => AppointmentsListScreen(
                      title: StringsHelper.recentVisits,
                      appointments: _recentVisits,
                    ),
              ),
            );
          },
          StringsHelper.recentVisits,
          isViewAllButtonVisible: true,
        ),
        _isLoadingRecentVisits
            ? Padding(
              padding: const EdgeInsets.only(left: 25),
              child: CircularProgressIndicator(),
            )
            : SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 25),
          child: Row(
            children:
                _recentVisits
                    .map(
                      (ap) => Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: SizedBox(
                          height: 120,
                          child: DoctorCard(
                            doctorName: ap.doctorName,
                            doctorSpecialization: [],
                            doctorPhotoPath:
                                ap.doctorPicture.isNotEmpty
                                    ? ImageHelper.fixImageUrl(ap.doctorPicture)
                                    : "/assets/images/mockup_doctor.png",
                            detailsList: [
                              CustomRowIconText(
                                icon: Icons.history,
                                text:
                                    "${DateHelper.formatDate(ap.date)} ${DateHelper.formatTime(ap.date)}",
                              ),
                              SizedBox(
                                width: 120,
                                child: BookNowButton(
                                  onPressed: () async {
                                    final doctorInfo =
                                        await DoctorService.getDoctorById(
                                          ap.doctorId,
                                        );

                                    navigator.push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => DoctorProfileScreen(
                                              doctor: doctorInfo,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                            width: 340,
                            hasVisibleIcons: true,
                            onPressed: () {
                              navigator.push(
                                MaterialPageRoute(
                                  builder:
                                      (_) => AppointmentDetailsScreen(
                                        appointmentId: ap.id,
                                        title: StringsHelper.recentVisit,
                                      ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }

  Widget getMedicalReports() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getSectionTitle(StringsHelper.medicalReports),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Row(
            children: [
              MedicalReport(medicalReportType: MedicalReportType.examinations),
              SizedBox(width: 20),
              MedicalReport(medicalReportType: MedicalReportType.analysis),
            ],
          ),
        ),
      ],
    );
  }

  Widget getSectionTitle(
    String title, {
    void Function()? onPressed,
    bool isViewAllButtonVisible = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: StylesHelper.titleStyle),
          Visibility(
            visible: isViewAllButtonVisible,
            child: InfoTag(onPressed: onPressed),
          ),
        ],
      ),
    );
  }
}
