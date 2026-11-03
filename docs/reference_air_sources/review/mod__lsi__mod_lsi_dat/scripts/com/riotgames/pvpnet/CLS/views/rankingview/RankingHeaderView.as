package com.riotgames.pvpnet.CLS.views.rankingview
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.loader.ImageX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.platform.common.provider.ILeagueDataProvider;
   import com.riotgames.platform.common.provider.InventoryProviderProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.CLS.controllers.ILeagueDecayMessageController;
   import com.riotgames.pvpnet.CLS.localeHelper.ILocaleHelper;
   import com.riotgames.pvpnet.CLS.managers.ILeagueSystemModuleNavigation;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import com.riotgames.pvpnet.CLS.models.SummonerLeagueObjectModel;
   import com.riotgames.pvpnet.CLS.views.enums.LeaguesDropdownTypesEnum;
   import com.riotgames.pvpnet.CLS.views.enums.QueueTypesEnum;
   import com.riotgames.pvpnet.CLS.views.helpers.DivisionSelector;
   import com.riotgames.pvpnet.CLS.views.helpers.ISummonerHelper;
   import com.riotgames.pvpnet.CLS.views.helpers.StringHelper;
   import com.riotgames.pvpnet.CLS.views.rankingview.dropdownrenderers.LeagueDropdownRenderer;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueSortOrder;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   import com.riotgames.pvpnet.system.leagues.configuration.LeagueConfig;
   import com.riotgames.rust.components.dropdown.Dropdown;
   import com.riotgames.rust.components.text.AutoSizeTextFieldProxy;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class RankingHeaderView extends SpriteProxy
   {
      
      private static const LEAGUE_TYPE_NORMAL:String = "normal";
      
      private static const LEAGUE_TYPE_MASTER:String = "master";
      
      private static const LEAGUE_TYPE_CHALLENGER:String = "challenger";
      
      private static const FIRST_LEAGUE:uint = 1;
      
      private static const MAX_TEAMNAME_LEN:uint = 10;
      
      private var _currentQueueType:uint;
      
      private var _currentRank:LeagueRank;
      
      private var _currentPlayerOrTeam:String;
      
      private var _summonerRank:LeagueRank;
      
      private var _leagueBadge:LeagueBadge;
      
      private var _leagueSystemModuleNavigation:ILeagueSystemModuleNavigation;
      
      private var _localeHelper:ILocaleHelper;
      
      private var _summonerHelper:ISummonerHelper;
      
      private var _pickLeagueDropdown:Dropdown;
      
      private var _divisionSelector:DivisionSelector;
      
      private var _leagueNameContainer:StatefulView;
      
      private var _leagueDecayPopup:RankingHeaderDecayPopup;
      
      private var _leagueDecayIcon:ButtonX;
      
      private var _championBanner:ImageX;
      
      private var _currentChampionBannerName:String;
      
      private var _leagueTierMedalName:TextFieldProxy;
      
      private var _leagueName:TextFieldProxy;
      
      private var _challengerClock:TextFieldProxy;
      
      private var _challengerClockLocalizedPrefix:String;
      
      private var _clockUpdateTimer:Timer;
      
      private var _nextApexUpdateMs:Number;
      
      private var _nextApexUpdateLastTimeSetMs:Number;
      
      private var _tiersNamesLocalized:Dictionary;
      
      private var _currentLeagueTierName:String;
      
      private var challengerTierTxt:String;
      
      private var fiveVersusFiveLabel:String;
      
      private var threeVersusThreeLabel:String;
      
      private var soloChallengerTypeLabel:String;
      
      private var myLeaguesLabel:String;
      
      private var dropDownLeaguesData:Array;
      
      private var _championIdMappping:Array;
      
      public function RankingHeaderView(param1:IContext, param2:LeagueRank, param3:Sprite = null)
      {
         this._currentRank = param2;
         super(param1,param3);
      }
      
      override protected function createChildren() : void
      {
         var _divisionSelectorContainer:SpriteProxy;
         super.createChildren();
         this._championIdMappping = InventoryProviderProxy.instance.getInventory().championIdMapping;
         if(!this._localeHelper)
         {
            this._localeHelper = getDependency(ILocaleHelper);
         }
         if(!this._summonerHelper)
         {
            this._summonerHelper = getDependency(ISummonerHelper);
         }
         this._leagueBadge = new LeagueBadge(this);
         setTimelineChildByName("currentLeagueContainer",this._leagueBadge);
         this.createPickLeagueDropdown();
         _divisionSelectorContainer = new SpriteProxy(this);
         setTimelineChildByName("leagueTierbar",_divisionSelectorContainer);
         this._divisionSelector = new DivisionSelector(this);
         this._divisionSelector.lockRoundRobin = true;
         this._divisionSelector.clickSignal.add(this.onDivisionSelectorClicked);
         _divisionSelectorContainer.setTimelineChildByName("vertDropdown",this._divisionSelector);
         this._leagueNameContainer = new StatefulView(this);
         setTimelineChildByName("currentRankTextMc",this._leagueNameContainer);
         this._leagueNameContainer.setCurrentState(LEAGUE_TYPE_NORMAL);
         this._leagueTierMedalName = new AutoSizeTextFieldProxy(this);
         this._leagueNameContainer.setTimelineChildByName("rankText",this._leagueTierMedalName);
         this._leagueName = new AutoSizeTextFieldProxy(this);
         this._leagueNameContainer.setTimelineChildByName("teamNameText",this._leagueName);
         this._challengerClock = new AutoSizeTextFieldProxy(this);
         this._leagueNameContainer.setTimelineChildByName("challengerClock",this._challengerClock);
         this._leagueDecayPopup = new RankingHeaderDecayPopup(this);
         setTimelineChildByName("decayPopup",this._leagueDecayPopup);
         this._leagueDecayIcon = new ButtonX(this);
         setTimelineChildByName("decayIcon",this._leagueDecayIcon);
         this._leagueDecayIcon.setVisible(false);
         this._leagueDecayIcon.setUseHandCursor(true);
         this._leagueDecayIcon.addEventListener(MouseEvent.CLICK,this.onDecayIconClick);
         this._championBanner = new ImageX(this,new Sprite());
         setTimelineChildByName("championBanner",this._championBanner);
         this._leagueSystemModuleNavigation = getDependency(ILeagueSystemModuleNavigation);
         this._leagueSystemModuleNavigation.getOnLeagueSelectionUpdateSignal().add(this.onLeagueChange);
         this._leagueSystemModuleNavigation.getOnChallengerTierSelectionUpdateSignal().add(this.onChallengerTierChange);
         this._leagueSystemModuleNavigation.getOnChallengerTierSelectionSignal().add(this.onChallengerTierSelection);
         this._leagueSystemModuleNavigation.getOnRankDragSelectionUpdateSignal().add(this.onRankDragSelection);
         this._leagueSystemModuleNavigation.getOnReceiveLeagueItemsSignal().add(this.onInitializeLeaguesData);
         this._leagueSystemModuleNavigation.dispatchOnAskLeagueItemsSignal();
         this._tiersNamesLocalized = this.localizeTierNames();
         this._challengerClockLocalizedPrefix = this._localeHelper.localeLookup("rhvChallengerClock");
         this._challengerClock.setText(this._challengerClockLocalizedPrefix);
         ProviderLookup.getProvider(ILeagueDataProvider,function(param1:ILeagueDataProvider):void
         {
            param1.getApexCountdownUpdated().add(setChallengerClock);
            setChallengerClock(param1.getUpdateApexCountdownMs());
         });
         this._clockUpdateTimer = new Timer(1000);
         this._clockUpdateTimer.addEventListener(TimerEvent.TIMER,this.updateChallengerClock,false,0,true);
         this._clockUpdateTimer.start();
      }
      
      public function hideVerticalDivisionSelector() : void
      {
         this._divisionSelector.setVisible(false);
      }
      
      public function updateDivision(param1:SummonerLeagueObjectModel) : void
      {
         this._leagueBadge.setBadgeState(param1.tier,param1.rank);
         this._summonerRank = param1.rank;
         this.onLeagueChange(param1);
         this.setNewRank(param1.rank);
      }
      
      private function localizeTierNames() : Dictionary
      {
         var _loc2_:LeagueTier = null;
         var _loc1_:Dictionary = new Dictionary();
         for each(_loc2_ in LeagueTier.values(LeagueSortOrder.ASCENDING))
         {
            _loc1_[_loc2_] = this.lookupLocalizedTier(_loc2_);
         }
         return _loc1_;
      }
      
      private function lookupLocalizedTier(param1:LeagueTier) : String
      {
         return this._localeHelper.localeLookup(param1.value());
      }
      
      private function createPickLeagueDropdown() : void
      {
         this._pickLeagueDropdown = new Dropdown(this);
         this._pickLeagueDropdown.listLinkage = "DropdownList";
         this._pickLeagueDropdown.listRenderer = LeagueDropdownRenderer;
         this._pickLeagueDropdown.button.setEnabled(false);
         this._pickLeagueDropdown.list.listView.itemPadding = 2;
         this._pickLeagueDropdown.list.allowVariableSpan = true;
         setTimelineChildByName("chooseLeagueDropdownButton",this._pickLeagueDropdown);
         this._pickLeagueDropdown.selectionChanged.add(this.onPickedLeague);
      }
      
      private function setNewRank(param1:LeagueRank) : void
      {
         this._currentRank = param1;
         this._leagueBadge.setBadgeState(null,this._currentRank);
         this._leagueSystemModuleNavigation.dispatchOnRankSelectionSignal(this._currentRank);
         this._divisionSelector.setActiveItemByDivision(this._currentRank,true);
      }
      
      private function onInitializeLeaguesData(param1:Vector.<SummonerLeagueObjectModel>) : void
      {
         this.dropDownLeaguesData = new Array();
         this.getLocalizedLabels();
         this.dropDownLeaguesData = this.addMyLeaguesLabels(param1,this.dropDownLeaguesData);
         this.dropDownLeaguesData = this.addChallengerTierLabels(param1,this.dropDownLeaguesData);
         this._pickLeagueDropdown.resizeBg = Boolean(param1) && param1.length < 9;
         this.clearCurrentLeagueSelection();
         this._pickLeagueDropdown.data = this.dropDownLeaguesData;
         this._pickLeagueDropdown.button.setEnabled(true);
         this._pickLeagueDropdown.selectedIndex = FIRST_LEAGUE;
         this.dropDownLeaguesData[FIRST_LEAGUE].selected = true;
      }
      
      private function addChallengerTierLabels(param1:Vector.<SummonerLeagueObjectModel>, param2:Array) : Array
      {
         param2.push({
            "label":this.challengerTierTxt,
            "type":LeaguesDropdownTypesEnum.CHALLENGER_SEPARATOR_TYPE
         });
         param2.push({
            "label":this.fiveVersusFiveLabel,
            "type":LeaguesDropdownTypesEnum.CHALLENGER_TIER_TYPE
         });
         param2.push({
            "label":this.threeVersusThreeLabel,
            "type":LeaguesDropdownTypesEnum.CHALLENGER_TIER_TYPE
         });
         param2.push({
            "label":this.soloChallengerTypeLabel,
            "type":LeaguesDropdownTypesEnum.CHALLENGER_TIER_TYPE
         });
         return param2;
      }
      
      private function addMyLeaguesLabels(param1:Vector.<SummonerLeagueObjectModel>, param2:Array) : Array
      {
         var _loc3_:SummonerLeagueObjectModel = null;
         var _loc4_:String = null;
         if(Boolean(param1) && param1.length > 0)
         {
            param2.push({
               "label":this.leaguesLabel,
               "type":LeaguesDropdownTypesEnum.SEPARATOR_TYPE
            });
            for each(_loc3_ in param1)
            {
               _loc4_ = "";
               if(_loc3_.queueType == QueueTypesEnum.QUEUE_TYPE_SOLO || _loc3_.teamName == null)
               {
                  _loc4_ = this._localeHelper.localeLookup(QueueTypesEnum.QUEUES_LABEL[QueueTypesEnum.INT_TO_QUEUES[_loc3_.queueType]]);
               }
               else
               {
                  _loc4_ = this._localeHelper.localeLookup(QueueTypesEnum.QUEUES_LABEL[QueueTypesEnum.INT_TO_QUEUES[_loc3_.queueType]]) + ": " + StringHelper.truncate(_loc3_.teamName,MAX_TEAMNAME_LEN);
               }
               if(_loc3_.teamName != null)
               {
                  param2.push({
                     "label":_loc4_,
                     "league":_loc3_,
                     "type":LeaguesDropdownTypesEnum.MY_LEAGUES_LIST_TYPE
                  });
               }
            }
         }
         return param2;
      }
      
      private function onPickedLeague() : void
      {
         var _loc1_:uint = uint(this._pickLeagueDropdown.selectedIndex);
         var _loc2_:SummonerLeagueObjectModel = this._pickLeagueDropdown.data[_loc1_].league as SummonerLeagueObjectModel;
         if(Boolean(_loc2_) && _loc2_.id >= 0)
         {
            if(_loc2_.tier == LeagueTier.CHALLENGER)
            {
               this._leagueSystemModuleNavigation.dispatchOnChallengerTierSelectionSignal(_loc2_.queueType);
            }
            else
            {
               this._leagueSystemModuleNavigation.dispatchOnLeagueSelectionSignal(_loc2_.id);
            }
            this._currentQueueType = _loc2_.queueType;
            this._currentPlayerOrTeam = _loc2_.teamName;
            this.processDecayMessages();
         }
         else if(this._pickLeagueDropdown.data[_loc1_].type == LeaguesDropdownTypesEnum.CHALLENGER_TIER_TYPE)
         {
            switch(_loc1_)
            {
               case this._pickLeagueDropdown.data.length - 3:
                  this._leagueSystemModuleNavigation.dispatchOnChallengerTierSelectionSignal(QueueTypesEnum.QUEUE_TYPE_5V5);
                  break;
               case this._pickLeagueDropdown.data.length - 2:
                  this._leagueSystemModuleNavigation.dispatchOnChallengerTierSelectionSignal(QueueTypesEnum.QUEUE_TYPE_3V3);
                  break;
               case this._pickLeagueDropdown.data.length - 1:
                  this._leagueSystemModuleNavigation.dispatchOnChallengerTierSelectionSignal(QueueTypesEnum.QUEUE_TYPE_SOLO);
            }
         }
         this.updateLeagueSelection(_loc1_);
      }
      
      private function updateLeagueSelection(param1:int) : void
      {
         this.clearCurrentLeagueSelection();
         this.dropDownLeaguesData[param1].selected = true;
         this._pickLeagueDropdown.data = this.dropDownLeaguesData;
         this._pickLeagueDropdown.selectedIndex = param1;
         this._pickLeagueDropdown.resizeBg = Boolean(this.dropDownLeaguesData) && this.dropDownLeaguesData.length < 9;
      }
      
      private function clearCurrentLeagueSelection() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.dropDownLeaguesData.length)
         {
            this.dropDownLeaguesData[_loc1_].selected = false;
            _loc1_++;
         }
      }
      
      private function onRankDragSelection(param1:LeagueRank) : void
      {
         this.setNewRank(param1);
      }
      
      private function onChallengerTierSelection(param1:uint) : void
      {
         this.onChallengerTierChange(null);
      }
      
      private function onChallengerTierChange(param1:Vector.<ListItemObjectModel>) : void
      {
         var _loc3_:Object = null;
         this._leagueBadge.setBadgeState(LeagueTier.CHALLENGER,LeagueRank.I);
         this.hideVerticalDivisionSelector();
         this._leagueNameContainer.setCurrentState(LEAGUE_TYPE_CHALLENGER);
         this._leagueTierMedalName.setText(this._tiersNamesLocalized[LeagueTier.CHALLENGER]);
         this._championBanner.setVisible(false);
         this._currentChampionBannerName = "";
         this.hideDecayMessaging();
         var _loc2_:int = 0;
         while(_loc2_ < this.dropDownLeaguesData.length)
         {
            _loc3_ = this.dropDownLeaguesData[_loc2_];
            if(_loc3_.type == LeaguesDropdownTypesEnum.CHALLENGER_TIER_TYPE)
            {
               this._pickLeagueDropdown.list.setSelectedIndex(_loc2_);
               this.updateLeagueSelection(_loc2_);
               break;
            }
            _loc2_++;
         }
      }
      
      private function onDivisionSelectorClicked(param1:LeagueRank) : void
      {
         this.setNewRank(param1);
      }
      
      private function onLeagueChange(param1:SummonerLeagueObjectModel) : void
      {
         var _loc5_:Champion = null;
         var _loc6_:Object = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:String = param1.leagueName;
         var _loc3_:String = this._localeHelper.getLeagueName(_loc2_);
         this._leagueName.setText(_loc3_);
         if(param1.tier == LeagueTier.MASTER)
         {
            this.hideVerticalDivisionSelector();
            this._leagueNameContainer.setCurrentState(LEAGUE_TYPE_MASTER);
            this._championBanner.setVisible(false);
            this._currentChampionBannerName = "";
         }
         else
         {
            this._divisionSelector.setVisible(true);
            this._leagueNameContainer.setCurrentState(LEAGUE_TYPE_NORMAL);
            if(this._currentChampionBannerName != _loc2_)
            {
               for each(_loc5_ in this._championIdMappping)
               {
                  if(_loc2_.toLowerCase().indexOf(_loc5_.skinName.toLowerCase()) == 0 || _loc5_.skinName.toLowerCase() == "monkeyking" && _loc2_.toLowerCase().indexOf("wukong") == 0)
                  {
                     this._championBanner.load(new URLRequest("mod/lsi/assets/championBanners/" + "league_header_" + _loc5_.skinName.toUpperCase() + ".jpg"));
                     this._championBanner.setVisible(true);
                     this._currentChampionBannerName = _loc2_;
                     break;
                  }
               }
            }
         }
         this.hideDecayMessaging();
         this._divisionSelector.setUserSelectedDivision(param1.rank);
         this._currentLeagueTierName = this._tiersNamesLocalized[param1.tier];
         this._leagueTierMedalName.setText(this._currentLeagueTierName);
         this._currentQueueType = param1.queueType;
         this._currentPlayerOrTeam = param1.teamName;
         this.processDecayMessages();
         var _loc4_:int = 0;
         while(_loc4_ < this.dropDownLeaguesData.length)
         {
            _loc6_ = this.dropDownLeaguesData[_loc4_];
            if(_loc6_.type == LeaguesDropdownTypesEnum.MY_LEAGUES_LIST_TYPE && _loc6_.league == param1)
            {
               this._pickLeagueDropdown.list.setSelectedIndex(_loc4_);
               this.updateLeagueSelection(_loc4_);
               break;
            }
            _loc4_++;
         }
      }
      
      private function setChallengerClock(param1:Number) : void
      {
         var _loc2_:Number = new Date().time;
         this._nextApexUpdateMs = param1;
         this._nextApexUpdateLastTimeSetMs = _loc2_;
      }
      
      private function updateChallengerClock(param1:TimerEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:String = null;
         if(!LeagueConfig.isMasterTierEnabled())
         {
            this._challengerClock.setText("");
         }
         else
         {
            _loc2_ = new Date().time;
            if(!this._nextApexUpdateMs || !this._nextApexUpdateLastTimeSetMs || this._nextApexUpdateMs < 0)
            {
               _loc3_ = "--:--:--";
            }
            else
            {
               _loc3_ = this.msToCountdownString(this._nextApexUpdateMs - (_loc2_ - this._nextApexUpdateLastTimeSetMs));
            }
            this._challengerClock.setText(this._challengerClockLocalizedPrefix + " " + _loc3_);
         }
      }
      
      private function msToCountdownString(param1:Number) : String
      {
         if(!param1 || param1 <= 0)
         {
            return "--:--:--";
         }
         var _loc2_:String = this.pad(param1 / 1000 % 60,2);
         var _loc3_:String = this.pad(param1 / 60000 % 60,2);
         var _loc4_:String = this.pad(param1 / 3600000,2);
         return _loc4_ + ":" + _loc3_ + ":" + _loc2_;
      }
      
      private function pad(param1:int, param2:int) : String
      {
         var _loc3_:String = param1.toString();
         while(_loc3_.length < param2)
         {
            _loc3_ = "0" + _loc3_;
         }
         return _loc3_;
      }
      
      private function processDecayMessages(param1:Boolean = false) : void
      {
         if(this._summonerHelper.currentSummoner != Session.instance.summoner.name)
         {
            return;
         }
         var _loc2_:ILeagueDecayMessageController = getDependency(ILeagueDecayMessageController);
         var _loc3_:Object = _loc2_.getProfileScreenDecayMessage(QueueTypesEnum.INT_TO_QUEUES[this._currentQueueType],this._currentPlayerOrTeam);
         if(_loc3_)
         {
            this._leagueDecayIcon.setVisible(true);
            this._leagueDecayPopup.show(_loc3_.message,param1);
         }
      }
      
      private function onDecayIconClick(param1:MouseEvent) : void
      {
         this.processDecayMessages(true);
      }
      
      private function hideDecayMessaging() : void
      {
         this._leagueDecayIcon.setVisible(false);
         this._leagueDecayPopup.hide();
      }
      
      private function getLocalizedLabels() : void
      {
         this.challengerTierTxt = this._localeHelper.localeLookup("rvdChallengerTier");
         this.fiveVersusFiveLabel = this._localeHelper.localeLookup("rvd5v5Teams");
         this.threeVersusThreeLabel = this._localeHelper.localeLookup("rvd3v3Teams");
         this.soloChallengerTypeLabel = this._localeHelper.localeLookup("rvdSoloQueue");
         this.myLeaguesLabel = this._localeHelper.localeLookup("rvdMyLeagues");
      }
      
      private function get leaguesLabel() : String
      {
         if(this._summonerHelper.currentSummoner == Session.instance.summoner.name)
         {
            return this.myLeaguesLabel;
         }
         return this._localeHelper.localeLookup("rvdOtherLeagues",[this._summonerHelper.currentSummoner]);
      }
   }
}

