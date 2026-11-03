package com.riotgames.platform.gameclient.views.summoner.stats
{
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import com.riotgames.platform.gameclient.domain.PlayerStatSummary;
   import com.riotgames.platform.gameclient.domain.game.CompetitiveSeason;
   import com.riotgames.platform.gameclient.domain.game.GameMode;
   import com.riotgames.platform.gameclient.domain.game.QueueType;
   import com.riotgames.platform.gameclient.domain.rankedTeams.RankedDisplayBucketDTO;
   import com.riotgames.platform.gameclient.views.IViewLifecycle;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.rankedteams.IRankedTeamsProvider;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
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
   import mx.binding.utils.ChangeWatcher;
   import mx.containers.Canvas;
   import mx.containers.ViewStack;
   import mx.controls.Label;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.effects.Fade;
   import mx.effects.Sequence;
   import mx.effects.SetPropertyAction;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class ProfileStatsRankingView extends ViewStack implements IViewLifecycle, IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _1567555806firstNormalMedalDisplay:MedalDisplay;
      
      private var _687972810rankedBucket_5v5:RankedDisplayBucket;
      
      private var summonerProfileControllerWatcher:ChangeWatcher = null;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _146790551rankedBucket_Solo:RankedDisplayBucket;
      
      private var _1678843372_gameMode:String = "CLASSIC";
      
      [Inject]
      private var _566834807summonerProfileController:SummonerProfileController;
      
      private var _2138341969secondNormalBucketLabel:Label;
      
      private var _738986113firstNormalBucket:Canvas;
      
      private var _45526771firstNormalBucketLabel:Label;
      
      private var initializeOnCreation:Boolean = false;
      
      private var _2113274557normalStatsView:Canvas;
      
      mx_internal var _watchers:Array = [];
      
      private var _329336172thirdNormalBucketSubLabel:Label;
      
      private var _1059974091firstNormalBucketSubLabel:Label;
      
      private var deleteMe:uint = 0;
      
      private var _1931117145rankedStatsView:Canvas;
      
      private var _1207187697infoFadeIn:Sequence;
      
      [Inject]
      public var profileStatsSummaryPresentationModel:ProfileStatsSummaryPresentationModel;
      
      private var _548010010secondNormalMedalDisplay:MedalDisplay;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var _529007623secondNormalBucketSubLabel:Label;
      
      private var _149351911thirdNormalMedalDisplay:MedalDisplay;
      
      private var _368369948thirdNormalBucketLabel:Label;
      
      private var _687970886rankedBucket_3v3:RankedDisplayBucket;
      
      mx_internal var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":ViewStack,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Canvas,
               "id":"rankedStatsView",
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "percentWidth":100,
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":RankedDisplayBucket,
                        "id":"rankedBucket_3v3",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentHeight":100,
                              "width":241
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":RankedDisplayBucket,
                        "id":"rankedBucket_Solo",
                        "stylesFactory":function():void
                        {
                           this.left = "238";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentHeight":100,
                              "width":241
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":RankedDisplayBucket,
                        "id":"rankedBucket_5v5",
                        "stylesFactory":function():void
                        {
                           this.left = "481";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentHeight":100,
                              "width":241
                           };
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"normalStatsView",
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "percentWidth":100,
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"firstNormalBucket",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "cacheAsBitmap":true,
                              "percentHeight":100,
                              "width":241,
                              "verticalScrollPolicy":"off",
                              "horizontalScrollPolicy":"off",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":MedalDisplay,
                                 "id":"firstNormalMedalDisplay"
                              }),new UIComponentDescriptor({
                                 "type":Label,
                                 "id":"firstNormalBucketLabel",
                                 "stylesFactory":function():void
                                 {
                                    this.top = "40";
                                    this.left = "0";
                                    this.right = "3";
                                    this.fontSize = 14;
                                    this.textAlign = "center";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {"styleName":"profileRankingStatsLabels"};
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Label,
                                 "id":"firstNormalBucketSubLabel",
                                 "stylesFactory":function():void
                                 {
                                    this.top = "63";
                                    this.left = "0";
                                    this.right = "10";
                                    this.fontSize = 16;
                                    this.textAlign = "center";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {"styleName":"summonerStatsTextSmall"};
                                 }
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"secondNormalBucket",
                        "stylesFactory":function():void
                        {
                           this.left = "237";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "cacheAsBitmap":true,
                              "percentHeight":100,
                              "width":242,
                              "verticalScrollPolicy":"off",
                              "horizontalScrollPolicy":"off",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":MedalDisplay,
                                 "id":"secondNormalMedalDisplay"
                              }),new UIComponentDescriptor({
                                 "type":Label,
                                 "id":"secondNormalBucketLabel",
                                 "stylesFactory":function():void
                                 {
                                    this.top = "40";
                                    this.left = "-7";
                                    this.right = "-5";
                                    this.fontSize = 14;
                                    this.textAlign = "center";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {"styleName":"profileRankingStatsLabels"};
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Label,
                                 "id":"secondNormalBucketSubLabel",
                                 "stylesFactory":function():void
                                 {
                                    this.top = "63";
                                    this.left = "0";
                                    this.right = "10";
                                    this.fontSize = 16;
                                    this.textAlign = "center";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {"styleName":"summonerStatsTextSmall"};
                                 }
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"thirdNormalBucket",
                        "stylesFactory":function():void
                        {
                           this.left = "481";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "cacheAsBitmap":true,
                              "percentHeight":100,
                              "width":241,
                              "verticalScrollPolicy":"off",
                              "horizontalScrollPolicy":"off",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":MedalDisplay,
                                 "id":"thirdNormalMedalDisplay"
                              }),new UIComponentDescriptor({
                                 "type":Label,
                                 "id":"thirdNormalBucketLabel",
                                 "stylesFactory":function():void
                                 {
                                    this.top = "40";
                                    this.left = "0";
                                    this.right = "3";
                                    this.fontSize = 14;
                                    this.textAlign = "center";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {"styleName":"profileRankingStatsLabels"};
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Label,
                                 "id":"thirdNormalBucketSubLabel",
                                 "stylesFactory":function():void
                                 {
                                    this.top = "63";
                                    this.left = "0";
                                    this.right = "10";
                                    this.fontSize = 16;
                                    this.textAlign = "center";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {"styleName":"summonerStatsTextSmall"};
                                 }
                              })]
                           };
                        }
                     })]
                  };
               }
            })]};
         }
      });
      
      private var _1057005384thirdNormalBucket:Canvas;
      
      private var _2140670907secondNormalBucket:Canvas;
      
      public function ProfileStatsRankingView()
      {
         super();
         mx_internal::_document = this;
         this._ProfileStatsRankingView_Sequence1_i();
         this.addEventListener("creationComplete",this.___ProfileStatsRankingView_ViewStack1_creationComplete);
         this.addEventListener("initialize",this.___ProfileStatsRankingView_ViewStack1_initialize);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ProfileStatsRankingView._watcherSetupUtil = param1;
      }
      
      public function set secondNormalBucketSubLabel(param1:Label) : void
      {
         var _loc2_:Object = this._529007623secondNormalBucketSubLabel;
         if(_loc2_ !== param1)
         {
            this._529007623secondNormalBucketSubLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"secondNormalBucketSubLabel",_loc2_,param1));
         }
      }
      
      public function set firstNormalBucket(param1:Canvas) : void
      {
         var _loc2_:Object = this._738986113firstNormalBucket;
         if(_loc2_ !== param1)
         {
            this._738986113firstNormalBucket = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"firstNormalBucket",_loc2_,param1));
         }
      }
      
      public function ___ProfileStatsRankingView_ViewStack1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      [Bindable(event="propertyChange")]
      public function get infoFadeIn() : Sequence
      {
         return this._1207187697infoFadeIn;
      }
      
      [Bindable(event="propertyChange")]
      public function get _gameMode() : String
      {
         return this._1678843372_gameMode;
      }
      
      [Bindable(event="propertyChange")]
      public function get thirdNormalMedalDisplay() : MedalDisplay
      {
         return this._149351911thirdNormalMedalDisplay;
      }
      
      public function set infoFadeIn(param1:Sequence) : void
      {
         var _loc2_:Object = this._1207187697infoFadeIn;
         if(_loc2_ !== param1)
         {
            this._1207187697infoFadeIn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"infoFadeIn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get firstNormalMedalDisplay() : MedalDisplay
      {
         return this._1567555806firstNormalMedalDisplay;
      }
      
      [Bindable(event="propertyChange")]
      public function get thirdNormalBucketLabel() : Label
      {
         return this._368369948thirdNormalBucketLabel;
      }
      
      public function set _gameMode(param1:String) : void
      {
         var _loc2_:Object = this._1678843372_gameMode;
         if(_loc2_ !== param1)
         {
            this._1678843372_gameMode = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_gameMode",_loc2_,param1));
         }
      }
      
      public function set thirdNormalMedalDisplay(param1:MedalDisplay) : void
      {
         var _loc2_:Object = this._149351911thirdNormalMedalDisplay;
         if(_loc2_ !== param1)
         {
            this._149351911thirdNormalMedalDisplay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"thirdNormalMedalDisplay",_loc2_,param1));
         }
      }
      
      private function onCreationComplete() : void
      {
         if(this.initializeOnCreation)
         {
            this.initializeOnCreation = false;
            this.initializeView();
         }
      }
      
      public function set thirdNormalBucketLabel(param1:Label) : void
      {
         var _loc2_:Object = this._368369948thirdNormalBucketLabel;
         if(_loc2_ !== param1)
         {
            this._368369948thirdNormalBucketLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"thirdNormalBucketLabel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get firstNormalBucketSubLabel() : Label
      {
         return this._1059974091firstNormalBucketSubLabel;
      }
      
      public function set firstNormalMedalDisplay(param1:MedalDisplay) : void
      {
         var _loc2_:Object = this._1567555806firstNormalMedalDisplay;
         if(_loc2_ !== param1)
         {
            this._1567555806firstNormalMedalDisplay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"firstNormalMedalDisplay",_loc2_,param1));
         }
      }
      
      public function ___ProfileStatsRankingView_ViewStack1_initialize(param1:FlexEvent) : void
      {
         this.initializeView();
      }
      
      [Bindable(event="propertyChange")]
      public function get secondNormalBucket() : Canvas
      {
         return this._2140670907secondNormalBucket;
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedBucket_3v3() : RankedDisplayBucket
      {
         return this._687970886rankedBucket_3v3;
      }
      
      public function initializeView() : void
      {
         if(!this.profileStatsSummaryPresentationModel || !this.rankedStatsView)
         {
            this.initializeOnCreation = true;
            return;
         }
         if(this.summonerProfileControllerWatcher == null)
         {
            this.summonerProfileControllerWatcher = ChangeWatcher.watch(this.summonerProfileController,"playerStatSummaries",this.onSummonerStatsLoaded);
            if(this.summonerProfileController != null && this.summonerProfileController.playerStatSummaries != null)
            {
               this.updateAllStats();
            }
         }
      }
      
      private function _ProfileStatsRankingView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("summonerProfile_profile_statsHeaderRanked");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            rankedStatsView.label = param1;
         },"rankedStatsView.label");
         result[0] = binding;
         binding = new Binding(this,function():*
         {
            return infoFadeIn;
         },function(param1:*):void
         {
            rankedStatsView.setStyle("showEffect",param1);
         },"rankedStatsView.showEffect");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("summonerProfile_profile_statsHeaderNormal");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            normalStatsView.label = param1;
         },"normalStatsView.label");
         result[2] = binding;
         binding = new Binding(this,function():*
         {
            return infoFadeIn;
         },function(param1:*):void
         {
            normalStatsView.setStyle("showEffect",param1);
         },"normalStatsView.showEffect");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("summonerProfile_profile_statsTakedowns_" + _gameMode.toLowerCase() + "_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            firstNormalBucket.toolTip = param1;
         },"firstNormalBucket.toolTip");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("summonerProfile_profile_statsTakedowns_" + _gameMode.toLowerCase());
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            firstNormalBucketLabel.text = param1;
         },"firstNormalBucketLabel.text");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this._gameMode == GameMode.CLASSIC ? RiotResourceLoader.getString("summonerProfile_profile_statsMinionKills") : (this._gameMode == GameMode.ARAM ? RiotResourceLoader.getString("summonerProfile_profile_statsTowersDestroyed") : RiotResourceLoader.getString("summonerProfile_profile_statsPointsCapturedAndNeutralize"));
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            secondNormalBucketLabel.text = param1;
         },"secondNormalBucketLabel.text");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("summonerProfile_mostPlayedChampions_wins");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            thirdNormalBucketLabel.text = param1;
         },"thirdNormalBucketLabel.text");
         result[7] = binding;
         return result;
      }
      
      private function showRankedStats() : void
      {
         if(!this.profileStatsSummaryPresentationModel)
         {
            return;
         }
         this.rankedBucket_3v3.clear();
         this.rankedBucket_Solo.clear();
         this.rankedBucket_5v5.clear();
         if(ClientConfig.instance.teamServiceEnabled)
         {
            ProviderLookup.getProvider(IRankedTeamsProvider,this.onRankedTeamsAvailable);
         }
         else
         {
            this.onRankedTeamsUnavailable();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedStatsView() : Canvas
      {
         return this._1931117145rankedStatsView;
      }
      
      public function set secondNormalBucketLabel(param1:Label) : void
      {
         var _loc2_:Object = this._2138341969secondNormalBucketLabel;
         if(_loc2_ !== param1)
         {
            this._2138341969secondNormalBucketLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"secondNormalBucketLabel",_loc2_,param1));
         }
      }
      
      private function onRankedTeamsUnavailable() : void
      {
         var _loc1_:int = int(this.summonerProfileController.currentStatsSeason);
         var _loc2_:RankedDisplayBucketDTO = this.retrieveArrangedTeam3v3Stats(_loc1_);
         var _loc3_:RankedDisplayBucketDTO = this.retrieveRankedSoloStats(_loc1_);
         var _loc4_:RankedDisplayBucketDTO = this.retrieveArrangedTeam5v5Stats(_loc1_);
         this.rankedBucket_3v3.showStats(_loc2_,this.profileStatsSummaryPresentationModel.isLocalSummoner());
         this.rankedBucket_Solo.showStats(_loc3_,this.profileStatsSummaryPresentationModel.isLocalSummoner());
         this.rankedBucket_5v5.showStats(_loc4_,this.profileStatsSummaryPresentationModel.isLocalSummoner());
      }
      
      private function updateAllStats() : void
      {
         this.showRankedStats();
         this.showStats();
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedBucket_Solo() : RankedDisplayBucket
      {
         return this._146790551rankedBucket_Solo;
      }
      
      public function set firstNormalBucketSubLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1059974091firstNormalBucketSubLabel;
         if(_loc2_ !== param1)
         {
            this._1059974091firstNormalBucketSubLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"firstNormalBucketSubLabel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get thirdNormalBucketSubLabel() : Label
      {
         return this._329336172thirdNormalBucketSubLabel;
      }
      
      public function set thirdNormalBucket(param1:Canvas) : void
      {
         var _loc2_:Object = this._1057005384thirdNormalBucket;
         if(_loc2_ !== param1)
         {
            this._1057005384thirdNormalBucket = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"thirdNormalBucket",_loc2_,param1));
         }
      }
      
      public function set gameMode(param1:String) : void
      {
         this._gameMode = param1;
         if(this._gameMode == GameMode.CLASSIC)
         {
            this.rankedStatsView.enabled = true;
         }
         else
         {
            this.rankedStatsView.enabled = false;
            this.selectedIndex = 1;
         }
         this.showStats();
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get summonerProfileController() : SummonerProfileController
      {
         return this._566834807summonerProfileController;
      }
      
      public function set normalStatsView(param1:Canvas) : void
      {
         var _loc2_:Object = this._2113274557normalStatsView;
         if(_loc2_ !== param1)
         {
            this._2113274557normalStatsView = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"normalStatsView",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get firstNormalBucket() : Canvas
      {
         return this._738986113firstNormalBucket;
      }
      
      public function set rankedBucket_3v3(param1:RankedDisplayBucket) : void
      {
         var _loc2_:Object = this._687970886rankedBucket_3v3;
         if(_loc2_ !== param1)
         {
            this._687970886rankedBucket_3v3 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedBucket_3v3",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ProfileStatsRankingView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ProfileStatsRankingView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_summoner_stats_ProfileStatsRankingViewWatcherSetupUtil");
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
      
      public function set secondNormalBucket(param1:Canvas) : void
      {
         var _loc2_:Object = this._2140670907secondNormalBucket;
         if(_loc2_ !== param1)
         {
            this._2140670907secondNormalBucket = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"secondNormalBucket",_loc2_,param1));
         }
      }
      
      public function resetView() : void
      {
         if(this.summonerProfileControllerWatcher != null)
         {
            this.summonerProfileControllerWatcher.unwatch();
            this.summonerProfileControllerWatcher = null;
         }
      }
      
      private function retrieveRankedSoloStats(param1:int) : RankedDisplayBucketDTO
      {
         var _loc2_:RankedDisplayBucketDTO = new RankedDisplayBucketDTO();
         var _loc3_:PlayerStatSummary = this.profileStatsSummaryPresentationModel.rankedQueueStatSummaries[QueueType.RANKED_SOLO_5x5];
         if(ClientConfig.instance.leagueServiceEnabled)
         {
            _loc2_.isLeague = true;
            _loc2_.league = ServiceProxy.instance.leagueService.cache.getLeagueDataForQueue(this.summonerProfileController.currentSummoner.name,QueueType.RANKED_SOLO_5x5);
            _loc2_.leaguePoints = ServiceProxy.instance.leagueService.cache.getLeaguePointsForSummonerOrTeam(this.summonerProfileController.currentSummoner.name);
            if(this.summonerProfileController.isLocalSummoner)
            {
               _loc2_.demotionWarningLevel = ServiceProxy.instance.leagueService.cache.getDemotionWarning(this.summonerProfileController.currentSummoner.sumId.toString(),QueueType.RANKED_SOLO_5x5);
            }
         }
         _loc2_.teamName = "";
         _loc2_.queueType = QueueType.RANKED_SOLO_5x5;
         _loc2_.wins = _loc3_.wins;
         _loc2_.losses = _loc3_.losses;
         _loc2_.leaves = _loc3_.leaves;
         return _loc2_;
      }
      
      private function retrieveArrangedTeam5v5Stats(param1:int) : RankedDisplayBucketDTO
      {
         var _loc2_:RankedDisplayBucketDTO = new RankedDisplayBucketDTO();
         var _loc3_:PlayerStatSummary = this.profileStatsSummaryPresentationModel.rankedQueueStatSummaries[QueueType.RANKED_PREMADE_5x5];
         _loc2_.teamName = "";
         _loc2_.queueType = QueueType.RANKED_TEAM_5x5;
         _loc2_.wins = _loc3_.wins;
         _loc2_.losses = _loc3_.losses;
         _loc2_.leaves = _loc3_.leaves;
         return _loc2_;
      }
      
      private function retrieveArrangedTeam3v3Stats(param1:int) : RankedDisplayBucketDTO
      {
         var _loc2_:RankedDisplayBucketDTO = new RankedDisplayBucketDTO();
         var _loc3_:PlayerStatSummary = this.profileStatsSummaryPresentationModel.rankedQueueStatSummaries[QueueType.RANKED_PREMADE_3x3];
         _loc2_.teamName = "";
         _loc2_.queueType = QueueType.RANKED_PREMADE_3x3;
         _loc2_.wins = _loc3_.wins;
         _loc2_.losses = _loc3_.losses;
         _loc2_.leaves = _loc3_.leaves;
         return _loc2_;
      }
      
      private function showStats() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:* = undefined;
         var _loc5_:Number = NaN;
         if(this._gameMode == GameMode.CLASSIC)
         {
            _loc1_ = Number(this.profileStatsSummaryPresentationModel.totalClassicTakedowns);
            this.firstNormalBucketSubLabel.text = _loc1_.toString();
            this.firstNormalMedalDisplay.setMedal(ProfileUtils.getTakedownsMedal(_loc1_),LeagueRank.DEFAULT);
            _loc2_ = Number(this.profileStatsSummaryPresentationModel.totalCreepsAndMinionsKilled);
            this.secondNormalBucketSubLabel.text = _loc2_.toString();
            this.secondNormalMedalDisplay.setMedal(ProfileUtils.getMinionKillsMedal(_loc2_),LeagueRank.DEFAULT);
            _loc3_ = Number(this.profileStatsSummaryPresentationModel.totalNormalClassicWins);
            this.thirdNormalBucketSubLabel.text = _loc3_.toString();
            this.thirdNormalMedalDisplay.setMedal(ProfileUtils.getNormalWinsMedal(_loc3_),LeagueRank.DEFAULT);
         }
         else if(this._gameMode == GameMode.DOMINION)
         {
            _loc1_ = Number(this.profileStatsSummaryPresentationModel.totalDominionTakedowns);
            this.firstNormalBucketSubLabel.text = _loc1_.toString();
            this.firstNormalMedalDisplay.setMedal(ProfileUtils.getTakedownsMedal(_loc1_),LeagueRank.DEFAULT);
            _loc4_ = this.profileStatsSummaryPresentationModel.totalPointsCapturedAndNeutralized;
            this.secondNormalBucketSubLabel.text = _loc4_.toString();
            this.secondNormalMedalDisplay.setMedal(ProfileUtils.getPointsCappedMedal(_loc4_),LeagueRank.DEFAULT);
            _loc3_ = Number(this.profileStatsSummaryPresentationModel.totalNormalDominionWins);
            this.thirdNormalBucketSubLabel.text = _loc3_.toString();
            this.thirdNormalMedalDisplay.setMedal(ProfileUtils.getNormalWinsMedal(_loc3_),LeagueRank.DEFAULT);
         }
         else if(this._gameMode == GameMode.ARAM)
         {
            _loc1_ = Number(this.profileStatsSummaryPresentationModel.totalARAMTakedowns);
            this.firstNormalBucketSubLabel.text = _loc1_.toString();
            this.firstNormalMedalDisplay.setMedal(ProfileUtils.getTakedownsMedal(_loc1_),LeagueRank.DEFAULT);
            _loc5_ = Number(this.profileStatsSummaryPresentationModel.totalARAMTowersDestroyed);
            this.secondNormalBucketSubLabel.text = _loc5_.toString();
            this.secondNormalMedalDisplay.setMedal(ProfileUtils.getTowersDestroyedMedal(_loc5_),LeagueRank.DEFAULT);
            _loc3_ = Number(this.profileStatsSummaryPresentationModel.totalNormalARAMWins);
            this.thirdNormalBucketSubLabel.text = _loc3_.toString();
            this.thirdNormalMedalDisplay.setMedal(ProfileUtils.getNormalWinsMedal(_loc3_),LeagueRank.DEFAULT);
         }
         this.infoFadeIn.end();
         this.infoFadeIn.play([this.normalStatsView]);
      }
      
      [Bindable(event="propertyChange")]
      public function get secondNormalBucketLabel() : Label
      {
         return this._2138341969secondNormalBucketLabel;
      }
      
      [Bindable(event="propertyChange")]
      public function get thirdNormalBucket() : Canvas
      {
         return this._1057005384thirdNormalBucket;
      }
      
      [Bindable(event="propertyChange")]
      public function get normalStatsView() : Canvas
      {
         return this._2113274557normalStatsView;
      }
      
      private function _ProfileStatsRankingView_SetPropertyAction1_c() : SetPropertyAction
      {
         var _loc1_:SetPropertyAction = new SetPropertyAction();
         _loc1_.name = "alpha";
         _loc1_.value = 0;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedBucket_5v5() : RankedDisplayBucket
      {
         return this._687972810rankedBucket_5v5;
      }
      
      private function _ProfileStatsRankingView_Fade1_c() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 375;
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         _loc1_.startDelay = 25;
         return _loc1_;
      }
      
      public function set rankedBucket_Solo(param1:RankedDisplayBucket) : void
      {
         var _loc2_:Object = this._146790551rankedBucket_Solo;
         if(_loc2_ !== param1)
         {
            this._146790551rankedBucket_Solo = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedBucket_Solo",_loc2_,param1));
         }
      }
      
      public function set secondNormalMedalDisplay(param1:MedalDisplay) : void
      {
         var _loc2_:Object = this._548010010secondNormalMedalDisplay;
         if(_loc2_ !== param1)
         {
            this._548010010secondNormalMedalDisplay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"secondNormalMedalDisplay",_loc2_,param1));
         }
      }
      
      public function set rankedStatsView(param1:Canvas) : void
      {
         var _loc2_:Object = this._1931117145rankedStatsView;
         if(_loc2_ !== param1)
         {
            this._1931117145rankedStatsView = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedStatsView",_loc2_,param1));
         }
      }
      
      private function onRankedTeamsAvailable(param1:IRankedTeamsProvider) : void
      {
         var _loc2_:int = int(this.summonerProfileController.currentStatsSeason);
         if(!param1.isRankedTeamServiceEnabled() || _loc2_ != CompetitiveSeason.currentSeason)
         {
            this.onRankedTeamsUnavailable();
            return;
         }
         var _loc3_:RankedDisplayBucketDTO = param1.retrieveHighest3v3TeamData(_loc2_);
         var _loc4_:RankedDisplayBucketDTO = this.retrieveRankedSoloStats(_loc2_);
         var _loc5_:RankedDisplayBucketDTO = param1.retrieveHighest5v5TeamData(_loc2_);
         this.rankedBucket_3v3.showStats(_loc3_,this.profileStatsSummaryPresentationModel.isLocalSummoner());
         this.rankedBucket_Solo.showStats(_loc4_,this.profileStatsSummaryPresentationModel.isLocalSummoner());
         this.rankedBucket_5v5.showStats(_loc5_,this.profileStatsSummaryPresentationModel.isLocalSummoner());
      }
      
      public function set thirdNormalBucketSubLabel(param1:Label) : void
      {
         var _loc2_:Object = this._329336172thirdNormalBucketSubLabel;
         if(_loc2_ !== param1)
         {
            this._329336172thirdNormalBucketSubLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"thirdNormalBucketSubLabel",_loc2_,param1));
         }
      }
      
      private function _ProfileStatsRankingView_Sequence1_i() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         this.infoFadeIn = _loc1_;
         _loc1_.children = [this._ProfileStatsRankingView_SetPropertyAction1_c(),this._ProfileStatsRankingView_Fade1_c()];
         return _loc1_;
      }
      
      public function set firstNormalBucketLabel(param1:Label) : void
      {
         var _loc2_:Object = this._45526771firstNormalBucketLabel;
         if(_loc2_ !== param1)
         {
            this._45526771firstNormalBucketLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"firstNormalBucketLabel",_loc2_,param1));
         }
      }
      
      public function set rankedBucket_5v5(param1:RankedDisplayBucket) : void
      {
         var _loc2_:Object = this._687972810rankedBucket_5v5;
         if(_loc2_ !== param1)
         {
            this._687972810rankedBucket_5v5 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedBucket_5v5",_loc2_,param1));
         }
      }
      
      public function set summonerProfileController(param1:SummonerProfileController) : void
      {
         var _loc2_:Object = this._566834807summonerProfileController;
         if(_loc2_ !== param1)
         {
            this._566834807summonerProfileController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerProfileController",_loc2_,param1));
         }
      }
      
      private function _ProfileStatsRankingView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = RiotResourceLoader.getString("summonerProfile_profile_statsHeaderRanked");
         _loc1_ = this.infoFadeIn;
         _loc1_ = RiotResourceLoader.getString("summonerProfile_profile_statsHeaderNormal");
         _loc1_ = this.infoFadeIn;
         _loc1_ = RiotResourceLoader.getString("summonerProfile_profile_statsTakedowns_" + this._gameMode.toLowerCase() + "_tooltip");
         _loc1_ = RiotResourceLoader.getString("summonerProfile_profile_statsTakedowns_" + this._gameMode.toLowerCase());
         _loc1_ = this._gameMode == GameMode.CLASSIC ? RiotResourceLoader.getString("summonerProfile_profile_statsMinionKills") : (this._gameMode == GameMode.ARAM ? RiotResourceLoader.getString("summonerProfile_profile_statsTowersDestroyed") : RiotResourceLoader.getString("summonerProfile_profile_statsPointsCapturedAndNeutralize"));
         _loc1_ = RiotResourceLoader.getString("summonerProfile_mostPlayedChampions_wins");
      }
      
      [Bindable(event="propertyChange")]
      public function get firstNormalBucketLabel() : Label
      {
         return this._45526771firstNormalBucketLabel;
      }
      
      [Bindable(event="propertyChange")]
      public function get secondNormalMedalDisplay() : MedalDisplay
      {
         return this._548010010secondNormalMedalDisplay;
      }
      
      private function onSummonerStatsLoaded(param1:PropertyChangeEvent) : void
      {
         this.updateAllStats();
      }
      
      [Bindable(event="propertyChange")]
      public function get secondNormalBucketSubLabel() : Label
      {
         return this._529007623secondNormalBucketSubLabel;
      }
   }
}

