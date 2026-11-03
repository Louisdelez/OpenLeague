package com.riotgames.pvpnet.CLS.commands
{
   import blix.context.IContext;
   import blix.layout.data.CanvasLayoutData;
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.IChatProvider;
   import com.riotgames.platform.gameclient.domain.LeagueItemDTO;
   import com.riotgames.platform.gameclient.domain.SummonerLeagueItemsDTO;
   import com.riotgames.platform.gameclient.leagues.LeagueUpdateItem;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.CLS.controllers.ILeagueDecayMessageController;
   import com.riotgames.pvpnet.CLS.views.promotionCeremony.PromotionCeremonyPopup;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   import com.riotgames.rust.popup.PopUpManager;
   import mx.rpc.events.ResultEvent;
   
   public class LeagueUpdatePopupCommand extends CommandBase
   {
      
      private var _type:String = "";
      
      private var _points:int = 0;
      
      private var _delta:int = 0;
      
      private var _updateItem:LeagueUpdateItem;
      
      private var _parentContext:IContext = null;
      
      private var _leagueDecayController:ILeagueDecayMessageController;
      
      public function LeagueUpdatePopupCommand(param1:LeagueUpdateItem, param2:ILeagueDecayMessageController, param3:IContext = null)
      {
         super();
         this._type = param1.type;
         this._points = param1.leaguePoints;
         this._delta = param1.leaguePointsDelta;
         this._parentContext = param3;
         this._leagueDecayController = param2;
         this._updateItem = param1;
      }
      
      override public function execute() : void
      {
         var _loc4_:PromotionCeremonyPopup = null;
         var _loc5_:PromotionCeremonyPopup = null;
         var _loc6_:AlertAction = null;
         super.execute();
         var _loc1_:Boolean = false;
         var _loc2_:String = RiotResourceLoader.getString("leagues_generalLeagueUpdateTitle","**New League Information");
         var _loc3_:String = "";
         switch(this._type)
         {
            case LeagueUpdateItem.LEAGUE_PROMOTED:
               if(LeagueRank.valueOf(this._updateItem.rank) == LeagueRank.V || Boolean(LeagueTier.valueOf(this._updateItem.tier).isApex()))
               {
                  _loc5_ = new PromotionCeremonyPopup(this._parentContext,true,this._updateItem);
                  PopUpManager.addPopUp(_loc5_,this.createCeremonyLayoutData(),true);
               }
               else
               {
                  _loc3_ = RiotResourceLoader.getString("leagues_message_" + this._type + "_" + this._updateItem.queueType,"**League update: " + this._type,[RiotResourceLoader.getString("leagues_rank_" + this._updateItem.tier,this._updateItem.tier),RiotResourceLoader.getString("leagues_tier_" + this._updateItem.rank,this._updateItem.rank),this._updateItem.playerOrTeamName]);
                  _loc1_ = true;
               }
               this.updateChatPresenceData();
               break;
            case LeagueUpdateItem.LEAGUE_DEMOTED:
               _loc3_ = RiotResourceLoader.getString("leagues_message_" + this._type + "_" + this._updateItem.queueType,"**League update: " + this._type,[RiotResourceLoader.getString("leagues_rank_" + this._updateItem.tier,this._updateItem.tier),RiotResourceLoader.getString("leagues_tier_" + this._updateItem.rank,this._updateItem.rank),this._updateItem.leagueName,this._updateItem.playerOrTeamName]);
               _loc1_ = true;
               if(ClientConfig.instance.leaguesDecayMessagingEnabled)
               {
                  this._leagueDecayController.processDemotionMessage(ServiceProxy.instance.leagueService.cache.myLeagueStandings,this._updateItem.queueType,this._updateItem.playerOrTeamName,this._delta);
               }
               this.updateChatPresenceData();
               break;
            case LeagueUpdateItem.MINISERIES_START:
               _loc2_ = RiotResourceLoader.getString("leagues_generalLeagueMiniseriesTitle","**New League Information");
               _loc3_ = RiotResourceLoader.getString("leagues_message_" + this._type);
               _loc1_ = true;
               break;
            case LeagueUpdateItem.MINISERIES_CANCEL:
               if(ClientConfig.instance.leaguesDecayMessagingEnabled)
               {
                  this._leagueDecayController.processMiniSeriesEndedMessage(ServiceProxy.instance.leagueService.cache.myLeagueStandings,this._updateItem.queueType,this._updateItem.playerOrTeamName,this._delta);
               }
               break;
            case LeagueUpdateItem.QUEUE_DODGE:
               _loc2_ = RiotResourceLoader.getString("leagues_generalLeagueMiniseriesTitle","**New League Information");
               _loc3_ = RiotResourceLoader.getString("leagues_message_" + this._type,"**League update: " + this._type);
               _loc1_ = true;
               break;
            case LeagueUpdateItem.MINISERIES_LOST:
               _loc2_ = RiotResourceLoader.getString("leagues_generalLeagueMiniseriesTitle","**New League Information");
               _loc3_ = RiotResourceLoader.getString("leagues_message_" + this._type,"**League update: " + this._type);
               _loc1_ = true;
               break;
            case LeagueUpdateItem.LEAGUE_SEEDED:
               _loc4_ = new PromotionCeremonyPopup(this._parentContext,false,this._updateItem);
               PopUpManager.addPopUp(_loc4_,this.createCeremonyLayoutData(),true);
               this.updateChatPresenceData();
               break;
            case LeagueUpdateItem.LEAGUE_POINTS_UPDATE:
               _loc3_ = RiotResourceLoader.getString("leagues_message_" + this._type,"**League update: " + this._type,[this._points,this._delta]);
               break;
            case LeagueUpdateItem.LEAGUE_UPDATE_DECAY:
               _loc2_ = RiotResourceLoader.getString("league_system_decay_title");
               _loc3_ = RiotResourceLoader.getString("league_system_decay_" + this._updateItem.queueType,null,[this._updateItem.playerOrTeamName,this._updateItem.timeUntilDecay]);
               _loc1_ = true;
               break;
            case LeagueUpdateItem.NOT_YET_SEEDED:
               _loc3_ = RiotResourceLoader.getString("leagues_message_" + this._type,"**League update: " + this._type);
               break;
            default:
               logger.error("Unknown league update received: " + this._type);
         }
         if(_loc1_)
         {
            _loc6_ = new AlertAction(_loc2_,_loc3_);
            _loc6_.isModal = true;
            _loc6_.add();
         }
      }
      
      private function updateChatPresenceData() : void
      {
         ServiceProxy.instance.leagueService.getMyLeaguePositions(this.onGetLeaguePositions);
      }
      
      private function onGetLeaguePositions(param1:ResultEvent) : void
      {
         var topLeague:LeagueItemDTO = null;
         var result:ResultEvent = param1;
         if(result.result is SummonerLeagueItemsDTO)
         {
            ServiceProxy.instance.leagueService.cache.updatePrescenceData(result.result as SummonerLeagueItemsDTO);
         }
         topLeague = ServiceProxy.instance.leagueService.cache.getTopLeagueForChatPrescence();
         ProviderLookup.getProvider(IChatProvider,function(param1:IChatProvider):void
         {
            var _loc2_:ChatController = param1 as ChatController;
            _loc2_.presenceController.updateLeagueData(topLeague);
         });
      }
      
      private function createCeremonyLayoutData() : CanvasLayoutData
      {
         var _loc1_:CanvasLayoutData = new CanvasLayoutData();
         _loc1_.setHorizontalCenter(15);
         _loc1_.setVerticalCenter(0);
         return _loc1_;
      }
   }
}

