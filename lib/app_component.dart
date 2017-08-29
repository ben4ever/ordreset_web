import 'package:angular_components/angular_components.dart';
import 'package:angular/core.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';

import 'package:ordreset/api.dart';
import 'package:ordreset/dashboard.dart';

BrowserClient browserClientFactory() => new BrowserClient();

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  directives: const [Dashboard],
  providers: const [
    const Provider(BaseClient, useFactory: browserClientFactory),
    const Provider(Api, useClass: Api, deps: const [BaseClient]),
    materialProviders,
  ],
)
class AppComponent {}
