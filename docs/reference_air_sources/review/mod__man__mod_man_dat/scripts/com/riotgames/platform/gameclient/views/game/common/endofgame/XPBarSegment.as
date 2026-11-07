package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.pvpnet.game.controllers.EndOfGameStatsController;
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
   import mx.controls.ToolTip;
   import mx.core.Container;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.managers.ToolTipManager;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class XPBarSegment extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private static const AVERAGE_WIDTH:uint = 50;
      
      private var colorDifference:int = 1381653;
      
      mx_internal var _watchers:Array;
      
      private var originalColors:Array = null;
      
      private var myToolTip:ToolTip = null;
      
      private var animationTimer:Timer;
      
      public var toolTipText:String = "";
      
      [Inject]
      private var _1164646953endOfGameStatsController:EndOfGameStatsController;
      
      private var _1332194002background:GradientCanvas;
      
      private var tooltipWidthWatcher:ChangeWatcher = null;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var frameCounter:int = 0;
      
      private var _1241320005_displayXP:int;
      
      private var _1339429080trueWidth:Number = 0;
      
      mx_internal var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var finalWidth:int = 0;
      
      private var timeStamp:Number = 0;
      
      public function XPBarSegment()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":GradientCanvas,
                  "id":"background",
                  "stylesFactory":function():void
                  {
                     this.borderThickness = 0;
                  }
               })]};
            }
         });
         this.animationTimer = new Timer(2,0);
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
            this.borderStyle = "solid";
            this.borderColor = 10592673;
            this.borderThickness = 1;
         };
         this.horizontalScrollPolicy = "off";
         this.addEventListener("rollOver",this.___XPBarSegment_Canvas1_rollOver);
         this.addEventListener("rollOut",this.___XPBarSegment_Canvas1_rollOut);
         this.addEventListener("creationComplete",this.___XPBarSegment_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         XPBarSegment._watcherSetupUtil = param1;
      }
      
      public function ___XPBarSegment_Canvas1_rollOut(param1:MouseEvent) : void
      {
         this.onRollOut();
      }
      
      private function set _displayXP(param1:int) : void
      {
         var _loc2_:Object = this._1241320005_displayXP;
         if(_loc2_ !== param1)
         {
            this._1241320005_displayXP = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_displayXP",_loc2_,param1));
         }
      }
      
      public function ___XPBarSegment_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:XPBarSegment = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._XPBarSegment_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_common_endofgame_XPBarSegmentWatcherSetupUtil");
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
      
      private function destroyTooltip() : void
      {
         if(this.myToolTip)
         {
            ToolTipManager.destroyToolTip(this.myToolTip);
            this.myToolTip = null;
         }
      }
      
      private function onRollOut() : void
      {
         this.destroyTooltip();
      }
      
      [Bindable(event="propertyChange")]
      public function get background() : GradientCanvas
      {
         return this._1332194002background;
      }
      
      private function onCreationComplete() : void
      {
         this.background.setStyle("fillColors",this.getStyle("fillColors"));
         this.background.setStyle("fillAlphas",this.getStyle("fillAlphas"));
      }
      
      [Bindable(event="propertyChange")]
      private function get _displayXP() : int
      {
         return this._1241320005_displayXP;
      }
      
      public function set endOfGameStatsController(param1:EndOfGameStatsController) : void
      {
         var _loc2_:Object = this._1164646953endOfGameStatsController;
         if(_loc2_ !== param1)
         {
            this._1164646953endOfGameStatsController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endOfGameStatsController",_loc2_,param1));
         }
      }
      
      public function ___XPBarSegment_Canvas1_rollOver(param1:MouseEvent) : void
      {
         this.onRollOver(param1);
      }
      
      private function _XPBarSegment_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.width;
         _loc1_ = this.height;
      }
      
      public function get displayXP() : int
      {
         return this._displayXP;
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get endOfGameStatsController() : EndOfGameStatsController
      {
         return this._1164646953endOfGameStatsController;
      }
      
      [Bindable(event="propertyChange")]
      private function get trueWidth() : Number
      {
         return this._1339429080trueWidth;
      }
      
      private function set trueWidth(param1:Number) : void
      {
         var _loc2_:Object = this._1339429080trueWidth;
         if(_loc2_ !== param1)
         {
            this._1339429080trueWidth = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"trueWidth",_loc2_,param1));
         }
      }
      
      public function set background(param1:GradientCanvas) : void
      {
         var _loc2_:Object = this._1332194002background;
         if(_loc2_ !== param1)
         {
            this._1332194002background = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"background",_loc2_,param1));
         }
      }
      
      private function createTooltip() : void
      {
         if(this.myToolTip != null)
         {
            return;
         }
         var _loc1_:Point = new Point(this.x,this.y);
         _loc1_ = Container(this.parent).contentToGlobal(_loc1_);
         this.myToolTip = ToolTipManager.createToolTip(this.toolTipText,_loc1_.x,_loc1_.y,"errorTipAbove") as ToolTip;
         this.myToolTip.setStyle("borderColor","#ff6600");
         this.myToolTip.setStyle("color","white");
         if(this._displayXP < 0)
         {
            this.myToolTip.visible = false;
         }
         var _loc2_:int = int(this.myToolTip.height);
         this.myToolTip.y -= _loc2_;
         this.myToolTip.x = _loc1_.x;
      }
      
      private function _XPBarSegment_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Number
         {
            return this.width;
         },function(param1:Number):void
         {
            background.width = param1;
         },"background.width");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return this.height;
         },function(param1:Number):void
         {
            background.height = param1;
         },"background.height");
         result[1] = binding;
         return result;
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         this.createTooltip();
      }
      
      public function set displayXP(param1:int) : void
      {
         this._displayXP = param1;
      }
      
      private function updateTooltipPos(param1:Number) : void
      {
         var _loc2_:Point = new Point(this.x,this.y);
         _loc2_ = Container(this.parent).contentToGlobal(_loc2_);
         this.myToolTip.x = _loc2_.x + param1 * 0.5 - 15;
      }
   }
}

