package com.riotgames.pvpnet.CLS.controllers
{
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.gameclient.domain.LeagueItemDTO;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   
   public class LeagueDecayMessageController implements ILeagueDecayMessageController
   {
      
      private static const LEAGUE_DECAY_HAPPENED:String = "decayHappened";
      
      private static const LEAGUE_DECAY_SOON:String = "decaySoon";
      
      private static const LEAGUE_MINISERIES_DECAY:String = "miniSeriesDecay";
      
      private static const LEAGUE_MINISERIES_INACTIVE:String = "miniSeriesInactive";
      
      private static const LEAGUE_MINISERIES_ENDED:String = "miniSeriesEnded";
      
      private static const LEAGUE_MINISERIES_ENDED_AND_DECAYED:String = "miniSeriesEndedDecayed";
      
      private static const LEAGUE_DECAY_DEMOTION:String = "decayDemotion";
      
      private var _decaySoonMessages:Array = [];
      
      private var _decayHappenedMessages:Array = [];
      
      private var _decayDemotionMessages:Array = [];
      
      private var _miniSeriesEndedMessages:Array = [];
      
      private var _miniSeriesDecayMessages:Array = [];
      
      private var _miniSeriesInactiveMessages:Array = [];
      
      private var _displayedMessagesForPlayerOrTeam:Array = [];
      
      private var shellDispatcher:ShellDispatcher;
      
      public function LeagueDecayMessageController()
      {
         super();
         this.shellDispatcher = ShellDispatcher.instance;
      }
      
      private function reset() : void
      {
         this._decaySoonMessages = [];
         this._decayHappenedMessages = [];
         this._miniSeriesDecayMessages = [];
         this._miniSeriesInactiveMessages = [];
         this._displayedMessagesForPlayerOrTeam = [];
      }
      
      public function processDecayMessages(param1:Vector.<LeagueItemDTO>, param2:Number = 0) : void
      {
         var _loc3_:LeagueItemDTO = null;
         this.reset();
         for each(_loc3_ in param1)
         {
            _loc3_.leaguePointsDelta = param2;
            if(_loc3_.displayDecayWarning)
            {
               if(_loc3_.timeUntilDecay == 0)
               {
                  this._decayHappenedMessages.push(_loc3_);
               }
               else if(_loc3_.miniSeries != null)
               {
                  this._miniSeriesDecayMessages.push(_loc3_);
               }
               else
               {
                  this._decaySoonMessages.push(_loc3_);
               }
            }
         }
         this._decayHappenedMessages.sort(this.sortLeaguesByQueueType);
         this._miniSeriesDecayMessages.sort(this.sortLeaguesByQueueType);
         this._miniSeriesInactiveMessages.sort(this.sortLeaguesByQueueType);
         this._decaySoonMessages.sort(this.sortLeaguesByQueueType);
         this.displayDecayMessaging();
      }
      
      public function processDemotionMessage(param1:Vector.<LeagueItemDTO>, param2:String, param3:String, param4:Number = 0) : void
      {
         var _loc5_:LeagueItemDTO = null;
         for each(_loc5_ in param1)
         {
            if(_loc5_.queueType == param2 && _loc5_.playerOrTeamName == param3 && _loc5_.timeUntilDecay == 0)
            {
               _loc5_.leaguePointsDelta = param4;
               this._decayDemotionMessages.push(_loc5_);
            }
         }
         this._decayDemotionMessages.sort(this.sortLeaguesByQueueType);
      }
      
      public function processMiniSeriesEndedMessage(param1:Vector.<LeagueItemDTO>, param2:String, param3:String, param4:Number = 0) : void
      {
         var _loc5_:LeagueItemDTO = null;
         for each(_loc5_ in param1)
         {
            if(_loc5_.queueType == param2 && _loc5_.playerOrTeamName == param3)
            {
               _loc5_.leaguePointsDelta = param4;
               this._miniSeriesEndedMessages.push(_loc5_);
            }
         }
         this._miniSeriesEndedMessages.sort(this.sortLeaguesByQueueType);
      }
      
      public function getProfileScreenDecayMessage(param1:String, param2:String = null) : Object
      {
         if(!ClientConfig.instance.leaguesDecayMessagingEnabled)
         {
            return null;
         }
         var _loc3_:Object = null;
         _loc3_ = this.processIndividualProfileMessage(this._miniSeriesEndedMessages,param1,param2,LEAGUE_MINISERIES_ENDED);
         if(_loc3_)
         {
            return _loc3_;
         }
         _loc3_ = this.processIndividualProfileMessage(this._miniSeriesInactiveMessages,param1,param2,LEAGUE_MINISERIES_INACTIVE);
         if(_loc3_)
         {
            return _loc3_;
         }
         _loc3_ = this.processIndividualProfileMessage(this._decayDemotionMessages,param1,param2,LEAGUE_DECAY_DEMOTION);
         if(_loc3_)
         {
            return _loc3_;
         }
         _loc3_ = this.processIndividualProfileMessage(this._decayHappenedMessages,param1,param2,LEAGUE_DECAY_HAPPENED);
         if(_loc3_)
         {
            return _loc3_;
         }
         _loc3_ = this.processIndividualProfileMessage(this._miniSeriesDecayMessages,param1,param2,LEAGUE_MINISERIES_DECAY);
         if(_loc3_)
         {
            return _loc3_;
         }
         _loc3_ = this.processIndividualProfileMessage(this._decaySoonMessages,param1,param2,LEAGUE_DECAY_SOON);
         if(_loc3_)
         {
            return _loc3_;
         }
         return null;
      }
      
      private function processIndividualProfileMessage(param1:Array, param2:String, param3:String, param4:String) : Object
      {
         var _loc5_:LeagueItemDTO = null;
         for each(_loc5_ in param1)
         {
            if(param4 == LEAGUE_MINISERIES_ENDED)
            {
               param4 = this.didMiniseriesDecay(_loc5_) ? LEAGUE_MINISERIES_ENDED_AND_DECAYED : LEAGUE_MINISERIES_ENDED;
            }
            if(_loc5_.playerOrTeamName == param3 && _loc5_.tier != "BRONZE")
            {
               return this.getMessageStrings(_loc5_,param4);
            }
            if(!param3 && _loc5_.queueType == param2 && _loc5_.tier != "BRONZE")
            {
               return this.getMessageStrings(_loc5_,param4);
            }
         }
         return null;
      }
      
      private function displayDecayMessaging() : void
      {
         this.processIndividualMessages(this._miniSeriesEndedMessages,LEAGUE_MINISERIES_ENDED);
         this.processIndividualMessages(this._miniSeriesInactiveMessages,LEAGUE_MINISERIES_INACTIVE);
         this.processIndividualMessages(this._decayDemotionMessages,LEAGUE_DECAY_DEMOTION);
         this.processIndividualMessages(this._decayHappenedMessages,LEAGUE_DECAY_HAPPENED);
         this.processIndividualMessages(this._miniSeriesDecayMessages,LEAGUE_MINISERIES_DECAY);
         this.processIndividualMessages(this._decaySoonMessages,LEAGUE_DECAY_SOON);
      }
      
      private function processIndividualMessages(param1:Array, param2:String) : void
      {
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            if(param2 == LEAGUE_MINISERIES_ENDED)
            {
               param2 = this.didMiniseriesDecay(param1[_loc3_]) ? LEAGUE_MINISERIES_ENDED_AND_DECAYED : LEAGUE_MINISERIES_ENDED;
            }
            if(param1[_loc3_].tier != "BRONZE")
            {
               this.addDecayPopup(param1[_loc3_],param2);
            }
            _loc3_++;
         }
      }
      
      private function addDecayPopup(param1:LeagueItemDTO, param2:String, param3:Boolean = false) : void
      {
         var decayMessage:Object = null;
         var decayItem:LeagueItemDTO = param1;
         var type:String = param2;
         var force:Boolean = param3;
         if(!ClientConfig.instance.leaguesDecayMessagingEnabled)
         {
            return;
         }
         if(!this.shouldDisplayMessage(decayItem) && !force)
         {
            return;
         }
         if(this.hasMessageBeenDisplayed(decayItem) && !force)
         {
            return;
         }
         decayMessage = this.getMessageStrings(decayItem,type);
         ProviderLookup.getProvider(INotificationsProvider,function(param1:INotificationsProvider):void
         {
            var _loc2_:String = RiotResourceLoader.getString("league_system_docked_title");
            var _loc3_:String = RiotResourceLoader.getString("common_button_close");
            param1.showDockedPrompt(DockedPrompt.create(decayMessage.message,_loc2_,decayMessage.title,_loc3_,null,null,handleDecayWarningMessageClosed,decayItem,true));
         });
         this._displayedMessagesForPlayerOrTeam.push(decayItem);
         this.removeMessage(type,decayItem);
      }
      
      private function handleDecayWarningMessageClosed(param1:String, param2:LeagueItemDTO) : void
      {
         if(param2.queueType == "RANKED_TEAM_5x5" || param2.queueType == "RANKED_TEAM_3x3")
         {
            ServiceProxy.instance.leagueService.updateTeamDecayMessageLastShown(param2.playerOrTeamId,param2.queueType);
         }
         else
         {
            ServiceProxy.instance.leagueService.updateMyDecayMessageLastShown(param2.queueType);
         }
      }
      
      private function sortLeaguesByQueueType(param1:LeagueItemDTO, param2:LeagueItemDTO) : int
      {
         var _loc3_:Array = ["RANKED_SOLO_5x5","RANKED_TEAM_3x3","RANKED_TEAM_5x5"];
         var _loc4_:int = _loc3_.indexOf(param1.queueType);
         var _loc5_:int = _loc3_.indexOf(param2.queueType);
         if(_loc4_ < _loc5_)
         {
            return -1;
         }
         if(_loc4_ > _loc5_)
         {
            return 1;
         }
         if(_loc4_ == _loc5_)
         {
            return 0;
         }
         return 0;
      }
      
      private function didMiniseriesDecay(param1:LeagueItemDTO) : Boolean
      {
         return this._decayHappenedMessages.indexOf(param1) != -1;
      }
      
      private function getMessageStrings(param1:LeagueItemDTO, param2:String = "") : Object
      {
         var _loc3_:Object = {
            "title":"",
            "message":""
         };
         switch(param2)
         {
            case LEAGUE_DECAY_SOON:
               _loc3_.title = RiotResourceLoader.getString("league_system_decay_soon_title");
               _loc3_.message = RiotResourceLoader.getString("league_system_decay_soon_" + param1.queueType,null,[param1.playerOrTeamName,this.getDecayTimeInDays(param1.timeUntilDecay)]);
               break;
            case LEAGUE_MINISERIES_DECAY:
               _loc3_.title = RiotResourceLoader.getString("league_system_series_inactivity_title");
               _loc3_.message = RiotResourceLoader.getString("league_system_series_inactivity_" + param1.queueType,null,[param1.playerOrTeamName,this.getDecayTimeInDays(param1.miniSeries.timeLeftToPlayMillis)]);
               break;
            case LEAGUE_DECAY_HAPPENED:
               _loc3_.title = RiotResourceLoader.getString("league_system_decay_title");
               _loc3_.message = RiotResourceLoader.getString("league_system_decay_" + param1.queueType,null,[param1.playerOrTeamName,param1.timeUntilDecay]);
               break;
            case LEAGUE_MINISERIES_INACTIVE:
               _loc3_.title = RiotResourceLoader.getString("league_system_series_inactivity_title");
               _loc3_.message = RiotResourceLoader.getString("league_system_series_inactivity_decay_" + param1.queueType,null,[param1.playerOrTeamName,this.getDecayTimeInDays(param1..miniSeries.timeLeftToPlayMillis)]);
               break;
            case LEAGUE_MINISERIES_ENDED:
               _loc3_.title = RiotResourceLoader.getString("league_system_series_ended_title_" + param1.queueType,null,[param1.playerOrTeamName]);
               _loc3_.message = RiotResourceLoader.getString("league_system_series_ended_" + param1.queueType,null,[param1.playerOrTeamName]);
               break;
            case LEAGUE_MINISERIES_ENDED_AND_DECAYED:
               _loc3_.title = RiotResourceLoader.getString("league_system_series_ended_title_" + param1.queueType,null,[param1.playerOrTeamName]);
               _loc3_.message = RiotResourceLoader.getString("league_system_series_ended_decay_" + param1.queueType,null,[param1.playerOrTeamName]);
               break;
            case LEAGUE_DECAY_DEMOTION:
               _loc3_.title = RiotResourceLoader.getString("league_system_decay_title");
               _loc3_.message = RiotResourceLoader.getString("league_system_decay_demotion_" + param1.queueType,null,[param1.playerOrTeamName,param1.timeUntilDecay,RiotResourceLoader.getString("leagues_rank_" + param1.tier,param1.tier),RiotResourceLoader.getString("leagues_tier_" + param1.rank,param1.rank)]);
         }
         return _loc3_;
      }
      
      private function removeMessage(param1:String, param2:LeagueItemDTO) : void
      {
         var _loc3_:Array = [];
         switch(param1)
         {
            case LEAGUE_DECAY_DEMOTION:
               _loc3_ = this._decayDemotionMessages;
               break;
            case LEAGUE_MINISERIES_ENDED:
               _loc3_ = this._miniSeriesEndedMessages;
               break;
            default:
               return;
         }
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_].playerOrTeamId == param2.playerOrTeamId)
            {
               _loc3_.splice(_loc4_,1);
               return;
            }
            _loc4_++;
         }
      }
      
      public function getDecayTimeInHours(param1:Number) : Number
      {
         return param1 / (1000 * 60 * 60);
      }
      
      public function getDecayTimeInDays(param1:Number) : Number
      {
         return Math.ceil(this.getDecayTimeInHours(param1) / 24);
      }
      
      public function shouldDisplayMessage(param1:LeagueItemDTO) : Boolean
      {
         return param1.timeLastDecayMessageShown <= param1.lastPlayed;
      }
      
      public function hasMessageBeenDisplayed(param1:LeagueItemDTO) : Boolean
      {
         return this._displayedMessagesForPlayerOrTeam.indexOf(param1) != -1;
      }
   }
}

