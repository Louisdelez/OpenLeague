package com.riotgames.platform.gameclient.controllers.game
{
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
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
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.effects.Fade;
   import mx.effects.Parallel;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class ArrowedAlertView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _1282133823fadeIn:Parallel;
      
      private var _530143077mainTextContainer:Canvas;
      
      private var _1292595405backgroundImage:cs_contextAlert;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array = [];
      
      private var firstUpdate:Boolean = true;
      
      private var _1641788370okButton:SoundEffectButton;
      
      private var _alertParameters:ArrowedAlertParameters = null;
      
      public var arrowedAlertController:ArrowedAlertController;
      
      private var _1624362035mainTextArea:Text;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object = {};
      
      private var _1956980552shadowFilter:DropShadowFilter;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {
               "width":320,
               "height":185,
               "childDescriptors":[new UIComponentDescriptor({
                  "type":cs_contextAlert,
                  "id":"backgroundImage"
               }),new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"mainTextContainer",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":5,
                        "y":5,
                        "width":306,
                        "height":105,
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Text,
                           "id":"mainTextArea",
                           "stylesFactory":function():void
                           {
                              this.textAlign = "left";
                              this.horizontalCenter = "0";
                              this.verticalCenter = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "width":290,
                                 "styleName":"arrowedAlertText",
                                 "selectable":false
                              };
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":SoundEffectButton,
                  "id":"okButton",
                  "events":{"click":"__okButton_click"},
                  "stylesFactory":function():void
                  {
                     this.bottom = "5";
                     this.horizontalCenter = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "styleName":"s1FormButton",
                        "buttonMode":true,
                        "useHandCursor":true
                     };
                  }
               })]
            };
         }
      });
      
      public function ArrowedAlertView()
      {
         super();
         mx_internal::_document = this;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.width = 320;
         this.height = 185;
         this._ArrowedAlertView_Parallel1_i();
         this._ArrowedAlertView_DropShadowFilter1_i();
         this.addEventListener("initialize",this.___ArrowedAlertView_Canvas1_initialize);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ArrowedAlertView._watcherSetupUtil = param1;
      }
      
      public function set fadeIn(param1:Parallel) : void
      {
         var _loc2_:Object = this._1282133823fadeIn;
         if(_loc2_ !== param1)
         {
            this._1282133823fadeIn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeIn",_loc2_,param1));
         }
      }
      
      private function onCloseClicked() : void
      {
         this.arrowedAlertController.okPressed();
      }
      
      private function _ArrowedAlertView_Fade1_c() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         _loc1_.duration = 350;
         return _loc1_;
      }
      
      public function set backgroundImage(param1:cs_contextAlert) : void
      {
         var _loc2_:Object = this._1292595405backgroundImage;
         if(_loc2_ !== param1)
         {
            this._1292595405backgroundImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"backgroundImage",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mainTextContainer() : Canvas
      {
         return this._530143077mainTextContainer;
      }
      
      public function __okButton_click(param1:MouseEvent) : void
      {
         this.onCloseClicked();
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ArrowedAlertView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ArrowedAlertView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_ArrowedAlertViewWatcherSetupUtil");
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
      
      private function _ArrowedAlertView_Parallel1_i() : Parallel
      {
         var _loc1_:Parallel = new Parallel();
         this.fadeIn = _loc1_;
         _loc1_.children = [this._ArrowedAlertView_Fade1_c()];
         BindingManager.executeBindings(this,"fadeIn",this.fadeIn);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get okButton() : SoundEffectButton
      {
         return this._1641788370okButton;
      }
      
      private function _ArrowedAlertView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return this;
         },function(param1:Object):void
         {
            fadeIn.target = param1;
         },"fadeIn.target");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.alertParameters.message;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            mainTextArea.htmlText = param1;
         },"mainTextArea.htmlText");
         result[1] = binding;
         binding = new Binding(this,function():Array
         {
            return [shadowFilter];
         },function(param1:Array):void
         {
            mainTextArea.filters = param1;
         },"mainTextArea.filters");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","summonerFirstLogin_continue");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            okButton.label = param1;
         },"okButton.label");
         result[3] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.alertParameters.button;
         },function(param1:Boolean):void
         {
            okButton.visible = param1;
         },"okButton.visible");
         result[4] = binding;
         return result;
      }
      
      public function set mainTextContainer(param1:Canvas) : void
      {
         var _loc2_:Object = this._530143077mainTextContainer;
         if(_loc2_ !== param1)
         {
            this._530143077mainTextContainer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mainTextContainer",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get shadowFilter() : DropShadowFilter
      {
         return this._1956980552shadowFilter;
      }
      
      [Bindable(event="propertyChange")]
      public function get mainTextArea() : Text
      {
         return this._1624362035mainTextArea;
      }
      
      public function ___ArrowedAlertView_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeIn() : Parallel
      {
         return this._1282133823fadeIn;
      }
      
      override protected function commitProperties() : void
      {
         if(this.alertParameters == null || this.backgroundImage == null)
         {
            return;
         }
         this.backgroundImage.currentState = (this.alertParameters.button ? "modal" : "modeless") + this.alertParameters.style;
         switch(this.alertParameters.style)
         {
            case ArrowedAlertStyle.NO_ARROW:
               if(this.alertParameters.button)
               {
                  this.height = 160;
               }
               break;
            case ArrowedAlertStyle.POINT_LEFT:
               this.width = 340;
               this.okButton.setStyle("bottom",30);
               this.mainTextContainer.x = 30;
               break;
            case ArrowedAlertStyle.POINT_RIGHT:
               this.width = 340;
               this.okButton.setStyle("bottom",30);
               break;
            case ArrowedAlertStyle.POINT_UP:
               this.mainTextContainer.y = 35;
               break;
            case ArrowedAlertStyle.POINT_DOWN:
               this.okButton.setStyle("bottom",30);
         }
         if(!this.alertParameters.button)
         {
            this.mainTextContainer.height += 20;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get backgroundImage() : cs_contextAlert
      {
         return this._1292595405backgroundImage;
      }
      
      private function onInitialize() : void
      {
         this.alpha = 0;
      }
      
      [Bindable(event="propertyChange")]
      public function set alertParameters(param1:ArrowedAlertParameters) : void
      {
         var _loc2_:Object = this.alertParameters;
         if(_loc2_ !== param1)
         {
            this._431217562alertParameters = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"alertParameters",_loc2_,param1));
         }
      }
      
      public function set okButton(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1641788370okButton;
         if(_loc2_ !== param1)
         {
            this._1641788370okButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"okButton",_loc2_,param1));
         }
      }
      
      private function _ArrowedAlertView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this;
         _loc1_ = this.alertParameters.message;
         _loc1_ = [this.shadowFilter];
         _loc1_ = resourceManager.getString("resources","summonerFirstLogin_continue");
         _loc1_ = this.alertParameters.button;
      }
      
      public function get alertParameters() : ArrowedAlertParameters
      {
         return this._alertParameters;
      }
      
      private function _ArrowedAlertView_DropShadowFilter1_i() : DropShadowFilter
      {
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         this.shadowFilter = _loc1_;
         _loc1_.strength = 0.7;
         _loc1_.distance = 2;
         _loc1_.blurX = 3;
         _loc1_.blurY = 3;
         return _loc1_;
      }
      
      public function set shadowFilter(param1:DropShadowFilter) : void
      {
         var _loc2_:Object = this._1956980552shadowFilter;
         if(_loc2_ !== param1)
         {
            this._1956980552shadowFilter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"shadowFilter",_loc2_,param1));
         }
      }
      
      public function set mainTextArea(param1:Text) : void
      {
         var _loc2_:Object = this._1624362035mainTextArea;
         if(_loc2_ !== param1)
         {
            this._1624362035mainTextArea = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mainTextArea",_loc2_,param1));
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         if(this.firstUpdate)
         {
            this.firstUpdate = false;
            if(UserPreferencesManager.userPrefs.enableAnimations)
            {
               callLater(this.fadeIn.play);
            }
            else
            {
               alpha = 1;
            }
         }
      }
      
      private function set _431217562alertParameters(param1:ArrowedAlertParameters) : void
      {
         this._alertParameters = param1;
         invalidateProperties();
      }
   }
}

