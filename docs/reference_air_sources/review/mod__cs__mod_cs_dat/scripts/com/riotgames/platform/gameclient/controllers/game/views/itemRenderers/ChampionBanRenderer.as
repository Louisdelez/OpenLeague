package com.riotgames.platform.gameclient.controllers.game.views.itemRenderers
{
   import com.riotgames.platform.gameclient.controllers.game.utils.ChampionImages;
   import com.riotgames.platform.gameclient.domain.Champion;
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
   import mx.containers.HBox;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class ChampionBanRenderer extends Canvas
   {
      
      private var _270636692championName:Label;
      
      private var champion:Champion;
      
      private var _204468622championImage:Image;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":HBox,
               "stylesFactory":function():void
               {
                  this.verticalAlign = "middle";
               },
               "propertiesFactory":function():Object
               {
                  return {"childDescriptors":[new UIComponentDescriptor({
                     "type":Image,
                     "id":"championImage",
                     "propertiesFactory":function():Object
                     {
                        return {
                           "height":32,
                           "width":32,
                           "autoLoad":true
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":Label,
                     "id":"championName",
                     "propertiesFactory":function():Object
                     {
                        return {"styleName":"championNameText"};
                     }
                  })]};
               }
            })]};
         }
      });
      
      public function ChampionBanRenderer()
      {
         super();
         mx_internal::_document = this;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.cacheAsBitmap = true;
      }
      
      [Bindable(event="propertyChange")]
      public function get championName() : Label
      {
         return this._270636692championName;
      }
      
      public function set championName(param1:Label) : void
      {
         var _loc2_:Object = this._270636692championName;
         if(_loc2_ !== param1)
         {
            this._270636692championName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championName",_loc2_,param1));
         }
      }
      
      public function set championImage(param1:Image) : void
      {
         var _loc2_:Object = this._204468622championImage;
         if(_loc2_ !== param1)
         {
            this._204468622championImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championImage",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         super.initialize();
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.champion = param1 as Champion;
         this.championImage.source = ChampionImages.getIconPath(this.champion.skinName);
         this.championName.text = this.champion.displayName;
      }
      
      [Bindable(event="propertyChange")]
      public function get championImage() : Image
      {
         return this._204468622championImage;
      }
   }
}

