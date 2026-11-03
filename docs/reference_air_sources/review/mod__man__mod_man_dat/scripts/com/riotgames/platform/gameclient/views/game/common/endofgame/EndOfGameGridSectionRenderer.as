package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.PlayerStat;
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
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.containers.Canvas;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.core.Repeater;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.formatters.NumberFormatter;
   import mx.styles.*;
   import mx.utils.ObjectUtil;
   
   use namespace mx_internal;
   
   public class EndOfGameGridSectionRenderer extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const END_OF_GAME_CONCRETE_TEXTURE:Class = EndOfGameGridSectionRenderer_END_OF_GAME_CONCRETE_TEXTURE;
      
      public var _EndOfGameGridSectionRenderer_Label2:Array;
      
      private var _13742283localizedHeaderText:String = "";
      
      private var _1104763207statsRepeater:Repeater;
      
      mx_internal var _watchers:Array = [];
      
      private var _1221270899header:Canvas;
      
      private var _698138578LINE_HEIGHT:int = 20;
      
      private var _662484372lineCanvas:Canvas;
      
      private var _1542833219headerColumn:Boolean = false;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      mx_internal var _bindingsByDestination:Object = {};
      
      public var _EndOfGameGridSectionRenderer_Canvas1:Canvas;
      
      private var _1166031975headerLabel:Label;
      
      private var _1811591370formatter:NumberFormatter;
      
      mx_internal var _bindings:Array = [];
      
      private var _1417816805texture:Image;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "id":"_EndOfGameGridSectionRenderer_Canvas1",
         "propertiesFactory":function():Object
         {
            return {
               "height":200,
               "childDescriptors":[new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"header",
                  "stylesFactory":function():void
                  {
                     this.backgroundColor = 16777215;
                     this.backgroundAlpha = 0.05;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"percentWidth":100};
                  }
               }),new UIComponentDescriptor({
                  "type":Image,
                  "id":"texture",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "blendMode":"overlay",
                        "alpha":0.48,
                        "maintainAspectRatio":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"lineCanvas",
                  "events":{"creationComplete":"__lineCanvas_creationComplete"},
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":100,
                        "percentHeight":100
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Label,
                  "id":"headerLabel",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":5,
                        "y":-1,
                        "styleName":"endOfGameGridSectionHeader"
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Repeater,
                  "id":"statsRepeater",
                  "propertiesFactory":function():Object
                  {
                     return {"childDescriptors":[new UIComponentDescriptor({
                        "type":Label,
                        "id":"_EndOfGameGridSectionRenderer_Label2",
                        "stylesFactory":function():void
                        {
                           this.right = "5";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "styleName":"endOfGameGridSectionStatsLabel",
                              "percentWidth":90
                           };
                        }
                     })]};
                  }
               })]
            };
         }
      });
      
      public function EndOfGameGridSectionRenderer()
      {
         super();
         mx_internal::_document = this;
         this.height = 200;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.clipContent = false;
         this._EndOfGameGridSectionRenderer_NumberFormatter1_i();
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         EndOfGameGridSectionRenderer._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get header() : Canvas
      {
         return this._1221270899header;
      }
      
      private function drawHeaderLines() : void
      {
         var _loc1_:Graphics = this.lineCanvas.graphics;
         _loc1_.lineStyle(1,16777215,0.2);
         _loc1_.moveTo(0,0);
         _loc1_.lineTo(this.width,0);
         _loc1_.moveTo(0,this.LINE_HEIGHT - 1);
         _loc1_.lineTo(this.width,this.LINE_HEIGHT - 1);
      }
      
      public function set formatter(param1:NumberFormatter) : void
      {
         var _loc2_:Object = this._1811591370formatter;
         if(_loc2_ !== param1)
         {
            this._1811591370formatter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"formatter",_loc2_,param1));
         }
      }
      
      public function set statsRepeater(param1:Repeater) : void
      {
         var _loc2_:Object = this._1104763207statsRepeater;
         if(_loc2_ !== param1)
         {
            this._1104763207statsRepeater = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statsRepeater",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:EndOfGameGridSectionRenderer = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._EndOfGameGridSectionRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameGridSectionRendererWatcherSetupUtil");
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
      
      public function set header(param1:Canvas) : void
      {
         var _loc2_:Object = this._1221270899header;
         if(_loc2_ !== param1)
         {
            this._1221270899header = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"header",_loc2_,param1));
         }
      }
      
      public function set headerColumn(param1:Boolean) : void
      {
         var _loc2_:Object = this._1542833219headerColumn;
         if(_loc2_ !== param1)
         {
            this._1542833219headerColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerColumn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get texture() : Image
      {
         return this._1417816805texture;
      }
      
      private function set LINE_HEIGHT(param1:int) : void
      {
         var _loc2_:Object = this._698138578LINE_HEIGHT;
         if(_loc2_ !== param1)
         {
            this._698138578LINE_HEIGHT = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"LINE_HEIGHT",_loc2_,param1));
         }
      }
      
      private function _EndOfGameGridSectionRenderer_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Number
         {
            return LINE_HEIGHT;
         },function(param1:Number):void
         {
            header.height = param1;
         },"header.height");
         result[0] = binding;
         binding = new Binding(this,function():Boolean
         {
            return data != null;
         },function(param1:Boolean):void
         {
            header.visible = param1;
         },"header.visible");
         result[1] = binding;
         binding = new Binding(this,function():Object
         {
            return END_OF_GAME_CONCRETE_TEXTURE;
         },function(param1:Object):void
         {
            texture.source = param1;
         },"texture.source");
         result[2] = binding;
         binding = new Binding(this,function():Number
         {
            return this.width - 2;
         },function(param1:Number):void
         {
            texture.width = param1;
         },"texture.width");
         result[3] = binding;
         binding = new Binding(this,function():Number
         {
            return this.height + 2;
         },function(param1:Number):void
         {
            texture.height = param1;
         },"texture.height");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = headerColumn ? localizedHeaderText : "";
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            headerLabel.text = param1;
         },"headerLabel.text");
         result[5] = binding;
         binding = new Binding(this,function():Object
         {
            return this.data;
         },function(param1:Object):void
         {
            statsRepeater.dataProvider = param1;
         },"statsRepeater.dataProvider");
         result[6] = binding;
         binding = new RepeatableBinding(this,function(param1:Array, param2:Array):String
         {
            var _loc3_:* = this.headerColumn ? 10 : 5;
            return _loc3_ == undefined ? null : String(_loc3_);
         },function(param1:String, param2:Array):void
         {
            _EndOfGameGridSectionRenderer_Label2[param2[0]].setStyle("left",param1);
         },"_EndOfGameGridSectionRenderer_Label2.left");
         result[7] = binding;
         binding = new RepeatableBinding(this,function(param1:Array, param2:Array):Number
         {
            return header.height + 1 + param2[0] * LINE_HEIGHT;
         },function(param1:Number, param2:Array):void
         {
            _EndOfGameGridSectionRenderer_Label2[param2[0]].y = param1;
         },"_EndOfGameGridSectionRenderer_Label2.y");
         result[8] = binding;
         binding = new RepeatableBinding(this,function(param1:Array, param2:Array):String
         {
            var _loc3_:* = headerColumn ? "left" : "right";
            return _loc3_ == undefined ? null : String(_loc3_);
         },function(param1:String, param2:Array):void
         {
            _EndOfGameGridSectionRenderer_Label2[param2[0]].setStyle("textAlign",param1);
         },"_EndOfGameGridSectionRenderer_Label2.textAlign");
         result[9] = binding;
         binding = new RepeatableBinding(this,function(param1:Array, param2:Array):Number
         {
            return LINE_HEIGHT;
         },function(param1:Number, param2:Array):void
         {
            _EndOfGameGridSectionRenderer_Label2[param2[0]].height = param1;
         },"_EndOfGameGridSectionRenderer_Label2.height");
         result[10] = binding;
         binding = new RepeatableBinding(this,function(param1:Array, param2:Array):String
         {
            var _loc3_:* = headerColumn ? statsRepeater.mx_internal::getItemAt(param2[0]).displayName : formatter.format(statsRepeater.mx_internal::getItemAt(param2[0]).value);
            return _loc3_ == undefined ? null : String(_loc3_);
         },function(param1:String, param2:Array):void
         {
            _EndOfGameGridSectionRenderer_Label2[param2[0]].text = param1;
         },"_EndOfGameGridSectionRenderer_Label2.text");
         result[11] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      private function get localizedHeaderText() : String
      {
         return this._13742283localizedHeaderText;
      }
      
      public function set texture(param1:Image) : void
      {
         var _loc2_:Object = this._1417816805texture;
         if(_loc2_ !== param1)
         {
            this._1417816805texture = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"texture",_loc2_,param1));
         }
      }
      
      private function _EndOfGameGridSectionRenderer_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.LINE_HEIGHT;
         _loc1_ = data != null;
         _loc1_ = END_OF_GAME_CONCRETE_TEXTURE;
         _loc1_ = this.width - 2;
         _loc1_ = this.height + 2;
         _loc1_ = this.headerColumn ? this.localizedHeaderText : "";
         _loc1_ = this.data;
         _loc1_ = this.headerColumn ? 10 : 5;
         _loc1_ = this.header.height + 1 + this.statsRepeater.currentIndex * this.LINE_HEIGHT;
         _loc1_ = this.headerColumn ? "left" : "right";
         _loc1_ = this.LINE_HEIGHT;
         _loc1_ = this.headerColumn ? this.statsRepeater.currentItem.displayName : this.formatter.format(this.statsRepeater.currentItem.value);
      }
      
      private function drawVerticalSeperatorLine() : void
      {
         var _loc1_:Graphics = this.lineCanvas.graphics;
         _loc1_.lineStyle(1,16777215,0.2);
         _loc1_.moveTo(this.width - 1,0);
         _loc1_.lineTo(this.width - 1,this.height);
      }
      
      [Bindable(event="propertyChange")]
      public function get headerColumn() : Boolean
      {
         return this._1542833219headerColumn;
      }
      
      [Bindable(event="propertyChange")]
      public function get statsRepeater() : Repeater
      {
         return this._1104763207statsRepeater;
      }
      
      public function __lineCanvas_creationComplete(param1:FlexEvent) : void
      {
         this.drawGridLines();
      }
      
      public function set headerLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1166031975headerLabel;
         if(_loc2_ !== param1)
         {
            this._1166031975headerLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerLabel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get LINE_HEIGHT() : int
      {
         return this._698138578LINE_HEIGHT;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:ArrayCollection = param1 as ArrayCollection;
         if(_loc2_ == null || _loc2_.length < 1)
         {
            return;
         }
         this.localizedHeaderText = RiotResourceLoader.getStatResourceString(_loc2_[0].statCategory.name,"**" + _loc2_[0].statCategory.name);
         this.height = (_loc2_.length + 1) * this.LINE_HEIGHT + 3;
         var _loc3_:Sort = new Sort();
         _loc3_.compareFunction = this.statCompareFunction;
         _loc2_.sort = _loc3_;
         _loc2_.refresh();
         super.data = _loc2_;
      }
      
      public function set lineCanvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._662484372lineCanvas;
         if(_loc2_ !== param1)
         {
            this._662484372lineCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lineCanvas",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get formatter() : NumberFormatter
      {
         return this._1811591370formatter;
      }
      
      [Bindable(event="propertyChange")]
      public function get headerLabel() : Label
      {
         return this._1166031975headerLabel;
      }
      
      private function statCompareFunction(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc4_:PlayerStat = param1 as PlayerStat;
         var _loc5_:PlayerStat = param2 as PlayerStat;
         if(!_loc4_)
         {
            return -1;
         }
         if(!_loc5_)
         {
            return 1;
         }
         if(!_loc4_ && !_loc5_)
         {
            return 0;
         }
         return ObjectUtil.numericCompare(_loc4_.priority,_loc5_.priority);
      }
      
      private function set localizedHeaderText(param1:String) : void
      {
         var _loc2_:Object = this._13742283localizedHeaderText;
         if(_loc2_ !== param1)
         {
            this._13742283localizedHeaderText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"localizedHeaderText",_loc2_,param1));
         }
      }
      
      private function drawGridLines() : void
      {
         if(this.data != null)
         {
            this.drawHeaderLines();
         }
         this.drawVerticalSeperatorLine();
      }
      
      [Bindable(event="propertyChange")]
      public function get lineCanvas() : Canvas
      {
         return this._662484372lineCanvas;
      }
      
      private function _EndOfGameGridSectionRenderer_NumberFormatter1_i() : NumberFormatter
      {
         var _loc1_:NumberFormatter = new NumberFormatter();
         this.formatter = _loc1_;
         _loc1_.rounding = "none";
         _loc1_.useThousandsSeparator = true;
         return _loc1_;
      }
   }
}

