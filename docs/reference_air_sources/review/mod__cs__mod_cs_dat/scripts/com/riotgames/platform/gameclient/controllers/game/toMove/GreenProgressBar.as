package com.riotgames.platform.gameclient.controllers.game.toMove
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
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class GreenProgressBar extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object = {};
      
      private var _97692013frame:Image;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array = [];
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array = [];
      
      private var _22792435currentPercentage:Number = 0.1;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Image,
               "id":"bg",
               "propertiesFactory":function():Object
               {
                  return {
                     "percentHeight":100,
                     "x":3,
                     "y":5,
                     "percentWidth":100
                  };
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"fill",
               "propertiesFactory":function():Object
               {
                  return {
                     "percentHeight":100,
                     "x":5,
                     "y":5,
                     "scaleContent":false
                  };
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"frame",
               "propertiesFactory":function():Object
               {
                  return {
                     "percentHeight":100,
                     "percentWidth":100
                  };
               }
            })]};
         }
      });
      
      private var _3143043fill:Image;
      
      private var _3141bg:Image;
      
      public function GreenProgressBar()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         GreenProgressBar._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get currentPercentage() : Number
      {
         return this._22792435currentPercentage;
      }
      
      [Bindable(event="propertyChange")]
      public function get fill() : Image
      {
         return this._3143043fill;
      }
      
      [Bindable(event="propertyChange")]
      public function get bg() : Image
      {
         return this._3141bg;
      }
      
      public function set fill(param1:Image) : void
      {
         var _loc2_:Object = this._3143043fill;
         if(_loc2_ !== param1)
         {
            this._3143043fill = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fill",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:GreenProgressBar = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._GreenProgressBar_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_toMove_GreenProgressBarWatcherSetupUtil");
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
      
      public function set bg(param1:Image) : void
      {
         var _loc2_:Object = this._3141bg;
         if(_loc2_ !== param1)
         {
            this._3141bg = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bg",_loc2_,param1));
         }
      }
      
      private function _GreenProgressBar_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_smallProgressMeterBg");
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_smallProgressMeterFill");
         _loc1_ = (width - 10) * this.currentPercentage;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_smallProgressMeterFrame");
      }
      
      public function set currentPercentage(param1:Number) : void
      {
         var _loc2_:Object = this._22792435currentPercentage;
         if(_loc2_ !== param1)
         {
            this._22792435currentPercentage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentPercentage",_loc2_,param1));
         }
      }
      
      public function set frame(param1:Image) : void
      {
         var _loc2_:Object = this._97692013frame;
         if(_loc2_ !== param1)
         {
            this._97692013frame = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"frame",_loc2_,param1));
         }
      }
      
      private function _GreenProgressBar_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_smallProgressMeterBg");
         },function(param1:Object):void
         {
            bg.source = param1;
         },"bg.source");
         result[0] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_smallProgressMeterFill");
         },function(param1:Object):void
         {
            fill.source = param1;
         },"fill.source");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return (width - 10) * currentPercentage;
         },function(param1:Number):void
         {
            fill.width = param1;
         },"fill.width");
         result[2] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_smallProgressMeterFrame");
         },function(param1:Object):void
         {
            frame.source = param1;
         },"frame.source");
         result[3] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get frame() : Image
      {
         return this._97692013frame;
      }
   }
}

