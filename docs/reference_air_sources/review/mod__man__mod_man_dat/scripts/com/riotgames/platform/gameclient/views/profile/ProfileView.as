package com.riotgames.platform.gameclient.views.profile
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.components.containers.LazyViewstack;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import com.riotgames.platform.gameclient.views.models.ProfileDisplayModel;
   import com.riotgames.platform.gameclient.views.summoner.SummonerProfileView;
   import com.riotgames.platform.gameclient.views.summoner.stats.LeagueSystemStatsView;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.rankedteams.IRankedTeamsProvider;
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
   import mx.binding.*;
   import mx.binding.utils.ChangeWatcher;
   import mx.containers.Canvas;
   import mx.controls.Button;
   import mx.controls.Image;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class ProfileView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _summonerProfileView:UIComponent;
      
      private var teamServiceWatcher:ChangeWatcher;
      
      public var session:Session;
      
      mx_internal var _watchers:Array = [];
      
      private var _575511170createRankedTeamButtonHolder:UIComponent;
      
      private var _rankedTeamsView:UIComponent;
      
      private var _695754682leagueSystemStatsView:LeagueSystemStatsView;
      
      private var rankedTeams:IRankedTeamsProvider;
      
      private var _475505495mainTabBar:SoundEffectButton;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      [Inject]
      public var profileDisplayModel:ProfileDisplayModel;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var _475400139rankedTeamTabButtonHolder:UIComponent;
      
      private var _951530617content:LazyViewstack;
      
      private var _1720418021summonerPromoGamesPlayedButton:Button;
      
      public var clientConfig:ClientConfig;
      
      mx_internal var _bindings:Array = [];
      
      [Inject]
      private var _566834807summonerProfileController:SummonerProfileController;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Image,
               "id":"mainBackgroundImage",
               "stylesFactory":function():void
               {
                  this.horizontalCenter = "1";
                  this.verticalCenter = "1";
               }
            }),new UIComponentDescriptor({
               "type":SoundEffectButton,
               "id":"mainTabBar",
               "events":{"click":"__mainTabBar_click"},
               "stylesFactory":function():void
               {
                  this.left = "99";
                  this.top = "36";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "styleName":"profileTabSelected",
                     "width":236,
                     "height":42,
                     "tabEnabled":false,
                     "tabChildren":false
                  };
               }
            }),new UIComponentDescriptor({
               "type":UIComponent,
               "id":"rankedTeamTabButtonHolder",
               "propertiesFactory":function():Object
               {
                  return {
                     "visible":false,
                     "x":338,
                     "y":40
                  };
               }
            }),new UIComponentDescriptor({
               "type":UIComponent,
               "id":"createRankedTeamButtonHolder",
               "propertiesFactory":function():Object
               {
                  return {
                     "visible":false,
                     "x":570,
                     "y":45
                  };
               }
            }),new UIComponentDescriptor({
               "type":Button,
               "id":"summonerPromoGamesPlayedButton",
               "events":{"click":"__summonerPromoGamesPlayedButton_click"},
               "stylesFactory":function():void
               {
                  this.fontSize = 13;
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "x":840,
                     "y":37,
                     "width":250,
                     "height":37,
                     "styleName":"genericButton",
                     "buttonMode":true
                  };
               }
            }),new UIComponentDescriptor({
               "type":LazyViewstack,
               "id":"content",
               "stylesFactory":function():void
               {
                  this.top = "76";
                  this.bottom = "0";
                  this.left = "0";
                  this.right = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "clipContent":false
                  };
               }
            }),new UIComponentDescriptor({
               "type":LeagueSystemStatsView,
               "id":"leagueSystemStatsView",
               "stylesFactory":function():void
               {
                  this.top = "76";
                  this.bottom = "0";
                  this.left = "0";
                  this.right = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {"clipContent":false};
               }
            })]};
         }
      });
      
      private var _550099412mainBackgroundImage:Image;
      
      public function ProfileView()
      {
         super();
         mx_internal::_document = this;
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.addEventListener("initialize",this.___ProfileView_Canvas1_initialize);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ProfileView._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get summonerProfileController() : SummonerProfileController
      {
         return this._566834807summonerProfileController;
      }
      
      public function __mainTabBar_click(param1:MouseEvent) : void
      {
         this.onSummonerTabClicked();
      }
      
      [Bindable(event="propertyChange")]
      public function get createRankedTeamButtonHolder() : UIComponent
      {
         return this._575511170createRankedTeamButtonHolder;
      }
      
      public function set content(param1:LazyViewstack) : void
      {
         var _loc2_:Object = this._951530617content;
         if(_loc2_ !== param1)
         {
            this._951530617content = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"content",_loc2_,param1));
         }
      }
      
      public function set createRankedTeamButtonHolder(param1:UIComponent) : void
      {
         var _loc2_:Object = this._575511170createRankedTeamButtonHolder;
         if(_loc2_ !== param1)
         {
            this._575511170createRankedTeamButtonHolder = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"createRankedTeamButtonHolder",_loc2_,param1));
         }
      }
      
      public function set leagueSystemStatsView(param1:LeagueSystemStatsView) : void
      {
         var _loc2_:Object = this._695754682leagueSystemStatsView;
         if(_loc2_ !== param1)
         {
            this._695754682leagueSystemStatsView = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leagueSystemStatsView",_loc2_,param1));
         }
      }
      
      public function __summonerPromoGamesPlayedButton_click(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest(RiotResourceLoader.getString("loyalty_promo_button_url","http://www.leagueoflegends.com")));
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ProfileView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ProfileView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_profile_ProfileViewWatcherSetupUtil");
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
      
      [Bindable(event="propertyChange")]
      public function get summonerPromoGamesPlayedButton() : Button
      {
         return this._1720418021summonerPromoGamesPlayedButton;
      }
      
      private function joinReady() : void
      {
         if(this.content)
         {
            this.mainBackgroundImage.source = ImagePackLookup.instance.getClassFromSwfRef("e_parchment");
            ProviderLookup.getProvider(IRankedTeamsProvider,this.onRankedTeamsAvailable);
            if(this.summonerProfileController.baseSummoner == null)
            {
               this.summonerProfileController.baseSummoner = this.session.summoner;
            }
            this.profileDisplayModel.addEventListener("changed",this.onProfileStateChanged);
            this.updateContent();
         }
      }
      
      private function initializeHandler() : void
      {
         this.clientConfig = ClientConfig.instance;
         this.session = Session.instance;
      }
      
      [PostConstruct]
      public function postConstruct() : void
      {
         this.joinReady();
      }
      
      public function set rankedTeamTabButtonHolder(param1:UIComponent) : void
      {
         var _loc2_:Object = this._475400139rankedTeamTabButtonHolder;
         if(_loc2_ !== param1)
         {
            this._475400139rankedTeamTabButtonHolder = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedTeamTabButtonHolder",_loc2_,param1));
         }
      }
      
      public function ___ProfileView_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.initializeHandler();
      }
      
      public function set mainBackgroundImage(param1:Image) : void
      {
         var _loc2_:Object = this._550099412mainBackgroundImage;
         if(_loc2_ !== param1)
         {
            this._550099412mainBackgroundImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mainBackgroundImage",_loc2_,param1));
         }
      }
      
      public function set mainTabBar(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._475505495mainTabBar;
         if(_loc2_ !== param1)
         {
            this._475505495mainTabBar = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mainTabBar",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leagueSystemStatsView() : LeagueSystemStatsView
      {
         return this._695754682leagueSystemStatsView;
      }
      
      private function get summonerProfileView() : UIComponent
      {
         var _loc1_:SummonerProfileView = null;
         if(!this._summonerProfileView)
         {
            _loc1_ = new SummonerProfileView();
            _loc1_.leagueSystemStatsView = this.leagueSystemStatsView;
            this._summonerProfileView = _loc1_;
         }
         return this._summonerProfileView;
      }
      
      private function _ProfileView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.summonerProfileController.summonerName;
         _loc1_ = RiotResourceLoader.getString("loyalty_promo_button_label","Promotional games played: " + int(this.summonerProfileController.promotionalGamesPlayed),[int(this.summonerProfileController.promotionalGamesPlayed)]);
         _loc1_ = this.summonerProfileController.isLocalSummoner && this.summonerProfileController.displayPromotionalGames;
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedTeamTabButtonHolder() : UIComponent
      {
         return this._475400139rankedTeamTabButtonHolder;
      }
      
      private function onTeamServiceEnabledChanged(param1:Boolean, param2:Boolean) : void
      {
         this.rankedTeamTabButtonHolder.visible = this.clientConfig.teamServiceEnabled;
         this.createRankedTeamButtonHolder.visible = this.clientConfig.teamServiceEnabled;
         if(!this.clientConfig.teamServiceEnabled && this.profileDisplayModel.activeView == ProfileDisplayModel.RANKED_TEAMS_VIEW)
         {
            this.onSummonerTabClicked();
         }
      }
      
      private function onProfileStateChanged(param1:Event) : void
      {
         this.updateContent();
      }
      
      public function set summonerPromoGamesPlayedButton(param1:Button) : void
      {
         var _loc2_:Object = this._1720418021summonerPromoGamesPlayedButton;
         if(_loc2_ !== param1)
         {
            this._1720418021summonerPromoGamesPlayedButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerPromoGamesPlayedButton",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mainBackgroundImage() : Image
      {
         return this._550099412mainBackgroundImage;
      }
      
      [Bindable(event="propertyChange")]
      public function get mainTabBar() : SoundEffectButton
      {
         return this._475505495mainTabBar;
      }
      
      private function onRankedTeamsAvailable(param1:IRankedTeamsProvider) : void
      {
         this.rankedTeams = param1;
         var _loc2_:DisplayObject = this.rankedTeams.getRankedTeamsTabButton();
         this.rankedTeamTabButtonHolder.addChild(_loc2_);
         this.rankedTeamTabButtonHolder.visible = this.clientConfig.teamServiceEnabled;
         var _loc3_:DisplayObject = this.rankedTeams.getCreateRankedTeamButton();
         this.createRankedTeamButtonHolder.addChild(_loc3_);
         this.createRankedTeamButtonHolder.visible = this.clientConfig.teamServiceEnabled;
         this.leagueSystemStatsView.init(this.rankedTeams);
         this.clientConfig.getteamServiceEnabledChanged().add(this.onTeamServiceEnabledChanged);
      }
      
      private function _ProfileView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.summonerProfileController.summonerName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            mainTabBar.label = param1;
         },"mainTabBar.label");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("loyalty_promo_button_label","Promotional games played: " + int(this.summonerProfileController.promotionalGamesPlayed),[int(this.summonerProfileController.promotionalGamesPlayed)]);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            summonerPromoGamesPlayedButton.label = param1;
         },"summonerPromoGamesPlayedButton.label");
         result[1] = binding;
         binding = new Binding(this,function():Boolean
         {
            return Boolean(this.summonerProfileController.isLocalSummoner) && Boolean(this.summonerProfileController.displayPromotionalGames);
         },function(param1:Boolean):void
         {
            summonerPromoGamesPlayedButton.visible = param1;
         },"summonerPromoGamesPlayedButton.visible");
         result[2] = binding;
         return result;
      }
      
      override protected function childrenCreated() : void
      {
         this.joinReady();
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
      
      private function get rankedTeamsView() : UIComponent
      {
         var _loc1_:DisplayObject = null;
         if(!this._rankedTeamsView)
         {
            _loc1_ = this.rankedTeams.getRankedTeamsTabView();
            this._rankedTeamsView = _loc1_ as UIComponent;
         }
         return this._rankedTeamsView;
      }
      
      private function updateContent() : void
      {
         if(this.profileDisplayModel)
         {
            switch(this.profileDisplayModel.activeView)
            {
               case ProfileDisplayModel.SUMMONER_VIEW:
                  this.content.content = this.summonerProfileView;
                  this.mainTabBar.styleName = "profileTabSelected";
                  break;
               case ProfileDisplayModel.RANKED_TEAMS_VIEW:
                  this.content.content = this.rankedTeamsView;
                  this.mainTabBar.styleName = "profileTabUnselected";
                  break;
               default:
                  this.content.content = null;
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get content() : LazyViewstack
      {
         return this._951530617content;
      }
      
      private function onSummonerTabClicked() : void
      {
         this.profileDisplayModel.activeView = ProfileDisplayModel.SUMMONER_VIEW;
         this.profileDisplayModel.update();
      }
   }
}

