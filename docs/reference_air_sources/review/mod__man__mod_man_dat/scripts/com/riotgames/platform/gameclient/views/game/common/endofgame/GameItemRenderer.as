package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.domain.GameItem;
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
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ToolTipEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class GameItemRenderer extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const EMPTY_ITEM_SLOT:String = "EmptyIcon";
      
      mx_internal var _bindingsByDestination:Object = {};
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var _1769475547gameItem:GameItem = null;
      
      private var _2124133034imageSource:Object;
      
      private var _1148514245cornerOverlay:Image;
      
      private var _2116183984itemImg:Image;
      
      mx_internal var _watchers:Array = [];
      
      mx_internal var _bindings:Array = [];
      
      public var glowEnabled:Boolean = false;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Image,
               "id":"itemImg",
               "events":{"toolTipCreate":"__itemImg_toolTipCreate"},
               "stylesFactory":function():void
               {
                  this.left = "0";
                  this.top = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "toolTip":"placeholder",
                     "smoothBitmapContent":true
                  };
               }
            }),new UIComponentDescriptor({
               "type":Image,
               "id":"cornerOverlay",
               "stylesFactory":function():void
               {
                  this.left = "0";
                  this.top = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "toolTip":"",
                     "mouseChildren":false,
                     "mouseEnabled":false
                  };
               }
            })]};
         }
      });
      
      public function GameItemRenderer()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.addEventListener("initialize",this.___GameItemRenderer_Canvas1_initialize);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         GameItemRenderer._watcherSetupUtil = param1;
      }
      
      private function onTooltipCreate(param1:ToolTipEvent) : void
      {
         var _loc2_:GameItemTooltip = new GameItemTooltip();
         _loc2_.mouseEnabled = false;
         _loc2_.mouseChildren = false;
         _loc2_.data = this.gameItem;
         param1.toolTip = _loc2_;
      }
      
      [Bindable(event="propertyChange")]
      public function get cornerOverlay() : Image
      {
         return this._1148514245cornerOverlay;
      }
      
      [Bindable(event="propertyChange")]
      public function get gameItem() : GameItem
      {
         return this._1769475547gameItem;
      }
      
      private function updateGameItem() : void
      {
         var _loc1_:Class = null;
         var _loc2_:Boolean = false;
         if(data)
         {
            this.gameItem = data as GameItem;
            if(this.gameItem != null)
            {
               _loc1_ = resourceManager.getClass("images",this.gameItem.iconName.toLowerCase());
               _loc2_ = _loc1_ != null;
               this.imageSource = _loc2_ ? _loc1_ : ImagePackLookup.instance.getItemSource(this.gameItem);
               if(this.itemImg)
               {
                  if(this.glowEnabled)
                  {
                     this.itemImg.filters = [new GlowFilter(7501172,0.6,8,8)];
                  }
                  else
                  {
                     this.itemImg.filters = null;
                  }
               }
            }
         }
      }
      
      private function onInitialize() : void
      {
         this.updateGameItem();
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:GameItemRenderer = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._GameItemRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_common_endofgame_GameItemRendererWatcherSetupUtil");
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
      
      private function _GameItemRenderer_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.imageSource;
         _loc1_ = this.width;
         _loc1_ = this.itemImg.width;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_cornerMask");
         _loc1_ = this.width;
         _loc1_ = this.itemImg.width;
      }
      
      private function set imageSource(param1:Object) : void
      {
         var _loc2_:Object = this._2124133034imageSource;
         if(_loc2_ !== param1)
         {
            this._2124133034imageSource = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"imageSource",_loc2_,param1));
         }
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.imageSource = null;
         this.updateGameItem();
      }
      
      private function _GameItemRenderer_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return this.imageSource;
         },function(param1:Object):void
         {
            itemImg.source = param1;
         },"itemImg.source");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return this.width;
         },function(param1:Number):void
         {
            itemImg.width = param1;
         },"itemImg.width");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return itemImg.width;
         },function(param1:Number):void
         {
            itemImg.height = param1;
         },"itemImg.height");
         result[2] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_cornerMask");
         },function(param1:Object):void
         {
            cornerOverlay.source = param1;
         },"cornerOverlay.source");
         result[3] = binding;
         binding = new Binding(this,function():Number
         {
            return this.width;
         },function(param1:Number):void
         {
            cornerOverlay.width = param1;
         },"cornerOverlay.width");
         result[4] = binding;
         binding = new Binding(this,function():Number
         {
            return itemImg.width;
         },function(param1:Number):void
         {
            cornerOverlay.height = param1;
         },"cornerOverlay.height");
         result[5] = binding;
         return result;
      }
      
      public function __itemImg_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.onTooltipCreate(param1);
      }
      
      public function set itemImg(param1:Image) : void
      {
         var _loc2_:Object = this._2116183984itemImg;
         if(_loc2_ !== param1)
         {
            this._2116183984itemImg = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemImg",_loc2_,param1));
         }
      }
      
      public function set gameItem(param1:GameItem) : void
      {
         var _loc2_:Object = this._1769475547gameItem;
         if(_loc2_ !== param1)
         {
            this._1769475547gameItem = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameItem",_loc2_,param1));
         }
      }
      
      public function ___GameItemRenderer_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      [Bindable(event="propertyChange")]
      public function get itemImg() : Image
      {
         return this._2116183984itemImg;
      }
      
      [Bindable(event="propertyChange")]
      private function get imageSource() : Object
      {
         return this._2124133034imageSource;
      }
      
      public function set cornerOverlay(param1:Image) : void
      {
         var _loc2_:Object = this._1148514245cornerOverlay;
         if(_loc2_ !== param1)
         {
            this._1148514245cornerOverlay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cornerOverlay",_loc2_,param1));
         }
      }
   }
}

