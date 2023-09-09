
import 'package:event_crew/event_crew.dart' as event_crew;
import 'package:mdw_crew/index.dart';

class MovieTicket extends StatelessWidget {
  
  const MovieTicket({super.key});

  @override
  Widget build(BuildContext context) {

    final MovieUcImpl movieUcImpl = MovieUcImpl();

    return QrScanner(title: 'ស្កេនសំបុត្រកុន', func: movieUcImpl.scanMovieQR);
  }
}