package com.riotgames.platform.gameclient.views.summoner
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.components.controls.ToggleButtonBar;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.provider.IRuneBookController;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import com.riotgames.platform.gameclient.items.ItemBrowserViewWrapper;
   import com.riotgames.platform.gameclient.talent.TalentTreeView;
   import com.riotgames.platform.gameclient.views.summoner.stats.LeagueSystemStatsView;
   import com.riotgames.platform.gameclient.views.summoner.stats.ProfileStatsSummaryPresentationModel;
   import com.riotgames.platform.gameclient.views.summoner.stats.ProfileStatsView;
   import com.riotgames.platform.module.RiotModuleManager;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.summonerprofile.ProfilePagesEnum;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlerterProviderProxy;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   import com.riotgames.pvpnet.system.config.ClientConfig;
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
   import flexlib.controls.PromptingTextInput;
   import mx.binding.*;
   import mx.binding.utils.ChangeWatcher;
   import mx.collections.ArrayCollection;
   import mx.containers.Canvas;
   import mx.containers.ViewStack;
   import mx.controls.Image;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.IndexChangedEvent;
   import mx.events.ItemClickEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.StateChangeEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.states.State;
   import mx.styles.*;
   import mx.utils.StringUtil;
   
   use namespace mx_internal;
   
   public class SummonerProfileView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private static const ACHIEVEMENTS_TROLL:Vector.<Number> = Vector.<Number>([6086,79064]);
      
      private static const LEAGUE_SYSTEM_MENU_POSITION:int = 1;
      
      public var _SummonerProfileView_State3:State;
      
      public var _SummonerProfileView_State4:State;
      
      public var _SummonerProfileView_State6:State;
      
      public var _SummonerProfileView_State8:State;
      
      public var _SummonerProfileView_State5:State;
      
      public var _SummonerProfileView_State7:State;
      
      public var _SummonerProfileView_State9:State;
      
      private var _562654158searchField:PromptingTextInput;
      
      private var _111402889masteries_wrapper:Canvas;
      
      public var alerter:IAlerterProvider;
      
      [Inject]
      private var _269543472masterGameController:MasterGameController;
      
      private var oldProfileOverview:SummonerSummaryView;
      
      private var championInventoryWrapper:ChampionInventoryViewWrapper;
      
      [Inject]
      private var _349030418lobbyController:ILobbyViewController;
      
      private var _165788532runesPage_c:Canvas;
      
      private var _1895424275clientConfig:ClientConfig;
      
      public var _SummonerProfileView_State1:State;
      
      private var _631361425item_sets_page:Canvas;
      
      private var riotResourceLoader:RiotResourceLoader;
      
      private var summonerChangeWatcher:ChangeWatcher;
      
      private var _1423281442spellsPage_c:SpellsViewWrapper;
      
      private var _894196291charactersPage_c:Canvas;
      
      mx_internal var _bindingsByDestination:Object;
      
      public var leagueSystemStatsView:LeagueSystemStatsView;
      
      private var rankedStatsView:ProfileStatsView;
      
      private var leagueSystemWrapper:Canvas;
      
      [Inject]
      private var _566834807summonerProfileController:SummonerProfileController;
      
      private var _1632655169profilePages_c:ViewStack;
      
      private var matchHistoryWrapper:MatchHistoryViewWrapper;
      
      private var _1165296933stackBackgroundImage:Image;
      
      private var _933969709newProfileViewChooser:ToggleButtonBar;
      
      private var leagueSystemShell:LeagueSystemShell;
      
      mx_internal var _watchers:Array;
      
      private var _137448340match_history_page:Canvas;
      
      private var _1161045572profilePage_c:Canvas;
      
      private var _850096521breadcrumbsContent:ArrayCollection;
      
      private var _392435869itemSetsEnabled:Boolean;
      
      private var runeBookControllerCallback:Function;
      
      [Inject]
      private var _1292102721profileStatsSummaryPresentationModel:ProfileStatsSummaryPresentationModel;
      
      private var _1690115777runeBookController:IRuneBookController;
      
      private var _1986500840itemSets_c:ItemBrowserViewWrapper;
      
      private var firstShow:Boolean = true;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _983698992achievementsLabel:Boolean;
      
      private var runeBookViewWrapper:RuneBookViewWrapper;
      
      mx_internal var _bindings:Array;
      
      private var _488583240masteriesPage_c:TalentTreeView;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public var _SummonerProfileView_State2:State;
      
      public function SummonerProfileView()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Image,
                  "id":"stackBackgroundImage",
                  "stylesFactory":function():void
                  {
                     this.horizontalCenter = "1";
                     this.top = "0";
                  }
               }),new UIComponentDescriptor({
                  "type":ViewStack,
                  "id":"profilePages_c",
                  "events":{"creationComplete":"__profilePages_c_creationComplete"},
                  "stylesFactory":function():void
                  {
                     this.horizontalCenter = "0";
                     this.backgroundAlpha = 1;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "y":34,
                        "width":1100,
                        "height":540,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Canvas,
                           "id":"profilePage_c",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "x":0,
                                 "y":0,
                                 "width":1160,
                                 "height":562
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Canvas,
                           "id":"match_history_page",
                           "stylesFactory":function():void
                           {
                              this.top = "0";
                              this.bottom = "0";
                              this.left = "55";
                              this.right = "30";
                           }
                        }),new UIComponentDescriptor({
                           "type":Canvas,
                           "id":"charactersPage_c",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "x":0,
                                 "y":0,
                                 "percentWidth":100,
                                 "percentHeight":100
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Canvas,
                           "id":"runesPage_c",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "percentHeight":100
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Canvas,
                           "id":"masteries_wrapper",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "percentWidth":100,
                                 "percentHeight":100,
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":TalentTreeView,
                                    "id":"masteriesPage_c",
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "x":15,
                                          "y":10,
                                          "percentWidth":100,
                                          "percentHeight":100
                                       };
                                    }
                                 })]
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":SpellsViewWrapper,
                           "id":"spellsPage_c",
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "x":0,
                                 "y":0,
                                 "percentWidth":100,
                                 "percentHeight":100
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":Canvas,
                           "id":"item_sets_page",
                           "propertiesFactory":function():Object
                           {
                              return {"childDescriptors":[new UIComponentDescriptor({
                                 "type":ItemBrowserViewWrapper,
                                 "id":"itemSets_c",
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "x":15,
                                       "y":10,
                                       "percentWidth":100,
                                       "percentHeight":100
                                    };
                                 }
                              })]};
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":PromptingTextInput,
                  "id":"searchField",
                  "events":{"enter":"__searchField_enter"},
                  "stylesFactory":function():void
                  {
                     this.top = "10";
                     this.right = "102";
                     this.focusAlpha = 0;
                     this.borderColor = 0;
                     this.borderStyle = "inset";
                     this.borderThickness = 1;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "width":130,
                        "height":27,
                        "styleName":"profileSearchBox"
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":ToggleButtonBar,
                  "id":"newProfileViewChooser",
                  "events":{
                     "itemClick":"__newProfileViewChooser_itemClick",
                     "creationComplete":"__newProfileViewChooser_creationComplete"
                  },
                  "stylesFactory":function():void
                  {
                     this.buttonWidth = 116;
                     this.buttonHeight = 40;
                     this.horizontalGap = 0.5;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "tabEnabled":false,
                        "tabChildren":false,
                        "x":100,
                        "y":2,
                        "styleName":"profileToggleButtonBar",
                        "visible":true
                     };
                  }
               })]};
            }
         });
         this.alerter = AlerterProviderProxy.instance;
         this._1895424275clientConfig = ClientConfig.instance;
         this._850096521breadcrumbsContent = new ArrayCollection();
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration();
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.backgroundAlpha = 0;
         };
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.states = [this._SummonerProfileView_State1_i(),this._SummonerProfileView_State2_i(),this._SummonerProfileView_State3_i(),this._SummonerProfileView_State4_i(),this._SummonerProfileView_State5_i(),this._SummonerProfileView_State6_i(),this._SummonerProfileView_State7_i(),this._SummonerProfileView_State8_i(),this._SummonerProfileView_State9_i()];
         this.addEventListener("initialize",this.___SummonerProfileView_Canvas1_initialize);
         this.addEventListener("show",this.___SummonerProfileView_Canvas1_show);
         this.addEventListener("hide",this.___SummonerProfileView_Canvas1_hide);
         this.addEventListener("addedToStage",this.___SummonerProfileView_Canvas1_addedToStage);
         this.addEventListener("removedFromStage",this.___SummonerProfileView_Canvas1_removedFromStage);
         this.addEventListener("currentStateChange",this.___SummonerProfileView_Canvas1_currentStateChange);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         SummonerProfileView._watcherSetupUtil = param1;
      }
      
      public function __newProfileViewChooser_creationComplete(param1:FlexEvent) : void
      {
         this.summonerProfileViewTruncationFix();
      }
      
      private function createNewRunePage() : void
      {
         this.runeBookViewWrapper = new RuneBookViewWrapper();
         this.runeBookViewWrapper.x = 15;
         this.runeBookViewWrapper.y = 10;
         this.runeBookViewWrapper.percentHeight = 100;
         this.runeBookViewWrapper.percentWidth = 100;
         this.runeBookViewWrapper.summonerProfileController = this.summonerProfileController;
         this.runesPage_c.addChild(this.runeBookViewWrapper);
      }
      
      public function set runesPage_c(param1:Canvas) : void
      {
         var _loc2_:Object = this._165788532runesPage_c;
         if(_loc2_ !== param1)
         {
            this._165788532runesPage_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"runesPage_c",_loc2_,param1));
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
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.createNewRunePage();
         this.createNewMatchHistory();
         this.createNewChampionInventory();
         this.createOldProfileOverview();
         this.createLeagueSystemTab();
      }
      
      public function ___SummonerProfileView_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      private function _SummonerProfileView_State6_i() : State
      {
         var _loc1_:State = new State();
         this._SummonerProfileView_State6 = _loc1_;
         BindingManager.executeBindings(this,"_SummonerProfileView_State6",this._SummonerProfileView_State6);
         return _loc1_;
      }
      
      private function _SummonerProfileView_State2_i() : State
      {
         var _loc1_:State = new State();
         this._SummonerProfileView_State2 = _loc1_;
         BindingManager.executeBindings(this,"_SummonerProfileView_State2",this._SummonerProfileView_State2);
         return _loc1_;
      }
      
      public function set item_sets_page(param1:Canvas) : void
      {
         var _loc2_:Object = this._631361425item_sets_page;
         if(_loc2_ !== param1)
         {
            this._631361425item_sets_page = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"item_sets_page",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get searchField() : PromptingTextInput
      {
         return this._562654158searchField;
      }
      
      public function set masteries_wrapper(param1:Canvas) : void
      {
         var _loc2_:Object = this._111402889masteries_wrapper;
         if(_loc2_ !== param1)
         {
            this._111402889masteries_wrapper = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"masteries_wrapper",_loc2_,param1));
         }
      }
      
      private function getRuneBookController(param1:Function) : void
      {
         this.runeBookControllerCallback = param1;
         ProviderLookup.getProvider(IRuneBookController,this.onRuneBookControllerRetrieved);
      }
      
      private function createOldProfileOverview() : void
      {
         this.oldProfileOverview = new SummonerSummaryView();
         this.oldProfileOverview.percentHeight = 100;
         this.oldProfileOverview.percentWidth = 100;
         this.oldProfileOverview.summonerProfileController = this.summonerProfileController;
         this.profilePage_c.addChild(this.oldProfileOverview);
      }
      
      private function createNewMatchHistory() : void
      {
         this.matchHistoryWrapper = new MatchHistoryViewWrapper();
         this.matchHistoryWrapper.x = 15;
         this.matchHistoryWrapper.y = 10;
         this.matchHistoryWrapper.percentHeight = 100;
         this.matchHistoryWrapper.percentWidth = 100;
         this.matchHistoryWrapper.summonerProfileController = this.summonerProfileController;
         this.match_history_page.addChild(this.matchHistoryWrapper);
      }
      
      [Bindable(event="propertyChange")]
      public function get runeBookController() : IRuneBookController
      {
         return this._1690115777runeBookController;
      }
      
      public function set itemSetsEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._392435869itemSetsEnabled;
         if(_loc2_ !== param1)
         {
            this._392435869itemSetsEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemSetsEnabled",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get newProfileViewChooser() : ToggleButtonBar
      {
         return this._933969709newProfileViewChooser;
      }
      
      [Bindable(event="propertyChange")]
      public function get stackBackgroundImage() : Image
      {
         return this._1165296933stackBackgroundImage;
      }
      
      private function onTabClicked(param1:ItemClickEvent) : void
      {
         var _loc2_:DisplayObject = this.profilePages_c.getChildAt(param1.index);
         if(_loc2_ == this.leagueSystemWrapper && Boolean(this.leagueSystemShell))
         {
            this.leagueSystemShell.show();
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get lobbyController() : ILobbyViewController
      {
         return this._349030418lobbyController;
      }
      
      private function createNewChampionInventory() : void
      {
         this.championInventoryWrapper = new ChampionInventoryViewWrapper();
         this.championInventoryWrapper.percentWidth = 100;
         this.championInventoryWrapper.percentHeight = 100;
         this.championInventoryWrapper.summonerProfileController = this.summonerProfileController;
         this.charactersPage_c.addChild(this.championInventoryWrapper);
      }
      
      private function __profilePages_c_change(param1:Event) : void
      {
         if(!(param1 is IndexChangedEvent))
         {
            return;
         }
         this.onTabChanged(param1 as IndexChangedEvent);
      }
      
      public function set breadcrumbsContent(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._850096521breadcrumbsContent;
         if(_loc2_ !== param1)
         {
            this._850096521breadcrumbsContent = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"breadcrumbsContent",_loc2_,param1));
         }
      }
      
      public function set newProfileViewChooser(param1:ToggleButtonBar) : void
      {
         var _loc2_:Object = this._933969709newProfileViewChooser;
         if(_loc2_ !== param1)
         {
            this._933969709newProfileViewChooser = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"newProfileViewChooser",_loc2_,param1));
         }
      }
      
      private function initializeView() : void
      {
         if(this.summonerChangeWatcher == null)
         {
            this.summonerChangeWatcher = ChangeWatcher.watch(this.summonerProfileController,"profileAcctId",this.summonerChanged);
         }
         this.stackBackgroundImage.source = ImagePackLookup.instance.getClassFromSwfRef("e_tabs_bg2");
         if(this.oldProfileOverview)
         {
            this.oldProfileOverview.initializeView();
         }
         if(this.profilePages_c.selectedIndex == 1 && Boolean(this.clientConfig.leagueServiceEnabled))
         {
            this.leagueSystemShell.show();
         }
      }
      
      public function set lobbyController(param1:ILobbyViewController) : void
      {
         var _loc2_:Object = this._349030418lobbyController;
         if(_loc2_ !== param1)
         {
            this._349030418lobbyController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lobbyController",_loc2_,param1));
         }
      }
      
      public function set match_history_page(param1:Canvas) : void
      {
         var _loc2_:Object = this._137448340match_history_page;
         if(_loc2_ !== param1)
         {
            this._137448340match_history_page = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"match_history_page",_loc2_,param1));
         }
      }
      
      public function set stackBackgroundImage(param1:Image) : void
      {
         var _loc2_:Object = this._1165296933stackBackgroundImage;
         if(_loc2_ !== param1)
         {
            this._1165296933stackBackgroundImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stackBackgroundImage",_loc2_,param1));
         }
      }
      
      private function onCreationComplete() : void
      {
         this.profilePages_c.addEventListener(IndexChangedEvent.CHANGE,this.__profilePages_c_change);
         this.itemSetsEnabled = Boolean(ClientConfig.instance.showItemSets) && RiotModuleManager.getModulesWithKeyValue("oldProfile","itemSets").length > 0;
         this.achievementsLabel = !this.itemSetsEnabled || ClientConfig.instance.regionTag == "na" && this.getShouldAchievements();
      }
      
      private function performSummonerSearch() : void
      {
         var _loc1_:String = this.searchField.text;
         if(_loc1_ == null || StringUtil.trim(_loc1_).length == 0)
         {
            _loc1_ = this.masterGameController.session.summoner.name;
         }
         this.lobbyController.searchForSummoner(_loc1_,this.onSearchError);
      }
      
      public function set masterGameController(param1:MasterGameController) : void
      {
         var _loc2_:Object = this._269543472masterGameController;
         if(_loc2_ !== param1)
         {
            this._269543472masterGameController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"masterGameController",_loc2_,param1));
         }
      }
      
      private function _SummonerProfileView_State1_i() : State
      {
         var _loc1_:State = new State();
         this._SummonerProfileView_State1 = _loc1_;
         BindingManager.executeBindings(this,"_SummonerProfileView_State1",this._SummonerProfileView_State1);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get masterGameController() : MasterGameController
      {
         return this._269543472masterGameController;
      }
      
      [Bindable(event="propertyChange")]
      public function get masteriesPage_c() : TalentTreeView
      {
         return this._488583240masteriesPage_c;
      }
      
      public function set searchField(param1:PromptingTextInput) : void
      {
         var _loc2_:Object = this._562654158searchField;
         if(_loc2_ !== param1)
         {
            this._562654158searchField = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"searchField",_loc2_,param1));
         }
      }
      
      private function _SummonerProfileView_State5_i() : State
      {
         var _loc1_:State = new State();
         this._SummonerProfileView_State5 = _loc1_;
         BindingManager.executeBindings(this,"_SummonerProfileView_State5",this._SummonerProfileView_State5);
         return _loc1_;
      }
      
      private function getShouldAchievements() : Boolean
      {
         var _loc1_:int = 0;
         if(!Session.instance.summoner)
         {
            return false;
         }
         for each(_loc1_ in ACHIEVEMENTS_TROLL)
         {
            if(Session.instance.summoner.sumId == _loc1_)
            {
               return true;
            }
         }
         return false;
      }
      
      public function set achievementsLabel(param1:Boolean) : void
      {
         var _loc2_:Object = this._983698992achievementsLabel;
         if(_loc2_ !== param1)
         {
            this._983698992achievementsLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"achievementsLabel",_loc2_,param1));
         }
      }
      
      private function _SummonerProfileView_State9_i() : State
      {
         var _loc1_:State = new State();
         this._SummonerProfileView_State9 = _loc1_;
         BindingManager.executeBindings(this,"_SummonerProfileView_State9",this._SummonerProfileView_State9);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get summonerProfileController() : SummonerProfileController
      {
         return this._566834807summonerProfileController;
      }
      
      private function _SummonerProfileView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.summonerProfileController.currentState;
         _loc1_ = ProfilePagesEnum.PROFILE_PAGE;
         _loc1_ = ProfilePagesEnum.RUNES_PAGE;
         _loc1_ = ProfilePagesEnum.CHARACTERS_PAGE;
         _loc1_ = ProfilePagesEnum.SPELLS_PAGE;
         _loc1_ = ProfilePagesEnum.MASTERIES_PAGE;
         _loc1_ = ProfilePagesEnum.MATCH_HISTORY_PAGE;
         _loc1_ = ProfilePagesEnum.STATS_PAGE;
         _loc1_ = ProfilePagesEnum.CLS;
         _loc1_ = ProfilePagesEnum.ITEMS_PAGE;
         _loc1_ = RiotResourceLoader.getString("summonerProfile_page_profile");
         _loc1_ = RiotResourceLoader.getString("summonerProfile_page_match_history");
         _loc1_ = RiotResourceLoader.getString("summonerProfile_page_champions");
         _loc1_ = this.summonerProfileController.isLocalSummoner;
         _loc1_ = RiotResourceLoader.getString("summonerProfile_page_runes");
         _loc1_ = this.clientConfig.clientMode != ClientConfig.SPECIAL_MODE_GARENA;
         _loc1_ = RiotResourceLoader.getString("summonerProfile_page_masteries");
         _loc1_ = this.summonerProfileController;
         _loc1_ = RiotResourceLoader.getString("summonerProfile_page_spells");
         _loc1_ = this.summonerProfileController;
         _loc1_ = RiotResourceLoader.getString(this.achievementsLabel ? "summonerProfile_page_achievemnets" : "summonerProfile_page_items");
         _loc1_ = this.itemSetsEnabled && this.summonerProfileController.isLocalSummoner;
         _loc1_ = this.summonerProfileController;
         _loc1_ = RiotResourceLoader.getString("summonerProfile_info_search_tooltip");
         _loc1_ = !this.summonerProfileController.isBusy;
         _loc1_ = RiotResourceLoader.getString("summonerProfile_info_search_prompt");
         _loc1_ = this.profilePages_c;
      }
      
      public function set profilePages_c(param1:ViewStack) : void
      {
         var _loc2_:Object = this._1632655169profilePages_c;
         if(_loc2_ !== param1)
         {
            this._1632655169profilePages_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profilePages_c",_loc2_,param1));
         }
      }
      
      public function ___SummonerProfileView_Canvas1_removedFromStage(param1:Event) : void
      {
         this.onHide();
      }
      
      public function ___SummonerProfileView_Canvas1_show(param1:FlexEvent) : void
      {
         this.onShow();
      }
      
      private function onShow() : void
      {
         this.callLater(this.initializeView);
      }
      
      public function set runeBookController(param1:IRuneBookController) : void
      {
         var _loc2_:Object = this._1690115777runeBookController;
         if(_loc2_ !== param1)
         {
            this._1690115777runeBookController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"runeBookController",_loc2_,param1));
         }
      }
      
      private function summonerChanged(param1:PropertyChangeEvent) : void
      {
         this.profilePages_c.selectedChild = this.profilePage_c;
      }
      
      public function set profilePage_c(param1:Canvas) : void
      {
         var _loc2_:Object = this._1161045572profilePage_c;
         if(_loc2_ !== param1)
         {
            this._1161045572profilePage_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profilePage_c",_loc2_,param1));
         }
      }
      
      public function set charactersPage_c(param1:Canvas) : void
      {
         var _loc2_:Object = this._894196291charactersPage_c;
         if(_loc2_ !== param1)
         {
            this._894196291charactersPage_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"charactersPage_c",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get item_sets_page() : Canvas
      {
         return this._631361425item_sets_page;
      }
      
      [Bindable(event="propertyChange")]
      public function get runesPage_c() : Canvas
      {
         return this._165788532runesPage_c;
      }
      
      private function resetView() : void
      {
         if(this.summonerChangeWatcher != null)
         {
            this.summonerChangeWatcher.unwatch();
            this.summonerChangeWatcher = null;
         }
         if(this.lobbyController)
         {
            this.lobbyController.clearNavigationPrompt();
         }
         if(this.stackBackgroundImage)
         {
            this.stackBackgroundImage.source = null;
         }
         if(this.oldProfileOverview)
         {
            this.oldProfileOverview.resetView();
         }
         if(this.charactersPage_c)
         {
            this.championInventoryWrapper.resetView();
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:SummonerProfileView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._SummonerProfileView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_summoner_SummonerProfileViewWatcherSetupUtil");
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
      
      private function onCurrentStateChanged(param1:StateChangeEvent) : void
      {
         var _loc2_:int = int(this.profilePages_c.selectedIndex);
         var _loc3_:int = int(SummonerProfileController.profilePages.indexOf(param1.newState));
         if(_loc3_ != -1 && _loc3_ != _loc2_)
         {
            this.newProfileViewChooser.selectedIndex = _loc3_;
         }
      }
      
      private function onTabChanged(param1:IndexChangedEvent) : void
      {
         this.summonerProfileController.profileViewChanged(param1.newIndex);
         var _loc2_:DisplayObject = this.profilePages_c.getChildAt(param1.oldIndex);
         var _loc3_:DisplayObject = this.profilePages_c.getChildAt(param1.newIndex);
         if(this.championInventoryWrapper != null)
         {
            if(_loc3_ == this.charactersPage_c)
            {
               this.championInventoryWrapper.showChampionInventoryRoot();
            }
            if(_loc2_ == this.charactersPage_c)
            {
               this.championInventoryWrapper.closeChampionInventoryRoot();
            }
         }
         if(this.matchHistoryWrapper != null)
         {
            if(_loc3_ == this.match_history_page)
            {
               this.matchHistoryWrapper.showMatchHistoryRoot();
            }
            if(_loc2_ == this.match_history_page)
            {
               this.matchHistoryWrapper.closeMatchHistoryRoot();
            }
         }
         if(_loc3_ === this.item_sets_page && Boolean(this.itemSets_c))
         {
            this.itemSets_c.showItemBrowser();
         }
         if(_loc2_ === this.item_sets_page && Boolean(this.itemSets_c))
         {
            this.itemSets_c.closeItemBrowser();
         }
         if(_loc2_ == this.leagueSystemWrapper && Boolean(this.leagueSystemShell))
         {
            this.leagueSystemShell.hide();
         }
      }
      
      public function set profileStatsSummaryPresentationModel(param1:ProfileStatsSummaryPresentationModel) : void
      {
         var _loc2_:Object = this._1292102721profileStatsSummaryPresentationModel;
         if(_loc2_ !== param1)
         {
            this._1292102721profileStatsSummaryPresentationModel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileStatsSummaryPresentationModel",_loc2_,param1));
         }
      }
      
      public function ___SummonerProfileView_Canvas1_addedToStage(param1:Event) : void
      {
         this.onShow();
      }
      
      public function set masteriesPage_c(param1:TalentTreeView) : void
      {
         var _loc2_:Object = this._488583240masteriesPage_c;
         if(_loc2_ !== param1)
         {
            this._488583240masteriesPage_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"masteriesPage_c",_loc2_,param1));
         }
      }
      
      private function summonerProfileViewTruncationFix() : void
      {
         this.newProfileViewChooser.invalidateSize();
         this.newProfileViewChooser.mouseClickKey = AudioKeys.SOUND_PROFILE_TAB_CLICK;
      }
      
      private function _SummonerProfileView_State8_i() : State
      {
         var _loc1_:State = new State();
         this._SummonerProfileView_State8 = _loc1_;
         BindingManager.executeBindings(this,"_SummonerProfileView_State8",this._SummonerProfileView_State8);
         return _loc1_;
      }
      
      private function _SummonerProfileView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.summonerProfileController.currentState;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            this.currentState = param1;
         },"this.currentState");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ProfilePagesEnum.PROFILE_PAGE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _SummonerProfileView_State1.name = param1;
         },"_SummonerProfileView_State1.name");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ProfilePagesEnum.RUNES_PAGE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _SummonerProfileView_State2.name = param1;
         },"_SummonerProfileView_State2.name");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ProfilePagesEnum.CHARACTERS_PAGE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _SummonerProfileView_State3.name = param1;
         },"_SummonerProfileView_State3.name");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ProfilePagesEnum.SPELLS_PAGE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _SummonerProfileView_State4.name = param1;
         },"_SummonerProfileView_State4.name");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ProfilePagesEnum.MASTERIES_PAGE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _SummonerProfileView_State5.name = param1;
         },"_SummonerProfileView_State5.name");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ProfilePagesEnum.MATCH_HISTORY_PAGE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _SummonerProfileView_State6.name = param1;
         },"_SummonerProfileView_State6.name");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ProfilePagesEnum.STATS_PAGE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _SummonerProfileView_State7.name = param1;
         },"_SummonerProfileView_State7.name");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ProfilePagesEnum.CLS;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _SummonerProfileView_State8.name = param1;
         },"_SummonerProfileView_State8.name");
         result[8] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ProfilePagesEnum.ITEMS_PAGE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _SummonerProfileView_State9.name = param1;
         },"_SummonerProfileView_State9.name");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("summonerProfile_page_profile");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            profilePage_c.label = param1;
         },"profilePage_c.label");
         result[10] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("summonerProfile_page_match_history");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            match_history_page.label = param1;
         },"match_history_page.label");
         result[11] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("summonerProfile_page_champions");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            charactersPage_c.label = param1;
         },"charactersPage_c.label");
         result[12] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.summonerProfileController.isLocalSummoner;
         },function(param1:Boolean):void
         {
            charactersPage_c.enabled = param1;
         },"charactersPage_c.enabled");
         result[13] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("summonerProfile_page_runes");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            runesPage_c.label = param1;
         },"runesPage_c.label");
         result[14] = binding;
         binding = new Binding(this,function():Boolean
         {
            return clientConfig.clientMode != ClientConfig.SPECIAL_MODE_GARENA;
         },function(param1:Boolean):void
         {
            runesPage_c.enabled = param1;
         },"runesPage_c.enabled");
         result[15] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("summonerProfile_page_masteries");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            masteries_wrapper.label = param1;
         },"masteries_wrapper.label");
         result[16] = binding;
         binding = new Binding(this,function():SummonerProfileController
         {
            return summonerProfileController;
         },function(param1:SummonerProfileController):void
         {
            masteriesPage_c.summonerProfileController = param1;
         },"masteriesPage_c.summonerProfileController");
         result[17] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("summonerProfile_page_spells");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            spellsPage_c.label = param1;
         },"spellsPage_c.label");
         result[18] = binding;
         binding = new Binding(this,function():SummonerProfileController
         {
            return summonerProfileController;
         },function(param1:SummonerProfileController):void
         {
            spellsPage_c.summonerProfileController = param1;
         },"spellsPage_c.summonerProfileController");
         result[19] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString(achievementsLabel ? "summonerProfile_page_achievemnets" : "summonerProfile_page_items");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            item_sets_page.label = param1;
         },"item_sets_page.label");
         result[20] = binding;
         binding = new Binding(this,function():Boolean
         {
            return itemSetsEnabled && Boolean(this.summonerProfileController.isLocalSummoner);
         },function(param1:Boolean):void
         {
            item_sets_page.enabled = param1;
         },"item_sets_page.enabled");
         result[21] = binding;
         binding = new Binding(this,function():SummonerProfileController
         {
            return summonerProfileController;
         },function(param1:SummonerProfileController):void
         {
            itemSets_c.summonerProfileController = param1;
         },"itemSets_c.summonerProfileController");
         result[22] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("summonerProfile_info_search_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            searchField.toolTip = param1;
         },"searchField.toolTip");
         result[23] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !this.summonerProfileController.isBusy;
         },function(param1:Boolean):void
         {
            searchField.enabled = param1;
         },"searchField.enabled");
         result[24] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("summonerProfile_info_search_prompt");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            searchField.prompt = param1;
         },"searchField.prompt");
         result[25] = binding;
         binding = new Binding(this,function():Object
         {
            return this.profilePages_c;
         },function(param1:Object):void
         {
            newProfileViewChooser.dataProvider = param1;
         },"newProfileViewChooser.dataProvider");
         result[26] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get achievementsLabel() : Boolean
      {
         return this._983698992achievementsLabel;
      }
      
      [Bindable(event="propertyChange")]
      public function get itemSetsEnabled() : Boolean
      {
         return this._392435869itemSetsEnabled;
      }
      
      [Bindable(event="propertyChange")]
      public function get masteries_wrapper() : Canvas
      {
         return this._111402889masteries_wrapper;
      }
      
      private function _SummonerProfileView_State4_i() : State
      {
         var _loc1_:State = new State();
         this._SummonerProfileView_State4 = _loc1_;
         BindingManager.executeBindings(this,"_SummonerProfileView_State4",this._SummonerProfileView_State4);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get charactersPage_c() : Canvas
      {
         return this._894196291charactersPage_c;
      }
      
      [Bindable(event="propertyChange")]
      public function get profilePages_c() : ViewStack
      {
         return this._1632655169profilePages_c;
      }
      
      private function onHide() : void
      {
         this.resetView();
      }
      
      private function handleSummonerProfileSearch() : void
      {
         if(this.masterGameController.session.summoner.isMe)
         {
            if(this.runeBookController)
            {
               this.runeBookController.promptToSaveBeforeExit(this,this.performSummonerSearch);
            }
            else
            {
               this.getRuneBookController(this.performSummonerSearch);
            }
         }
         else
         {
            this.performSummonerSearch();
         }
      }
      
      public function ___SummonerProfileView_Canvas1_hide(param1:FlexEvent) : void
      {
         this.onHide();
      }
      
      private function onRuneBookControllerRetrieved(param1:IRuneBookController) : void
      {
         this.runeBookController = param1;
         if(this.runeBookControllerCallback != null)
         {
            this.runeBookController.promptToSaveBeforeExit(this,this.runeBookControllerCallback);
            this.runeBookControllerCallback = null;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get profilePage_c() : Canvas
      {
         return this._1161045572profilePage_c;
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get profileStatsSummaryPresentationModel() : ProfileStatsSummaryPresentationModel
      {
         return this._1292102721profileStatsSummaryPresentationModel;
      }
      
      private function onInitialize() : void
      {
      }
      
      public function set itemSets_c(param1:ItemBrowserViewWrapper) : void
      {
         var _loc2_:Object = this._1986500840itemSets_c;
         if(_loc2_ !== param1)
         {
            this._1986500840itemSets_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemSets_c",_loc2_,param1));
         }
      }
      
      public function __newProfileViewChooser_itemClick(param1:ItemClickEvent) : void
      {
         this.onTabClicked(param1);
      }
      
      public function set spellsPage_c(param1:SpellsViewWrapper) : void
      {
         var _loc2_:Object = this._1423281442spellsPage_c;
         if(_loc2_ !== param1)
         {
            this._1423281442spellsPage_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spellsPage_c",_loc2_,param1));
         }
      }
      
      public function __profilePages_c_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      private function createLeagueSystemTab() : void
      {
         this.rankedStatsView = new ProfileStatsView();
         this.rankedStatsView.id = "rankedStatsView";
         this.rankedStatsView.label = RiotResourceLoader.getString("summonerProfile_page_stats");
         this.rankedStatsView.enabled = Boolean(this.summonerProfileController.isSummonerStatsLoaded) && Boolean(this.profileStatsSummaryPresentationModel.showStats);
         this.rankedStatsView.masterGameController = this.masterGameController;
         this.rankedStatsView.summonerProfileController = this.summonerProfileController;
         this.leagueSystemWrapper = new Canvas();
         this.leagueSystemWrapper.id = "leagueSystemWrapper";
         this.leagueSystemWrapper.label = RiotResourceLoader.getString("summonerProfile_page_leagues");
         this.leagueSystemShell = new LeagueSystemShell();
         this.leagueSystemShell.id = "leagueSystemShell";
         this.leagueSystemShell.summonerProfileController = this.summonerProfileController;
         this.leagueSystemShell.masterGameController = this.masterGameController;
         this.leagueSystemShell.lobbyController = this.masterGameController.lobbyController;
         this.leagueSystemShell.leagueSystemStatsView = this.leagueSystemStatsView;
         this.leagueSystemWrapper.addChild(this.leagueSystemShell);
         this.clientConfig.getLeagueServiceEnabledChanged().add(this.onLeagueServiceEnabledChanged);
         this.onLeagueServiceEnabledChanged(true,this.clientConfig.leagueServiceEnabled);
      }
      
      [Bindable(event="propertyChange")]
      public function get breadcrumbsContent() : ArrayCollection
      {
         return this._850096521breadcrumbsContent;
      }
      
      private function onSearchError(param1:ServerError) : void
      {
         var _loc2_:IResourceManager = null;
         var _loc3_:AlertAction = null;
         if(this.searchField.text != "" && this.searchField.text != null)
         {
            _loc2_ = ResourceManager.getInstance();
            _loc3_ = new AlertAction(_loc2_.getString("resources","summonerProfile_info_search_error_title"),_loc2_.getString("resources","chat_buddyWindow_errorOnAddBuddyAlertMessage",[this.searchField.text.replace(/</g,"&lt;")]));
            _loc3_.add();
         }
      }
      
      public function __searchField_enter(param1:FlexEvent) : void
      {
         this.handleSummonerProfileSearch();
      }
      
      [Bindable(event="propertyChange")]
      public function get spellsPage_c() : SpellsViewWrapper
      {
         return this._1423281442spellsPage_c;
      }
      
      [Bindable(event="propertyChange")]
      public function get itemSets_c() : ItemBrowserViewWrapper
      {
         return this._1986500840itemSets_c;
      }
      
      public function set clientConfig(param1:ClientConfig) : void
      {
         var _loc2_:Object = this._1895424275clientConfig;
         if(_loc2_ !== param1)
         {
            this._1895424275clientConfig = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clientConfig",_loc2_,param1));
         }
      }
      
      private function _SummonerProfileView_State7_i() : State
      {
         var _loc1_:State = new State();
         this._SummonerProfileView_State7 = _loc1_;
         BindingManager.executeBindings(this,"_SummonerProfileView_State7",this._SummonerProfileView_State7);
         return _loc1_;
      }
      
      public function ___SummonerProfileView_Canvas1_currentStateChange(param1:StateChangeEvent) : void
      {
         this.onCurrentStateChanged(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get clientConfig() : ClientConfig
      {
         return this._1895424275clientConfig;
      }
      
      [Bindable(event="propertyChange")]
      public function get match_history_page() : Canvas
      {
         return this._137448340match_history_page;
      }
      
      private function _SummonerProfileView_State3_i() : State
      {
         var _loc1_:State = new State();
         this._SummonerProfileView_State3 = _loc1_;
         BindingManager.executeBindings(this,"_SummonerProfileView_State3",this._SummonerProfileView_State3);
         return _loc1_;
      }
      
      private function onLeagueServiceEnabledChanged(param1:Boolean, param2:Boolean) : void
      {
         if(param2)
         {
            if(this.profilePages_c.contains(this.rankedStatsView))
            {
               this.profilePages_c.removeChild(this.rankedStatsView);
            }
            this.profilePages_c.addChildAt(this.leagueSystemWrapper,LEAGUE_SYSTEM_MENU_POSITION);
         }
         if(!param2)
         {
            if(this.profilePages_c.contains(this.leagueSystemWrapper))
            {
               this.profilePages_c.removeChild(this.leagueSystemWrapper);
            }
            this.profilePages_c.addChildAt(this.rankedStatsView,LEAGUE_SYSTEM_MENU_POSITION);
         }
      }
   }
}

