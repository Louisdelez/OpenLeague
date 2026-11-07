package com.riotgames.platform.gameclient.views.summoner
{
   import blix.assets.proxy.IDisplayChild;
   import com.adobe.effects.SaturationFade;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.provider.IRerollProvider;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.components.summoner.SummonerIcon;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.platform.gameclient.kudos.IKudosFactory;
   import com.riotgames.platform.gameclient.kudos.IKudosProfilePanel;
   import com.riotgames.platform.gameclient.kudos.KudosFactoryProxy;
   import com.riotgames.platform.gameclient.utils.DateUtil;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
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
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ToolTipEvent;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class SummonerInfoQuickView extends Canvas implements ISummonerInfoQuickView, IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const OVERVIEW_FIRST_WIN_ICON:Class = SummonerInfoQuickView_OVERVIEW_FIRST_WIN_ICON;
      
      public static const OVERVIEW_REROLL_AVAILABLE_ICON:Class = SummonerInfoQuickView_OVERVIEW_REROLL_AVAILABLE_ICON;
      
      public static const OVERVIEW_REROLL_UNAVAILABLE_ICON:Class = SummonerInfoQuickView_OVERVIEW_REROLL_UNAVAILABLE_ICON;
      
      private var _417404173summonerHeaderTierAsset:Object;
      
      private var _1984987798session:Session = Session.instance;
      
      private var targetSummonerChangeWatcher:ChangeWatcher = null;
      
      private var _1820819015summonerHeaderLevelDisplay:Label;
      
      private var _624983732summonerIconImage:SummonerIcon;
      
      private var _1039096784summonerHeaderNameplate:Label;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _1975831668ipImage:Image;
      
      private var _261322561rerollProvider:IRerollProvider;
      
      private var _818238841blackTextGlow:GlowFilter;
      
      private var _1891482301xpImage:Image;
      
      private var _1681870212xpindicatorBar:Image;
      
      private var _1662566157profileHeaderTierRewardBorder:Image;
      
      private var _1855392849bottomRow:ConstraintRow;
      
      private var _942527945rerollIcon:Image;
      
      private var _868055995topRow:ConstraintRow;
      
      private var _39586041firstWinOfTheDayTimeDisplay:Label;
      
      private var _2020599460inventory:IInventory;
      
      protected var kudosFactory:IKudosFactory = KudosFactoryProxy.getInstance();
      
      private var _851761783xpBarBackground:Image;
      
      mx_internal var _watchers:Array = [];
      
      private var kudosProfilePanel:IKudosProfilePanel;
      
      private var _1817957447satFadeIn:SaturationFade;
      
      private var firstWinTimer:Timer;
      
      private var _1326310780profileSignitureHeader:Canvas;
      
      private var _1613087374rerollDisplay:Label;
      
      private var _1893862255summonerXPCurrentDisplay:Label;
      
      private var _504563792summonerTier:String;
      
      private var _522112108satFadeOut:SaturationFade;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var tierHeaderMap:Object = {};
      
      private var _1554473828profileHeaderBackground:Image;
      
      private var _801539531summonerHeaderAsset:Object;
      
      private var _1269534117firstWinIcon:Image;
      
      public var clientConfig:ClientConfig = ClientConfig.instance;
      
      mx_internal var _bindings:Array = [];
      
      private var _summonerProfileController:SummonerProfileController;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Canvas,
               "id":"profileSignitureHeader",
               "propertiesFactory":function():Object
               {
                  return {
                     "percentWidth":100,
                     "percentHeight":100,
                     "verticalScrollPolicy":"off",
                     "horizontalScrollPolicy":"off",
                     "cacheAsBitmap":true,
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Image,
                        "id":"profileHeaderBackground",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "x":7,
                              "y":-9,
                              "width":1056,
                              "height":192
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"profileHeaderTierRewardBorder",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "y":-2,
                              "x":2,
                              "maintainAspectRatio":true,
                              "width":1064,
                              "height":180
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":SummonerIcon,
                        "id":"summonerIconImage",
                        "stylesFactory":function():void
                        {
                           this.top = "39";
                           this.left = "35";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "width":96,
                              "height":96
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Label,
                        "id":"summonerHeaderNameplate",
                        "stylesFactory":function():void
                        {
                           this.top = "49";
                           this.left = "140";
                           this.color = 16777215;
                           this.fontSize = 20;
                        }
                     }),new UIComponentDescriptor({
                        "type":Label,
                        "id":"summonerHeaderLevelDisplay",
                        "stylesFactory":function():void
                        {
                           this.top = "100";
                           this.color = 16777215;
                           this.fontSize = 22;
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"xpBarBackground",
                        "stylesFactory":function():void
                        {
                           this.left = "128";
                           this.top = "90";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "width":208,
                              "maintainAspectRatio":false
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"xpindicatorBar",
                        "stylesFactory":function():void
                        {
                           this.left = "140";
                           this.top = "100";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {"maintainAspectRatio":false};
                        }
                     }),new UIComponentDescriptor({
                        "type":Label,
                        "id":"summonerXPCurrentDisplay",
                        "stylesFactory":function():void
                        {
                           this.textAlign = "center";
                           this.top = "100";
                           this.left = "140";
                           this.color = 16777215;
                           this.fontSize = 20;
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "styleName":"summonerStatsText",
                              "width":180
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Label,
                        "id":"firstWinOfTheDayTimeDisplay",
                        "stylesFactory":function():void
                        {
                           this.right = "60";
                           this.top = "119";
                           this.color = 16777215;
                           this.fontSize = 14;
                           this.textAlign = "right";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "styleName":"summonerStatsText",
                              "text":"",
                              "width":500
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"firstWinIcon",
                        "stylesFactory":function():void
                        {
                           this.right = "28";
                           this.top = "117";
                        }
                     }),new UIComponentDescriptor({
                        "type":Label,
                        "id":"rerollDisplay",
                        "stylesFactory":function():void
                        {
                           this.right = "60";
                           this.top = "88";
                           this.color = 16777215;
                           this.fontSize = 14;
                           this.textAlign = "right";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "styleName":"summonerStatsText",
                              "text":"",
                              "toolTip":"",
                              "width":500
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"rerollIcon",
                        "stylesFactory":function():void
                        {
                           this.right = "28";
                           this.top = "86";
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"xpImage",
               "events":{"toolTipCreate":"__xpImage_toolTipCreate"},
               "stylesFactory":function():void
               {
                  this.right = "82";
                  this.top = "32";
               },
               "propertiesFactory":function():Object
               {
                  return {"toolTip":"unused"};
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"ipImage",
               "events":{"toolTipCreate":"__ipImage_toolTipCreate"},
               "stylesFactory":function():void
               {
                  this.right = "27";
                  this.top = "32";
               },
               "propertiesFactory":function():Object
               {
                  return {"toolTip":"unused"};
               }
            })]};
         }
      });
      
      public function SummonerInfoQuickView()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.clipContent = false;
         this.constraintRows = [this._SummonerInfoQuickView_ConstraintRow1_i(),this._SummonerInfoQuickView_ConstraintRow2_i()];
         this._SummonerInfoQuickView_GlowFilter1_i();
         this._SummonerInfoQuickView_SaturationFade2_i();
         this._SummonerInfoQuickView_SaturationFade1_i();
         this.addEventListener("creationComplete",this.___SummonerInfoQuickView_Canvas1_creationComplete);
         this.addEventListener("initialize",this.___SummonerInfoQuickView_Canvas1_initialize);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         SummonerInfoQuickView._watcherSetupUtil = param1;
      }
      
      private function onRerollProvider(param1:IRerollProvider) : void
      {
         this.rerollProvider = param1;
         this.updateRerollDisplay();
      }
      
      private function set _566834807summonerProfileController(param1:SummonerProfileController) : void
      {
         if(this.targetSummonerChangeWatcher)
         {
            this.targetSummonerChangeWatcher.unwatch();
            this.targetSummonerChangeWatcher = null;
         }
         this._summonerProfileController = param1;
         if(this._summonerProfileController)
         {
            this.targetSummonerChangeWatcher = ChangeWatcher.watch(this._summonerProfileController,"currentSummoner",this.onTargetSummonerChanged);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get firstWinOfTheDayTimeDisplay() : Label
      {
         return this._39586041firstWinOfTheDayTimeDisplay;
      }
      
      public function set profileSignitureHeader(param1:Canvas) : void
      {
         var _loc2_:Object = this._1326310780profileSignitureHeader;
         if(_loc2_ !== param1)
         {
            this._1326310780profileSignitureHeader = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileSignitureHeader",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get summonerHeaderTierAsset() : Object
      {
         return this._417404173summonerHeaderTierAsset;
      }
      
      private function _SummonerInfoQuickView_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.topRow = _loc1_;
         _loc1_.percentHeight = 50;
         _loc1_.initialized(this,"topRow");
         return _loc1_;
      }
      
      public function set firstWinOfTheDayTimeDisplay(param1:Label) : void
      {
         var _loc2_:Object = this._39586041firstWinOfTheDayTimeDisplay;
         if(_loc2_ !== param1)
         {
            this._39586041firstWinOfTheDayTimeDisplay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"firstWinOfTheDayTimeDisplay",_loc2_,param1));
         }
      }
      
      public function set xpBarBackground(param1:Image) : void
      {
         var _loc2_:Object = this._851761783xpBarBackground;
         if(_loc2_ !== param1)
         {
            this._851761783xpBarBackground = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xpBarBackground",_loc2_,param1));
         }
      }
      
      private function onTargetSummonerChanged(param1:PropertyChangeEvent) : void
      {
         var _loc2_:String = null;
         if(this.summonerProfileController.currentSummoner != null)
         {
            this.summonerTier = this.summonerProfileController.currentSummoner.previousSeasonHighestTier;
            _loc2_ = this.tierHeaderMap[this.summonerTier];
            if(!_loc2_ || !this.clientConfig.showTierRewards)
            {
               _loc2_ = this.tierHeaderMap["UNRANKED"];
               this.summonerTier = "UNRANKED";
            }
            this.updateBannerForIconSelection();
            this.summonerHeaderTierAsset = ImagePackLookup.instance.getClassFromSwfRef(_loc2_);
            if(this.summonerProfileController.isLocalSummoner)
            {
               this.setupTimer();
               this.updateFirstWinTimeLabel();
            }
            this.displayKudosDataForSummoner(this.summonerProfileController.currentSummoner);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.initKudosProfilePanel();
         if(this.kudosProfilePanel != null)
         {
            this.kudosProfilePanel.initializeBlix();
         }
      }
      
      public function setAsAsset(param1:IDisplayChild) : void
      {
         param1.setAsset(this);
      }
      
      public function ___SummonerInfoQuickView_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      private function removeTimer() : void
      {
         if(this.firstWinTimer)
         {
            this.firstWinTimer.stop();
            this.firstWinTimer.removeEventListener(TimerEvent.TIMER,this.onFirstWinTimer);
            this.firstWinTimer = null;
         }
      }
      
      private function updateRerollDisplay() : void
      {
         if(this.rerollProvider != null)
         {
            if(this.summonerProfileController.isLocalSummoner)
            {
               if(!this.rerollProvider.getRerollCached())
               {
                  this.rerollProvider.getPointsBalance(this.onRerollPointsBalanceSuccess,null,this.onRerollPointsBalanceError);
               }
               this.updateRerollDisplayText();
            }
            else
            {
               this.rerollDisplay.visible = false;
               this.rerollIcon.visible = false;
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerHeaderNameplate() : Label
      {
         return this._1039096784summonerHeaderNameplate;
      }
      
      [Bindable(event="propertyChange")]
      private function get summonerHeaderAsset() : Object
      {
         return this._801539531summonerHeaderAsset;
      }
      
      private function onCreationComplete() : void
      {
         this.removeTimer();
         this.setupTimer();
         this.updateFirstWinTimeLabel();
         this.satFadeOut.play([this.firstWinIcon]);
         this.summonerIconImage.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onSummonerIconPropertyChanged,false,0,true);
      }
      
      public function set session(param1:Session) : void
      {
         var _loc2_:Object = this._1984987798session;
         if(_loc2_ !== param1)
         {
            this._1984987798session = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"session",_loc2_,param1));
         }
      }
      
      private function updateBannerForIconSelection() : void
      {
         if(Boolean(this.summonerProfileController) && Boolean(this.summonerProfileController.currentSummoner))
         {
            this.summonerHeaderAsset = ImagePackLookup.instance.getClassFromSwfRef("e_summonerBanner" + this.summonerProfileController.currentSummoner.profileIconId.toString());
            if(this.summonerHeaderAsset == null)
            {
               this.summonerHeaderAsset = ImagePackLookup.instance.getClassFromSwfRef("e_defaultSummonerBanner");
            }
         }
         else
         {
            this.summonerHeaderAsset = ImagePackLookup.instance.getClassFromSwfRef("e_defaultSummonerBanner");
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get xpImage() : Image
      {
         return this._1891482301xpImage;
      }
      
      [Bindable(event="propertyChange")]
      public function get topRow() : ConstraintRow
      {
         return this._868055995topRow;
      }
      
      [Bindable(event="propertyChange")]
      public function get satFadeIn() : SaturationFade
      {
         return this._1817957447satFadeIn;
      }
      
      [Bindable(event="propertyChange")]
      public function get rerollProvider() : IRerollProvider
      {
         return this._261322561rerollProvider;
      }
      
      private function onInventoryProvider(param1:IInventoryProvider) : void
      {
         this.inventory = param1.getInventory();
         this.setXpBoostVisibility();
         this.setIpBoostVisibility();
      }
      
      public function set firstWinIcon(param1:Image) : void
      {
         var _loc2_:Object = this._1269534117firstWinIcon;
         if(_loc2_ !== param1)
         {
            this._1269534117firstWinIcon = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"firstWinIcon",_loc2_,param1));
         }
      }
      
      public function __ipImage_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.createIPTooltip(param1);
      }
      
      public function initializeView() : void
      {
      }
      
      [Bindable(event="propertyChange")]
      private function get summonerTier() : String
      {
         return this._504563792summonerTier;
      }
      
      [Bindable(event="propertyChange")]
      public function get inventory() : IInventory
      {
         return this._2020599460inventory;
      }
      
      private function _SummonerInfoQuickView_GlowFilter1_i() : GlowFilter
      {
         var _loc1_:GlowFilter = new GlowFilter();
         this.blackTextGlow = _loc1_;
         _loc1_.color = 0;
         _loc1_.alpha = 1;
         _loc1_.blurX = 6;
         _loc1_.blurY = 6;
         _loc1_.strength = 3;
         _loc1_.quality = 1;
         return _loc1_;
      }
      
      private function onRerollPointsBalanceError(param1:Object = null) : void
      {
         this.rerollDisplay.visible = false;
         this.rerollIcon.visible = false;
      }
      
      private function createIPTooltip(param1:ToolTipEvent) : void
      {
         var _loc2_:BoostToolTip = new BoostToolTip();
         var _loc3_:Object = {
            "titleText":ResourceManager.getInstance().getString("resources","summonerProfile_info_ipBoostTitle_tooltip"),
            "displayEndDate":this.inventory.activeBoosts.displayIpEndDate,
            "boostsPerWinCount":this.inventory.activeBoosts.displayIpBoostPerWinCount
         };
         _loc2_.data = _loc3_;
         param1.toolTip = _loc2_;
      }
      
      [Bindable(event="propertyChange")]
      public function get profileHeaderBackground() : Image
      {
         return this._1554473828profileHeaderBackground;
      }
      
      public function set bottomRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._1855392849bottomRow;
         if(_loc2_ !== param1)
         {
            this._1855392849bottomRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottomRow",_loc2_,param1));
         }
      }
      
      private function _SummonerInfoQuickView_SaturationFade2_i() : SaturationFade
      {
         var _loc1_:SaturationFade = new SaturationFade();
         this.satFadeIn = _loc1_;
         _loc1_.duration = 1000;
         _loc1_.saturationFrom = 0;
         _loc1_.saturationTo = 1;
         return _loc1_;
      }
      
      public function set summonerHeaderNameplate(param1:Label) : void
      {
         var _loc2_:Object = this._1039096784summonerHeaderNameplate;
         if(_loc2_ !== param1)
         {
            this._1039096784summonerHeaderNameplate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerHeaderNameplate",_loc2_,param1));
         }
      }
      
      public function set summonerIconImage(param1:SummonerIcon) : void
      {
         var _loc2_:Object = this._624983732summonerIconImage;
         if(_loc2_ !== param1)
         {
            this._624983732summonerIconImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerIconImage",_loc2_,param1));
         }
      }
      
      private function initKudosProfilePanel() : void
      {
         if(!this.kudosProfilePanel)
         {
            this.kudosProfilePanel = this.kudosFactory.getProfilePanel(this);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get satFadeOut() : SaturationFade
      {
         return this._522112108satFadeOut;
      }
      
      private function createXPTooltip(param1:ToolTipEvent) : void
      {
         var _loc2_:BoostToolTip = new BoostToolTip();
         var _loc3_:Object = {
            "titleText":ResourceManager.getInstance().getString("resources","summonerProfile_info_xpBoostTitle_tooltip"),
            "displayEndDate":this.inventory.activeBoosts.displayXpEndDate,
            "boostsPerWinCount":this.inventory.activeBoosts.displayXpBoostPerWinCount
         };
         _loc2_.data = _loc3_;
         param1.toolTip = _loc2_;
      }
      
      private function set summonerHeaderAsset(param1:Object) : void
      {
         var _loc2_:Object = this._801539531summonerHeaderAsset;
         if(_loc2_ !== param1)
         {
            this._801539531summonerHeaderAsset = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerHeaderAsset",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ipImage() : Image
      {
         return this._1975831668ipImage;
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerXPCurrentDisplay() : Label
      {
         return this._1893862255summonerXPCurrentDisplay;
      }
      
      [Inject]
      public function get summonerProfileController() : SummonerProfileController
      {
         return this._summonerProfileController;
      }
      
      [Bindable(event="propertyChange")]
      public function get blackTextGlow() : GlowFilter
      {
         return this._818238841blackTextGlow;
      }
      
      [Bindable(event="propertyChange")]
      public function get xpindicatorBar() : Image
      {
         return this._1681870212xpindicatorBar;
      }
      
      public function set rerollProvider(param1:IRerollProvider) : void
      {
         var _loc2_:Object = this._261322561rerollProvider;
         if(_loc2_ !== param1)
         {
            this._261322561rerollProvider = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rerollProvider",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get profileSignitureHeader() : Canvas
      {
         return this._1326310780profileSignitureHeader;
      }
      
      public function set xpImage(param1:Image) : void
      {
         var _loc2_:Object = this._1891482301xpImage;
         if(_loc2_ !== param1)
         {
            this._1891482301xpImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xpImage",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get xpBarBackground() : Image
      {
         return this._851761783xpBarBackground;
      }
      
      [Bindable(event="propertyChange")]
      public function get rerollDisplay() : Label
      {
         return this._1613087374rerollDisplay;
      }
      
      public function set satFadeIn(param1:SaturationFade) : void
      {
         var _loc2_:Object = this._1817957447satFadeIn;
         if(_loc2_ !== param1)
         {
            this._1817957447satFadeIn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"satFadeIn",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:SummonerInfoQuickView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._SummonerInfoQuickView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_summoner_SummonerInfoQuickViewWatcherSetupUtil");
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
      
      private function displayKudosDataForSummoner(param1:Summoner) : void
      {
         var _loc2_:Number = NaN;
         if(param1)
         {
            this.initKudosProfilePanel();
            _loc2_ = Number(param1.sumId);
            if(this.kudosProfilePanel != null)
            {
               this.kudosProfilePanel.requestAndDisplayKudosDataForSummonerID(_loc2_);
            }
         }
      }
      
      public function resetView() : void
      {
         this.removeTimer();
      }
      
      [Bindable(event="propertyChange")]
      public function get session() : Session
      {
         return this._1984987798session;
      }
      
      public function set topRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._868055995topRow;
         if(_loc2_ !== param1)
         {
            this._868055995topRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topRow",_loc2_,param1));
         }
      }
      
      private function _SummonerInfoQuickView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.summonerProfileController.isSummonerStatsLoaded;
         _loc1_ = this.summonerHeaderAsset;
         _loc1_ = this.summonerHeaderTierAsset;
         _loc1_ = this.summonerProfileController.currentSummonerIconSource;
         _loc1_ = this.summonerProfileController.summonerName;
         _loc1_ = [this.blackTextGlow];
         _loc1_ = resourceManager.getString("resources","BuddyListTooltip_summonerLevel",[this.summonerProfileController.levelUpInfo.currentLevel]);
         _loc1_ = this.summonerProfileController.levelUpInfo.currentLevel != 30 ? 340 : 140;
         _loc1_ = [this.blackTextGlow];
         _loc1_ = this.summonerProfileController.levelUpInfo.currentLevel != 30;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_xpBarBg");
         _loc1_ = this.summonerProfileController.levelUpInfo.currentLevel != 30;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_expbar");
         _loc1_ = 184 * (this.summonerProfileController.levelUpInfo.currentLevel == 30 ? 1 : this.summonerProfileController.levelUpInfo.percentCompleteForNextLevel);
         _loc1_ = this.summonerProfileController.levelUpInfo.currentLevel == 30 ? "" : this.summonerProfileController.levelUpInfo.totalExperiencePoints + "/" + this.summonerProfileController.levelUpInfo.totalPointsNeededForNextLevel;
         _loc1_ = [this.blackTextGlow];
         _loc1_ = [this.blackTextGlow];
         _loc1_ = this.summonerProfileController.isLocalSummoner;
         _loc1_ = OVERVIEW_FIRST_WIN_ICON;
         _loc1_ = this.summonerProfileController.isLocalSummoner;
         _loc1_ = [this.blackTextGlow];
         _loc1_ = this.summonerProfileController.isLocalSummoner;
         _loc1_ = OVERVIEW_REROLL_UNAVAILABLE_ICON;
         _loc1_ = this.summonerProfileController.isLocalSummoner;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_XPBoost1");
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_IpPlus");
      }
      
      private function _SummonerInfoQuickView_SaturationFade1_i() : SaturationFade
      {
         var _loc1_:SaturationFade = new SaturationFade();
         this.satFadeOut = _loc1_;
         _loc1_.duration = 1000;
         _loc1_.saturationFrom = 1;
         _loc1_.saturationTo = 0;
         return _loc1_;
      }
      
      private function _SummonerInfoQuickView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Boolean
         {
            return this.summonerProfileController.isSummonerStatsLoaded;
         },function(param1:Boolean):void
         {
            profileSignitureHeader.visible = param1;
         },"profileSignitureHeader.visible");
         result[0] = binding;
         binding = new Binding(this,function():Object
         {
            return summonerHeaderAsset;
         },function(param1:Object):void
         {
            profileHeaderBackground.source = param1;
         },"profileHeaderBackground.source");
         result[1] = binding;
         binding = new Binding(this,function():Object
         {
            return summonerHeaderTierAsset;
         },function(param1:Object):void
         {
            profileHeaderTierRewardBorder.source = param1;
         },"profileHeaderTierRewardBorder.source");
         result[2] = binding;
         binding = new Binding(this,function():Object
         {
            return this.summonerProfileController.currentSummonerIconSource;
         },function(param1:Object):void
         {
            summonerIconImage.iconPath = param1;
         },"summonerIconImage.iconPath");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.summonerProfileController.summonerName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            summonerHeaderNameplate.text = param1;
         },"summonerHeaderNameplate.text");
         result[4] = binding;
         binding = new Binding(this,function():Array
         {
            return [blackTextGlow];
         },function(param1:Array):void
         {
            summonerHeaderNameplate.filters = param1;
         },"summonerHeaderNameplate.filters");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","BuddyListTooltip_summonerLevel",[this.summonerProfileController.levelUpInfo.currentLevel]);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            summonerHeaderLevelDisplay.text = param1;
         },"summonerHeaderLevelDisplay.text");
         result[6] = binding;
         binding = new Binding(this,function():Number
         {
            return this.summonerProfileController.levelUpInfo.currentLevel != 30 ? 340 : 140;
         },function(param1:Number):void
         {
            summonerHeaderLevelDisplay.x = param1;
         },"summonerHeaderLevelDisplay.x");
         result[7] = binding;
         binding = new Binding(this,function():Array
         {
            return [blackTextGlow];
         },function(param1:Array):void
         {
            summonerHeaderLevelDisplay.filters = param1;
         },"summonerHeaderLevelDisplay.filters");
         result[8] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.summonerProfileController.levelUpInfo.currentLevel != 30;
         },function(param1:Boolean):void
         {
            xpBarBackground.visible = param1;
         },"xpBarBackground.visible");
         result[9] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_xpBarBg");
         },function(param1:Object):void
         {
            xpBarBackground.source = param1;
         },"xpBarBackground.source");
         result[10] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.summonerProfileController.levelUpInfo.currentLevel != 30;
         },function(param1:Boolean):void
         {
            xpindicatorBar.visible = param1;
         },"xpindicatorBar.visible");
         result[11] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_expbar");
         },function(param1:Object):void
         {
            xpindicatorBar.source = param1;
         },"xpindicatorBar.source");
         result[12] = binding;
         binding = new Binding(this,function():Number
         {
            return 184 * (this.summonerProfileController.levelUpInfo.currentLevel == 30 ? 1 : this.summonerProfileController.levelUpInfo.percentCompleteForNextLevel);
         },function(param1:Number):void
         {
            xpindicatorBar.width = param1;
         },"xpindicatorBar.width");
         result[13] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.summonerProfileController.levelUpInfo.currentLevel == 30 ? "" : this.summonerProfileController.levelUpInfo.totalExperiencePoints + "/" + this.summonerProfileController.levelUpInfo.totalPointsNeededForNextLevel;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            summonerXPCurrentDisplay.text = param1;
         },"summonerXPCurrentDisplay.text");
         result[14] = binding;
         binding = new Binding(this,function():Array
         {
            return [blackTextGlow];
         },function(param1:Array):void
         {
            summonerXPCurrentDisplay.filters = param1;
         },"summonerXPCurrentDisplay.filters");
         result[15] = binding;
         binding = new Binding(this,function():Array
         {
            return [blackTextGlow];
         },function(param1:Array):void
         {
            firstWinOfTheDayTimeDisplay.filters = param1;
         },"firstWinOfTheDayTimeDisplay.filters");
         result[16] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.summonerProfileController.isLocalSummoner;
         },function(param1:Boolean):void
         {
            firstWinOfTheDayTimeDisplay.visible = param1;
         },"firstWinOfTheDayTimeDisplay.visible");
         result[17] = binding;
         binding = new Binding(this,function():Object
         {
            return OVERVIEW_FIRST_WIN_ICON;
         },function(param1:Object):void
         {
            firstWinIcon.source = param1;
         },"firstWinIcon.source");
         result[18] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.summonerProfileController.isLocalSummoner;
         },function(param1:Boolean):void
         {
            firstWinIcon.visible = param1;
         },"firstWinIcon.visible");
         result[19] = binding;
         binding = new Binding(this,function():Array
         {
            return [blackTextGlow];
         },function(param1:Array):void
         {
            rerollDisplay.filters = param1;
         },"rerollDisplay.filters");
         result[20] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.summonerProfileController.isLocalSummoner;
         },function(param1:Boolean):void
         {
            rerollDisplay.visible = param1;
         },"rerollDisplay.visible");
         result[21] = binding;
         binding = new Binding(this,function():Object
         {
            return OVERVIEW_REROLL_UNAVAILABLE_ICON;
         },function(param1:Object):void
         {
            rerollIcon.source = param1;
         },"rerollIcon.source");
         result[22] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.summonerProfileController.isLocalSummoner;
         },function(param1:Boolean):void
         {
            rerollIcon.visible = param1;
         },"rerollIcon.visible");
         result[23] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_XPBoost1");
         },function(param1:Object):void
         {
            xpImage.source = param1;
         },"xpImage.source");
         result[24] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_IpPlus");
         },function(param1:Object):void
         {
            ipImage.source = param1;
         },"ipImage.source");
         result[25] = binding;
         return result;
      }
      
      public function set rerollIcon(param1:Image) : void
      {
         var _loc2_:Object = this._942527945rerollIcon;
         if(_loc2_ !== param1)
         {
            this._942527945rerollIcon = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rerollIcon",_loc2_,param1));
         }
      }
      
      private function setIpBoostVisibility() : void
      {
         if(Boolean(this.inventory && this.ipImage) && Boolean(this.inventory.activeBoosts) && Boolean(this.summonerProfileController))
         {
            this.ipImage.visible = Boolean(this.inventory) && Boolean(this.inventory.activeBoosts.ipBoostEnabled) && Boolean(this.summonerProfileController.isLocalSummoner);
         }
      }
      
      private function updateFirstWinTimeLabel() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this.firstWinOfTheDayTimeDisplay) && Boolean(this.session))
         {
            _loc1_ = this.session.firstWinOfDayTimeRemaining / 1000;
            if(_loc1_ > 0)
            {
               this.firstWinOfTheDayTimeDisplay.text = RiotResourceLoader.getString("endOfGame_next_first_win","next first win",[DateUtil.secondsToTimeString(_loc1_)]);
            }
            else
            {
               this.firstWinOfTheDayTimeDisplay.text = RiotResourceLoader.getString("summonerProfile_info_firstWinAvailable");
               this.satFadeIn.play([this.firstWinIcon]);
               this.removeTimer();
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get firstWinIcon() : Image
      {
         return this._1269534117firstWinIcon;
      }
      
      [PostConstruct]
      public function onInjection() : void
      {
         this.tierHeaderMap[LeagueTier.NULL.value()] = "";
         this.tierHeaderMap[LeagueTier.PROVISIONAL.value()] = "";
         this.tierHeaderMap["UNRANKED"] = "";
         this.tierHeaderMap[LeagueTier.BRONZE.value()] = "";
         this.tierHeaderMap[LeagueTier.SILVER.value()] = "e_header_season_reward_silver";
         this.tierHeaderMap[LeagueTier.GOLD.value()] = "e_header_season_reward_gold";
         this.tierHeaderMap[LeagueTier.PLATINUM.value()] = "e_header_season_reward_platinum";
         this.tierHeaderMap[LeagueTier.DIAMOND.value()] = "e_header_season_reward_diamond";
         this.tierHeaderMap[LeagueTier.MASTER.value()] = "e_header_season_reward_master";
         this.tierHeaderMap[LeagueTier.CHALLENGER.value()] = "e_header_season_reward_challenger";
         this.onTargetSummonerChanged(null);
         this.removeTimer();
         this.setupTimer();
         this.updateFirstWinTimeLabel();
         this.updateRerollDisplay();
         if(this.firstWinIcon)
         {
            this.satFadeOut.play([this.firstWinIcon]);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerHeaderLevelDisplay() : Label
      {
         return this._1820819015summonerHeaderLevelDisplay;
      }
      
      private function setXpBoostVisibility() : void
      {
         if(Boolean(this.inventory && this.xpImage) && Boolean(this.inventory.activeBoosts) && Boolean(this.summonerProfileController))
         {
            this.xpImage.visible = Boolean(this.inventory) && Boolean(this.inventory.activeBoosts.xpBoostEnabled) && Boolean(this.summonerProfileController.isLocalSummoner);
         }
      }
      
      public function set inventory(param1:IInventory) : void
      {
         var _loc2_:Object = this._2020599460inventory;
         if(_loc2_ !== param1)
         {
            this._2020599460inventory = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inventory",_loc2_,param1));
         }
      }
      
      private function set summonerTier(param1:String) : void
      {
         var _loc2_:Object = this._504563792summonerTier;
         if(_loc2_ !== param1)
         {
            this._504563792summonerTier = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerTier",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerIconImage() : SummonerIcon
      {
         return this._624983732summonerIconImage;
      }
      
      private function _SummonerInfoQuickView_ConstraintRow2_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.bottomRow = _loc1_;
         _loc1_.percentHeight = 50;
         _loc1_.initialized(this,"bottomRow");
         return _loc1_;
      }
      
      private function setupTimer() : void
      {
         if(this.firstWinTimer)
         {
            this.removeTimer();
         }
         this.firstWinTimer = new Timer(1000);
         this.firstWinTimer.addEventListener(TimerEvent.TIMER,this.onFirstWinTimer);
         this.firstWinTimer.start();
      }
      
      public function onInitialize() : void
      {
         if(!this.inventory)
         {
            ProviderLookup.getProvider(IInventoryProvider,this.onInventoryProvider);
            ProviderLookup.getProvider(IRerollProvider,this.onRerollProvider);
         }
         this.initKudosProfilePanel();
      }
      
      [Bindable(event="propertyChange")]
      public function get rerollIcon() : Image
      {
         return this._942527945rerollIcon;
      }
      
      [Bindable(event="propertyChange")]
      public function get bottomRow() : ConstraintRow
      {
         return this._1855392849bottomRow;
      }
      
      public function set summonerHeaderLevelDisplay(param1:Label) : void
      {
         var _loc2_:Object = this._1820819015summonerHeaderLevelDisplay;
         if(_loc2_ !== param1)
         {
            this._1820819015summonerHeaderLevelDisplay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerHeaderLevelDisplay",_loc2_,param1));
         }
      }
      
      public function set profileHeaderBackground(param1:Image) : void
      {
         var _loc2_:Object = this._1554473828profileHeaderBackground;
         if(_loc2_ !== param1)
         {
            this._1554473828profileHeaderBackground = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileHeaderBackground",_loc2_,param1));
         }
      }
      
      public function set satFadeOut(param1:SaturationFade) : void
      {
         var _loc2_:Object = this._522112108satFadeOut;
         if(_loc2_ !== param1)
         {
            this._522112108satFadeOut = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"satFadeOut",_loc2_,param1));
         }
      }
      
      private function onRerollPointsBalanceSuccess(param1:Object = null) : void
      {
         this.updateRerollDisplayText();
         if(!this.summonerProfileController)
         {
            return;
         }
         this.rerollDisplay.visible = this.summonerProfileController.isLocalSummoner;
         this.rerollIcon.visible = this.summonerProfileController.isLocalSummoner;
      }
      
      public function ___SummonerInfoQuickView_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      private function onSummonerIconPropertyChanged(param1:PropertyChangeEvent) : void
      {
         this.updateBannerForIconSelection();
      }
      
      public function set rerollDisplay(param1:Label) : void
      {
         var _loc2_:Object = this._1613087374rerollDisplay;
         if(_loc2_ !== param1)
         {
            this._1613087374rerollDisplay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rerollDisplay",_loc2_,param1));
         }
      }
      
      public function set summonerXPCurrentDisplay(param1:Label) : void
      {
         var _loc2_:Object = this._1893862255summonerXPCurrentDisplay;
         if(_loc2_ !== param1)
         {
            this._1893862255summonerXPCurrentDisplay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerXPCurrentDisplay",_loc2_,param1));
         }
      }
      
      public function set profileHeaderTierRewardBorder(param1:Image) : void
      {
         var _loc2_:Object = this._1662566157profileHeaderTierRewardBorder;
         if(_loc2_ !== param1)
         {
            this._1662566157profileHeaderTierRewardBorder = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileHeaderTierRewardBorder",_loc2_,param1));
         }
      }
      
      public function set ipImage(param1:Image) : void
      {
         var _loc2_:Object = this._1975831668ipImage;
         if(_loc2_ !== param1)
         {
            this._1975831668ipImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ipImage",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set summonerProfileController(param1:SummonerProfileController) : void
      {
         var _loc2_:Object = this.summonerProfileController;
         if(_loc2_ !== param1)
         {
            this._566834807summonerProfileController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerProfileController",_loc2_,param1));
         }
      }
      
      public function __xpImage_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.createXPTooltip(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get profileHeaderTierRewardBorder() : Image
      {
         return this._1662566157profileHeaderTierRewardBorder;
      }
      
      private function set summonerHeaderTierAsset(param1:Object) : void
      {
         var _loc2_:Object = this._417404173summonerHeaderTierAsset;
         if(_loc2_ !== param1)
         {
            this._417404173summonerHeaderTierAsset = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerHeaderTierAsset",_loc2_,param1));
         }
      }
      
      private function updateRerollDisplayText() : void
      {
         this.rerollDisplay.text = RiotResourceLoader.getString("summonerProfile_info_rerollText","RerollText",[this.rerollProvider.getRerollCount().toString(),this.rerollProvider.getMaxRerollCount().toString()]);
         this.rerollDisplay.toolTip = RiotResourceLoader.getString("summonerProfile_info_rerollTooltip","RerollTooltip",[this.rerollProvider.getRerollProgress().toString(),this.rerollProvider.getMaxRerollProgress().toString()]);
         this.rerollIcon.source = this.rerollProvider.getRerollCount() > 0 ? OVERVIEW_REROLL_AVAILABLE_ICON : OVERVIEW_REROLL_UNAVAILABLE_ICON;
      }
      
      public function set blackTextGlow(param1:GlowFilter) : void
      {
         var _loc2_:Object = this._818238841blackTextGlow;
         if(_loc2_ !== param1)
         {
            this._818238841blackTextGlow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"blackTextGlow",_loc2_,param1));
         }
      }
      
      private function onFirstWinTimer(param1:TimerEvent) : void
      {
         this.updateFirstWinTimeLabel();
      }
      
      public function set xpindicatorBar(param1:Image) : void
      {
         var _loc2_:Object = this._1681870212xpindicatorBar;
         if(_loc2_ !== param1)
         {
            this._1681870212xpindicatorBar = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xpindicatorBar",_loc2_,param1));
         }
      }
   }
}

