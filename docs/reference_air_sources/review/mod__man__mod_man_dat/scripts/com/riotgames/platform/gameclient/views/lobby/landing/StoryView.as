package com.riotgames.platform.gameclient.views.lobby.landing
{
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
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
   import mx.controls.HTML;
   import mx.controls.Image;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.effects.Fade;
   import mx.effects.Sequence;
   import mx.effects.SetPropertyAction;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class StoryView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const LOADING_SPINNER:Class = StoryView_LOADING_SPINNER;
      
      private var _1282133823fadeIn:Sequence;
      
      mx_internal var _watchers:Array;
      
      private var _1895424275clientConfig:ClientConfig;
      
      private var _978073224htmlLandingPanel:HTML;
      
      private var _1499252765championsSpinnerBackground:Image;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      [Inject]
      private var _1019249940chatController:ChatController;
      
      private var _1097462182locale:String;
      
      mx_internal var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function StoryView()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Image,
                  "id":"championsSpinnerBackground",
                  "stylesFactory":function():void
                  {
                     this.verticalCenter = "0";
                     this.horizontalCenter = "0";
                  }
               }),new UIComponentDescriptor({
                  "type":HTML,
                  "id":"htmlLandingPanel",
                  "events":{"complete":"__htmlLandingPanel_complete"},
                  "stylesFactory":function():void
                  {
                     this.bottom = "0";
                     this.top = "0";
                     this.left = "0";
                     this.right = "0";
                     this.verticalScrollBarStyleName = "chatScroll";
                     this.horizontalScrollBarStyleName = "chatScroll";
                     this.backgroundAlpha = 1;
                     this.backgroundColor = 0;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"auto",
                        "alpha":0
                     };
                  }
               })]};
            }
         });
         this._1895424275clientConfig = ClientConfig.instance;
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
            this.backgroundAlpha = 1;
            this.backgroundColor = 0;
         };
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.percentWidth = 100;
         this.percentHeight = 100;
         this._StoryView_Sequence1_i();
         this.addEventListener("initialize",this.___StoryView_Canvas1_initialize);
         this.addEventListener("creationComplete",this.___StoryView_Canvas1_creationComplete);
         this.addEventListener("show",this.___StoryView_Canvas1_show);
         this.addEventListener("hide",this.___StoryView_Canvas1_hide);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         StoryView._watcherSetupUtil = param1;
      }
      
      public function set fadeIn(param1:Sequence) : void
      {
         var _loc2_:Object = this._1282133823fadeIn;
         if(_loc2_ !== param1)
         {
            this._1282133823fadeIn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeIn",_loc2_,param1));
         }
      }
      
      public function ___StoryView_Canvas1_show(param1:FlexEvent) : void
      {
         this.onShow();
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:StoryView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._StoryView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_lobby_landing_StoryViewWatcherSetupUtil");
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
      
      private function _StoryView_SetPropertyAction1_c() : SetPropertyAction
      {
         var _loc1_:SetPropertyAction = new SetPropertyAction();
         _loc1_.name = "alpha";
         _loc1_.value = 0;
         return _loc1_;
      }
      
      public function resetView() : void
      {
      }
      
      private function _StoryView_Fade1_c() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 375;
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         _loc1_.startDelay = 0;
         return _loc1_;
      }
      
      public function ___StoryView_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      [Bindable(event="propertyChange")]
      public function get championsSpinnerBackground() : Image
      {
         return this._1499252765championsSpinnerBackground;
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get chatController() : ChatController
      {
         return this._1019249940chatController;
      }
      
      public function set chatController(param1:ChatController) : void
      {
         var _loc2_:Object = this._1019249940chatController;
         if(_loc2_ !== param1)
         {
            this._1019249940chatController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatController",_loc2_,param1));
         }
      }
      
      private function set locale(param1:String) : void
      {
         var _loc2_:Object = this._1097462182locale;
         if(_loc2_ !== param1)
         {
            this._1097462182locale = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"locale",_loc2_,param1));
         }
      }
      
      private function _StoryView_Sequence1_i() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         this.fadeIn = _loc1_;
         _loc1_.children = [this._StoryView_SetPropertyAction1_c(),this._StoryView_Fade1_c()];
         return _loc1_;
      }
      
      private function onCreationComplete() : void
      {
         this.initializeView();
         if(this.htmlLandingPanel)
         {
            this.htmlLandingPanel.htmlLoader.navigateInSystemBrowser = true;
         }
      }
      
      private function onComplete() : void
      {
         if(UserPreferencesManager.globalPrefs.enableAnimations)
         {
            this.fadeIn.play([this.htmlLandingPanel]);
         }
         else
         {
            this.htmlLandingPanel.alpha = 1;
         }
      }
      
      public function set championsSpinnerBackground(param1:Image) : void
      {
         var _loc2_:Object = this._1499252765championsSpinnerBackground;
         if(_loc2_ !== param1)
         {
            this._1499252765championsSpinnerBackground = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championsSpinnerBackground",_loc2_,param1));
         }
      }
      
      private function _StoryView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = LOADING_SPINNER;
         _loc1_ = this.htmlLandingPanel.alpha != 1;
         _loc1_ = this.clientConfig.storyPageURL != null ? this.clientConfig.storyPageURL : resourceManager.getString("resources","storyPageURL",this.clientConfig.locale.substr(0,2) == "en" ? [""] : [this.clientConfig.locale.substr(0,2)]);
         _loc1_ = 1 / this.parentApplication.scaleX;
         _loc1_ = 1 / this.parentApplication.scaleY;
      }
      
      public function __htmlLandingPanel_complete(param1:Event) : void
      {
         this.onComplete();
      }
      
      private function onHide() : void
      {
         this.resetView();
      }
      
      public function ___StoryView_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeIn() : Sequence
      {
         return this._1282133823fadeIn;
      }
      
      public function ___StoryView_Canvas1_hide(param1:FlexEvent) : void
      {
         this.onHide();
      }
      
      private function onInitialize() : void
      {
      }
      
      public function initializeView() : void
      {
      }
      
      [Bindable(event="propertyChange")]
      private function get locale() : String
      {
         return this._1097462182locale;
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
      
      private function _StoryView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return LOADING_SPINNER;
         },function(param1:Object):void
         {
            championsSpinnerBackground.source = param1;
         },"championsSpinnerBackground.source");
         result[0] = binding;
         binding = new Binding(this,function():Boolean
         {
            return htmlLandingPanel.alpha != 1;
         },function(param1:Boolean):void
         {
            championsSpinnerBackground.visible = param1;
         },"championsSpinnerBackground.visible");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = clientConfig.storyPageURL != null ? clientConfig.storyPageURL : resourceManager.getString("resources","storyPageURL",this.clientConfig.locale.substr(0,2) == "en" ? [""] : [this.clientConfig.locale.substr(0,2)]);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            htmlLandingPanel.location = param1;
         },"htmlLandingPanel.location");
         result[2] = binding;
         binding = new Binding(this,function():Number
         {
            return 1 / this.parentApplication.scaleX;
         },function(param1:Number):void
         {
            htmlLandingPanel.scaleX = param1;
         },"htmlLandingPanel.scaleX");
         result[3] = binding;
         binding = new Binding(this,function():Number
         {
            return 1 / this.parentApplication.scaleY;
         },function(param1:Number):void
         {
            htmlLandingPanel.scaleY = param1;
         },"htmlLandingPanel.scaleY");
         result[4] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get clientConfig() : ClientConfig
      {
         return this._1895424275clientConfig;
      }
      
      public function set htmlLandingPanel(param1:HTML) : void
      {
         var _loc2_:Object = this._978073224htmlLandingPanel;
         if(_loc2_ !== param1)
         {
            this._978073224htmlLandingPanel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"htmlLandingPanel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get htmlLandingPanel() : HTML
      {
         return this._978073224htmlLandingPanel;
      }
      
      private function onShow() : void
      {
         this.initializeView();
      }
   }
}

