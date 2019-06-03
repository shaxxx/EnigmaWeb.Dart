//import 'package:enigma_web/enigma_web.dart';

import 'parsers/get_stream_parameters_parser.dart';
import 'package:logging/logging.dart';

import './commands/get_bouquet_items_command.dart';
import './commands/get_bouquets_command.dart';
import './commands/get_current_service_command.dart';
import './commands/get_stream_parameters_command.dart';
import './commands/message_command.dart';
import './commands/power_state_command.dart';
import './commands/reload_settings_command.dart';
import './commands/remote_control_command.dart';
import './commands/restart_command.dart';
import './commands/screenshot_command.dart';
import './commands/set_volume_command.dart';
import './commands/signal_command.dart';
import './commands/sleep_command.dart';
import './commands/volume_status_command.dart';
import './commands/wake_up_command.dart';
import './commands/zap_command.dart';
import './parsers/get_bouquets_items_parser.dart';
import './parsers/get_bouquets_parser.dart';
import './parsers/get_current_service_parser.dart';
import './parsers/power_state_parser.dart';
import './parsers/signal_parser.dart';
import './parsers/volume_status_parser.dart';
import './responses/get_bouquet_items_response.dart';
import './responses/get_bouquets_response.dart';
import './responses/get_current_service_response.dart';
import './responses/get_stream_parameters_response.dart';
import './responses/power_state_response.dart';
import './responses/screenshot_response.dart';
import './responses/signal_response.dart';
import './responses/volume_status_response.dart';
import './volume_status.dart';
import 'bouquet_item_bouquet.dart';
import 'bouquet_item_marker.dart';
import 'bouquet_item_service.dart';
import 'bouquet_item_service_e1.dart';
import 'commands/i_get_bouquet_items_command.dart';
import 'commands/i_get_bouquets_command.dart';
import 'commands/i_get_current_service_command.dart';
import 'commands/i_get_stream_parameters_command.dart';
import 'commands/i_message_command.dart';
import 'commands/i_power_state_command.dart';
import 'commands/i_reload_settings_command.dart';
import 'commands/i_remote_control_command.dart';
import 'commands/i_restart_command.dart';
import 'commands/i_screenshot_command.dart';
import 'commands/i_set_volume_command.dart';
import 'commands/i_signal_command.dart';
import 'commands/i_sleep_command.dart';
import 'commands/i_volume_status_command.dart';
import 'commands/i_wake_up_command.dart';
import 'commands/i_zap_command.dart';
import 'e1_signal.dart';
import 'e2_signal.dart';
import 'i_bouquet_item.dart';
import 'i_bouquet_item_bouquet.dart';
import 'i_bouquet_item_marker.dart';
import 'i_bouquet_item_service.dart';
import 'i_bouquet_item_service_e1.dart';
import 'i_e1_signal.dart';
import 'i_e2_signal.dart';
import 'i_factory.dart';
import 'i_signal.dart';
import 'i_volume_status.dart';
import 'i_web_requester.dart';
import 'parsers/i_response_parser.dart';
import 'parsers/unparsed_parser.dart';
import 'responses/i_get_bouquet_items_response.dart';
import 'responses/i_get_bouquets_response.dart';
import 'responses/i_get_current_service_response.dart';
import 'responses/i_get_stream_parameters_response.dart';
import 'responses/i_power_state_response.dart';
import 'responses/i_response.dart';
import 'responses/i_screenshot_response.dart';
import 'responses/i_signal_response.dart';
import 'responses/i_volume_status_response.dart';
import 'responses/unparsed_response.dart';
import 'web_requester.dart';

class Factory implements IFactory {
  static final Factory _factory = new Factory._internal();

  @override
  Logger log;

  factory Factory() {
    return _factory;
  }

  Factory._internal() {
    Logger.root.level = Level.ALL;
    log = new Logger('EnigmaWeb');
  }

  @override
  IBouquetItemBouquet bouquetItemBouquet() {
    return new BouquetItemBouquet();
  }

  @override
  IBouquetItemMarker bouquetItemMarker() {
    return new BouquetItemMarker();
  }

  @override
  IBouquetItemService bouquetItemService() {
    return new BouquetItemService();
  }

  @override
  IBouquetItemServiceE1 bouquetItemServiceE1() {
    return new BouquetItemServiceE1();
  }

  @override
  IE1Signal e1Signal() {
    return new E1Signal();
  }

  @override
  IE2Signal e2Signal() {
    return new E2Signal();
  }

  @override
  IGetBouquetItemsCommand getBouquetItemsCommand() {
    return new GetBouquetItemsCommand(this);
  }

  @override
  IResponseParser<IGetBouquetItemsCommand, IGetBouquetItemsResponse>
      getBouquetItemsParser() {
    return new GetBouquetItemsParser(this);
  }

  @override
  IGetBouquetItemsResponse getBouquetItemsResponse() {
    return new GetBouquetItemsResponse();
  }

  @override
  IGetBouquetItemsResponse getBouquetItemsResponseWithItems(
      List<IBouquetItem> items) {
    return new GetBouquetItemsResponse.withItems(items);
  }

  @override
  IGetBouquetsCommand getBouquetsCommand() {
    return new GetBouquetsCommand(this);
  }

  @override
  IResponseParser<IGetBouquetsCommand, IGetBouquetsResponse>
      getBouquetsParser() {
    return new GetBouquetsParser(this);
  }

  @override
  IGetBouquetsResponse getBouquetsResponse() {
    return new GetBouquetsResponse();
  }

  @override
  IGetBouquetsResponse getBouquetsResponseWithBouquets(
      List<IBouquetItemBouquet> bouquets) {
    return new GetBouquetsResponse.withBouquets(bouquets);
  }

  @override
  IGetCurrentServiceCommand getCurrentServiceCommand() {
    return new GetCurrentServiceCommand(this);
  }

  @override
  IResponseParser<IGetCurrentServiceCommand, IGetCurrentServiceResponse>
      getCurrentServiceParser() {
    return new GetCurrentServiceParser(this);
  }

  @override
  IGetCurrentServiceResponse getCurrentServiceResponse() {
    return new GetCurrentServiceResponse();
  }

  @override
  IGetCurrentServiceResponse getCurrentServiceResponseWithService(
      IBouquetItemService service) {
    return new GetCurrentServiceResponse.withService(service);
  }

  @override
  IGetStreamParametersCommand getStreamParametersCommand() {
    return new GetStreamParametersCommand(this);
  }

  @override
  IResponseParser<IGetStreamParametersCommand, IGetStreamParametersResponse>
      getStreamParametersParser() {
    return new GetStreamParametersParser(this);
  }

  @override
  IGetStreamParametersResponse getStreamParametersResponse() {
    return new GetStreamParametersResponse();
  }

  @override
  IGetStreamParametersResponse getStreamParametersResponseWithResponse(
      String response) {
    return new GetStreamParametersResponse.withResponse(response);
  }

  @override
  IMessageCommand messageCommand() {
    return new MessageCommand(this);
  }

  @override
  IResponseParser<IMessageCommand, IResponse<IMessageCommand>> messageParser() {
    return new UnparsedParser<IMessageCommand>();
  }

  @override
  IResponse<IMessageCommand> messageResponse() {
    return new UnparsedResponse<IMessageCommand>(null);
  }

  @override
  IResponse<IMessageCommand> messageResponseWithResponse(String response) {
    return new UnparsedResponse<IMessageCommand>(response);
  }

  @override
  IPowerStateCommand powerStateCommand() {
    return new PowerStateCommand(this);
  }

  @override
  IResponseParser<IPowerStateCommand, IPowerStateResponse> powerStateParser() {
    return new PowerStateParser(this);
  }

  @override
  IPowerStateResponse powerStateResponse(bool standby) {
    return new PowerStateResponse(standby);
  }

  @override
  IReloadSettingsCommand reloadSettingsCommand() {
    return new ReloadSettingsCommand(this);
  }

  @override
  IResponseParser<IReloadSettingsCommand, IResponse<IReloadSettingsCommand>>
      reloadSettingsParser() {
    return new UnparsedParser<IReloadSettingsCommand>();
  }

  @override
  IResponse<IReloadSettingsCommand> reloadSettingsResponse() {
    return new UnparsedResponse<IReloadSettingsCommand>(null);
  }

  @override
  IResponse<IReloadSettingsCommand> reloadSettingsResponseWithResponse(
      String response) {
    return new UnparsedResponse<IReloadSettingsCommand>(response);
  }

  @override
  IRemoteControlCommand remoteControlCommand() {
    return new RemoteControlCommand(this);
  }

  @override
  IResponseParser<IRemoteControlCommand, IResponse<IRemoteControlCommand>>
      remoteControlParser() {
    return new UnparsedParser<IRemoteControlCommand>();
  }

  @override
  IResponse<IRemoteControlCommand> remoteControlResponse() {
    return new UnparsedResponse<IRemoteControlCommand>(null);
  }

  @override
  IResponse<IRemoteControlCommand> remoteControlResponseWithResponse(
      String response) {
    return new UnparsedResponse<IRemoteControlCommand>(response);
  }

  @override
  IRestartCommand restartCommand() {
    return new RestartCommand(this);
  }

  @override
  IResponseParser<IRestartCommand, IResponse<IRestartCommand>> restartParser() {
    return new UnparsedParser<IRestartCommand>();
  }

  @override
  IResponse<IRestartCommand> restartResponse() {
    return new UnparsedResponse<IRestartCommand>(null);
  }

  @override
  IResponse<IRestartCommand> restartResponseWithResponse(String response) {
    return new UnparsedResponse<IRestartCommand>(response);
  }

  @override
  IScreenshotCommand screenshotCommand() {
    return new ScreenshotCommand(this);
  }

  @override
  IScreenshotResponse screenshotResponse() {
    return new ScreenshotResponse(null);
  }

  @override
  IScreenshotResponse screenshotResponseWithBytes(List<int> screenshot) {
    return new ScreenshotResponse(screenshot);
  }

  @override
  ISetVolumeCommand setVolumeCommand() {
    return new SetVolumeCommand(this);
  }

  @override
  IResponseParser<ISetVolumeCommand, IResponse<ISetVolumeCommand>>
      setVolumeParser() {
    return new UnparsedParser<ISetVolumeCommand>();
  }

  @override
  IResponse<ISetVolumeCommand> setVolumeResponse() {
    return new UnparsedResponse<ISetVolumeCommand>(null);
  }

  @override
  IResponse<ISetVolumeCommand> setVolumeResponseWithResponse(String response) {
    return new UnparsedResponse<ISetVolumeCommand>(response);
  }

  @override
  ISignalCommand signalCommand() {
    return new SignalCommand(this);
  }

  @override
  IResponseParser<ISignalCommand, ISignalResponse> signalParser() {
    return new SignalParser(this);
  }

  @override
  ISignalResponse signalResponse(ISignal signal) {
    return new SignalResponse(signal);
  }

  @override
  ISleepCommand sleepCommand() {
    return new SleepCommand(this);
  }

  @override
  IResponseParser<ISleepCommand, IResponse<ISleepCommand>> sleepParser() {
    return new UnparsedParser<ISleepCommand>();
  }

  @override
  IResponse<ISleepCommand> sleepResponse() {
    return new UnparsedResponse<ISleepCommand>(null);
  }

  @override
  IResponse<ISleepCommand> sleepResponseWithResponse(String response) {
    return new UnparsedResponse<ISleepCommand>(response);
  }

  @override
  IVolumeStatus volumeStatus() {
    return new VolumeStatus();
  }

  @override
  IVolumeStatusCommand volumeStatusCommand() {
    return new VolumeStatusCommand(this);
  }

  @override
  IResponseParser<IVolumeStatusCommand, IVolumeStatusResponse>
      volumeStatusParser() {
    return new VolumeStatusParser(this);
  }

  @override
  IVolumeStatusResponse volumeStatusResponse() {
    return new VolumeStatusResponse(null);
  }

  @override
  IVolumeStatusResponse volumeStatusResponseWithResponse(IVolumeStatus status) {
    return new VolumeStatusResponse(status);
  }

  @override
  IWakeUpCommand wakeUpCommand() {
    return new WakeUpCommand(this);
  }

  @override
  IResponseParser<IWakeUpCommand, IResponse<IWakeUpCommand>> wakeUpParser() {
    return new UnparsedParser<IWakeUpCommand>();
  }

  @override
  IResponse<IWakeUpCommand> wakeUpResponse() {
    return new UnparsedResponse<IWakeUpCommand>(null);
  }

  @override
  IResponse<IWakeUpCommand> wakeUpResponseWithResponse(String response) {
    return new UnparsedResponse<IWakeUpCommand>(response);
  }

  @override
  IWebRequester webRequester() {
    return new WebRequester(log);
  }

  @override
  IZapCommand zapCommand() {
    return new ZapCommand(this);
  }

  @override
  IResponseParser<IZapCommand, IResponse<IZapCommand>> zapParser() {
    return new UnparsedParser<IZapCommand>();
  }

  @override
  IResponse<IZapCommand> zapResponse() {
    return new UnparsedResponse<IZapCommand>(null);
  }

  @override
  IResponse<IZapCommand> zapResponseWithResponse(String response) {
    return new UnparsedResponse<IZapCommand>(response);
  }
}
