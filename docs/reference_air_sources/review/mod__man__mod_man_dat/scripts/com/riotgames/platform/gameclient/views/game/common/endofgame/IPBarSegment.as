package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
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
   import mx.binding.utils.BindingUtils;
   import mx.binding.utils.ChangeWatcher;
   import mx.containers.Canvas;
   import mx.controls.Label;
   import mx.controls.ToolTip;
   import mx.core.Container;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.managers.ToolTipManager;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class IPBarSegment extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private static const AVERAGE_WIDTH:uint = 50;
      
      private var colorDifference:int = 1381653;
      
      private var _1978245645ipLabel:Label;
      
      private var _1525210725_ipGain:int = 0;
      
      mx_internal var _watchers:Array = [];
      
      private var _1986068061ipTotal:int;
      
      private var animationTimer:Timer = new Timer(2,0);
      
      private var myToolTip:ToolTip = null;
      
      private var originalColors:Array = null;
      
      private var _1182849791ipType:String;
      
      private var _1332194002background:GradientCanvas;
      
      private var tooltipWidthWatcher:ChangeWatcher = null;
      
      private var _657607808currentIp:int = 0;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var frameCounter:int = 0;
      
      private var _713110302totalWidth:Number;
      
      private var _1339429080trueWidth:Number = 0;
      
      mx_internal var _bindings:Array = [];
      
      private var finalWidth:int = 0;
      
      private var timeStamp:Number = 0;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":GradientCanvas,
               "id":"background"
            }),new UIComponentDescriptor({
               "type":Label,
               "id":"ipLabel",
               "stylesFactory":function():void
               {
                  this.horizontalCenter = "0";
                  this.textAlign = "center";
                  this.verticalCenter = "0";
                  this.fontFamily = "ApplicationFont1";
                  this.color = 15658734;
                  this.fontSize = 14;
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "percentWidth":100,
                     "percentHeight":89
                  };
               }
            })]};
         }
      });
      
      public function IPBarSegment()
      {
         super();
         mx_internal::_document = this;
         this.addEventListener("rollOver",this.___IPBarSegment_Canvas1_rollOver);
         this.addEventListener("rollOut",this.___IPBarSegment_Canvas1_rollOut);
         this.addEventListener("creationComplete",this.___IPBarSegment_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         IPBarSegment._watcherSetupUtil = param1;
      }
      
      public function set ipType(param1:String) : void
      {
         var _loc2_:Object = this._1182849791ipType;
         if(_loc2_ !== param1)
         {
            this._1182849791ipType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ipType",_loc2_,param1));
         }
      }
      
      public function set ipGain(param1:int) : void
      {
         this._ipGain = param1;
         if(this.ipTotal < param1)
         {
            this.ipTotal = param1;
         }
         if(param1)
         {
            this.finalWidth = param1 / this.ipTotal * this.totalWidth;
            this.trueWidth = this.finalWidth;
            this.width = this.trueWidth;
         }
         if(this.ipTotal == 0 || this.totalWidth == 0 || this._ipGain == 0)
         {
            this.currentIp = 0;
         }
         else
         {
            this.currentIp = this._ipGain;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ipLabel() : Label
      {
         return this._1978245645ipLabel;
      }
      
      [Bindable(event="propertyChange")]
      public function get currentIp() : int
      {
         return this._657607808currentIp;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:IPBarSegment = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._IPBarSegment_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_common_endofgame_IPBarSegmentWatcherSetupUtil");
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
      
      private function _IPBarSegment_bindingsSetup() : Array
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
         binding = new Binding(this,function():Array
         {
            return [new GlowFilter(0,0.7)];
         },function(param1:Array):void
         {
            ipLabel.filters = param1;
         },"ipLabel.filters");
         result[2] = binding;
         binding = new Binding(this,function():Boolean
         {
            return ipLabel.width > 30;
         },function(param1:Boolean):void
         {
            ipLabel.visible = param1;
         },"ipLabel.visible");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = "+" + this._ipGain.toString();
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            ipLabel.text = param1;
         },"ipLabel.text");
         result[4] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get ipType() : String
      {
         return this._1182849791ipType;
      }
      
      private function getTooltipText() : String
      {
         var _loc1_:String = null;
         _loc1_ = RiotResourceLoader.getString("endofgame_ipbreakdowntooltip_" + this.ipType,null,[this.currentIp.toString()]);
         if(_loc1_ == null)
         {
            switch(this.ipType)
            {
               case IpBreakdownEvent.IP_TYPE_BASE_WIN:
                  _loc1_ = "**Won Game: ";
                  break;
               case IpBreakdownEvent.IP_TYPE_BASE_LOST:
                  _loc1_ = "**Lost Game: ";
                  break;
               case IpBreakdownEvent.IP_TYPE_FIRST_WIN_BONUS:
                  _loc1_ = "**First Win of the Day: ";
                  break;
               case IpBreakdownEvent.IP_TYPE_BOOST:
                  _loc1_ = "**Ip Boost: ";
                  break;
               case IpBreakdownEvent.IP_TYPE_BOOST_DISABLED:
                  _loc1_ = "**Ip Boost (not enabled): ";
                  break;
               case IpBreakdownEvent.IP_TYPE_QUEUE_BONUS:
                  _loc1_ = "**Queue Bonus: ";
                  break;
               case IpBreakdownEvent.IP_TYPE_ZERO_EARNED:
                  _loc1_ = "**No IP Earned.";
                  break;
               case IpBreakdownEvent.IP_TYPE_BOOST_LOCATION:
                  _loc1_ = "**Location Boost: ";
                  break;
               case IpBreakdownEvent.IP_TYPE_BOOST_LOYALTY:
                  _loc1_ = "**Loyalty Boost: ";
            }
            if(this.ipType != IpBreakdownEvent.IP_TYPE_ZERO_EARNED)
            {
               _loc1_ += this.currentIp.toString();
            }
         }
         return _loc1_;
      }
      
      public function stopAnimation() : void
      {
         this.destroyTooltip();
      }
      
      private function destroyTooltip() : void
      {
         if(this.myToolTip)
         {
            ToolTipManager.destroyToolTip(this.myToolTip);
            this.myToolTip = null;
            this.tooltipWidthWatcher.unwatch();
            this.tooltipWidthWatcher = null;
         }
      }
      
      public function set currentIp(param1:int) : void
      {
         var _loc2_:Object = this._657607808currentIp;
         if(_loc2_ !== param1)
         {
            this._657607808currentIp = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentIp",_loc2_,param1));
         }
      }
      
      public function ___IPBarSegment_Canvas1_rollOver(param1:MouseEvent) : void
      {
         this.onRollOver(param1);
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
      
      public function onAnimationEnd(param1:EffectEvent) : void
      {
         this.destroyTooltip();
         this.dispatchEvent(param1);
      }
      
      private function onCreationComplete() : void
      {
         this.background.setStyle("fillColors",this.getStyle("fillColors"));
         this.background.setStyle("fillAlphas",this.getStyle("fillAlphas"));
      }
      
      public function set ipTotal(param1:int) : void
      {
         var _loc2_:Object = this._1986068061ipTotal;
         if(_loc2_ !== param1)
         {
            this._1986068061ipTotal = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ipTotal",_loc2_,param1));
         }
      }
      
      public function set ipLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1978245645ipLabel;
         if(_loc2_ !== param1)
         {
            this._1978245645ipLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ipLabel",_loc2_,param1));
         }
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
      
      private function _IPBarSegment_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.width;
         _loc1_ = this.height;
         _loc1_ = [new GlowFilter(0,0.7)];
         _loc1_ = this.ipLabel.width > 30;
         _loc1_ = "+" + this._ipGain.toString();
      }
      
      public function get ipGain() : int
      {
         return this._ipGain;
      }
      
      public function set totalWidth(param1:Number) : void
      {
         var _loc2_:Object = this._713110302totalWidth;
         if(_loc2_ !== param1)
         {
            this._713110302totalWidth = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalWidth",_loc2_,param1));
         }
      }
      
      private function set _ipGain(param1:int) : void
      {
         var _loc2_:Object = this._1525210725_ipGain;
         if(_loc2_ !== param1)
         {
            this._1525210725_ipGain = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ipGain",_loc2_,param1));
         }
      }
      
      public function startAnimation() : void
      {
         this.createTooltip();
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
      
      [Bindable(event="propertyChange")]
      public function get ipTotal() : int
      {
         return this._1986068061ipTotal;
      }
      
      [Bindable(event="propertyChange")]
      private function get trueWidth() : Number
      {
         return this._1339429080trueWidth;
      }
      
      [Bindable(event="propertyChange")]
      public function get totalWidth() : Number
      {
         return this._713110302totalWidth;
      }
      
      [Bindable(event="propertyChange")]
      private function get _ipGain() : int
      {
         return this._1525210725_ipGain;
      }
      
      private function createTooltip() : void
      {
         if(this.myToolTip != null)
         {
            return;
         }
         var _loc1_:Point = new Point(this.x,this.y);
         _loc1_ = Container(this.parent).contentToGlobal(_loc1_);
         this.myToolTip = ToolTipManager.createToolTip(this.getTooltipText(),_loc1_.x,_loc1_.y,"errorTipAbove") as ToolTip;
         this.myToolTip.setStyle("borderAlpha","0xFFFFFF");
         this.myToolTip.setStyle("borderThickness",3);
         this.myToolTip.setStyle("borderColor","0x174681");
         this.myToolTip.setStyle("color","white");
         var _loc2_:int = this.myToolTip.height + 5;
         this.myToolTip.y -= _loc2_;
         this.tooltipWidthWatcher = BindingUtils.bindSetter(this.updateTooltipPos,this,"width");
      }
      
      public function ___IPBarSegment_Canvas1_rollOut(param1:MouseEvent) : void
      {
         this.onRollOut();
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         this.createTooltip();
      }
      
      private function updateTooltipPos(param1:Number) : void
      {
         var _loc2_:Point = new Point(this.x,this.y);
         _loc2_ = Container(this.parent).contentToGlobal(_loc2_);
         this.myToolTip.x = _loc2_.x + param1 * 0.5 - 15;
         this.myToolTip.text = this.getTooltipText();
      }
      
      public function ___IPBarSegment_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
   }
}

