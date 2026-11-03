package com.riotgames.platform.gameclient.views.summoner.stats
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.game.QueueType;
   import com.riotgames.platform.gameclient.domain.rankedTeams.RankedDisplayBucketDTO;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   import com.riotgames.pvpnet.system.leagues.ProfileUtils;
   import flash.accessibility.*;
   import flash.data.*;
   import flash.debugger.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filesystem.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.html.*;
   import flash.html.script.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.containers.Canvas;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class RankedDisplayBucket extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const WARNING_ICON:Class = RankedDisplayBucket_WARNING_ICON;
      
      public static const YELLOW_WARNING_ICON:Class = RankedDisplayBucket_YELLOW_WARNING_ICON;
      
      private var _599883856unrankedLabel:Label;
      
      mx_internal var _watchers:Array = [];
      
      private var _149635589leagueLabel:Label;
      
      private var _stats:RankedDisplayBucketDTO;
      
      private var showStatsAnyway:Boolean = false;
      
      private var _962121163medalDisplay:MedalDisplay;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _1037111740subtitleLabel:Label;
      
      private var _1791483012titleLabel:Label;
      
      private var _747378099yellowWarningImage:Image;
      
      mx_internal var _bindings:Array = [];
      
      private var _151871548currRatingText:Text;
      
      private var _607443376redWarningImage:Image;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":MedalDisplay,
               "id":"medalDisplay"
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"yellowWarningImage",
               "stylesFactory":function():void
               {
                  this.horizontalCenter = "-2";
                  this.top = "72";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "height":27,
                     "width":27,
                     "visible":false
                  };
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"redWarningImage",
               "stylesFactory":function():void
               {
                  this.horizontalCenter = "-2";
                  this.top = "72";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "height":27,
                     "width":27,
                     "visible":false
                  };
               }
            }),new UIComponentDescriptor({
               "type":Label,
               "id":"titleLabel",
               "stylesFactory":function():void
               {
                  this.top = "40";
                  this.left = "0";
                  this.right = "3";
                  this.fontWeight = "normal";
                  this.fontSize = 14;
                  this.textAlign = "center";
               },
               "propertiesFactory":function():Object
               {
                  return {"styleName":"summonerStatsTextSmall"};
               }
            }),new UIComponentDescriptor({
               "type":Label,
               "id":"subtitleLabel",
               "stylesFactory":function():void
               {
                  this.top = "58";
                  this.left = "0";
                  this.fontSize = 14;
                  this.color = 5708042;
                  this.textAlign = "center";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "width":240,
                     "styleName":"summonerStatsTextSmall"
                  };
               }
            }),new UIComponentDescriptor({
               "type":Label,
               "id":"unrankedLabel",
               "stylesFactory":function():void
               {
                  this.top = "83";
                  this.horizontalCenter = "-3";
               },
               "propertiesFactory":function():Object
               {
                  return {"styleName":"summonerProfileUnrankedText"};
               }
            }),new UIComponentDescriptor({
               "type":Text,
               "id":"winLossLabel",
               "stylesFactory":function():void
               {
                  this.bottom = "35";
                  this.left = "15";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "styleName":"summonerStatsTextLarge",
                     "selectable":false,
                     "mouseEnabled":false,
                     "mouseChildren":false
                  };
               }
            }),new UIComponentDescriptor({
               "type":Text,
               "id":"currRatingText",
               "stylesFactory":function():void
               {
                  this.bottom = "35";
                  this.right = "15";
                  this.textAlign = "right";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "styleName":"summonerStatsTextLarge",
                     "selectable":false,
                     "mouseEnabled":false,
                     "mouseChildren":false
                  };
               }
            }),new UIComponentDescriptor({
               "type":Label,
               "id":"leagueLabel",
               "stylesFactory":function():void
               {
                  this.bottom = "3";
                  this.left = "0";
                  this.fontSize = 12;
                  this.color = 8650752;
                  this.fontWeight = "bold";
                  this.textAlign = "center";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "width":240,
                     "styleName":"summonerStatsTextSmall"
                  };
               }
            })]};
         }
      });
      
      private var _938062101winLossLabel:Text;
      
      public function RankedDisplayBucket()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.verticalScrollPolicy = "off";
         this.horizontalScrollPolicy = "off";
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         RankedDisplayBucket._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get leagueLabel() : Label
      {
         return this._149635589leagueLabel;
      }
      
      public function set titleLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1791483012titleLabel;
         if(_loc2_ !== param1)
         {
            this._1791483012titleLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"titleLabel",_loc2_,param1));
         }
      }
      
      private function getMedalRank() : LeagueRank
      {
         if(this.isLeague)
         {
            return LeagueRank.valueOf(this._stats.league.requestorsRank);
         }
         return LeagueRank.DEFAULT;
      }
      
      private function setEmptyMedalImage() : void
      {
         this.medalDisplay.setMedal(LeagueTier.NULL,LeagueRank.DEFAULT);
      }
      
      public function set leagueLabel(param1:Label) : void
      {
         var _loc2_:Object = this._149635589leagueLabel;
         if(_loc2_ !== param1)
         {
            this._149635589leagueLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leagueLabel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get winLossLabel() : Text
      {
         return this._938062101winLossLabel;
      }
      
      public function set medalDisplay(param1:MedalDisplay) : void
      {
         var _loc2_:Object = this._962121163medalDisplay;
         if(_loc2_ !== param1)
         {
            this._962121163medalDisplay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"medalDisplay",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:RankedDisplayBucket = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._RankedDisplayBucket_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_summoner_stats_RankedDisplayBucketWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },bindings,watchers);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         super.initialize();
      }
      
      public function showStats(param1:RankedDisplayBucketDTO, param2:Boolean) : void
      {
         this.showStatsAnyway = param2;
         this._stats = param1;
         invalidateProperties();
      }
      
      public function set winLossLabel(param1:Text) : void
      {
         var _loc2_:Object = this._938062101winLossLabel;
         if(_loc2_ !== param1)
         {
            this._938062101winLossLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"winLossLabel",_loc2_,param1));
         }
      }
      
      private function getLeagueTier() : LeagueTier
      {
         if(this.isLeague)
         {
            return LeagueTier.valueOf(this._stats.league.tier);
         }
         return LeagueTier.NULL;
      }
      
      public function set redWarningImage(param1:Image) : void
      {
         var _loc2_:Object = this._607443376redWarningImage;
         if(_loc2_ !== param1)
         {
            this._607443376redWarningImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"redWarningImage",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get unrankedLabel() : Label
      {
         return this._599883856unrankedLabel;
      }
      
      [Bindable(event="propertyChange")]
      public function get yellowWarningImage() : Image
      {
         return this._747378099yellowWarningImage;
      }
      
      private function formatWinLossLabel(param1:int, param2:int) : String
      {
         var _loc3_:String = "";
         _loc3_ += RiotResourceLoader.getString("playerProfile_winsAbbreviationAndColor","**WINS" + param1,[param1]);
         if(param2 >= 0)
         {
            _loc3_ += " <br/>";
            _loc3_ += RiotResourceLoader.getString("playerProfile_lossesAbbreviationAndColor","**GAMES" + param2 + param1,[param2 + param1]);
         }
         return _loc3_;
      }
      
      [Bindable(event="propertyChange")]
      public function get currRatingText() : Text
      {
         return this._151871548currRatingText;
      }
      
      private function formatCurrentRating(param1:int) : String
      {
         var _loc2_:String = "";
         if(param1 > 0)
         {
            _loc2_ = RiotResourceLoader.getString("summonerProfile_profile_stats_CurrentRating","**CURRENTRATING<p></p>" + param1,[param1]);
         }
         return _loc2_;
      }
      
      private function setProvisionalMedalImage() : void
      {
         this.medalDisplay.setMedal(LeagueTier.PROVISIONAL,LeagueRank.DEFAULT);
      }
      
      [Bindable(event="propertyChange")]
      public function get subtitleLabel() : Label
      {
         return this._1037111740subtitleLabel;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         super.commitProperties();
         this.setEmptyMedalImage();
         this.titleLabel.text = "";
         this.subtitleLabel.text = "";
         this.unrankedLabel.visible = false;
         this.winLossLabel.text = "";
         this.currRatingText.text = "";
         this.leagueLabel.text = "";
         if(this._stats)
         {
            switch(this._stats.queueType)
            {
               case QueueType.RANKED_PREMADE_3x3:
                  this.titleLabel.text = RiotResourceLoader.getString("summonerProfile_profile_statsArrangedTeams3x3Title");
                  this.subtitleLabel.text = "";
                  break;
               case QueueType.RANKED_PREMADE_5x5:
                  this.titleLabel.text = RiotResourceLoader.getString("summonerProfile_profile_statsArrangedTeams5x5Title");
                  this.subtitleLabel.text = "";
                  break;
               case QueueType.RANKED_SOLO_5x5:
                  this.titleLabel.text = RiotResourceLoader.getString("summonerProfile_profile_statsSoloTitle");
                  this.subtitleLabel.text = "";
                  break;
               case QueueType.RANKED_TEAM_3x3:
                  this.titleLabel.text = RiotResourceLoader.getString("summonerProfile_profile_statsRankedTeamsTitle3x3");
                  this.subtitleLabel.text = this._stats.teamName;
                  break;
               case QueueType.RANKED_TEAM_5x5:
                  this.titleLabel.text = RiotResourceLoader.getString("summonerProfile_profile_statsRankedTeamsTitle5x5");
                  this.subtitleLabel.text = this._stats.teamName;
            }
            if(this._stats.onlyDisplayQueueType)
            {
               this.setEmptyMedalImage();
               this.subtitleLabel.text = "";
               this.unrankedLabel.visible = false;
               this.winLossLabel.text = "";
               this.currRatingText.text = "";
               this.leagueLabel.text = "";
               return;
            }
            _loc1_ = this._stats.wins + this._stats.losses + this._stats.leaves;
            _loc2_ = _loc1_ > 0;
            _loc3_ = _loc2_ && !this.isLeague && _loc1_ < ProfileUtils.MIN_RANKED_GAMES_FOR_LEAGUES[this._stats.queueType];
            if(!this.isLeague && !ClientConfig.instance.leagueServiceEnabled)
            {
               this.unrankedLabel.visible = _loc3_;
            }
            if(_loc2_ || this.isLeague)
            {
               if(_loc3_)
               {
                  this.currRatingText.htmlText = "";
                  this.subtitleLabel.text = RiotResourceLoader.getString("profile_provisional_title");
                  this.leagueLabel.text = RiotResourceLoader.getString("profile_division_provisional","**profile_division_provisional",[_loc1_,ProfileUtils.MIN_RANKED_GAMES_FOR_LEAGUES[this._stats.queueType]]);
                  this.setProvisionalMedalImage();
               }
               else
               {
                  if(this.isLeague)
                  {
                     this.winLossLabel.htmlText = this.formatWinLossLabel(this._stats.wins,this.showStatsAnyway ? int(this._stats.losses) : -1);
                  }
                  this.currRatingText.htmlText = "";
                  if(this.isLeague)
                  {
                     this.yellowWarningImage.visible = false;
                     this.redWarningImage.visible = false;
                     if(this._stats.teamName != "" && Boolean(DynamicClientConfigManager.getConfiguration("SeasonReward","QualificationWarningEnabled",false).getValue()))
                     {
                        this.redWarningImage.visible = !this._stats.isPersonallyQualified;
                        this.redWarningImage.toolTip = RiotResourceLoader.getString("rankedTeams_notQualifiedForRewardsTooltip",null,[this._stats.numGamesNeededForQualification]);
                     }
                     if(DynamicClientConfigManager.getConfiguration("SeasonReward","DemotionWarningEnabled",false).getValue())
                     {
                        if(this._stats.demotionWarningLevel == 1)
                        {
                           this.yellowWarningImage.visible = true;
                           this.yellowWarningImage.toolTip = RiotResourceLoader.getString("demotionShieldLevel1Warning");
                        }
                        else if(this._stats.demotionWarningLevel == 2)
                        {
                           this.redWarningImage.visible = true;
                           if(!this._stats.isPersonallyQualified && this._stats.teamName != "" && Boolean(DynamicClientConfigManager.getConfiguration("SeasonReward","QualificationWarningEnabled",false).getValue()))
                           {
                              this.redWarningImage.toolTip += "\n\n" + RiotResourceLoader.getString("demotionShieldLevel2Warning");
                           }
                           else
                           {
                              this.redWarningImage.toolTip = RiotResourceLoader.getString("demotionShieldLevel2Warning");
                           }
                        }
                     }
                     if(!LeagueTier.valueOf(this._stats.league.tier).isApex())
                     {
                        this.subtitleLabel.text = this._stats.league.name;
                     }
                     this.currRatingText.htmlText = RiotResourceLoader.getString("summonerProfile_profile_stats_LeaguePoints","**POINTS" + this._stats.leaguePoints,[this._stats.leaguePoints]);
                     if(this.isLeague && (this._stats.queueType != QueueType.RANKED_PREMADE_3x3 && this._stats.queueType != QueueType.RANKED_PREMADE_5x5))
                     {
                        this.leagueLabel.text = RiotResourceLoader.getString("profile_devision_display",null,[RiotResourceLoader.getString("leagues_rank_" + this._stats.league.tier,"**" + this._stats.league.tier),RiotResourceLoader.getString("leagues_tier_" + this._stats.league.requestorsRank,"**" + this._stats.league.requestorsRank)]);
                     }
                  }
                  this.setRankedMedalImage();
               }
            }
            else
            {
               this.yellowWarningImage.visible = false;
               this.redWarningImage.visible = false;
               this.subtitleLabel.text = "";
               this.winLossLabel.htmlText = "";
               this.currRatingText.htmlText = "";
               this.setEmptyMedalImage();
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get medalDisplay() : MedalDisplay
      {
         return this._962121163medalDisplay;
      }
      
      public function clear() : void
      {
         this._stats = null;
         invalidateProperties();
      }
      
      [Bindable(event="propertyChange")]
      public function get redWarningImage() : Image
      {
         return this._607443376redWarningImage;
      }
      
      private function _RankedDisplayBucket_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = YELLOW_WARNING_ICON;
         _loc1_ = WARNING_ICON;
         _loc1_ = RiotResourceLoader.getString("endofgame_overview_unranked");
      }
      
      private function setRankedMedalImage() : void
      {
         this.medalDisplay.setMedal(this.getLeagueTier(),this.getMedalRank());
      }
      
      public function set unrankedLabel(param1:Label) : void
      {
         var _loc2_:Object = this._599883856unrankedLabel;
         if(_loc2_ !== param1)
         {
            this._599883856unrankedLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"unrankedLabel",_loc2_,param1));
         }
      }
      
      private function _RankedDisplayBucket_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return YELLOW_WARNING_ICON;
         },function(param1:Object):void
         {
            yellowWarningImage.source = param1;
         },"yellowWarningImage.source");
         result[0] = binding;
         binding = new Binding(this,function():Object
         {
            return WARNING_ICON;
         },function(param1:Object):void
         {
            redWarningImage.source = param1;
         },"redWarningImage.source");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("endofgame_overview_unranked");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            unrankedLabel.text = param1;
         },"unrankedLabel.text");
         result[2] = binding;
         return result;
      }
      
      public function set yellowWarningImage(param1:Image) : void
      {
         var _loc2_:Object = this._747378099yellowWarningImage;
         if(_loc2_ !== param1)
         {
            this._747378099yellowWarningImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yellowWarningImage",_loc2_,param1));
         }
      }
      
      public function set currRatingText(param1:Text) : void
      {
         var _loc2_:Object = this._151871548currRatingText;
         if(_loc2_ !== param1)
         {
            this._151871548currRatingText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currRatingText",_loc2_,param1));
         }
      }
      
      private function get isLeague() : Boolean
      {
         return this._stats != null && Boolean(this._stats.isLeague) && this._stats.league != null;
      }
      
      [Bindable(event="propertyChange")]
      public function get titleLabel() : Label
      {
         return this._1791483012titleLabel;
      }
      
      public function set subtitleLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1037111740subtitleLabel;
         if(_loc2_ !== param1)
         {
            this._1037111740subtitleLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"subtitleLabel",_loc2_,param1));
         }
      }
   }
}

