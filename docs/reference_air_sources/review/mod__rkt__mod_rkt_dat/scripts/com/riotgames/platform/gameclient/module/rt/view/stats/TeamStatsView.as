package com.riotgames.platform.gameclient.module.rt.view.stats
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TeamStatsView;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.AggregatedStatType;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.LeagueItemDTO;
   import com.riotgames.platform.gameclient.domain.LeagueListDTO;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.model.TeamStatsProxy;
   import com.riotgames.platform.gameclient.module.rt.resource.RTContext;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import com.riotgames.platform.gameclient.module.rt.view.common.IActivatableView;
   import com.riotgames.pvpnet.rankedteams.stats.TeamQueuePlayerChampStats;
   import com.riotgames.pvpnet.rankedteams.stats.TeamQueueStats;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.leagues.ProfileUtils;
   import com.riotgames.rust.components.FlashFlexComponent;
   import com.riotgames.rust.components.dropdown.Dropdown;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import mx.events.ListEvent;
   
   public class TeamStatsView extends FlashFlexComponent implements IActivatableView
   {
      
      private static const incrementalAnimationDelay:int = 200;
      
      private static const animationDuration:int = 900;
      
      private var teamAverageKillsText:TextFieldProxy;
      
      private var champPanel:StatefulView;
      
      private var statsInfoIcon:SpriteProxy;
      
      private var _closeSignal:Signal;
      
      private var teamTotalAssistsText:TextFieldProxy;
      
      private var teamTotalDeathsText:TextFieldProxy;
      
      private var teamSubtitle:TextFieldProxy;
      
      private var teamRatingTitle:TextFieldProxy;
      
      private var stats:TeamQueueStats;
      
      private var champWonText:TextFieldProxy;
      
      private var teamRatingText:TextFieldProxy;
      
      private var achievementIcons:StatefulView;
      
      private var teamDoubleKillsText:TextFieldProxy;
      
      private var champWinPercentText:TextFieldProxy;
      
      private var champBars:Vector.<ChampBarView> = new Vector.<ChampBarView>();
      
      private var teamPentaKillsText:TextFieldProxy;
      
      private var champAchievementText:TextFieldProxy;
      
      private var champAverageAssistsText:TextFieldProxy;
      
      private var queueDropdown:Dropdown;
      
      private var teamWonText:TextFieldProxy;
      
      private var teamTripleKillsText:TextFieldProxy;
      
      private var champAverageDeathsText:TextFieldProxy;
      
      private var champLostText:TextFieldProxy;
      
      private var closeButton:ButtonX;
      
      private var teamWinPercentText:TextFieldProxy;
      
      private var teamAverageAssistsText:TextFieldProxy;
      
      private var champTotalKillsText:TextFieldProxy;
      
      private var champAverageKillsText:TextFieldProxy;
      
      private var ratingShield:StatefulView;
      
      private var teamAverageDeathsText:TextFieldProxy;
      
      private var noGamesPlayedText:TextFieldProxy;
      
      private var teamLostText:TextFieldProxy;
      
      private var teamQuadraKillsText:TextFieldProxy;
      
      private var champTotalDeathsText:TextFieldProxy;
      
      private var champTotalAssistsText:TextFieldProxy;
      
      private var teamTotalKillsText:TextFieldProxy;
      
      private var allStats:Dictionary;
      
      public function TeamStatsView(param1:RTContext)
      {
         super(param1,"ts.TeamStatsView");
         RTFacade.profileTeamProxy.teamLoaded.add(this.activate);
         var _loc2_:blix.assets.proxy.TeamStatsView = new blix.assets.proxy.TeamStatsView();
         this.queueDropdown = new Dropdown(this.view,QueueDropdownRenderer);
         this.queueDropdown.listLinkage = "st.DropdownList";
         this.queueDropdown.listRendererLinkage = "st.QueueDropdownRenderer";
         this.queueDropdown.listRenderer = QueueDropdownRenderer;
         this.view.setTimelineChild(_loc2_.queueDropdown,this.queueDropdown);
         this.ratingShield = new StatefulView(this.view);
         this.view.setTimelineChild(_loc2_.background_elements.rating_shield,this.ratingShield);
         this.statsInfoIcon = new SpriteProxy(this.view);
         this.view.setTimelineChild(_loc2_.statsInfoIcon,this.statsInfoIcon);
         this.achievementIcons = new StatefulView(this.view);
         this.view.setTimelineChild(_loc2_.champPanel.achievementIcons,this.achievementIcons);
         this.teamRatingTitle = new TextFieldProxy(this.view);
         this.teamSubtitle = new TextFieldProxy(this.view);
         this.view.setTimelineChildByName("teamSubtitle",this.teamSubtitle);
         this.view.setTimelineChildByName("teamRatingTitle",this.teamRatingTitle);
         this.teamWonText = _loc2_.teamWonText.create(this.view);
         this.teamRatingText = _loc2_.background_elements.rating_shield.teamRatingText.create(this.view);
         this.teamLostText = _loc2_.teamLostText.create(this.view);
         this.teamWinPercentText = _loc2_.background_elements.rating_shield.teamWinPercentText.create(this.view);
         this.teamTotalKillsText = _loc2_.teamTotalKillsText.create(this.view);
         this.teamAverageKillsText = _loc2_.teamAverageKillsText.create(this.view);
         this.teamTotalDeathsText = _loc2_.teamTotalDeathsText.create(this.view);
         this.teamAverageDeathsText = _loc2_.teamAverageDeathsText.create(this.view);
         this.teamTotalAssistsText = new TextFieldProxy(this.view);
         this.view.setTimelineChildByName("teamTotalAssistsText",this.teamTotalAssistsText);
         this.teamAverageAssistsText = _loc2_.teamAverageAssistsText.create(this.view);
         this.teamDoubleKillsText = _loc2_.teamDoubleKillsText.create(this.view);
         this.teamTripleKillsText = _loc2_.teamTripleKillsText.create(this.view);
         this.teamQuadraKillsText = _loc2_.teamQuadraKillsText.create(this.view);
         this.teamPentaKillsText = _loc2_.teamPentaKillsText.create(this.view);
         this.noGamesPlayedText = _loc2_.noGamesPlayedText.create(this.view);
         this.champPanel = new StatefulView(this.view);
         this.view.setTimelineChild(_loc2_.champPanel,this.champPanel);
         var _loc3_:int = 0;
         while(_loc3_ < 5)
         {
            this.champBars.push(this.wireChampBar("champBar" + _loc3_));
            this.champBars[_loc3_].index = _loc3_;
            _loc3_++;
         }
         this.champWonText = _loc2_.champPanel.champWonText.create(this.view);
         this.champLostText = _loc2_.champPanel.champLostText.create(this.view);
         this.champWinPercentText = _loc2_.champPanel.champWinPercentText.create(this.view);
         this.champTotalKillsText = _loc2_.champPanel.champTotalKillsText.create(this.view);
         this.champAverageKillsText = _loc2_.champPanel.champAverageKillsText.create(this.view);
         this.champTotalDeathsText = _loc2_.champPanel.champTotalDeathsText.create(this.view);
         this.champAverageDeathsText = _loc2_.champPanel.champAverageDeathsText.create(this.view);
         this.champTotalAssistsText = _loc2_.champPanel.champTotalAssistsText.create(this.view);
         this.champAverageAssistsText = _loc2_.champPanel.champAverageAssistsText.create(this.view);
         this.champAchievementText = _loc2_.champPanel.champAchievementText.create(this.view);
         this.closeButton = new ButtonX(this.view);
         this.view.setTimelineChildByName("closeButton",this.closeButton);
         this.closeButton.addEventListener(MouseEvent.MOUSE_DOWN,this.onCloseButtonClicked);
         this.closeButton.setVisible(false);
         this.view.setCurrentState("loading");
      }
      
      public function set closeSignal(param1:Signal) : void
      {
         this._closeSignal = param1;
      }
      
      private function wireChampBar(param1:String) : ChampBarView
      {
         var _loc2_:ChampBarView = new ChampBarView(this.view);
         this.view.setTimelineChildByName(param1,_loc2_);
         _loc2_.selected.add(this.selectChampForDisplay);
         return _loc2_;
      }
      
      private function buildComboData(param1:TeamQueueStats) : Object
      {
         var _loc2_:String = RTResource.getString("stQueueName" + param1.queueId);
         return {
            "label":_loc2_,
            "queue":param1
         };
      }
      
      private function processChamps() : void
      {
         var _loc2_:TeamQueuePlayerChampStats = null;
         var _loc3_:Number = NaN;
         var _loc7_:TeamQueuePlayerChampStats = null;
         var _loc8_:Champion = null;
         var _loc9_:Number = NaN;
         var _loc10_:Object = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.stats.allPlayers.championsMap)
         {
            _loc1_.push(_loc2_);
         }
         _loc1_.sort(this.sortChampsByMostPlayed);
         if(_loc1_[0])
         {
            _loc3_ = Number((_loc1_[0] as TeamQueuePlayerChampStats).getGamesPlayed());
            if(_loc3_ < 1)
            {
               _loc3_ = 1;
            }
         }
         var _loc4_:Array = _loc1_.slice(0,this.champBars.length);
         var _loc5_:Array = this.getChampAchievements(_loc4_);
         var _loc6_:int = 0;
         while(_loc6_ < this.champBars.length)
         {
            _loc7_ = _loc1_[_loc6_];
            if(!_loc7_)
            {
               break;
            }
            _loc8_ = RTFacade.instance.rtProvider.getChampionById(_loc7_.champId);
            if(!_loc8_)
            {
               _loc8_ = RTFacade.instance.rtProvider.getChampionById(1);
            }
            _loc9_ = _loc7_.getGamesPlayed() / _loc3_;
            _loc10_ = _loc5_[_loc8_.championId];
            if(!_loc10_)
            {
               _loc10_ = {};
            }
            this.champBars[_loc6_].setChampData(_loc7_,_loc8_.displayName,_loc10_.achievement,this.formatValue(_loc10_.value,1));
            this.champBars[_loc6_].animate(_loc9_,_loc6_ * incrementalAnimationDelay,animationDuration);
            _loc6_++;
         }
         while(_loc6_ < this.champBars.length)
         {
            this.champBars[_loc6_].setChampData(null,null,null,null);
            this.champBars[_loc6_].animate(0,0,0);
            _loc6_++;
         }
         this.selectChampForDisplay(this.champBars[0]);
      }
      
      private function getLeaguePoints(param1:LeagueListDTO, param2:String) : Number
      {
         var _loc4_:LeagueListDTO = null;
         var _loc5_:LeagueItemDTO = null;
         var _loc3_:Number = 0;
         for each(_loc4_ in param1)
         {
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.playerOrTeamName == param2)
               {
                  _loc3_ = Number(_loc5_.leaguePoints);
               }
            }
         }
         return _loc3_;
      }
      
      private function onStatsChanged() : void
      {
         this.allStats = RTFacade.statsProxy.stats;
         this.refreshView();
      }
      
      private function wireToolTip() : void
      {
         var _loc1_:StatefulView = new StatefulView(this.view);
         _loc1_.setLinkage("st.AboutStatsTip");
         var _loc2_:StationaryAnimatedTooltipHandler = new StationaryAnimatedTooltipHandler(_loc1_);
         _loc2_.showDelay = 0;
         assignToolTip(this.statsInfoIcon,null,_loc2_);
      }
      
      private function get view() : StatefulView
      {
         return _view as StatefulView;
      }
      
      private function showQueue(param1:TeamQueueStats) : void
      {
         this.stats = param1;
         this.hookupDynamicText();
         var _loc2_:Boolean = Boolean(ClientConfig.instance.leagueServiceEnabled);
         if(!this.stats || this.stats.wins + this.stats.losses == 0)
         {
            this.noGamesPlayedText.setVisible(true);
         }
         else
         {
            this.noGamesPlayedText.setVisible(false);
         }
         if(_loc2_)
         {
            if(Boolean(param1.isLeague) && param1.league != null)
            {
               this.teamSubtitle.setText(param1.league.name);
               this.teamRatingText.setText(param1.leaguePoints + RTResource.getString("leaguePointsLabel"));
               this.teamRatingText.setVisible(true);
            }
            else
            {
               this.teamSubtitle.setText(RTResource.getString("profileQueueHiddenRating",[this.stats.wins + this.stats.losses,ProfileUtils.MIN_RANKED_GAMES_FOR_LEAGUES["RANKED_TEAM_5x5"]]));
               this.teamRatingText.setVisible(false);
            }
         }
         else
         {
            this.teamSubtitle.setText(RTResource.getString("profileQueueHiddenRating",[this.stats.wins + this.stats.losses,ProfileUtils.MIN_RANKED_GAMES_FOR_LEAGUES["RANKED_TEAM_5x5"]]));
            this.teamRatingText.setVisible(false);
         }
         this.teamSubtitle.setVisible(_loc2_);
         this.processChamps();
      }
      
      private function refreshView() : void
      {
         var _loc1_:Array = null;
         var _loc2_:TeamQueueStats = null;
         if(this.allStats)
         {
            this.view.setCurrentState("showStats");
            _loc1_ = [];
            _loc1_.push(this.buildComboData(this.allStats[TeamQueueStats.ALL]));
            for each(_loc2_ in this.allStats)
            {
               if(_loc2_.queueId != TeamQueueStats.ALL)
               {
                  _loc1_.push(this.buildComboData(_loc2_));
               }
            }
            this.queueDropdown.removeEventListener(ListEvent.CHANGE,this.onQueueChanged);
            this.queueDropdown.data = _loc1_;
            this.queueDropdown.selectionChanged.add(this.onQueueChanged);
            this.teamRatingTitle.setText(RTFacade.profileTeamProxy.team.name);
            this.showQueue(this.allStats[TeamQueueStats.ALL]);
         }
         else
         {
            this.view.setCurrentState("loading");
         }
         this.wireToolTip();
      }
      
      override protected function createView() : DisplayObjectProxy
      {
         return new StatefulViewWithPopupManagement(_context);
      }
      
      private function onCloseButtonClicked(param1:MouseEvent) : void
      {
         if(this._closeSignal == null)
         {
            return;
         }
         this._closeSignal.dispatch();
      }
      
      private function formatValue(param1:Number, param2:int) : String
      {
         if(param2 == 0)
         {
            param1 = Math.floor(param1);
            return param1.toString();
         }
         return param1.toFixed(param2);
      }
      
      private function selectChampForDisplay(param1:ChampBarView) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc2_:TeamQueuePlayerChampStats = param1.champStats;
         var _loc3_:int = 0;
         while(_loc3_ < this.champBars.length)
         {
            this.champBars[_loc3_].setSelected(false);
            _loc3_++;
         }
         if(_loc2_)
         {
            param1.setSelected(true);
            this.champPanel.setCurrentState("champ" + param1.index);
            this.showChampStat(this.champWonText,_loc2_,AggregatedStatType.STAT_TYPE_WINS,0);
            this.showChampStat(this.champLostText,_loc2_,AggregatedStatType.STAT_TYPE_LOSSES,0);
            _loc4_ = int(_loc2_.getStatValue(AggregatedStatType.STAT_TYPE_WINS));
            _loc5_ = int(_loc2_.getStatValue(AggregatedStatType.STAT_TYPE_LOSSES));
            this.champWinPercentText.setText(RTResource.getString("stChampWinPercentValue",[this.getWinPercentText(_loc4_,_loc5_)]));
            this.showChampStat(this.champTotalKillsText,_loc2_,AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_KILLS,0);
            this.showChampStat(this.champTotalDeathsText,_loc2_,AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_DEATHS,0);
            this.showChampStat(this.champTotalAssistsText,_loc2_,AggregatedStatType.TOTAL_ASSISTS,0);
            _loc6_ = Math.max(_loc2_.getGamesPlayed(),1);
            _loc7_ = this.formatValue(_loc2_.getStatValue(AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_KILLS) / _loc6_,1);
            this.champAverageKillsText.setText(RTResource.getString("stPerGame",[_loc7_]));
            _loc7_ = this.formatValue(_loc2_.getStatValue(AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_DEATHS) / _loc6_,1);
            this.champAverageDeathsText.setText(RTResource.getString("stPerGame",[_loc7_]));
            _loc7_ = this.formatValue(_loc2_.getStatValue(AggregatedStatType.TOTAL_ASSISTS) / _loc6_,1);
            this.champAverageAssistsText.setText(RTResource.getString("stPerGame",[_loc7_]));
            _loc8_ = param1.champAchievement;
            if(_loc8_)
            {
               this.champAchievementText.setText(RTResource.getString("stAchievement_" + _loc8_,[param1.champAchievementDetail]));
               this.achievementIcons.setCurrentState(_loc8_);
               this.achievementIcons.setVisible(true);
            }
            else
            {
               this.champAchievementText.setText(null);
               this.achievementIcons.setVisible(false);
            }
         }
         else
         {
            this.champPanel.setCurrentState("none");
            this.achievementIcons.setVisible(false);
         }
      }
      
      private function getChampAchievements(param1:Array) : Array
      {
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc2_:Array = [TeamStatsProxy.CHAMP_HIGHEST_WIN_RATIO,TeamStatsProxy.CHAMP_HIGHEST_AVERAGE_KILLS,TeamStatsProxy.CHAMP_HIGHEST_AVERAGE_GOLD,TeamStatsProxy.CHAMP_HIGHEST_AVERAGE_ASSISTS,TeamStatsProxy.CHAMP_LOWEST_AVERAGE_DEATHS,TeamStatsProxy.CHAMP_HIGHEST_AVERAGE_MINIONS_KILLED,TeamStatsProxy.CHAMP_HIGHEST_AVERAGE_DAMAGE_DEALT,TeamStatsProxy.CHAMP_HIGHEST_AVERAGE_MULTI_KILLS,TeamStatsProxy.CHAMP_MAX_KILLING_SPREE,TeamStatsProxy.CHAMP_MAX_CRIT,TeamStatsProxy.CHAMP_HIGHEST_AVERAGE_DAMAGE_TAKEN,TeamStatsProxy.CHAMP_LOWEST_AVERAGE_DAMAGE_TAKEN,TeamStatsProxy.CHAMP_HIGHEST_AVERAGE_BUILDINGS_DESTROYED,TeamStatsProxy.CHAMP_HIGHEST_AVERAGE_HEALING,TeamStatsProxy.CHAMP_HIGHEST_AVERAGE_PHYSICAL_DAMAGE_DEALT,TeamStatsProxy.CHAMP_HIGHEST_AVERAGE_MAGIC_DAMAGE_DEALT,TeamStatsProxy.CHAMP_MOST_WINS,TeamStatsProxy.CHAMP_MOST_KILLS,TeamStatsProxy.CHAMP_MOST_GOLD,TeamStatsProxy.CHAMP_MOST_ASSISTS,TeamStatsProxy.CHAMP_MOST_MINIONS_KILLED,TeamStatsProxy.CHAMP_MOST_DAMAGE_DEALT,TeamStatsProxy.CHAMP_MOST_MULTI_KILLS
         ,TeamStatsProxy.CHAMP_MOST_DAMAGE_TAKEN,TeamStatsProxy.CHAMP_MOST_BUILDINGS_DESTROYED,TeamStatsProxy.CHAMP_MOST_HEALING,TeamStatsProxy.CHAMP_MOST_PHYSICAL_DAMAGE_DEALT,TeamStatsProxy.CHAMP_MOST_MAGIC_DAMAGE_DEALT];
         var _loc3_:Dictionary = TeamStatsProxy.computeChampionCallouts(param1);
         var _loc4_:Array = [];
         for each(_loc5_ in _loc2_)
         {
            _loc6_ = _loc3_[_loc5_];
            if(_loc6_.champ)
            {
               if(!_loc4_[_loc6_.champ])
               {
                  _loc6_.achievement = _loc5_;
                  _loc4_[_loc6_.champ] = _loc6_;
               }
            }
         }
         return _loc4_;
      }
      
      public function set isLeague(param1:Boolean) : void
      {
         if(param1)
         {
            this.closeButton.setVisible(true);
            this.teamRatingText.setVisible(false);
         }
         else
         {
            this.closeButton.setVisible(false);
         }
      }
      
      private function hookupDynamicText() : void
      {
         var _loc2_:String = null;
         if(!this.stats)
         {
            return;
         }
         this.teamWonText.setText(this.stats.wins.toString());
         this.teamLostText.setText(this.stats.losses.toString());
         if(!this.stats.isRanked)
         {
            this.teamRatingText.setText(RTResource.getString("statusUnranked"));
         }
         this.teamWinPercentText.setText(RTResource.getString("stWinPercentInline",[this.getWinPercentText(this.stats.wins,this.stats.losses)]));
         this.showStat(this.teamTotalKillsText,AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_KILLS,0);
         this.showStat(this.teamTotalDeathsText,AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_DEATHS,0);
         this.showStat(this.teamTotalAssistsText,AggregatedStatType.TOTAL_ASSISTS,0);
         var _loc1_:Number = Math.max(this.stats.wins + this.stats.losses,1);
         this.teamAverageKillsText.setText("");
         this.teamAverageDeathsText.setText("");
         this.teamAverageAssistsText.setText("");
         var _loc3_:int = int(this.stats.allPlayers.getStatValue(AggregatedStatType.TOTAL_DOUBLE_KILLS));
         var _loc4_:int = int(this.stats.allPlayers.getStatValue(AggregatedStatType.TOTAL_TRIPLE_KILLS));
         var _loc5_:int = int(this.stats.allPlayers.getStatValue(AggregatedStatType.TOTAL_QUADRA_KILLS));
         var _loc6_:int = int(this.stats.allPlayers.getStatValue(AggregatedStatType.TOTAL_PENTA_KILLS));
         this.teamDoubleKillsText.setText(this.formatValue(_loc3_ - _loc4_,0));
         this.teamTripleKillsText.setText(this.formatValue(_loc4_ - _loc5_,0));
         this.teamQuadraKillsText.setText(this.formatValue(_loc5_ - _loc6_,0));
         this.teamPentaKillsText.setText(this.formatValue(_loc6_,0));
      }
      
      private function sortChampsByMostPlayed(param1:TeamQueuePlayerChampStats, param2:TeamQueuePlayerChampStats) : int
      {
         var _loc3_:int = int(param1.getGamesPlayed());
         var _loc4_:int = int(param2.getGamesPlayed());
         return _loc4_ - _loc3_;
      }
      
      private function getWinPercentText(param1:int, param2:int) : String
      {
         if(param1 == 0 && param2 == 0)
         {
            return "";
         }
         if(param1 == 0)
         {
            return "0";
         }
         if(param2 == 0)
         {
            return "100";
         }
         var _loc3_:Number = param1 / (param1 + param2);
         var _loc4_:Number = _loc3_ * 100;
         return _loc4_.toFixed(1);
      }
      
      private function showChampStat(param1:TextFieldProxy, param2:TeamQueuePlayerChampStats, param3:String, param4:int) : void
      {
         var _loc5_:Number = Number(param2.getStatValue(param3));
         param1.setText(this.formatValue(_loc5_,param4));
      }
      
      private function onQueueChanged() : void
      {
         var _loc1_:Object = this.queueDropdown.data[this.queueDropdown.selectedIndex];
         var _loc2_:TeamQueueStats = _loc1_.queue;
         this.showQueue(_loc2_);
      }
      
      public function activate() : void
      {
         RTFacade.statsProxy.statsChanged.add(this.onStatsChanged);
         RTFacade.statsProxy.resetStats();
         RTFacade.statsProxy.retrieveStats(RTFacade.profileTeamProxy.team);
         if(RTFacade.profilePlayerProxy.isLocal)
         {
         }
      }
      
      public function deactivate() : void
      {
         RTFacade.statsProxy.statsChanged.remove(this.onStatsChanged);
      }
      
      private function showStat(param1:TextFieldProxy, param2:String, param3:int) : void
      {
         var _loc4_:Number = Number(this.stats.allPlayers.getStatValue(param2));
         param1.setText(this.formatValue(_loc4_,param3));
      }
   }
}

