package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.tooltips.SpellToolTip;
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
   import mx.events.ToolTipEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class SpellItemRenderer extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      mx_internal var _watchers:Array = [];
      
      public var inventory:IInventory;
      
      mx_internal var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Image,
               "id":"spellImg",
               "events":{"toolTipCreate":"__spellImg_toolTipCreate"},
               "stylesFactory":function():void
               {
                  this.left = "0";
                  this.top = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "toolTip":"unused",
                     "smoothBitmapContent":true
                  };
               }
            })]};
         }
      });
      
      private var _2124501637spellImg:Image;
      
      public function SpellItemRenderer()
      {
         super();
         mx_internal::_document = this;
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         SpellItemRenderer._watcherSetupUtil = param1;
      }
      
      private function onTooltipCreate(param1:ToolTipEvent) : void
      {
         var _loc2_:SpellToolTip = new SpellToolTip();
         _loc2_.data = this.data;
         param1.toolTip = _loc2_;
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = this.inventory.spellDictionary[param1];
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:SpellItemRenderer = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._SpellItemRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_common_endofgame_SpellItemRendererWatcherSetupUtil");
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
      
      public function __spellImg_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.onTooltipCreate(param1);
      }
      
      private function _SpellItemRenderer_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getSpellSource(data as Spell);
         },function(param1:Object):void
         {
            spellImg.source = param1;
         },"spellImg.source");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return this.width;
         },function(param1:Number):void
         {
            spellImg.width = param1;
         },"spellImg.width");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return spellImg.width;
         },function(param1:Number):void
         {
            spellImg.height = param1;
         },"spellImg.height");
         result[2] = binding;
         binding = new Binding(this,function():Array
         {
            return [new GlowFilter(12000741,0.7,8,8)];
         },function(param1:Array):void
         {
            spellImg.filters = param1;
         },"spellImg.filters");
         result[3] = binding;
         return result;
      }
      
      public function set spellImg(param1:Image) : void
      {
         var _loc2_:Object = this._2124501637spellImg;
         if(_loc2_ !== param1)
         {
            this._2124501637spellImg = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spellImg",_loc2_,param1));
         }
      }
      
      private function _SpellItemRenderer_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = ImagePackLookup.instance.getSpellSource(data as Spell);
         _loc1_ = this.width;
         _loc1_ = this.spellImg.width;
         _loc1_ = [new GlowFilter(12000741,0.7,8,8)];
      }
      
      [Bindable(event="propertyChange")]
      public function get spellImg() : Image
      {
         return this._2124501637spellImg;
      }
   }
}

