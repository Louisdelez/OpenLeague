package com.riotgames.platform.gameclient.controllers.game.views
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
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
   import mx.controls.Label;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class MapView extends GradientCanvas
   {
      
      private var _gameMap:GameMap;
      
      private var _12089446header_c_label:Label;
      
      private var _mapSource:Class;
      
      protected var mapSourceChanged:Boolean = false;
      
      private var _158535007mapImage:Image;
      
      protected var mapTitleChanged:Boolean = false;
      
      private var _mapTitle:String;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function MapView()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":GradientCanvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Canvas,
                  "stylesFactory":function():void
                  {
                     this.bottom = "0";
                     this.left = "0";
                     this.right = "0";
                     this.top = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Image,
                           "id":"mapImage",
                           "stylesFactory":function():void
                           {
                              this.bottom = "-1";
                              this.top = "0";
                              this.left = "0";
                              this.right = "0";
                              this.horizontalAlign = "center";
                              this.verticalAlign = "middle";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"maintainAspectRatio":true};
                           }
                        }),new UIComponentDescriptor({
                           "type":Label,
                           "id":"header_c_label",
                           "stylesFactory":function():void
                           {
                              this.right = "8";
                              this.bottom = "-2";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"mapRendererMapName"};
                           }
                        })]
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
            this.backgroundAlpha = 0;
            this.borderSides = "left top";
            this.cornerRadius = 2;
         };
         this.horizontalScrollPolicy = "off";
         this.styleName = "blueParchmentTablet";
         this.verticalScrollPolicy = "off";
         this.cacheAsBitmap = true;
         this.addEventListener("creationComplete",this.___MapView_GradientCanvas1_creationComplete);
      }
      
      public function set mapImage(param1:Image) : void
      {
         var _loc2_:Object = this._158535007mapImage;
         if(_loc2_ !== param1)
         {
            this._158535007mapImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapImage",_loc2_,param1));
         }
      }
      
      public function setGameMap() : void
      {
         if(this.gameMap)
         {
            this.mapTitle = this.gameMap.displayName;
            this.mapSource = ImagePackLookup.instance.getMapSource(this.gameMap);
         }
         else
         {
            this.mapTitle = "";
            this.mapSource = null;
         }
      }
      
      public function get gameMap() : GameMap
      {
         return this._gameMap;
      }
      
      public function set header_c_label(param1:Label) : void
      {
         var _loc2_:Object = this._12089446header_c_label;
         if(_loc2_ !== param1)
         {
            this._12089446header_c_label = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"header_c_label",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         super.initialize();
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.mapTitleChanged && Boolean(this.header_c_label))
         {
            this.setMapTitle();
            this.mapTitleChanged = false;
         }
         if(this.mapSourceChanged && Boolean(this.mapImage))
         {
            this.setMapSource();
            this.mapSourceChanged = false;
         }
      }
      
      public function set gameMap(param1:GameMap) : void
      {
         if(this._gameMap == param1)
         {
            return;
         }
         this._gameMap = param1;
         this.setGameMap();
      }
      
      protected function setMapSource() : void
      {
         if(!this.mapImage)
         {
            return;
         }
         this.mapImage.source = this.mapSource;
      }
      
      public function ___MapView_GradientCanvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      public function get mapTitle() : String
      {
         return this._mapTitle;
      }
      
      public function get mapSource() : Class
      {
         return this._mapSource;
      }
      
      [Bindable(event="propertyChange")]
      public function get mapImage() : Image
      {
         return this._158535007mapImage;
      }
      
      [Bindable(event="propertyChange")]
      public function get header_c_label() : Label
      {
         return this._12089446header_c_label;
      }
      
      protected function setMapTitle() : void
      {
         if(!this.mapTitle)
         {
            return;
         }
         this.header_c_label.text = this.mapTitle;
      }
      
      public function set mapSource(param1:Class) : void
      {
         if(this._mapSource == param1)
         {
            return;
         }
         this._mapSource = param1;
         this.mapSourceChanged = true;
         invalidateProperties();
      }
      
      private function onCreationComplete() : void
      {
         if(this.mapTitleChanged && Boolean(this.header_c_label))
         {
            this.setMapTitle();
            this.mapTitleChanged = false;
         }
         if(this.mapSourceChanged && Boolean(this.mapImage))
         {
            this.setMapSource();
            this.mapSourceChanged = false;
         }
      }
      
      public function set mapTitle(param1:String) : void
      {
         if(this._mapTitle == param1)
         {
            return;
         }
         this._mapTitle = param1;
         this.mapTitleChanged = true;
         invalidateProperties();
      }
   }
}

