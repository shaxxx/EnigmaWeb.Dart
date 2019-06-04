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
  static final Factory _factory = Factory._internal();

  @override
  Logger log;

  factory Factory() {
    return _factory;
  }

  Factory._internal() {
    Logger.root.level = Level.ALL;
    log = Logger('EnigmaWeb');
  }

  @override
  IBouquetItemBouquet bouquetItemBouquet() {
    return BouquetItemBouquet();
  }

  @override
  IBouquetItemMarker bouquetItemMarker() {
    return BouquetItemMarker();
  }

  @override
  IBouquetItemService bouquetItemService() {
    return BouquetItemService();
  }

  @override
  IBouquetItemServiceE1 bouquetItemServiceE1() {
    return BouquetItemServiceE1();
  }

  @override
  IE1Signal e1Signal() {
    return E1Signal();
  }

  @override
  IE2Signal e2Signal() {
    return E2Signal();
  }

  @override
  IGetBouquetItemsCommand getBouquetItemsCommand() {
    return GetBouquetItemsCommand(this);
  }

  @override
  IResponseParser<IGetBouquetItemsCommand, IGetBouquetItemsResponse> getBouquetItemsParser() {
    return GetBouquetItemsParser(this);
  }

  @override
  IGetBouquetItemsResponse getBouquetItemsResponse() {
    return GetBouquetItemsResponse();
  }

  @override
  IGetBouquetItemsResponse getBouquetItemsResponseWithItems(List<IBouquetItem> items) {
    return GetBouquetItemsResponse.withItems(items);
  }

  @override
  IGetBouquetsCommand getBouquetsCommand() {
    return GetBouquetsCommand(this);
  }

  @override
  IResponseParser<IGetBouquetsCommand, IGetBouquetsResponse> getBouquetsParser() {
    return GetBouquetsParser(this);
  }

  @override
  IGetBouquetsResponse getBouquetsResponse() {
    return GetBouquetsResponse();
  }

  @override
  IGetBouquetsResponse getBouquetsResponseWithBouquets(List<IBouquetItemBouquet> bouquets) {
    return GetBouquetsResponse.withBouquets(bouquets);
  }

  @override
  IGetCurrentServiceCommand getCurrentServiceCommand() {
    return GetCurrentServiceCommand(this);
  }

  @override
  IResponseParser<IGetCurrentServiceCommand, IGetCurrentServiceResponse> getCurrentServiceParser() {
    return GetCurrentServiceParser(this);
  }

  @override
  IGetCurrentServiceResponse getCurrentServiceResponse() {
    return GetCurrentServiceResponse();
  }

  @override
  IGetCurrentServiceResponse getCurrentServiceResponseWithService(IBouquetItemService service) {
    return GetCurrentServiceResponse.withService(service);
  }

  @override
  IGetStreamParametersCommand getStreamParametersCommand() {
    return GetStreamParametersCommand(this);
  }

  @override
  IResponseParser<IGetStreamParametersCommand, IGetStreamParametersResponse>
      getStreamParametersParser() {
    return GetStreamParametersParser(this);
  }

  @override
  IGetStreamParametersResponse getStreamParametersResponse() {
    return GetStreamParametersResponse();
  }

  @override
  IGetStreamParametersResponse getStreamParametersResponseWithResponse(String response) {
    return GetStreamParametersResponse.withResponse(response);
  }

  @override
  IMessageCommand messageCommand() {
    return MessageCommand(this);
  }

  @override
  IResponseParser<IMessageCommand, IResponse<IMessageCommand>> messageParser() {
    return UnparsedParser<IMessageCommand>();
  }

  @override
  IResponse<IMessageCommand> messageResponse() {
    return UnparsedResponse<IMessageCommand>(null);
  }

  @override
  IResponse<IMessageCommand> messageResponseWithResponse(String response) {
    return UnparsedResponse<IMessageCommand>(response);
  }

  @override
  IPowerStateCommand powerStateCommand() {
    return PowerStateCommand(this);
  }

  @override
  IResponseParser<IPowerStateCommand, IPowerStateResponse> powerStateParser() {
    return PowerStateParser(this);
  }

  @override
  IPowerStateResponse powerStateResponse(bool standby) {
    return PowerStateResponse(standby);
  }

  @override
  IReloadSettingsCommand reloadSettingsCommand() {
    return ReloadSettingsCommand(this);
  }

  @override
  IResponseParser<IReloadSettingsCommand, IResponse<IReloadSettingsCommand>>
      reloadSettingsParser() {
    return UnparsedParser<IReloadSettingsCommand>();
  }

  @override
  IResponse<IReloadSettingsCommand> reloadSettingsResponse() {
    return UnparsedResponse<IReloadSettingsCommand>(null);
  }

  @override
  IResponse<IReloadSettingsCommand> reloadSettingsResponseWithResponse(String response) {
    return UnparsedResponse<IReloadSettingsCommand>(response);
  }

  @override
  IRemoteControlCommand remoteControlCommand() {
    return RemoteControlCommand(this);
  }

  @override
  IResponseParser<IRemoteControlCommand, IResponse<IRemoteControlCommand>> remoteControlParser() {
    return UnparsedParser<IRemoteControlCommand>();
  }

  @override
  IResponse<IRemoteControlCommand> remoteControlResponse() {
    return UnparsedResponse<IRemoteControlCommand>(null);
  }

  @override
  IResponse<IRemoteControlCommand> remoteControlResponseWithResponse(String response) {
    return UnparsedResponse<IRemoteControlCommand>(response);
  }

  @override
  IRestartCommand restartCommand() {
    return RestartCommand(this);
  }

  @override
  IResponseParser<IRestartCommand, IResponse<IRestartCommand>> restartParser() {
    return UnparsedParser<IRestartCommand>();
  }

  @override
  IResponse<IRestartCommand> restartResponse() {
    return UnparsedResponse<IRestartCommand>(null);
  }

  @override
  IResponse<IRestartCommand> restartResponseWithResponse(String response) {
    return UnparsedResponse<IRestartCommand>(response);
  }

  @override
  IScreenshotCommand screenshotCommand() {
    return ScreenshotCommand(this);
  }

  @override
  IScreenshotResponse screenshotResponse() {
    return ScreenshotResponse(null);
  }

  @override
  IScreenshotResponse screenshotResponseWithBytes(List<int> screenshot) {
    return ScreenshotResponse(screenshot);
  }

  @override
  ISetVolumeCommand setVolumeCommand() {
    return SetVolumeCommand(this);
  }

  @override
  IResponseParser<ISetVolumeCommand, IResponse<ISetVolumeCommand>> setVolumeParser() {
    return UnparsedParser<ISetVolumeCommand>();
  }

  @override
  IResponse<ISetVolumeCommand> setVolumeResponse() {
    return UnparsedResponse<ISetVolumeCommand>(null);
  }

  @override
  IResponse<ISetVolumeCommand> setVolumeResponseWithResponse(String response) {
    return UnparsedResponse<ISetVolumeCommand>(response);
  }

  @override
  ISignalCommand signalCommand() {
    return SignalCommand(this);
  }

  @override
  IResponseParser<ISignalCommand, ISignalResponse> signalParser() {
    return SignalParser(this);
  }

  @override
  ISignalResponse signalResponse(ISignal signal) {
    return SignalResponse(signal);
  }

  @override
  ISleepCommand sleepCommand() {
    return SleepCommand(this);
  }

  @override
  IResponseParser<ISleepCommand, IResponse<ISleepCommand>> sleepParser() {
    return UnparsedParser<ISleepCommand>();
  }

  @override
  IResponse<ISleepCommand> sleepResponse() {
    return UnparsedResponse<ISleepCommand>(null);
  }

  @override
  IResponse<ISleepCommand> sleepResponseWithResponse(String response) {
    return UnparsedResponse<ISleepCommand>(response);
  }

  @override
  IVolumeStatus volumeStatus() {
    return VolumeStatus();
  }

  @override
  IVolumeStatusCommand volumeStatusCommand() {
    return VolumeStatusCommand(this);
  }

  @override
  IResponseParser<IVolumeStatusCommand, IVolumeStatusResponse> volumeStatusParser() {
    return VolumeStatusParser(this);
  }

  @override
  IVolumeStatusResponse volumeStatusResponse() {
    return VolumeStatusResponse(null);
  }

  @override
  IVolumeStatusResponse volumeStatusResponseWithResponse(IVolumeStatus status) {
    return VolumeStatusResponse(status);
  }

  @override
  IWakeUpCommand wakeUpCommand() {
    return WakeUpCommand(this);
  }

  @override
  IResponseParser<IWakeUpCommand, IResponse<IWakeUpCommand>> wakeUpParser() {
    return UnparsedParser<IWakeUpCommand>();
  }

  @override
  IResponse<IWakeUpCommand> wakeUpResponse() {
    return UnparsedResponse<IWakeUpCommand>(null);
  }

  @override
  IResponse<IWakeUpCommand> wakeUpResponseWithResponse(String response) {
    return UnparsedResponse<IWakeUpCommand>(response);
  }

  @override
  IWebRequester webRequester() {
    return WebRequester(log);
  }

  @override
  IZapCommand zapCommand() {
    return ZapCommand(this);
  }

  @override
  IResponseParser<IZapCommand, IResponse<IZapCommand>> zapParser() {
    return UnparsedParser<IZapCommand>();
  }

  @override
  IResponse<IZapCommand> zapResponse() {
    return UnparsedResponse<IZapCommand>(null);
  }

  @override
  IResponse<IZapCommand> zapResponseWithResponse(String response) {
    return UnparsedResponse<IZapCommand>(response);
  }
}
