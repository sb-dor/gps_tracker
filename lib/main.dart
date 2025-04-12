import 'runner_stub.dart'
    if (dart.library.io) 'runner_io.dart'
    if (dart.library.html) 'runner_web.dart'
    as runner;

void main() => runner.run();
