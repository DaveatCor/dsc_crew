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
// ignore: duplicate_export
export 'package:mdw_crew/domain/model/benefit_m.dart';

// Usecases
export 'package:mdw_crew/domain/usecase/login_uc/login_uc.dart';
export 'package:mdw_crew/domain/usecase/login_uc/login_uc_impl.dart';
export 'package:mdw_crew/domain/usecase/home_uc/home_uc.dart';
export 'package:mdw_crew/domain/usecase/home_uc/home_uc_impl.dart';
export 'package:mdw_crew/domain/usecase/general_uc/general_uc.dart';
export 'package:mdw_crew/domain/usecase/general_uc/general_uc_impl.dart';
export 'package:mdw_crew/domain/usecase/check_in_uc/check_in_uc.dart';
export 'package:mdw_crew/domain/usecase/membership_uc/membership_uc.dart';
export 'package:mdw_crew/domain/usecase/movie_uc/movie_uc_impl.dart';
export 'package:mdw_crew/domain/usecase/movie_uc/movie_uc.dart';

export 'package:filter_list/filter_list.dart';
// ignore: depend_on_referenced_packages
export 'package:lottie/lottie.dart';
export 'package:transition/transition.dart';

export 'package:flutter/foundation.dart';
///------------------ Presentation Layer
///
// Widgets
export 'package:mdw_crew/presentation/widgets/text_c.dart';
export 'package:mdw_crew/presentation/widgets/dialog_c.dart';
export 'package:mdw_crew/presentation/widgets/event_card_c.dart';
export 'package:mdw_crew/presentation/widgets/input_field_c.dart';
export 'package:mdw_crew/presentation/screens/registration/app_update/check_update.dart';

export 'package:mdw_crew/presentation/pages/movie/movie.dart';
export 'package:mdw_crew/presentation/pages/checkout/count_checkout.dart';
export 'package:mdw_crew/presentation/screens/general.dart';
export 'package:mdw_crew/presentation/screens/checkin_screen.dart';
export 'package:mdw_crew/presentation/screens/membership_screen.dart';
export 'package:mdw_crew/presentation/screens/home_screen.dart';
export 'package:mdw_crew/presentation/screens/login_screen.dart';

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
