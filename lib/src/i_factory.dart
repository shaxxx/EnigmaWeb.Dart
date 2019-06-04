import 'package:logging/logging.dart';

import './parsers/i_response_parser.dart';
import './responses/i_get_bouquet_items_response.dart';
import '../enigma_web.dart';
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
import 'i_bouquet_item.dart';
import 'i_bouquet_item_bouquet.dart';
import 'i_bouquet_item_marker.dart';
import 'i_bouquet_item_service.dart';
import 'i_bouquet_item_service_e1.dart';
import 'i_volume_status.dart';
import 'i_web_requester.dart';
import 'responses/i_get_bouquets_response.dart';
import 'responses/i_get_current_service_response.dart';
import 'responses/i_get_stream_parameters_response.dart';
import 'responses/i_power_state_response.dart';
import 'responses/i_response.dart';
import 'responses/i_screenshot_response.dart';
import 'responses/i_signal_response.dart';
import 'responses/i_volume_status_response.dart';

abstract class IFactory {
  Logger log;

  IGetCurrentServiceCommand getCurrentServiceCommand();

  IGetCurrentServiceResponse getCurrentServiceResponseWithService(IBouquetItemService service);

  IGetCurrentServiceResponse getCurrentServiceResponse();

  IResponseParser<IGetCurrentServiceCommand, IGetCurrentServiceResponse> getCurrentServiceParser();

  IBouquetItemService bouquetItemService();

  IBouquetItemServiceE1 bouquetItemServiceE1();

  IBouquetItemMarker bouquetItemMarker();

  IWebRequester webRequester();

  IWakeUpCommand wakeUpCommand();

  IResponse<IWakeUpCommand> wakeUpResponse();

  IResponse<IWakeUpCommand> wakeUpResponseWithResponse(String response);

  IResponseParser<IWakeUpCommand, IResponse<IWakeUpCommand>> wakeUpParser();

  IPowerStateCommand powerStateCommand();

  IPowerStateResponse powerStateResponse(bool standby);

  IResponseParser<IPowerStateCommand, IPowerStateResponse> powerStateParser();

  IGetBouquetsCommand getBouquetsCommand();

  IGetBouquetsResponse getBouquetsResponse();

  IGetBouquetsResponse getBouquetsResponseWithBouquets(List<IBouquetItemBouquet> bouquets);

  IResponseParser<IGetBouquetsCommand, IGetBouquetsResponse> getBouquetsParser();

  IBouquetItemBouquet bouquetItemBouquet();

  IGetBouquetItemsCommand getBouquetItemsCommand();

  IGetBouquetItemsResponse getBouquetItemsResponse();

  IGetBouquetItemsResponse getBouquetItemsResponseWithItems(List<IBouquetItem> items);

  IResponseParser<IGetBouquetItemsCommand, IGetBouquetItemsResponse> getBouquetItemsParser();

  ISignalCommand signalCommand();

  ISignalResponse signalResponse(ISignal signal);

  IE1Signal e1Signal();

  IE2Signal e2Signal();

  IResponseParser<ISignalCommand, ISignalResponse> signalParser();

  IZapCommand zapCommand();

  IResponse<IZapCommand> zapResponse();

  IResponse<IZapCommand> zapResponseWithResponse(String response);

  IResponseParser<IZapCommand, IResponse<IZapCommand>> zapParser();

  IScreenshotCommand screenshotCommand();

  IScreenshotResponse screenshotResponse();

  IScreenshotResponse screenshotResponseWithBytes(List<int> screenshot);

  IVolumeStatus volumeStatus();

  IVolumeStatusCommand volumeStatusCommand();

  IVolumeStatusResponse volumeStatusResponse();

  IVolumeStatusResponse volumeStatusResponseWithResponse(IVolumeStatus status);

  IResponseParser<IVolumeStatusCommand, IVolumeStatusResponse> volumeStatusParser();

  ISetVolumeCommand setVolumeCommand();

  IResponse<ISetVolumeCommand> setVolumeResponse();

  IResponse<ISetVolumeCommand> setVolumeResponseWithResponse(String response);

  IResponseParser<ISetVolumeCommand, IResponse<ISetVolumeCommand>> setVolumeParser();

  IRemoteControlCommand remoteControlCommand();

  IResponse<IRemoteControlCommand> remoteControlResponse();

  IResponse<IRemoteControlCommand> remoteControlResponseWithResponse(String response);

  IResponseParser<IRemoteControlCommand, IResponse<IRemoteControlCommand>> remoteControlParser();

  IMessageCommand messageCommand();

  IResponse<IMessageCommand> messageResponse();

  IResponse<IMessageCommand> messageResponseWithResponse(String response);

  IResponseParser<IMessageCommand, IResponse<IMessageCommand>> messageParser();

  IReloadSettingsCommand reloadSettingsCommand();

  IResponse<IReloadSettingsCommand> reloadSettingsResponse();

  IResponse<IReloadSettingsCommand> reloadSettingsResponseWithResponse(String response);

  IResponseParser<IReloadSettingsCommand, IResponse<IReloadSettingsCommand>> reloadSettingsParser();

  IGetStreamParametersCommand getStreamParametersCommand();

  IGetStreamParametersResponse getStreamParametersResponse();

  IGetStreamParametersResponse getStreamParametersResponseWithResponse(String response);

  IResponseParser<IGetStreamParametersCommand, IGetStreamParametersResponse>
      getStreamParametersParser();

  ISleepCommand sleepCommand();

  IResponse<ISleepCommand> sleepResponse();

  IResponse<ISleepCommand> sleepResponseWithResponse(String response);

  IResponseParser<ISleepCommand, IResponse<ISleepCommand>> sleepParser();

  IRestartCommand restartCommand();

  IResponse<IRestartCommand> restartResponse();

  IResponse<IRestartCommand> restartResponseWithResponse(String response);

  IResponseParser<IRestartCommand, IResponse<IRestartCommand>> restartParser();
}
