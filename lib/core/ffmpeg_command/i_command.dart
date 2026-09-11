abstract class ICommand {
  const ICommand();
  List<String> get commands;
}

class CustomCommand implements ICommand {
  final String command;
  const CustomCommand(this.command);
  @override
  List<String> get commands => command.split(' ');
}
