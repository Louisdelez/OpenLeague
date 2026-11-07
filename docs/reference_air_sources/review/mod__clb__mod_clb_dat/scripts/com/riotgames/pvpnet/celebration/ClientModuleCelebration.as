package com.riotgames.pvpnet.celebration
{
   import blix.action.IAction;
   import com.riotgames.platform.common.provider.ChromeContextAlertProviderProxy;
   import com.riotgames.platform.common.provider.ICLSProvider;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.IPresenceProvider;
   import com.riotgames.platform.gameclient.contextAlert.AlertLocation;
   import com.riotgames.platform.gameclient.contextAlert.AlertParameters;
   import com.riotgames.platform.gameclient.domain.celebration.SimpleDialogMessage;
   import com.riotgames.platform.gameclient.domain.celebration.SimpleDialogMessageResponse;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.celebration.enums.CelebrationConstants;
   import com.riotgames.pvpnet.celebration.enums.ReportReasonConstants;
   import com.riotgames.pvpnet.celebration.enums.RestrictionType;
   import com.riotgames.pvpnet.celebration.views.ICelebrationDialog;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.LoginConfig;
   import com.riotgames.pvpnet.system.localization.action.LoadModuleResourceBundleAction;
   import com.riotgames.rust.popup.PopUpManager;
   import com.riotgames.util.json.jsonDecode;
   import flash.desktop.NativeApplication;
   import flash.display.NativeWindow;
   import flash.display.NativeWindowDisplayState;
   import flash.display.Sprite;
   import flash.events.NativeWindowDisplayStateEvent;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import mx.collections.ArrayCollection;
   import mx.messaging.events.MessageEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class ClientModuleCelebration extends Sprite implements IProviderModule, ICelebrationProvider
   {
      
      public static const CELEBRATION_RESOURCE_ID:String = "Celebration";
      
      public static const TEAM_BUILDER_ROLE_ICON_CELEBRATION:String = "TB_GRANT_ROLE_ICON";
      
      public static const TEAM_BUILDER_ICON_PROGRESS:String = "TB_REMAINING_ROLE_ICON";
      
      public static const FIRST_TIME_LEAVER_WARNING:String = "leaver-buster-tainted-warning";
      
      public static const LEAVER_BUSTER_PUNISHMENT_INCURRED:String = "leaver-buster-punishment-incurred";
      
      public static const LEAVER_BUSTER_PUNISHED_GAMES_REMAINING:String = "leaver-buster-punished-games-remaining";
      
      public static const LEAVER_BUSTER_REFORMING:String = "leaver-buster-reforming";
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var _celebrationDialogFactory:CelebrationDialogFactory;
      
      private var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      private var inventory:IInventory;
      
      private var leagues:ICLSProvider;
      
      private var presenceProvider:IPresenceProvider;
      
      private var _dialogShown:Boolean = false;
      
      private var _delayedMessages:Vector.<SimpleDialogMessage>;
      
      private var _alertsToAckDictionary:Dictionary = new Dictionary();
      
      public function ClientModuleCelebration()
      {
         super();
         var _loc1_:NativeWindow = NativeApplication.nativeApplication.openedWindows[0];
         _loc1_.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,this.handleWindowDisplayStateChanged);
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this._delayedMessages = new Vector.<SimpleDialogMessage>();
         this._moduleInfo = param1;
         this.loadLocalizedResources();
         ProviderLookup.getProvider(IInventoryProvider,this.onInventoryProvider);
         ProviderLookup.getProvider(ICLSProvider,this.onLeagueSystemProvider);
         ProviderLookup.getProvider(IPresenceProvider,this.onPresenceProvider);
         ChromeContextAlertProviderProxy.instance.getActiveAlertChanged().add(this.handleActiveContextAlertChanged);
      }
      
      private function onInventoryProvider(param1:IInventoryProvider) : void
      {
         this.inventory = param1.getInventory();
      }
      
      private function onLeagueSystemProvider(param1:ICLSProvider) : void
      {
         this.leagues = param1;
      }
      
      private function onPresenceProvider(param1:IPresenceProvider) : void
      {
         this.presenceProvider = param1;
      }
      
      private function loadLocalizedResources() : void
      {
         var _loc1_:String = this.getCurrentLocale();
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:IAction = new LoadModuleResourceBundleAction(_loc2_,_loc1_,"Celebration","Celebration","clb",ClientConfig.instance.debugLocale);
         _loc3_.getCompleted().addOnce(this.onResourceBundleLoaded);
         _loc3_.invoke();
      }
      
      private function onResourceBundleLoaded() : void
      {
         ProviderLookup.publishProvider(ICelebrationProvider,this);
         this.serviceProxy = ServiceProxy.instance;
         this.serviceProxy.messageRouterService.addClientNotificationMessageListener(this.onClientNotificationMessageRecieved);
         setTimeout(this.processLoginDataPacket,5000);
      }
      
      private function processLoginDataPacket() : void
      {
         var _loc2_:SimpleDialogMessage = null;
         var _loc1_:ArrayCollection = LoginConfig.instance.celebrationMessages;
         if(_loc1_ != null)
         {
            for each(_loc2_ in _loc1_)
            {
               this.onSimpleDialogMessageRecieved(_loc2_);
            }
         }
         this.processDecayNotifications();
      }
      
      private function processDecayNotifications() : void
      {
         if(ClientConfig.instance.leagueServiceEnabled)
         {
            ProviderLookup.getProvider(ICLSProvider,function(param1:ICLSProvider):void
            {
               if(ClientConfig.instance.leaguesDecayMessagingEnabled)
               {
                  param1.processDecayMessages();
               }
            });
         }
      }
      
      private function getCurrentLocale() : String
      {
         return ClientConfig.instance.locale;
      }
      
      private function onClientNotificationMessageRecieved(param1:MessageEvent) : void
      {
         var _loc2_:Object = param1.message.body;
         if(_loc2_ is SimpleDialogMessage)
         {
            this.onSimpleDialogMessageRecieved(SimpleDialogMessage(_loc2_));
         }
      }
      
      private function onSimpleDialogMessageRecieved(param1:SimpleDialogMessage) : void
      {
         var _loc2_:NativeWindow = NativeApplication.nativeApplication.openedWindows[0];
         if(_loc2_.displayState != NativeWindowDisplayState.MINIMIZED)
         {
            switch(param1.type)
            {
               case "giftReceiver":
                  this.onCelebrationForReceiver(param1);
                  break;
               case "giftDelivered":
                  this.onCelebrationForDelivered(param1);
                  break;
               case "leagues":
                  this.handleLeagueMessage(param1);
                  break;
               case "harassment.restriction":
                  this.showHarassmentMessage(param1);
                  break;
               case "harassment.reported.alert":
                  this.showReportedMessage(param1);
                  break;
               case "ready_check.penalty.warning":
                  this.showReadyCheckDodgeWarning(param1);
                  break;
               case "ready_check.penalty.applied":
                  this.showReadyCheckDodgeApplied(param1);
                  break;
               case TEAM_BUILDER_ROLE_ICON_CELEBRATION:
                  this.onTeamBuilderRoleIconCelebration(param1);
                  break;
               case TEAM_BUILDER_ICON_PROGRESS:
                  this.onTeamBuilderRoleIconProgress(param1);
                  break;
               case FIRST_TIME_LEAVER_WARNING:
                  this.onFirstTimeLeaverWarning(param1);
                  break;
               case LEAVER_BUSTER_PUNISHMENT_INCURRED:
                  this.onLeaverBusterPunishmentIncurred(param1);
                  break;
               case LEAVER_BUSTER_PUNISHED_GAMES_REMAINING:
                  this.onLeaverBusterGamesRemaining(param1);
                  break;
               case LEAVER_BUSTER_REFORMING:
                  this.onLeaverBusterReforming(param1);
            }
         }
         else
         {
            this.pushSimpleDialogMessage(param1);
         }
      }
      
      private function onLeaverBusterPunishmentIncurred(param1:SimpleDialogMessage) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:AlertAction = null;
         try
         {
            _loc2_ = jsonDecode(param1.params[0]);
            _loc3_ = int(_loc2_["punishedGamesRemaining"]);
            _loc4_ = RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,"leaver_buster_notification_title","LeaverBuster");
            _loc5_ = RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,"leaver_buster_punishment_incurred","LeaverBuster Punishment Incurred",[_loc3_]);
            _loc6_ = new AlertAction(_loc4_,_loc5_);
            _loc6_.add();
         }
         catch(e:Error)
         {
         }
         this.doAckForDialogMessage(param1);
      }
      
      private function onLeaverBusterGamesRemaining(param1:SimpleDialogMessage) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:AlertParameters = null;
         try
         {
            _loc2_ = jsonDecode(param1.params[0]);
            _loc3_ = int(_loc2_["punishedGamesRemaining"]);
            _loc4_ = new AlertParameters();
            _loc4_.location = AlertLocation.DEFAULT_POSITION;
            _loc4_.title = RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,"leaver_buster_notification_title","LeaverBuster");
            _loc4_.message = RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,"leaver_buster_punished_games_remaining","Leaver Buster Games Remaining",[_loc3_]);
            ChromeContextAlertProviderProxy.instance.showAlertForParameters(_loc4_);
         }
         catch(e:Error)
         {
         }
         this.doAckForDialogMessage(param1);
      }
      
      private function onLeaverBusterReforming(param1:SimpleDialogMessage) : void
      {
         var _loc2_:AlertParameters = new AlertParameters();
         _loc2_.location = AlertLocation.DEFAULT_POSITION;
         _loc2_.title = RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,"leaver_buster_notification_title","LeaverBuster");
         _loc2_.message = RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,"leaver_buster_reforming","Leaver Buster Reforming");
         ChromeContextAlertProviderProxy.instance.showAlertForParameters(_loc2_);
         this.doAckForDialogMessage(param1);
      }
      
      private function onFirstTimeLeaverWarning(param1:SimpleDialogMessage) : void
      {
         if(this._dialogShown && Boolean(param1))
         {
            this.pushSimpleDialogMessage(param1);
            return;
         }
         this._dialogShown = true;
         if(this._celebrationDialogFactory == null)
         {
            this._celebrationDialogFactory = new CelebrationDialogFactory(null,this._moduleInfo);
         }
         var _loc2_:ICelebrationDialog = this._celebrationDialogFactory.getFirstTimeLeaverDialogue();
         _loc2_.setModel(param1,null);
         _loc2_.getDialogDismissed().addOnce(this.handleFirstTimeLeaverDialogueDismissed);
         PopUpManager.addPopUp(_loc2_,null,true);
      }
      
      private function onTeamBuilderRoleIconCelebration(param1:SimpleDialogMessage) : void
      {
         if(this._dialogShown)
         {
            this.pushSimpleDialogMessage(param1);
            return;
         }
         this._dialogShown = true;
         if(this._celebrationDialogFactory == null)
         {
            this._celebrationDialogFactory = new CelebrationDialogFactory(null,this._moduleInfo);
         }
         var _loc2_:ICelebrationDialog = this._celebrationDialogFactory.getTeamBuilderCelebrationDialog();
         _loc2_.setModel(param1,null);
         _loc2_.getDialogDismissed().addOnce(this.handleDialogForReceivedDismissed);
         PopUpManager.addPopUp(_loc2_,null,true);
      }
      
      private function onTeamBuilderRoleIconProgress(param1:SimpleDialogMessage) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:AlertParameters = null;
         this.doAckForDialogMessage(param1);
         try
         {
            _loc2_ = jsonDecode(param1.params[0]);
            _loc3_ = int(_loc2_["gamesRemaining"]);
            _loc4_ = RiotResourceLoader.getResourceString(ClientModuleCelebration.CELEBRATION_RESOURCE_ID,"role_icon_" + String(_loc2_["roleName"]).toLowerCase(),"##Icon Name");
            _loc5_ = int(_loc2_["threshold"]);
            _loc6_ = _loc5_ - _loc3_;
            if(_loc5_ <= 0 || _loc6_ <= 0)
            {
               return;
            }
            _loc7_ = RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,"summoner_icon_progress_title","My Role Progress");
            _loc8_ = RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,"summoner_icon_progess_body","Progress Info",[_loc6_,_loc5_,_loc4_]);
            _loc9_ = new AlertParameters();
            _loc9_.location = AlertLocation.DEFAULT_POSITION;
            _loc9_.message = _loc8_;
            _loc9_.title = _loc7_;
            ChromeContextAlertProviderProxy.instance.showAlertForParameters(_loc9_);
         }
         catch(e:Error)
         {
         }
      }
      
      private function handleLeagueMessage(param1:SimpleDialogMessage) : void
      {
         var messageObject:Object;
         var message:SimpleDialogMessage = param1;
         if(this._dialogShown)
         {
            this.pushSimpleDialogMessage(message);
            return;
         }
         messageObject = jsonDecode(message.params[0]);
         if(this.leagues.processLatestMessage(messageObject))
         {
            this._dialogShown = true;
            PopUpManager.instance.getInModalModeChanged().addOnce(function():void
            {
               _dialogShown = false;
               doAckForDialogMessage(message);
               popSimpleDialogMessage();
            });
         }
         else
         {
            this._dialogShown = false;
            this.doAckForDialogMessage(message);
            this.popSimpleDialogMessage();
         }
      }
      
      private function showReadyCheckDodgeWarning(param1:SimpleDialogMessage) : void
      {
         var _loc2_:AlertAction = new AlertAction(RiotResourceLoader.getResourceString("resources","readyCheckDodgeWarning_title","Ready Check Dodging"),RiotResourceLoader.getResourceString("resources","readyCheckDodgeWarning_message","You have dodged too many ready checks."));
         _loc2_.getCompleted().add(this.handleDialogDismissedForAlertAction);
         _loc2_.data = param1;
         _loc2_.add();
      }
      
      private function showReadyCheckDodgeApplied(param1:SimpleDialogMessage) : void
      {
         var _loc2_:AlertAction = new AlertAction(RiotResourceLoader.getResourceString("resources","readyCheckDodgePenalty_title","Ready Check Dodging"),RiotResourceLoader.getResourceString("resources","readyCheckDodgePenalty_message","You have dodged too many ready checks."));
         _loc2_.getCompleted().add(this.handleDialogDismissedForAlertAction);
         _loc2_.data = param1;
         _loc2_.add();
      }
      
      private function showReportedMessage(param1:SimpleDialogMessage) : void
      {
         var _loc2_:String = this.convertReportReasonToResourceId(jsonDecode(param1.params[0]) as String);
         var _loc3_:AlertAction = new AlertAction(RiotResourceLoader.getResourceString("resources","behavioralAlert_title","You have been reported"),RiotResourceLoader.getResourceString("resources","behavioralAlert_message","You have been reported.",[RiotResourceLoader.getResourceString("resources",_loc2_,"Bad Behavior")]));
         _loc3_.getCompleted().add(this.handleDialogDismissedForAlertAction);
         _loc3_.data = param1;
         _loc3_.add();
      }
      
      private function convertReportReasonToResourceId(param1:String) : String
      {
         var _loc2_:String = param1;
         switch(param1)
         {
            case ReportReasonConstants.OFFENSIVE_LANGUAGE:
               _loc2_ = "reportPlayerOffense_offensiveLanguage";
               break;
            case ReportReasonConstants.VERBAL_ABUSE:
               _loc2_ = "reportPlayerOffense_verbalAbuse";
               break;
            case ReportReasonConstants.INTENTIONAL_FEEDING:
               _loc2_ = "reportPlayerOffense_intentionalFeeding";
               break;
            case ReportReasonConstants.ASSISTING_ENEMY:
               _loc2_ = "reportPlayerOffense_assistingEnemy";
               break;
            case ReportReasonConstants.UNSKILLED_PLAYER:
               _loc2_ = "reportPlayerOffense_unskilledPlayer";
               break;
            case ReportReasonConstants.NO_COMMUNICATION_WITH_TEAM:
               _loc2_ = "reportPlayerOffense_noCommunication";
               break;
            case ReportReasonConstants.LEAVING_AFK:
               _loc2_ = "reportPlayerOffense_leavingAFK";
               break;
            case ReportReasonConstants.NEGATIVE_ATTITUDE:
               _loc2_ = "reportPlayerOffense_badAttitude";
               break;
            case ReportReasonConstants.INAPPROPRIATE_NAME:
               _loc2_ = "reportPlayerOffense_inappropriateName";
               break;
            case ReportReasonConstants.SPAMMING:
               _loc2_ = "reportPlayerOffense_spamming";
               break;
            default:
               _loc2_ = "reportPlayerOffense_default";
         }
         return _loc2_;
      }
      
      private function showHarassmentMessage(param1:SimpleDialogMessage) : void
      {
         var _loc2_:Object = jsonDecode(param1.params[0]);
         if(_loc2_.restrictionType == RestrictionType.IN_GAME_CHAT)
         {
            this.showChatRestrictionMessage(param1,_loc2_);
         }
         else if(_loc2_.restrictionType == RestrictionType.RANKED_GAME_RESTRICTION)
         {
            this.handleRankedRestrictionMessage(param1,_loc2_);
         }
      }
      
      private function showChatRestrictionMessage(param1:SimpleDialogMessage, param2:Object) : void
      {
         var _loc3_:AlertParameters = new AlertParameters();
         var _loc4_:Number = param2.previousDuration + param2.durationDelta;
         if(_loc4_ < 0)
         {
            return;
         }
         if(_loc4_ == 0)
         {
            _loc3_.message = RiotResourceLoader.getResourceString("resources","restrictedChat_eog_finished_message","");
            _loc3_.title = RiotResourceLoader.getResourceString("resources","restrictedChat_eog_finished_title","");
         }
         else
         {
            _loc3_.title = RiotResourceLoader.getResourceString("resources","restrictedChat_eog_progress_title","");
            if(_loc4_ == 1)
            {
               _loc3_.message = RiotResourceLoader.getResourceString("resources","restrictedChat_eog_progress_message","",[_loc4_]);
            }
            else
            {
               _loc3_.message = RiotResourceLoader.getResourceString("resources","restrictedChat_eog_progress_message_plural","",[_loc4_]);
            }
         }
         _loc3_.location = AlertLocation.PROFILE_BUTTON;
         this._alertsToAckDictionary[_loc3_] = param1;
         ChromeContextAlertProviderProxy.instance.showAlertForParameters(_loc3_);
      }
      
      private function handleRankedRestrictionMessage(param1:SimpleDialogMessage, param2:Object) : void
      {
         var _loc3_:AlertParameters = new AlertParameters();
         var _loc4_:Number = param2.previousDuration + param2.durationDelta;
         Session.instance.rankedRestrictedGamesRemaining = _loc4_;
         if(_loc4_ < 0)
         {
            return;
         }
         if(_loc4_ == 0)
         {
            _loc3_.message = RiotResourceLoader.getResourceString("resources","restrictedRanked_eog_finished_message","");
            _loc3_.title = RiotResourceLoader.getResourceString("resources","restrictedRanked_eog_finished_title","");
         }
         else
         {
            _loc3_.title = RiotResourceLoader.getResourceString("resources","restrictedRanked_eog_progress_title","");
            if(_loc4_ == 1)
            {
               _loc3_.message = RiotResourceLoader.getResourceString("resources","restrictedRanked_eog_progress_message","",[_loc4_]);
            }
            else
            {
               _loc3_.message = RiotResourceLoader.getResourceString("resources","restrictedRanked_eog_progress_message_plural","",[_loc4_]);
            }
         }
         _loc3_.location = AlertLocation.PROFILE_BUTTON;
         _loc3_.location = AlertLocation.PROFILE_BUTTON;
         this._alertsToAckDictionary[_loc3_] = param1;
         ChromeContextAlertProviderProxy.instance.showAlertForParameters(_loc3_);
         this.presenceProvider.setRankedSoloRestricted(_loc4_ > 0,true);
      }
      
      private function handleActiveContextAlertChanged() : void
      {
         var _loc1_:SimpleDialogMessage = this._alertsToAckDictionary[ChromeContextAlertProviderProxy.instance.getActiveAlert()] as SimpleDialogMessage;
         if(_loc1_)
         {
            this.doAckForDialogMessage(_loc1_);
            delete this._alertsToAckDictionary[ChromeContextAlertProviderProxy.instance.getActiveAlert()];
         }
      }
      
      private function pushSimpleDialogMessage(param1:SimpleDialogMessage) : void
      {
         this._delayedMessages.push(param1);
      }
      
      private function handleWindowDisplayStateChanged(param1:NativeWindowDisplayStateEvent) : *
      {
         if(param1.afterDisplayState != NativeWindowDisplayState.MINIMIZED)
         {
            if(!this._dialogShown && this._delayedMessages.length > 0)
            {
               setTimeout(this.popSimpleDialogMessage,1000);
            }
         }
      }
      
      private function popSimpleDialogMessage() : void
      {
         var _loc1_:Object = null;
         if(this._delayedMessages.length > 0)
         {
            _loc1_ = this._delayedMessages.pop();
            if(_loc1_ != null)
            {
               this.onSimpleDialogMessageRecieved(SimpleDialogMessage(_loc1_));
            }
         }
      }
      
      public function onAlertDisplayed(param1:Array) : void
      {
         var _loc2_:SimpleDialogMessage = null;
         if(param1.length > 0)
         {
            _loc2_ = param1[0].data;
            this.doAckForDialogMessage(_loc2_);
         }
      }
      
      public function onCelebrationForReceiver(param1:SimpleDialogMessage) : void
      {
         if(this._dialogShown)
         {
            this.pushSimpleDialogMessage(param1);
            return;
         }
         this._dialogShown = true;
         if(this._celebrationDialogFactory == null)
         {
            this._celebrationDialogFactory = new CelebrationDialogFactory(null,this._moduleInfo);
         }
         var _loc2_:ICelebrationDialog = this._celebrationDialogFactory.getCelebrationDialog();
         _loc2_.setModel(param1,this.getItemNameFromMessage(param1));
         _loc2_.getDialogDismissed().addOnce(this.handleDialogForReceivedDismissed);
         PopUpManager.addPopUp(_loc2_,null,true);
      }
      
      public function onCelebrationForDelivered(param1:SimpleDialogMessage) : void
      {
         if(this._dialogShown)
         {
            this.pushSimpleDialogMessage(param1);
            return;
         }
         this._dialogShown = true;
         var _loc2_:AlertAction = new AlertAction(RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,param1.titleCode,"##Thanks!",[param1.params[1]]),RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,param1.bodyCode,"##They got your gift!",[param1.params[0],this.getItemNameFromMessage(param1)]));
         _loc2_.getCompleted().add(this.handleDialogDismissedForAlertAction);
         _loc2_.data = param1;
         _loc2_.affirmativeLabel = RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,CelebrationConstants.GIFT_DELIVERED_BUTTON,"##Close");
         _loc2_.add();
      }
      
      public function onTierPromotion(param1:SimpleDialogMessage) : void
      {
         this.onSimpleDialogMessageRecieved(param1);
      }
      
      private function handleFirstTimeLeaverDialogueDismissed(param1:ICelebrationDialog, param2:SimpleDialogMessage) : void
      {
         this.serviceProxy.clientFacadeService.ackLeaverBusterWarning();
         this.handleDialogForReceivedDismissed(param1,param2);
      }
      
      private function handleDialogForReceivedDismissed(param1:ICelebrationDialog, param2:SimpleDialogMessage) : void
      {
         PopUpManager.removePopUp(param1);
         param1.destroy();
         this._dialogShown = false;
         this.popSimpleDialogMessage();
         if(param2)
         {
            this.doAckForDialogMessage(param2);
         }
      }
      
      private function handleDialogDismissedForAlertAction(param1:AlertAction) : void
      {
         this._dialogShown = false;
         this.popSimpleDialogMessage();
         this.doAckForDialogMessage(SimpleDialogMessage(param1.data));
      }
      
      private function doAckForDialogMessage(param1:SimpleDialogMessage) : void
      {
         if(param1.msgId == null)
         {
            return;
         }
         var _loc2_:SimpleDialogMessageResponse = new SimpleDialogMessageResponse();
         _loc2_.accountId = param1.accountId;
         _loc2_.msgId = param1.msgId;
         _loc2_.command = SimpleDialogMessageResponse.ACKNOWLEDGE_COMMAND;
         this.serviceProxy.clientFacadeService.acknowlageMessage(_loc2_,this.onAcknowledgeSent);
      }
      
      private function onAcknowledgeSent(param1:Boolean) : void
      {
      }
      
      public function getItemNameFromMessage(param1:SimpleDialogMessage) : String
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:* = undefined;
         if(param1 != null && param1.params.length >= 5)
         {
            if(param1.params[3] == "RP")
            {
               return RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,CelebrationConstants.GIFT_RP,"##{0} Riot Points",[param1.params[4]]);
            }
            if(param1.params[3] == "CHAMPION")
            {
               if(this.inventory == null || this.inventory.championIdMapping[param1.params[4]] == null)
               {
                  return RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,CelebrationConstants.GIFT_CHAMPION,"##A Champion");
               }
               return this.inventory.championIdMapping[param1.params[4]].displayName;
            }
            if(param1.params[3] == "CHAMPION_SKIN")
            {
               _loc2_ = null;
               if(this.inventory != null)
               {
                  _loc2_ = this.inventory.skinSkinIdMapping[param1.params[4]];
               }
               if(this.inventory == null || _loc2_ == null)
               {
                  return RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,CelebrationConstants.GIFT_CHAMPION_SKIN,"##A Champion Skin");
               }
               return RiotResourceLoader.getChampionSkinResourceString("name",_loc2_.championSkinName,_loc2_.skinIndex,"#A Champion Skin");
            }
            if(param1.params[3] == "SPELL_BOOK_PAGE")
            {
               _loc3_ = parseInt(param1.params[4]);
               if(_loc3_ > 1)
               {
                  return RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,CelebrationConstants.GIFT_RUNE_PAGES,"##{0} Rune Pages",[_loc3_]);
               }
               return RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,CelebrationConstants.GIFT_RUNE_PAGE,"##Rune Page");
            }
            if(param1.params[3] == "SUMMONER_ICON")
            {
               return RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,CelebrationConstants.GIFT_SUMMONER_ICON,"##Summoner Icon");
            }
            if(param1.params[3] == "WARD_SKIN")
            {
               return RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,CelebrationConstants.GIFT_WARD_SKIN,"##Ward Skin");
            }
            if(param1.params[3] == "BOOST")
            {
               _loc4_ = "";
               _loc5_ = param1.params[8];
               if(param1.params[7] == "DURATION")
               {
                  _loc4_ = RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,CelebrationConstants.GIFT_BOOST_DAY,"##Day");
               }
               else
               {
                  _loc4_ = RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,CelebrationConstants.GIFT_BOOST_WIN,"##Win");
               }
               if(param1.params[6] == "XP")
               {
                  return RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,CelebrationConstants.GIFT_XP_BOOST,"##A {0} {1} XP Boost",[_loc5_,_loc4_]);
               }
               if(param1.params[6] == "IP")
               {
                  return RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,CelebrationConstants.GIFT_IP_BOOST,"##A {0} {1} IP Boost",[_loc5_,_loc4_]);
               }
               return RiotResourceLoader.getResourceString(CELEBRATION_RESOURCE_ID,CelebrationConstants.GIFT_BOOST,"##A Boost");
            }
         }
         return "";
      }
      
      public function showFirstTimeLeaverDialogue() : void
      {
         this.onFirstTimeLeaverWarning(null);
      }
   }
}

