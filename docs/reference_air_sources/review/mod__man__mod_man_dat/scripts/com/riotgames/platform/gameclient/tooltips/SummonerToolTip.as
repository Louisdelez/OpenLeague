package com.riotgames.platform.gameclient.tooltips
{
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
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
   import mx.containers.VBox;
   import mx.controls.Label;
   import mx.controls.TextArea;
   import mx.core.UIComponentDescriptor;
   import mx.core.Window;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class SummonerToolTip extends Window implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private static var _1057234440DEFAULT_WIDTH:int = 156;
      
      private static var _staticBindingEventDispatcher:EventDispatcher = new EventDispatcher();
      
      mx_internal var _bindingsByDestination:Object;
      
      private var _info:String;
      
      public var _SummonerToolTip_Canvas1:Canvas;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      mx_internal var _watchers:Array;
      
      public var hovered:Boolean;
      
      private var _2073517620statsArea:TextArea;
      
      public var _SummonerToolTip_Label1:Label;
      
      private var _109757599stats:String;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      [Inject]
      public var summonerToolTipManager:SummonerTooltipManager;
      
      mx_internal var _bindings:Array;
      
      public function SummonerToolTip()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Window,
            "propertiesFactory":function():Object
            {
               return {
                  "height":150,
                  "childDescriptors":[new UIComponentDescriptor({
                     "type":Canvas,
                     "id":"_SummonerToolTip_Canvas1",
                     "propertiesFactory":function():Object
                     {
                        return {
                           "cacheAsBitmap":true,
                           "height":57,
                           "styleName":"summonerToolTipContainer",
                           "childDescriptors":[new UIComponentDescriptor({
                              "type":Canvas,
                              "stylesFactory":function():void
                              {
                                 this.backgroundColor = 13421772;
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "cacheAsBitmap":true,
                                    "x":5,
                                    "y":5,
                                    "width":45,
                                    "height":45
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":VBox,
                              "stylesFactory":function():void
                              {
                                 this.verticalGap = -2;
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "x":55,
                                    "y":3,
                                    "width":100,
                                    "height":50,
                                    "verticalScrollPolicy":"off",
                                    "horizontalScrollPolicy":"off",
                                    "childDescriptors":[new UIComponentDescriptor({
                                       "type":Label,
                                       "id":"_SummonerToolTip_Label1",
                                       "propertiesFactory":function():Object
                                       {
                                          return {
                                             "styleName":"summonerToolTipTitle",
                                             "percentWidth":100
                                          };
                                       }
                                    }),new UIComponentDescriptor({
                                       "type":TextArea,
                                       "id":"statsArea",
                                       "propertiesFactory":function():Object
                                       {
                                          return {
                                             "selectable":false,
                                             "styleName":"summonerToolTipText",
                                             "percentWidth":100,
                                             "percentHeight":100
                                          };
                                       }
                                    })]
                                 };
                              }
                           })]
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":SoundEffectButton,
                     "propertiesFactory":function():Object
                     {
                        return {
                           "x":0,
                           "y":59,
                           "width":66,
                           "height":14,
                           "styleName":"summonerToolTipButton",
                           "label":"view profile"
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
            this.borderThickness = 0;
            this.backgroundAlpha = 0;
            this.dropShadowEnabled = true;
            this.dropShadowColor = 0;
         };
         this.layout = "absolute";
         this.height = 150;
         this.showStatusBar = false;
         this.showTitleBar = false;
         this.showGripper = false;
         this.resizable = false;
         this.maximizable = false;
         this.minimizable = false;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.addEventListener("mouseOver",this.___SummonerToolTip_Window1_mouseOver);
         this.addEventListener("mouseOut",this.___SummonerToolTip_Window1_mouseOut);
      }
      
      public static function set DEFAULT_WIDTH(param1:int) : void
      {
         var _loc3_:IEventDispatcher = null;
         var _loc2_:Object = SummonerToolTip._1057234440DEFAULT_WIDTH;
         if(_loc2_ !== param1)
         {
            SummonerToolTip._1057234440DEFAULT_WIDTH = param1;
            _loc3_ = SummonerToolTip.staticEventDispatcher;
            if(_loc3_ != null)
            {
               _loc3_.dispatchEvent(PropertyChangeEvent.createUpdateEvent(SummonerToolTip,"DEFAULT_WIDTH",_loc2_,param1));
            }
         }
      }
      
      public static function get staticEventDispatcher() : IEventDispatcher
      {
         return _staticBindingEventDispatcher;
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         SummonerToolTip._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public static function get DEFAULT_WIDTH() : int
      {
         return SummonerToolTip._1057234440DEFAULT_WIDTH;
      }
      
      [Bindable(event="propertyChange")]
      private function get stats() : String
      {
         return this._109757599stats;
      }
      
      private function set _3237038info(param1:String) : void
      {
         this._info = param1;
         this.formatStats();
      }
      
      private function onInitialize() : void
      {
      }
      
      [Bindable(event="propertyChange")]
      public function set info(param1:String) : void
      {
         var _loc2_:Object = this.info;
         if(_loc2_ !== param1)
         {
            this._3237038info = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"info",_loc2_,param1));
         }
      }
      
      private function _SummonerToolTip_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = DEFAULT_WIDTH;
         _loc1_ = DEFAULT_WIDTH;
         _loc1_ = this.info;
         _loc1_ = this.stats;
      }
      
      [Bindable(event="propertyChange")]
      public function get statsArea() : TextArea
      {
         return this._2073517620statsArea;
      }
      
      public function set statsArea(param1:TextArea) : void
      {
         var _loc2_:Object = this._2073517620statsArea;
         if(_loc2_ !== param1)
         {
            this._2073517620statsArea = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statsArea",_loc2_,param1));
         }
      }
      
      private function onMouseOut() : void
      {
         this.hovered = false;
         this.summonerToolTipManager.removeToolTip();
      }
      
      private function _SummonerToolTip_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Number
         {
            return DEFAULT_WIDTH;
         },function(param1:Number):void
         {
            this.width = param1;
         },"this.width");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return DEFAULT_WIDTH;
         },function(param1:Number):void
         {
            _SummonerToolTip_Canvas1.width = param1;
         },"_SummonerToolTip_Canvas1.width");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = info;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _SummonerToolTip_Label1.text = param1;
         },"_SummonerToolTip_Label1.text");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = stats;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            statsArea.htmlText = param1;
         },"statsArea.htmlText");
         result[3] = binding;
         return result;
      }
      
      public function get info() : String
      {
         return this._info;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:SummonerToolTip = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._SummonerToolTip_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_tooltips_SummonerToolTipWatcherSetupUtil");
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
      
      private function formatStats() : void
      {
         var _loc1_:String = null;
         _loc1_ = resourceManager.getString("resources","playerProfile_levelLabel") + "<br>";
         _loc1_ += resourceManager.getString("resources","playerProfile_tierLabel");
         this.stats = _loc1_;
      }
      
      public function ___SummonerToolTip_Window1_mouseOver(param1:MouseEvent) : void
      {
         this.onMouseOver();
      }
      
      private function onMouseOver() : void
      {
         this.hovered = true;
      }
      
      private function set stats(param1:String) : void
      {
         var _loc2_:Object = this._109757599stats;
         if(_loc2_ !== param1)
         {
            this._109757599stats = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stats",_loc2_,param1));
         }
      }
      
      public function ___SummonerToolTip_Window1_mouseOut(param1:MouseEvent) : void
      {
         this.onMouseOut();
      }
   }
}

