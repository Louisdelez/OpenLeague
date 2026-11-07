package com.riotgames.platform.gameclient.shell.platformshutdown
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.components.PieClockDisplay;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.utils.AnimationHelper;
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
   import mx.controls.HRule;
   import mx.controls.Label;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.managers.PopUpManager;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class PlatformShutdownStatusPane extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public var _PlatformShutdownStatusPane_Text1:Text;
      
      public const STYLE_TITLE:String = "serverPopupTitle";
      
      public const STYLE_HRULE:String = "serverPopupHRule";
      
      public var controller:PlatformShutdownDisplay;
      
      mx_internal var _watchers:Array;
      
      private var _873112108messageText:Text;
      
      public const STYLE_BUTTON:String = "s1FormButton";
      
      public const STYLE_BODY:String = "serverPopupBody";
      
      public var _PlatformShutdownStatusPane_HRule1:HRule;
      
      private var _1823111375dropshadow:DropShadowFilter;
      
      private var _2046375913nextUpdateProgress:Number = 1;
      
      public const STYLE_CANVAS:String = "serverPopupCanvas";
      
      private var _2077607820timeLeft:String;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      mx_internal var _bindingsByDestination:Object;
      
      private var _302434724dismissButton:SoundEffectButton;
      
      private var _1208363484cConatiner:GradientCanvas;
      
      mx_internal var _bindings:Array;
      
      public var _PlatformShutdownStatusPane_PieClockDisplay1:PieClockDisplay;
      
      private var _110371416title:Label;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function PlatformShutdownStatusPane()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {
                  "width":420,
                  "height":200,
                  "childDescriptors":[new UIComponentDescriptor({
                     "type":GradientCanvas,
                     "id":"cConatiner",
                     "propertiesFactory":function():Object
                     {
                        return {
                           "width":420,
                           "height":200,
                           "horizontalScrollPolicy":"off",
                           "verticalScrollPolicy":"off",
                           "childDescriptors":[new UIComponentDescriptor({
                              "type":Label,
                              "id":"title",
                              "stylesFactory":function():void
                              {
                                 this.top = "10";
                                 this.left = "10";
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {"selectable":false};
                              }
                           }),new UIComponentDescriptor({
                              "type":Text,
                              "id":"_PlatformShutdownStatusPane_Text1",
                              "stylesFactory":function():void
                              {
                                 this.top = "12";
                                 this.right = "48";
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "styleName":"loginQueueNextUpdateLabel",
                                    "selectable":false
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":PieClockDisplay,
                              "id":"_PlatformShutdownStatusPane_PieClockDisplay1",
                              "stylesFactory":function():void
                              {
                                 this.right = "10";
                                 this.top = "5";
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "width":30,
                                    "height":30,
                                    "foregroundColor":14474462,
                                    "backgroundColor":2849
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":HRule,
                              "id":"_PlatformShutdownStatusPane_HRule1",
                              "stylesFactory":function():void
                              {
                                 this.top = "42";
                                 this.horizontalCenter = "0";
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "width":400,
                                    "alpha":0.5
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":Text,
                              "id":"messageText",
                              "stylesFactory":function():void
                              {
                                 this.horizontalCenter = "0";
                                 this.top = "60";
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "width":360,
                                    "selectable":false,
                                    "mouseEnabled":false,
                                    "mouseChildren":false
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":SoundEffectButton,
                              "id":"dismissButton",
                              "events":{"click":"__dismissButton_click"},
                              "stylesFactory":function():void
                              {
                                 this.horizontalCenter = "0";
                                 this.bottom = "7";
                              }
                           })]
                        };
                     }
                  })]
               };
            }
         });
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
            this.verticalCenter = "0";
            this.horizontalCenter = "-150";
         };
         this.cacheAsBitmap = true;
         this.verticalScrollPolicy = "off";
         this.horizontalScrollPolicy = "off";
         this.width = 420;
         this.height = 200;
         this._PlatformShutdownStatusPane_DropShadowFilter1_i();
         this.addEventListener("remove",this.___PlatformShutdownStatusPane_Canvas1_remove);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         PlatformShutdownStatusPane._watcherSetupUtil = param1;
      }
      
      public function __dismissButton_click(param1:MouseEvent) : void
      {
         this.onDismissButtonClicked();
      }
      
      private function _PlatformShutdownStatusPane_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return STYLE_CANVAS;
         },function(param1:Object):void
         {
            cConatiner.styleName = param1;
         },"cConatiner.styleName");
         result[0] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_TITLE;
         },function(param1:Object):void
         {
            title.styleName = param1;
         },"title.styleName");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("platform_shutdown_dialog_title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            title.htmlText = param1;
         },"title.htmlText");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("platform_shutdown_dialog_refresh");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _PlatformShutdownStatusPane_Text1.text = param1;
         },"_PlatformShutdownStatusPane_Text1.text");
         result[3] = binding;
         binding = new Binding(this,function():Number
         {
            return nextUpdateProgress;
         },function(param1:Number):void
         {
            _PlatformShutdownStatusPane_PieClockDisplay1.progress = param1;
         },"_PlatformShutdownStatusPane_PieClockDisplay1.progress");
         result[4] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_HRULE;
         },function(param1:Object):void
         {
            _PlatformShutdownStatusPane_HRule1.styleName = param1;
         },"_PlatformShutdownStatusPane_HRule1.styleName");
         result[5] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_BODY;
         },function(param1:Object):void
         {
            messageText.styleName = param1;
         },"messageText.styleName");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = timeLeft;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            messageText.htmlText = param1;
         },"messageText.htmlText");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getString("common_button_ok");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            dismissButton.label = param1;
         },"dismissButton.label");
         result[8] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_BUTTON;
         },function(param1:Object):void
         {
            dismissButton.styleName = param1;
         },"dismissButton.styleName");
         result[9] = binding;
         return result;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:PlatformShutdownStatusPane = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._PlatformShutdownStatusPane_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_shell_platformshutdown_PlatformShutdownStatusPaneWatcherSetupUtil");
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
      
      public function set dropshadow(param1:DropShadowFilter) : void
      {
         var _loc2_:Object = this._1823111375dropshadow;
         if(_loc2_ !== param1)
         {
            this._1823111375dropshadow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dropshadow",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cConatiner() : GradientCanvas
      {
         return this._1208363484cConatiner;
      }
      
      public function ___PlatformShutdownStatusPane_Canvas1_remove(param1:FlexEvent) : void
      {
         AnimationHelper.playFadeOutEffect(this);
      }
      
      private function onDismissButtonClicked() : void
      {
         PopUpManager.removePopUp(this);
      }
      
      private function _PlatformShutdownStatusPane_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.STYLE_CANVAS;
         _loc1_ = this.STYLE_TITLE;
         _loc1_ = RiotResourceLoader.getString("platform_shutdown_dialog_title");
         _loc1_ = RiotResourceLoader.getString("platform_shutdown_dialog_refresh");
         _loc1_ = this.nextUpdateProgress;
         _loc1_ = this.STYLE_HRULE;
         _loc1_ = this.STYLE_BODY;
         _loc1_ = this.timeLeft;
         _loc1_ = RiotResourceLoader.getString("common_button_ok");
         _loc1_ = this.STYLE_BUTTON;
      }
      
      public function set messageText(param1:Text) : void
      {
         var _loc2_:Object = this._873112108messageText;
         if(_loc2_ !== param1)
         {
            this._873112108messageText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"messageText",_loc2_,param1));
         }
      }
      
      public function set dismissButton(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._302434724dismissButton;
         if(_loc2_ !== param1)
         {
            this._302434724dismissButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dismissButton",_loc2_,param1));
         }
      }
      
      public function set cConatiner(param1:GradientCanvas) : void
      {
         var _loc2_:Object = this._1208363484cConatiner;
         if(_loc2_ !== param1)
         {
            this._1208363484cConatiner = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cConatiner",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get dropshadow() : DropShadowFilter
      {
         return this._1823111375dropshadow;
      }
      
      public function set title(param1:Label) : void
      {
         var _loc2_:Object = this._110371416title;
         if(_loc2_ !== param1)
         {
            this._110371416title = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"title",_loc2_,param1));
         }
      }
      
      private function _PlatformShutdownStatusPane_DropShadowFilter1_i() : DropShadowFilter
      {
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         this.dropshadow = _loc1_;
         _loc1_.distance = 3;
         _loc1_.alpha = 0.8;
         _loc1_.quality = 3;
         _loc1_.blurX = 6;
         _loc1_.blurY = 6;
         return _loc1_;
      }
      
      public function set nextUpdateProgress(param1:Number) : void
      {
         var _loc2_:Object = this._2046375913nextUpdateProgress;
         if(_loc2_ !== param1)
         {
            this._2046375913nextUpdateProgress = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nextUpdateProgress",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get messageText() : Text
      {
         return this._873112108messageText;
      }
      
      [Bindable(event="propertyChange")]
      public function get title() : Label
      {
         return this._110371416title;
      }
      
      [Bindable(event="propertyChange")]
      public function get dismissButton() : SoundEffectButton
      {
         return this._302434724dismissButton;
      }
      
      public function set timeLeft(param1:String) : void
      {
         var _loc2_:Object = this._2077607820timeLeft;
         if(_loc2_ !== param1)
         {
            this._2077607820timeLeft = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timeLeft",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get nextUpdateProgress() : Number
      {
         return this._2046375913nextUpdateProgress;
      }
      
      [Bindable(event="propertyChange")]
      public function get timeLeft() : String
      {
         return this._2077607820timeLeft;
      }
   }
}

