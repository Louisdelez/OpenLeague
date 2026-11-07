package com.riotgames.platform.gameclient.views.game.practice.teamselection
{
   import com.adobe.effects.SaturationFade;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.views.game.common.ChampionImages;
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
   import mx.controls.Image;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class BotChampionRenderer extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _1282133823fadeIn:SaturationFade;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var championWatcher:ChangeWatcher;
      
      private var _938996090championIcon_img:Image;
      
      mx_internal var _watchers:Array = [];
      
      private var _1091436750fadeOut:SaturationFade;
      
      mx_internal var _bindings:Array = [];
      
      private var _1639521861championName_txt:Text;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Image,
               "id":"championIcon_img",
               "stylesFactory":function():void
               {
                  this.verticalCenter = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "height":48,
                     "width":48
                  };
               }
            }),new UIComponentDescriptor({
               "type":Text,
               "id":"championName_txt",
               "stylesFactory":function():void
               {
                  this.verticalCenter = "0";
                  this.color = 15658734;
               }
            })]};
         }
      });
      
      public function BotChampionRenderer()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.verticalScrollPolicy = "off";
         this.horizontalScrollPolicy = "off";
         this._BotChampionRenderer_SaturationFade2_i();
         this._BotChampionRenderer_SaturationFade1_i();
         this.addEventListener("initialize",this.___BotChampionRenderer_Canvas1_initialize);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         BotChampionRenderer._watcherSetupUtil = param1;
      }
      
      private function onParticipantChanged(param1:PropertyChangeEvent) : void
      {
         if(param1.newValue != null)
         {
            this.fadeOut.play();
         }
         else
         {
            this.fadeIn.play();
         }
      }
      
      public function ___BotChampionRenderer_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      [Bindable(event="propertyChange")]
      public function get championName_txt() : Text
      {
         return this._1639521861championName_txt;
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeIn() : SaturationFade
      {
         return this._1282133823fadeIn;
      }
      
      public function set fadeIn(param1:SaturationFade) : void
      {
         var _loc2_:Object = this._1282133823fadeIn;
         if(_loc2_ !== param1)
         {
            this._1282133823fadeIn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeIn",_loc2_,param1));
         }
      }
      
      private function onInitialize() : void
      {
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:BotChampionRenderer = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._BotChampionRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_practice_teamselection_BotChampionRendererWatcherSetupUtil");
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
      
      public function set championName_txt(param1:Text) : void
      {
         var _loc2_:Object = this._1639521861championName_txt;
         if(_loc2_ !== param1)
         {
            this._1639521861championName_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championName_txt",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get championIcon_img() : Image
      {
         return this._938996090championIcon_img;
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         if(this.championWatcher != null)
         {
            this.championWatcher.unwatch();
            this.championWatcher = null;
         }
         if(param1 != null)
         {
            if(param1.participant != null)
            {
               this.fadeOut.play();
            }
            else
            {
               this.fadeIn.play();
            }
            this.championWatcher = ChangeWatcher.watch(param1,"participant",this.onParticipantChanged);
         }
         else
         {
            this.fadeIn.play();
         }
      }
      
      private function _BotChampionRenderer_SaturationFade1_i() : SaturationFade
      {
         var _loc1_:SaturationFade = new SaturationFade();
         this.fadeOut = _loc1_;
         _loc1_.saturationFrom = 1;
         _loc1_.saturationTo = 0;
         _loc1_.duration = 1;
         BindingManager.executeBindings(this,"fadeOut",this.fadeOut);
         return _loc1_;
      }
      
      private function _BotChampionRenderer_SaturationFade2_i() : SaturationFade
      {
         var _loc1_:SaturationFade = new SaturationFade();
         this.fadeIn = _loc1_;
         _loc1_.saturationFrom = 0;
         _loc1_.saturationTo = 1;
         _loc1_.duration = 1;
         BindingManager.executeBindings(this,"fadeIn",this.fadeIn);
         return _loc1_;
      }
      
      private function _BotChampionRenderer_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return this;
         },function(param1:Object):void
         {
            fadeOut.target = param1;
         },"fadeOut.target");
         result[0] = binding;
         binding = new Binding(this,function():Object
         {
            return this;
         },function(param1:Object):void
         {
            fadeIn.target = param1;
         },"fadeIn.target");
         result[1] = binding;
         binding = new Binding(this,function():Object
         {
            return ChampionImages.getIconPath(this.data.champion.skinName);
         },function(param1:Object):void
         {
            championIcon_img.source = param1;
         },"championIcon_img.source");
         result[2] = binding;
         binding = new Binding(this,function():Number
         {
            return this.championIcon_img.x + this.championIcon_img.width;
         },function(param1:Number):void
         {
            championName_txt.x = param1;
         },"championName_txt.x");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getChampionResourceString("name",this.data.champion.skinName,"**" + this.data.champion.displayName);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            championName_txt.htmlText = param1;
         },"championName_txt.htmlText");
         result[4] = binding;
         return result;
      }
      
      private function _BotChampionRenderer_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this;
         _loc1_ = this;
         _loc1_ = ChampionImages.getIconPath(this.data.champion.skinName);
         _loc1_ = this.championIcon_img.x + this.championIcon_img.width;
         _loc1_ = RiotResourceLoader.getChampionResourceString("name",this.data.champion.skinName,"**" + this.data.champion.displayName);
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeOut() : SaturationFade
      {
         return this._1091436750fadeOut;
      }
      
      public function set championIcon_img(param1:Image) : void
      {
         var _loc2_:Object = this._938996090championIcon_img;
         if(_loc2_ !== param1)
         {
            this._938996090championIcon_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championIcon_img",_loc2_,param1));
         }
      }
      
      public function set fadeOut(param1:SaturationFade) : void
      {
         var _loc2_:Object = this._1091436750fadeOut;
         if(_loc2_ !== param1)
         {
            this._1091436750fadeOut = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeOut",_loc2_,param1));
         }
      }
   }
}

