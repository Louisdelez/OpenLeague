package com.riotgames.platform.gameclient.module.services.maestro
{
   import com.riotgames.platform.common.event.GameChatEvent;
   import com.riotgames.platform.common.event.GameCrashedEvent;
   import com.riotgames.platform.common.utils.ServiceLogger;
   import com.riotgames.platform.gameclient.services.maestro.MaestroConstants;
   import com.riotgames.platform.gameclient.services.maestro.MaestroEnumerateClientVersionEvent;
   import com.riotgames.platform.gameclient.services.maestro.MaestroGetLatestClientVersionsEvent;
   import com.riotgames.platform.gameclient.services.maestro.MaestroMessage;
   import com.riotgames.platform.gameclient.services.maestro.MaestroProgressUpdateEvent;
   import com.riotgames.platform.gameclient.services.maestro.MaestroService;
   import com.riotgames.platform.gameclient.services.maestro.MaestroUpdatePlayerConnectionEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.Socket;
   import flash.utils.Endian;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class MaestroServiceImpl extends EventDispatcher implements MaestroService
   {
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_CREATE:int = 0;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_STOPPED:int = 1;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_CRASHED:int = 2;
      
      public static const MAESTROMESSAGETYPE_CLOSE:int = 3;
      
      public static const MAESTROMESSAGETYPE_HEARTBEAT:int = 4;
      
      public static const MAESTROMESSAGETYPE_REPLY:int = 5;
      
      public static const MAESTROMESSAGETYPE_LAUNCHERCLIENT:int = 6;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_ABANDONED:int = 7;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_LAUNCHED:int = 8;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_VERSION_MISMATCH:int = 9;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_CONNECTED_TO_SERVER:int = 10;
      
      public static const MAESTROMESSAGETYPE_CHATMESSAGE_TO_GAME:int = 11;
      
      public static const MAESTROMESSAGETYPE_CHATMESSAGE_FROM_GAME:int = 12;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_CREATE_VERSION:int = 13;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_INSTALL_VERSION:int = 14;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_CANCEL_INSTALL:int = 15;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_INSTALL_PROGRESS:int = 16;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_INSTALL_PREVIEW:int = 17;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_CANCEL_PREVIEW:int = 18;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_PREVIEW_PROGRESS:int = 19;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_PLAY_REPLAY:int = 20;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_UNINSTALL_VERSION:int = 21;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_CANCEL_UNINSTALL:int = 22;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_UNINSTALL_PROGRESS:int = 23;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_UNINSTALL_PREVIEW:int = 24;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_CANCEL_UNINSTALL_PREVIEW:int = 25;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_PREVIEW_UNINSTALL_PROGRESS:int = 26;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_ENUMERATE_VERSIONS:int = 27;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_CREATE_CLIENT_AND_PRELOAD:int = 28;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_UPDATE_PRELOADED_GAME_WITH_CREDENTIALS:int = 29;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_INITIAL_PRELOAD_COMPLETE:int = 30;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_UPDATE_PLAYER_CONNECTION:int = 31;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_PLAY_PRELOADED_GAME:int = 32;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_GAME_LOADING_COMPLETE:int = 33;
      
      public static const MAESTROMESSAGETYPE_KILL_GAMECLIENT_PROCESS:int = 34;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_ENUMERATE_UNINSTALLABLE_VERSIONS:int = 35;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_ENUMERATE_LATEST_VERSIONS:int = 36;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_INSTALLED_VERSIONS_SIZES:int = 37;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_INSTALLED_VERSIONS_SIZES_PROGRESS:int = 38;
      
      public static const MAESTROMESSAGETYPE_GAMECLIENT_CANCEL_INSTALLED_VERSIONS_SIZES:int = 39;
      
      public static const MAESTROMESSAGETYPE_INVALID:int = 40;
      
      private var port:int;
      
      private var lastHeartbeat:Date = new Date();
      
      private var isOnProbation:Boolean;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private const MAX_HEARTBEAT_WAIT_INTERVAL:int = 75000;
      
      private const HEARTBEAT_INTERVAL:int = 25000;
      
      private var currentMessage:MaestroMessage = null;
      
      private var checkHeartbeatTimer:Timer = new Timer(this.HEARTBEAT_INTERVAL);
      
      private var sendHeartbeatTimer:Timer = new Timer(this.HEARTBEAT_INTERVAL);
      
      private var socket:Socket = new Socket();
      
      public function MaestroServiceImpl()
      {
         super();
      }
      
      public function requestInstalledGameVersionsSizesProgress() : void
      {
         var _loc1_:MaestroMessage = new MaestroMessage();
         _loc1_.setType(MAESTROMESSAGETYPE_GAMECLIENT_INSTALLED_VERSIONS_SIZES_PROGRESS);
         this.sendMessage(_loc1_);
      }
      
      public function sendKillGameClientProcessRequest() : void
      {
         var _loc1_:MaestroMessage = new MaestroMessage();
         _loc1_.setType(MAESTROMESSAGETYPE_KILL_GAMECLIENT_PROCESS);
         this.sendMessage(_loc1_);
         ServiceLogger.requestMaestro("sendKillGameClientProcessRequest");
      }
      
      public function start(param1:int) : void
      {
         this.port = param1;
         this.socket.endian = Endian.LITTLE_ENDIAN;
         this.socket.addEventListener(Event.CLOSE,this.closeHandler);
         this.socket.addEventListener(Event.CONNECT,this.connectHandler);
         this.socket.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         this.socket.addEventListener(ProgressEvent.SOCKET_DATA,this.socketDataHandler);
         this.sendHeartbeatTimer.addEventListener(TimerEvent.TIMER,this.sendHeartbeat);
         this.sendHeartbeatTimer.start();
         this.checkHeartbeatTimer.addEventListener(TimerEvent.TIMER,this.heartbeatCheck);
         this.checkHeartbeatTimer.start();
         this.socket.connect("127.0.0.1",this.port);
         ServiceLogger.requestMaestro("start",[param1]);
      }
      
      private function connectHandler(param1:Event) : void
      {
         var _loc2_:Event = new Event(MaestroConstants.MAESTROCONNECTED_EVENT);
         dispatchEvent(_loc2_);
      }
      
      public function cancelUninstall() : void
      {
         var _loc1_:MaestroMessage = new MaestroMessage();
         _loc1_.setType(MAESTROMESSAGETYPE_GAMECLIENT_CANCEL_UNINSTALL);
         this.sendMessage(_loc1_);
      }
      
      public function requestUninstallPreviewProgress() : void
      {
         var _loc1_:MaestroMessage = new MaestroMessage();
         _loc1_.setType(MAESTROMESSAGETYPE_GAMECLIENT_PREVIEW_UNINSTALL_PROGRESS);
         this.sendMessage(_loc1_);
      }
      
      private function processSocketData() : Boolean
      {
         if(this.currentMessage == null)
         {
            return this.processMessageHeader();
         }
         return this.processMessageContent();
      }
      
      private function onMaestroHeartbeatReceived() : void
      {
         this.isOnProbation = false;
         this.lastHeartbeat = new Date();
      }
      
      private function processMessageContent() : Boolean
      {
         if(this.socket.bytesAvailable < this.currentMessage.getPayloadSize())
         {
            return false;
         }
         this.currentMessage.setPayload(this.socket.readUTFBytes(this.currentMessage.getPayloadSize()));
         this.fireMaestroMessage(this.currentMessage);
         this.currentMessage = null;
         return true;
      }
      
      public function uninstallVersion(param1:String) : void
      {
         var _loc2_:MaestroMessage = new MaestroMessage();
         _loc2_.setType(MAESTROMESSAGETYPE_GAMECLIENT_UNINSTALL_VERSION);
         _loc2_.setPayload(param1);
         this.sendMessage(_loc2_);
      }
      
      private function sendMessage(param1:MaestroMessage) : void
      {
         var _loc2_:Event = null;
         if(this.socket.connected)
         {
            this.socket.writeInt(param1.getSize());
            this.socket.writeInt(param1.getVersion());
            this.socket.writeInt(param1.getType());
            this.socket.writeInt(param1.getPayloadSize());
            if(param1.getPayloadSize() > 0)
            {
               this.socket.writeBytes(param1.getPayloadBytes());
            }
            this.socket.flush();
         }
         else
         {
            this.logger.error("0001 Error sending message through Maestro: Connection closed.\nMessage Type: " + param1.getType());
            _loc2_ = new Event(MaestroConstants.MAESTROCONNECTIONFAILED_EVENT);
            dispatchEvent(_loc2_);
         }
      }
      
      public function getInstalledGameVersionsSizes() : void
      {
         var _loc1_:MaestroMessage = new MaestroMessage();
         _loc1_.setType(MAESTROMESSAGETYPE_GAMECLIENT_INSTALLED_VERSIONS_SIZES);
         this.sendMessage(_loc1_);
      }
      
      public function stopHeartbeat() : void
      {
         this.sendHeartbeatTimer.stop();
      }
      
      public function enumerateGameClientVersions() : void
      {
         var _loc1_:MaestroMessage = new MaestroMessage();
         _loc1_.setType(MAESTROMESSAGETYPE_GAMECLIENT_ENUMERATE_VERSIONS);
         this.sendMessage(_loc1_);
      }
      
      public function cancelInstalledGameVersionsSizes() : void
      {
         var _loc1_:MaestroMessage = new MaestroMessage();
         _loc1_.setType(MAESTROMESSAGETYPE_GAMECLIENT_CANCEL_INSTALLED_VERSIONS_SIZES);
         this.sendMessage(_loc1_);
      }
      
      public function cancelUninstallPreview() : void
      {
         var _loc1_:MaestroMessage = new MaestroMessage();
         _loc1_.setType(MAESTROMESSAGETYPE_GAMECLIENT_CANCEL_UNINSTALL_PREVIEW);
         this.sendMessage(_loc1_);
      }
      
      public function sendPlayPreloadedGameMessage() : void
      {
         var _loc1_:MaestroMessage = new MaestroMessage();
         _loc1_.setType(MAESTROMESSAGETYPE_GAMECLIENT_PLAY_PRELOADED_GAME);
         this.sendMessage(_loc1_);
         ServiceLogger.requestMaestro("sendPlayPreloadedGameMessage");
      }
      
      private function closeHandler(param1:Event) : void
      {
      }
      
      public function sendCloseRequest() : void
      {
         var _loc1_:MaestroMessage = new MaestroMessage();
         _loc1_.setType(MAESTROMESSAGETYPE_CLOSE);
         this.sendMessage(_loc1_);
         ServiceLogger.requestMaestro("sendCloseRequest");
      }
      
      private function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
      }
      
      public function installVersion(param1:String) : void
      {
         var _loc2_:MaestroMessage = new MaestroMessage();
         _loc2_.setType(MAESTROMESSAGETYPE_GAMECLIENT_INSTALL_VERSION);
         _loc2_.setPayload(param1);
         this.sendMessage(_loc2_);
      }
      
      public function sendUpdatePreloadedGameWithCredentialsMessage(param1:String) : void
      {
         var _loc2_:MaestroMessage = new MaestroMessage();
         _loc2_.setType(MAESTROMESSAGETYPE_GAMECLIENT_UPDATE_PRELOADED_GAME_WITH_CREDENTIALS);
         _loc2_.setPayload(param1);
         this.sendMessage(_loc2_);
         ServiceLogger.requestMaestro("sendUpdatePreloadedGameWithCredentialsMessage");
      }
      
      private function processMessageHeader() : Boolean
      {
         if(this.socket.bytesAvailable < MaestroMessage.MESSAGE_HEADERSIZE)
         {
            return false;
         }
         var _loc1_:int = this.socket.readInt();
         var _loc2_:int = this.socket.readInt();
         var _loc3_:int = this.socket.readInt();
         var _loc4_:int = this.socket.readInt();
         if(_loc1_ != MaestroMessage.MESSAGE_HEADERSIZE)
         {
            throw "Unexpected message size. Expected: " + MaestroMessage.MESSAGE_HEADERSIZE + " Actual: " + _loc1_;
         }
         if(_loc2_ != MaestroMessage.MESSAGE_VERSION)
         {
            throw "Unexpected message version. Expected: " + MaestroMessage.MESSAGE_VERSION + " Actual: " + _loc2_;
         }
         if(_loc3_ > MAESTROMESSAGETYPE_INVALID)
         {
            _loc3_ = MAESTROMESSAGETYPE_INVALID;
         }
         var _loc5_:MaestroMessage = new MaestroMessage();
         _loc5_.setType(_loc3_);
         _loc5_.setPayloadSize(_loc4_);
         if(_loc5_.getPayloadSize() == 0)
         {
            this.fireMaestroMessage(_loc5_);
         }
         else
         {
            this.currentMessage = _loc5_;
         }
         return true;
      }
      
      public function sendCreateClientAndPreloadRequest(param1:String) : void
      {
         var _loc2_:MaestroMessage = new MaestroMessage();
         _loc2_.setType(MAESTROMESSAGETYPE_GAMECLIENT_CREATE_CLIENT_AND_PRELOAD);
         _loc2_.setPayload(param1);
         this.sendMessage(_loc2_);
         ServiceLogger.requestMaestro("sendCreateClientAndPreloadRequest");
      }
      
      public function cancelInstallPreview() : void
      {
         var _loc1_:MaestroMessage = new MaestroMessage();
         _loc1_.setType(MAESTROMESSAGETYPE_GAMECLIENT_CANCEL_PREVIEW);
         this.sendMessage(_loc1_);
      }
      
      public function installVersionPreview(param1:String) : void
      {
         var _loc2_:MaestroMessage = new MaestroMessage();
         _loc2_.setType(MAESTROMESSAGETYPE_GAMECLIENT_INSTALL_PREVIEW);
         _loc2_.setPayload(param1);
         this.sendMessage(_loc2_);
      }
      
      private function socketDataHandler(param1:ProgressEvent) : void
      {
         var _loc2_:Boolean = true;
         while(_loc2_)
         {
            _loc2_ = this.processSocketData();
         }
      }
      
      public function enableHeartbeatCheck() : void
      {
         if(!this.checkHeartbeatTimer.running)
         {
            this.checkHeartbeatTimer.start();
         }
      }
      
      public function cancelInstall() : void
      {
         var _loc1_:MaestroMessage = new MaestroMessage();
         _loc1_.setType(MAESTROMESSAGETYPE_GAMECLIENT_CANCEL_INSTALL);
         this.sendMessage(_loc1_);
      }
      
      private function sendHeartbeat(param1:TimerEvent) : void
      {
         var _loc2_:MaestroMessage = new MaestroMessage();
         _loc2_.setType(MAESTROMESSAGETYPE_HEARTBEAT);
         this.sendMessage(_loc2_);
      }
      
      public function fireMaestroMessage(param1:MaestroMessage) : void
      {
         var _loc2_:Event = null;
         var _loc3_:Event = null;
         var _loc4_:Event = null;
         var _loc5_:Event = null;
         var _loc6_:Event = null;
         var _loc7_:MaestroProgressUpdateEvent = null;
         var _loc8_:MaestroProgressUpdateEvent = null;
         var _loc9_:MaestroProgressUpdateEvent = null;
         var _loc10_:MaestroProgressUpdateEvent = null;
         var _loc11_:MaestroProgressUpdateEvent = null;
         var _loc12_:MaestroEnumerateClientVersionEvent = null;
         var _loc13_:Event = null;
         var _loc14_:Event = null;
         var _loc15_:MaestroEnumerateClientVersionEvent = null;
         var _loc16_:MaestroGetLatestClientVersionsEvent = null;
         switch(param1.getType())
         {
            case MAESTROMESSAGETYPE_GAMECLIENT_STOPPED:
               ServiceLogger.responseMaestro("gameClientStopped",[param1]);
               _loc2_ = new Event(MaestroConstants.GAMECLIENTSTOPPED_EVENT);
               dispatchEvent(_loc2_);
               break;
            case MAESTROMESSAGETYPE_GAMECLIENT_CRASHED:
               ServiceLogger.responseMaestro("gameClientCrashed",[param1]);
               dispatchEvent(new GameCrashedEvent(param1.getPayloadString()));
               break;
            case MAESTROMESSAGETYPE_GAMECLIENT_ABANDONED:
               ServiceLogger.responseMaestro("gameClientAbandoned",[param1]);
               _loc3_ = new Event(MaestroConstants.GAME_CLIENT_ABANDONED);
               dispatchEvent(_loc3_);
               break;
            case MAESTROMESSAGETYPE_GAMECLIENT_LAUNCHED:
               ServiceLogger.responseMaestro("gameClientLaunched",[param1]);
               _loc4_ = new Event(MaestroConstants.GAME_CLIENT_LAUNCHED);
               dispatchEvent(_loc4_);
               break;
            case MAESTROMESSAGETYPE_GAMECLIENT_VERSION_MISMATCH:
               ServiceLogger.responseMaestro("gameClientVersionMismatch",[param1]);
               _loc5_ = new Event(MaestroConstants.GAME_CLIENT_VERSION_MISMATCH);
               dispatchEvent(_loc5_);
               break;
            case MAESTROMESSAGETYPE_GAMECLIENT_CONNECTED_TO_SERVER:
               ServiceLogger.responseMaestro("gameClientConnectedToServer",[param1]);
               _loc6_ = new Event(MaestroConstants.GAME_CLIENT_CONNECTED_TO_SERVER);
               dispatchEvent(_loc6_);
               break;
            case MAESTROMESSAGETYPE_HEARTBEAT:
               this.onMaestroHeartbeatReceived();
               break;
            case MAESTROMESSAGETYPE_CHATMESSAGE_FROM_GAME:
               ServiceLogger.responseMaestro("chatMessageFromGame",[param1]);
               dispatchEvent(new GameChatEvent(param1.getPayloadString()));
               break;
            case MAESTROMESSAGETYPE_GAMECLIENT_INSTALL_PROGRESS:
               _loc7_ = new MaestroProgressUpdateEvent(MaestroConstants.INSTALL_PROGRESS_UPDATE,param1.getPayloadString());
               dispatchEvent(_loc7_);
               break;
            case MAESTROMESSAGETYPE_GAMECLIENT_UNINSTALL_PROGRESS:
               _loc8_ = new MaestroProgressUpdateEvent(MaestroConstants.UNINSTALL_PROGRESS_UPDATE,param1.getPayloadString());
               dispatchEvent(_loc8_);
               break;
            case MAESTROMESSAGETYPE_GAMECLIENT_PREVIEW_PROGRESS:
               _loc9_ = new MaestroProgressUpdateEvent(MaestroConstants.PREVIEW_PROGRESS_UPDATE,param1.getPayloadString());
               dispatchEvent(_loc9_);
               break;
            case MAESTROMESSAGETYPE_GAMECLIENT_INSTALLED_VERSIONS_SIZES_PROGRESS:
               _loc10_ = new MaestroProgressUpdateEvent(MaestroConstants.GET_INSTALLED_GAME_CLIENT_VERSIONS_SIZES_PROGRESS,param1.getPayloadString());
               dispatchEvent(_loc10_);
               break;
            case MAESTROMESSAGETYPE_GAMECLIENT_PREVIEW_UNINSTALL_PROGRESS:
               _loc11_ = new MaestroProgressUpdateEvent(MaestroConstants.PREVIEW_UNINSTALL_PROGRESS_UPDATE,param1.getPayloadString());
               dispatchEvent(_loc11_);
               break;
            case MAESTROMESSAGETYPE_GAMECLIENT_ENUMERATE_VERSIONS:
               ServiceLogger.responseMaestro("enumerateGameClientVersions",[param1]);
               _loc12_ = new MaestroEnumerateClientVersionEvent(MaestroConstants.ENUMERATE_GAME_CLIENT_VERSIONS,param1.getPayloadString());
               dispatchEvent(_loc12_);
               break;
            case MAESTROMESSAGETYPE_GAMECLIENT_INITIAL_PRELOAD_COMPLETE:
               break;
            case MAESTROMESSAGETYPE_GAMECLIENT_UPDATE_PLAYER_CONNECTION:
               ServiceLogger.responseMaestro("updatePlayerConnection",[param1]);
               _loc13_ = new MaestroUpdatePlayerConnectionEvent(MaestroConstants.UPDATE_PLAYER_CONNECTION,param1.getPayloadString());
               dispatchEvent(_loc13_);
               break;
            case MAESTROMESSAGETYPE_GAMECLIENT_GAME_LOADING_COMPLETE:
               ServiceLogger.responseMaestro("gameLoadingComplete",[param1]);
               _loc14_ = new Event(MaestroConstants.GAME_LOADING_COMPLETE);
               dispatchEvent(_loc14_);
               break;
            case MAESTROMESSAGETYPE_GAMECLIENT_ENUMERATE_UNINSTALLABLE_VERSIONS:
               ServiceLogger.responseMaestro("enumerateUninstallableGameClientVersions",[param1]);
               _loc15_ = new MaestroEnumerateClientVersionEvent(MaestroConstants.ENUMERATE_UNINSTALLABLE_GAME_CLIENT_VERSIONS,param1.getPayloadString());
               dispatchEvent(_loc15_);
               break;
            case MAESTROMESSAGETYPE_GAMECLIENT_ENUMERATE_LATEST_VERSIONS:
               ServiceLogger.responseMaestro("enumerateLatestGameClientVersions",[param1]);
               _loc16_ = new MaestroGetLatestClientVersionsEvent(MaestroConstants.ENUMERATE_LATEST_GAME_CLIENT_VERSIONS,param1.getPayloadString());
               dispatchEvent(_loc16_);
               break;
            case MAESTROMESSAGETYPE_INVALID:
               throw "Invalid message received.";
         }
      }
      
      public function requestInstallProgress() : void
      {
         var _loc1_:MaestroMessage = new MaestroMessage();
         _loc1_.setType(MAESTROMESSAGETYPE_GAMECLIENT_INSTALL_PROGRESS);
         this.sendMessage(_loc1_);
      }
      
      public function sendCreateGameClientRequest(param1:String) : void
      {
         var _loc2_:MaestroMessage = new MaestroMessage();
         _loc2_.setType(MAESTROMESSAGETYPE_GAMECLIENT_CREATE);
         _loc2_.setPayload(param1);
         this.sendMessage(_loc2_);
         ServiceLogger.requestMaestro("sendCreateGameClientRequest",[param1]);
      }
      
      public function uninstallVersionPreview(param1:String) : void
      {
         var _loc2_:MaestroMessage = new MaestroMessage();
         _loc2_.setType(MAESTROMESSAGETYPE_GAMECLIENT_UNINSTALL_PREVIEW);
         _loc2_.setPayload(param1);
         this.sendMessage(_loc2_);
      }
      
      public function sendChatMessage(param1:String) : void
      {
         var _loc2_:MaestroMessage = new MaestroMessage();
         _loc2_.setType(MAESTROMESSAGETYPE_CHATMESSAGE_TO_GAME);
         _loc2_.setPayload(param1);
         this.sendMessage(_loc2_);
         ServiceLogger.requestMaestro("sendChatMessage",[param1]);
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
         var _loc2_:Event = new Event(MaestroConstants.MAESTROCONNECTIONFAILED_EVENT);
         dispatchEvent(_loc2_);
      }
      
      public function sendCreateGameClientFromVersionRequest(param1:String) : void
      {
         var _loc2_:MaestroMessage = new MaestroMessage();
         _loc2_.setType(MAESTROMESSAGETYPE_GAMECLIENT_CREATE_VERSION);
         _loc2_.setPayload(param1);
         this.sendMessage(_loc2_);
         ServiceLogger.requestMaestro("sendCreateGameClientFromVersionRequest",[param1]);
      }
      
      private function heartbeatCheck(param1:TimerEvent) : void
      {
         var _loc2_:Event = null;
         if(new Date().time > this.lastHeartbeat.getTime() + this.MAX_HEARTBEAT_WAIT_INTERVAL)
         {
            this.logger.warn("0002 Maestro.heartbeatCheck: No Maestro heartbeat was received.");
            if(this.isOnProbation)
            {
               this.logger.fatal("0003 Maestro.heartbeatCheck: Maestro was on probation and no heartbeat has been detected.  Application will shutdown.");
               _loc2_ = new Event(MaestroConstants.HEARTBEATFAILED_EVENT);
               dispatchEvent(_loc2_);
            }
            else
            {
               this.logger.warn("0004 Maestro.heartbeatCheck: Maestro is being placed on probation since no heartbeat has been detected.");
               this.isOnProbation = true;
            }
         }
      }
      
      public function requestUninstallProgress() : void
      {
         var _loc1_:MaestroMessage = new MaestroMessage();
         _loc1_.setType(MAESTROMESSAGETYPE_GAMECLIENT_UNINSTALL_PROGRESS);
         this.sendMessage(_loc1_);
      }
      
      public function requestInstallPreviewProgress() : void
      {
         var _loc1_:MaestroMessage = new MaestroMessage();
         _loc1_.setType(MAESTROMESSAGETYPE_GAMECLIENT_PREVIEW_PROGRESS);
         this.sendMessage(_loc1_);
      }
      
      public function disableHeartbeatCheck() : void
      {
         if(this.checkHeartbeatTimer.running)
         {
            this.checkHeartbeatTimer.stop();
            this.checkHeartbeatTimer.reset();
         }
      }
      
      public function getLatestGameClientVersions(param1:String) : void
      {
         var _loc2_:MaestroMessage = new MaestroMessage();
         _loc2_.setType(MAESTROMESSAGETYPE_GAMECLIENT_ENUMERATE_LATEST_VERSIONS);
         _loc2_.setPayload(param1);
         this.sendMessage(_loc2_);
      }
      
      public function enumerateUninstallableGameClientVersions() : void
      {
         var _loc1_:MaestroMessage = new MaestroMessage();
         _loc1_.setType(MAESTROMESSAGETYPE_GAMECLIENT_ENUMERATE_UNINSTALLABLE_VERSIONS);
         this.sendMessage(_loc1_);
      }
   }
}

