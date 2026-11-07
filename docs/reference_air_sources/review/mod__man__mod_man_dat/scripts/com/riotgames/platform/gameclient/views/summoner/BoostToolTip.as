package com.riotgames.platform.gameclient.views.summoner
{
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
   import mx.controls.Spacer;
   import mx.controls.Text;
   import mx.core.IToolTip;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.formatters.DateFormatter;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class BoostToolTip extends Canvas implements IBindingClient, IToolTip
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _1664710829winsLeftValue:Text;
      
      public var _text:String;
      
      private var _16287751displayEndDate:String = "";
      
      mx_internal var _watchers:Array;
      
      private var _1896335571boostPerWinCount:String = "";
      
      private var _2012629696bootInfo:VBox;
      
      private var _2135756891titleText:String = "";
      
      private var _1673956138winsLeftLabel:Text;
      
      private var dateFormatter:DateFormatter;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public var _BoostToolTip_Label1:Label;
      
      private var _540573984timeLeftLabel:Text;
      
      mx_internal var _bindings:Array;
      
      private var _531328675timeLeftValue:Text;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function BoostToolTip()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {
                  "width":225,
                  "childDescriptors":[new UIComponentDescriptor({
                     "type":VBox,
                     "id":"bootInfo",
                     "stylesFactory":function():void
                     {
                        this.paddingLeft = 5;
                        this.paddingTop = 5;
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "x":0,
                           "y":0,
                           "verticalScrollPolicy":"off",
                           "horizontalScrollPolicy":"off",
                           "childDescriptors":[new UIComponentDescriptor({
                              "type":Label,
                              "id":"_BoostToolTip_Label1",
                              "stylesFactory":function():void
                              {
                                 this.fontSize = 17;
                                 this.textAlign = "left";
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "percentWidth":100,
                                    "styleName":"optionsText"
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":Text,
                              "id":"winsLeftLabel",
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "percentWidth":100,
                                    "height":18,
                                    "styleName":"boostToolTipLabelText"
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":Text,
                              "id":"winsLeftValue",
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "percentWidth":100,
                                    "styleName":"boostToolTipValueText"
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":Text,
                              "id":"timeLeftLabel",
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "percentWidth":100,
                                    "height":18,
                                    "styleName":"boostToolTipLabelText"
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":Text,
                              "id":"timeLeftValue",
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "percentWidth":100,
                                    "styleName":"boostToolTipValueText"
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":Spacer,
                              "propertiesFactory":function():Object
                              {
                                 return {"height":10};
                              }
                           })]
                        };
                     }
                  })]
               };
            }
         });
         this.dateFormatter = new DateFormatter();
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
            this.dropShadowEnabled = true;
            this.shadowDistance = 10;
            this.shadowDirection = "right";
            this.backgroundAlpha = 0.95;
            this.backgroundColor = 0;
            this.cornerRadius = 5;
         };
         this.cacheAsBitmap = true;
         this.styleName = "stoneTablet";
         this.width = 225;
         this.verticalScrollPolicy = "off";
         this.horizontalScrollPolicy = "off";
         this.addEventListener("initialize",this.___BoostToolTip_Canvas1_initialize);
         this.addEventListener("creationComplete",this.___BoostToolTip_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         BoostToolTip._watcherSetupUtil = param1;
      }
      
      public function set bootInfo(param1:VBox) : void
      {
         var _loc2_:Object = this._2012629696bootInfo;
         if(_loc2_ !== param1)
         {
            this._2012629696bootInfo = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bootInfo",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get displayEndDate() : String
      {
         return this._16287751displayEndDate;
      }
      
      private function set displayEndDate(param1:String) : void
      {
         var _loc2_:Object = this._16287751displayEndDate;
         if(_loc2_ !== param1)
         {
            this._16287751displayEndDate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayEndDate",_loc2_,param1));
         }
      }
      
      private function _BoostToolTip_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Number
         {
            return this.width;
         },function(param1:Number):void
         {
            bootInfo.width = param1;
         },"bootInfo.width");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.titleText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _BoostToolTip_Label1.text = param1;
         },"_BoostToolTip_Label1.text");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","summonerProfile_info_perWiBoostsSubTitle_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            winsLeftLabel.text = param1;
         },"winsLeftLabel.text");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = boostPerWinCount;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            winsLeftValue.text = param1;
         },"winsLeftValue.text");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","summonerProfile_info_timeeBasedBoostsSubTitle_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            timeLeftLabel.text = param1;
         },"timeLeftLabel.text");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.displayEndDate;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            timeLeftValue.text = param1;
         },"timeLeftValue.text");
         result[5] = binding;
         return result;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:BoostToolTip = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._BoostToolTip_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_summoner_BoostToolTipWatcherSetupUtil");
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
      
      private function _BoostToolTip_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.width;
         _loc1_ = this.titleText;
         _loc1_ = resourceManager.getString("resources","summonerProfile_info_perWiBoostsSubTitle_tooltip");
         _loc1_ = this.boostPerWinCount;
         _loc1_ = resourceManager.getString("resources","summonerProfile_info_timeeBasedBoostsSubTitle_tooltip");
         _loc1_ = this.displayEndDate;
      }
      
      [Bindable(event="propertyChange")]
      private function get titleText() : String
      {
         return this._2135756891titleText;
      }
      
      public function set winsLeftValue(param1:Text) : void
      {
         var _loc2_:Object = this._1664710829winsLeftValue;
         if(_loc2_ !== param1)
         {
            this._1664710829winsLeftValue = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"winsLeftValue",_loc2_,param1));
         }
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function ___BoostToolTip_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      private function onCreationComplete() : void
      {
      }
      
      [Bindable(event="propertyChange")]
      public function get bootInfo() : VBox
      {
         return this._2012629696bootInfo;
      }
      
      public function set winsLeftLabel(param1:Text) : void
      {
         var _loc2_:Object = this._1673956138winsLeftLabel;
         if(_loc2_ !== param1)
         {
            this._1673956138winsLeftLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"winsLeftLabel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get boostPerWinCount() : String
      {
         return this._1896335571boostPerWinCount;
      }
      
      public function set timeLeftLabel(param1:Text) : void
      {
         var _loc2_:Object = this._540573984timeLeftLabel;
         if(_loc2_ !== param1)
         {
            this._540573984timeLeftLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timeLeftLabel",_loc2_,param1));
         }
      }
      
      public function set timeLeftValue(param1:Text) : void
      {
         var _loc2_:Object = this._531328675timeLeftValue;
         if(_loc2_ !== param1)
         {
            this._531328675timeLeftValue = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timeLeftValue",_loc2_,param1));
         }
      }
      
      private function onInitialize() : void
      {
      }
      
      private function set titleText(param1:String) : void
      {
         var _loc2_:Object = this._2135756891titleText;
         if(_loc2_ !== param1)
         {
            this._2135756891titleText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"titleText",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get winsLeftValue() : Text
      {
         return this._1664710829winsLeftValue;
      }
      
      [Bindable(event="propertyChange")]
      public function get winsLeftLabel() : Text
      {
         return this._1673956138winsLeftLabel;
      }
      
      public function ___BoostToolTip_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      [Bindable(event="propertyChange")]
      public function get timeLeftLabel() : Text
      {
         return this._540573984timeLeftLabel;
      }
      
      [Bindable(event="propertyChange")]
      public function get timeLeftValue() : Text
      {
         return this._531328675timeLeftValue;
      }
      
      public function set text(param1:String) : void
      {
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         if(data)
         {
            this.titleText = param1.titleText;
            this.displayEndDate = param1.displayEndDate;
            this.boostPerWinCount = param1.boostsPerWinCount;
         }
      }
      
      private function set boostPerWinCount(param1:String) : void
      {
         var _loc2_:Object = this._1896335571boostPerWinCount;
         if(_loc2_ !== param1)
         {
            this._1896335571boostPerWinCount = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"boostPerWinCount",_loc2_,param1));
         }
      }
   }
}

