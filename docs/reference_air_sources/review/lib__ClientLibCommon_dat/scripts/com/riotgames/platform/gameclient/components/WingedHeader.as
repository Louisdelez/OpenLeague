package com.riotgames.platform.gameclient.components
{
   import com.riotgames.platform.common.ImagePackLookup;
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
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.events.StateChangeEvent;
   import mx.states.State;
   import mx.styles.*;
   
   public class WingedHeader extends Canvas implements IBindingClient
   {
      
      public static var blueHeader:Class;
      
      public static var purpleSmoke:Class;
      
      public static var yellowSmoke:Class;
      
      public static var yellowHeader:Class;
      
      public static var purpleHeader:Class;
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static var orangeHeader:Class;
      
      public static var blueSmoke:Class;
      
      public static var orangeSmoke:Class;
      
      public static const YELLOW:String = "yellow";
      
      public static const BLUE:String = "blue";
      
      public static const PURPLE:String = "purple";
      
      public static const ORANGE:String = "orange";
      
      public static const NONE:String = "none";
      
      private static const wingImgWidth:Number = 53;
      
      private static const smokeImgWidth:Number = 246;
      
      public var firstLetterFontSize:Number;
      
      private var _showWing:Boolean;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array = [];
      
      private var _1113097841wing_img:Image;
      
      public var _WingedHeader_State1:State;
      
      public var _WingedHeader_State2:State;
      
      private var _2117844749smoke_img:Image;
      
      public var _WingedHeader_State5:State;
      
      public var _WingedHeader_State3:State;
      
      public var _WingedHeader_State4:State;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object = {};
      
      private var _1961449401remainingLettersFontSize:Number = 15;
      
      private var _1684457576remainingLetters_txt:Text;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {
               "height":59,
               "childDescriptors":[new UIComponentDescriptor({
                  "type":Image,
                  "id":"wing_img",
                  "propertiesFactory":function():Object
                  {
                     return {"y":5};
                  }
               }),new UIComponentDescriptor({
                  "type":Image,
                  "id":"smoke_img",
                  "propertiesFactory":function():Object
                  {
                     return {"y":0};
                  }
               }),new UIComponentDescriptor({
                  "type":Text,
                  "id":"remainingLetters_txt",
                  "stylesFactory":function():void
                  {
                     this.verticalCenter = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"selectable":false};
                  }
               })]
            };
         }
      });
      
      private var _headerText:String;
      
      public function WingedHeader()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.height = 59;
         this.states = [this._WingedHeader_State1_i(),this._WingedHeader_State2_i(),this._WingedHeader_State3_i(),this._WingedHeader_State4_i(),this._WingedHeader_State5_i()];
         this.addEventListener("currentStateChanging",this.___WingedHeader_Canvas1_currentStateChanging);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         WingedHeader._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get wing_img() : Image
      {
         return this._1113097841wing_img;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:WingedHeader = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._WingedHeader_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_components_WingedHeaderWatcherSetupUtil");
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
      
      public function set remainingLettersFontSize(param1:Number) : void
      {
         var _loc2_:Object = this._1961449401remainingLettersFontSize;
         if(_loc2_ !== param1)
         {
            this._1961449401remainingLettersFontSize = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"remainingLettersFontSize",_loc2_,param1));
         }
      }
      
      private function _WingedHeader_State2_i() : State
      {
         var _loc1_:State = new State();
         this._WingedHeader_State2 = _loc1_;
         BindingManager.executeBindings(this,"_WingedHeader_State2",this._WingedHeader_State2);
         return _loc1_;
      }
      
      private function _WingedHeader_State4_i() : State
      {
         var _loc1_:State = new State();
         this._WingedHeader_State4 = _loc1_;
         BindingManager.executeBindings(this,"_WingedHeader_State4",this._WingedHeader_State4);
         return _loc1_;
      }
      
      public function set wing_img(param1:Image) : void
      {
         var _loc2_:Object = this._1113097841wing_img;
         if(_loc2_ !== param1)
         {
            this._1113097841wing_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"wing_img",_loc2_,param1));
         }
      }
      
      private function _WingedHeader_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = WingedHeader.YELLOW;
         _loc1_ = WingedHeader.BLUE;
         _loc1_ = WingedHeader.PURPLE;
         _loc1_ = WingedHeader.ORANGE;
         _loc1_ = WingedHeader.NONE;
         _loc1_ = this.remainingLettersFontSize;
      }
      
      private function onCurrentStateChanging(param1:StateChangeEvent) : void
      {
         if(yellowHeader == null)
         {
            yellowHeader = ImagePackLookup.instance.getClassFromSwfRef("e_wingedHeaderYellow");
            yellowSmoke = ImagePackLookup.instance.getClassFromSwfRef("e_headerBackgroundYellowSmoke");
            blueHeader = ImagePackLookup.instance.getClassFromSwfRef("e_wingedHeaderBlue");
            blueSmoke = ImagePackLookup.instance.getClassFromSwfRef("e_headerBackgroundBlueSmoke");
            purpleHeader = ImagePackLookup.instance.getClassFromSwfRef("e_wingedHeaderPurple");
            purpleSmoke = ImagePackLookup.instance.getClassFromSwfRef("e_headerBackgroundPurpleSmoke");
            orangeHeader = ImagePackLookup.instance.getClassFromSwfRef("e_wingedHeaderOrange");
            orangeSmoke = ImagePackLookup.instance.getClassFromSwfRef("e_headerBackgroundOrangeSmoke");
         }
         switch(param1.newState)
         {
            case WingedHeader.YELLOW:
               this.wing_img.source = yellowHeader;
               this.smoke_img.source = yellowSmoke;
               break;
            case WingedHeader.BLUE:
               this.wing_img.source = blueHeader;
               this.smoke_img.source = blueSmoke;
               break;
            case WingedHeader.PURPLE:
               this.wing_img.source = purpleHeader;
               this.smoke_img.source = purpleSmoke;
               break;
            case WingedHeader.ORANGE:
               this.wing_img.source = orangeHeader;
               this.smoke_img.source = orangeSmoke;
               break;
            case WingedHeader.NONE:
               this.wing_img.source = null;
               this.smoke_img.source = null;
         }
      }
      
      private function _WingedHeader_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = WingedHeader.YELLOW;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _WingedHeader_State1.name = param1;
         },"_WingedHeader_State1.name");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = WingedHeader.BLUE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _WingedHeader_State2.name = param1;
         },"_WingedHeader_State2.name");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = WingedHeader.PURPLE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _WingedHeader_State3.name = param1;
         },"_WingedHeader_State3.name");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = WingedHeader.ORANGE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _WingedHeader_State4.name = param1;
         },"_WingedHeader_State4.name");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = WingedHeader.NONE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _WingedHeader_State5.name = param1;
         },"_WingedHeader_State5.name");
         result[4] = binding;
         binding = new Binding(this,function():Number
         {
            return this.remainingLettersFontSize;
         },function(param1:Number):void
         {
            remainingLetters_txt.setStyle("fontSize",param1);
         },"remainingLetters_txt.fontSize");
         result[5] = binding;
         return result;
      }
      
      public function get showWing() : Boolean
      {
         return this._showWing;
      }
      
      public function set headerText(param1:String) : void
      {
         this._headerText = param1;
         invalidateProperties();
      }
      
      [Bindable(event="propertyChange")]
      public function get remainingLettersFontSize() : Number
      {
         return this._1961449401remainingLettersFontSize;
      }
      
      public function set showWing(param1:Boolean) : void
      {
         this._showWing = param1;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         this.smoke_img.x = this.showWing ? wingImgWidth - 15 : 0;
         this.wing_img.visible = this.showWing;
         this.remainingLetters_txt.htmlText = this.headerText;
         this.remainingLetters_txt.x = this.smoke_img.x + 10;
      }
      
      private function _WingedHeader_State3_i() : State
      {
         var _loc1_:State = new State();
         this._WingedHeader_State3 = _loc1_;
         BindingManager.executeBindings(this,"_WingedHeader_State3",this._WingedHeader_State3);
         return _loc1_;
      }
      
      private function _WingedHeader_State5_i() : State
      {
         var _loc1_:State = new State();
         this._WingedHeader_State5 = _loc1_;
         BindingManager.executeBindings(this,"_WingedHeader_State5",this._WingedHeader_State5);
         return _loc1_;
      }
      
      public function ___WingedHeader_Canvas1_currentStateChanging(param1:StateChangeEvent) : void
      {
         this.onCurrentStateChanging(param1);
      }
      
      public function set remainingLetters_txt(param1:Text) : void
      {
         var _loc2_:Object = this._1684457576remainingLetters_txt;
         if(_loc2_ !== param1)
         {
            this._1684457576remainingLetters_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"remainingLetters_txt",_loc2_,param1));
         }
      }
      
      private function _WingedHeader_State1_i() : State
      {
         var _loc1_:State = new State();
         this._WingedHeader_State1 = _loc1_;
         BindingManager.executeBindings(this,"_WingedHeader_State1",this._WingedHeader_State1);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get remainingLetters_txt() : Text
      {
         return this._1684457576remainingLetters_txt;
      }
      
      public function get headerText() : String
      {
         return this._headerText;
      }
      
      [Bindable(event="propertyChange")]
      public function get smoke_img() : Image
      {
         return this._2117844749smoke_img;
      }
      
      public function set smoke_img(param1:Image) : void
      {
         var _loc2_:Object = this._2117844749smoke_img;
         if(_loc2_ !== param1)
         {
            this._2117844749smoke_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"smoke_img",_loc2_,param1));
         }
      }
   }
}

