export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'dart:convert';
// ignore: depend_on_referenced_packages
export 'package:flutter_dotenv/flutter_dotenv.dart';
///------------------ Data Layer
export 'package:mdw_crew/data/backend/backend.dart';
export 'package:mdw_crew/data/backend/post_api.dart';
export 'package:mdw_crew/data/backend/get_api.dart';

export 'package:mdw_crew/service/storage.dart';

export 'package:mdw_crew/tool/app_utils.dart';

export 'package:animated_text_kit/animated_text_kit.dart';

///------------------ Domain Layer
export 'package:mdw_crew/domain/model/mdw_m.dart';
export 'package:mdw_crew/domain/model/benefit_m.dart';
export 'package:mdw_crew/domain/model/login_m.dart';

// Usecases
export 'package:mdw_crew/domain/usecase/login_uc.dart';

export 'package:filter_list/filter_list.dart';
// ignore: depend_on_referenced_packages
export 'package:lottie/lottie.dart';
export 'package:mdw_crew/presentation/registration/login.dart';
export 'package:mdw_crew/presentation/registration/app_update/check_update.dart';
export 'package:transition/transition.dart';

export 'package:flutter/foundation.dart';
///------------------ Presentation Layer
export 'package:mdw_crew/presentation/widgets/text_c.dart';
export 'package:mdw_crew/presentation/widgets/dialog_c.dart';
export 'package:mdw_crew/presentation/widgets/event_card_c.dart';
export 'package:mdw_crew/presentation/widgets/input_field_c.dart';


export 'package:mdw_crew/presentation/home/pages/checkin.dart';
export 'package:mdw_crew/presentation/home/pages/general/general.dart';
export 'package:mdw_crew/presentation/home/pages/membership/membership.dart';
export 'package:mdw_crew/presentation/home/pages/movie/bloc_movie.dart';
export 'package:mdw_crew/presentation/home/pages/checkout/count_checkout.dart';
export 'package:mdw_crew/presentation/home/home.dart';

// ignore: depend_on_referenced_packages
export 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
export 'package:vibration/vibration.dart';
// ignore: unused_import
export 'package:mdw_crew/presentation/provider/mdw_socket_p.dart';
export 'package:mdw_crew/presentation/provider/download_p.dart';
export 'package:mdw_crew/tool/sound.dart';
export 'package:mdw_crew/qr_scanner/qr_scanner.dart';

export 'dart:isolate';
export 'package:flutter_downloader/flutter_downloader.dart';


export 'dart:io';
export 'package:mdw_crew/constants/download_status.dart';

export 'package:url_launcher/url_launcher.dart';

// ignore: depend_on_referenced_packages
export 'package:shared_preferences/shared_preferences.dart';

export 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

// ignore: depend_on_referenced_packages
export 'package:flutter_localizations/flutter_localizations.dart';
