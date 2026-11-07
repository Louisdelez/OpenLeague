package com.riotgames.platform.gameclient.views.summoner.wizard
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
   import mx.containers.VBox;
   import mx.controls.Image;
   import mx.core.BitmapAsset;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class ChooseIconRenderer extends VBox
   {
      
      private static const GLOW_SELECTED:GlowFilter = new GlowFilter(23039,1,16,16,5,1,true);
      
      private static const GLOW_REGULAR:GlowFilter = new GlowFilter(16777215,1,4,4,5,1,true);
      
      private static const GRAYSCALE:ColorMatrixFilter = new ColorMatrixFilter([0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0]);
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _737599747icon_img:Image;
      
      public function ChooseIconRenderer()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":VBox,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Image,
                  "id":"icon_img",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "width":65,
                        "height":65,
                        "mouseEnabled":false,
                        "mouseChildren":false
                     };
                  }
               })]};
            }
         });
         super();
         mx_internal::_document = this;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration();
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.backgroundColor = 0;
            this.horizontalAlign = "center";
            this.paddingTop = 2;
            this.paddingLeft = 2;
            this.paddingRight = 2;
            this.paddingBottom = 2;
         };
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Boolean = false;
         super.commitProperties();
         if(data)
         {
            this.icon_img.source = new BitmapAsset(data.iconSource,"auto",true);
            _loc1_ = Boolean(data.selected) && !data.restrictedFromUse;
            if(data.restrictedFromUse)
            {
               this.icon_img.filters = [GRAYSCALE,_loc1_ ? GLOW_SELECTED : GLOW_REGULAR];
            }
            else
            {
               this.icon_img.filters = [_loc1_ ? GLOW_SELECTED : GLOW_REGULAR];
            }
         }
         else
         {
            this.icon_img.source = null;
            this.icon_img.filters = [];
         }
      }
      
      override public function initialize() : void
      {
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         super.initialize();
      }
      
      public function set icon_img(param1:Image) : void
      {
         var _loc2_:Object = this._737599747icon_img;
         if(_loc2_ !== param1)
         {
            this._737599747icon_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"icon_img",_loc2_,param1));
         }
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         invalidateProperties();
      }
      
      [Bindable(event="propertyChange")]
      public function get icon_img() : Image
      {
         return this._737599747icon_img;
      }
   }
}

