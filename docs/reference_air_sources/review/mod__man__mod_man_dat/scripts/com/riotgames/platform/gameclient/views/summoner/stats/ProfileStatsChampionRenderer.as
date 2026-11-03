package com.riotgames.platform.gameclient.views.summoner.stats
{
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import com.riotgames.platform.gameclient.domain.Champion;
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
   import mx.containers.Canvas;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.events.ToolTipEvent;
   import mx.styles.*;
   
   public class ProfileStatsChampionRenderer extends Canvas
   {
      
      private var _270636692championName:Label;
      
      private var _204468622championImage:Image;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":cs_championItem,
               "propertiesFactory":function():Object
               {
                  return {"content":_ProfileStatsChampionRenderer_Image1_i()};
               }
            }),new UIComponentDescriptor({
               "type":Label,
               "id":"championName",
               "stylesFactory":function():void
               {
                  this.horizontalCenter = "0";
                  this.bottom = "2";
                  this.textAlign = "center";
                  this.color = 0;
                  this.fontSize = 12;
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "percentWidth":100,
                     "styleName":"championNameText"
                  };
               }
            })]};
         }
      });
      
      [Inject]
      public var summonerProfileController:SummonerProfileController;
      
      public function ProfileStatsChampionRenderer()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.toolTip = "unused";
         this.addEventListener("toolTipCreate",this.___ProfileStatsChampionRenderer_Canvas1_toolTipCreate);
      }
      
      private function _ProfileStatsChampionRenderer_Image1_i() : Image
      {
         var _loc1_:Image = new Image();
         this.championImage = _loc1_;
         _loc1_.autoLoad = true;
         _loc1_.id = "championImage";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get championName() : Label
      {
         return this._270636692championName;
      }
      
      public function ___ProfileStatsChampionRenderer_Canvas1_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.createChampionTooltip(param1);
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
      
      override protected function commitProperties() : void
      {
         var _loc1_:Champion = null;
         if(this.data)
         {
            _loc1_ = this.data as Champion;
            if(Boolean(_loc1_) && Boolean(this.championImage))
            {
               this.championImage.source = ChampionImages.getIconPath(_loc1_.skinName);
               this.championName.text = _loc1_.displayName;
            }
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
      
      private function createChampionTooltip(param1:ToolTipEvent) : void
      {
         var _loc2_:ChampionStatsTooltip = new ChampionStatsTooltip();
         _loc2_.summonerProfileController = this.summonerProfileController;
         _loc2_.data = this.data;
         param1.toolTip = _loc2_;
      }
      
      override public function initialize() : void
      {
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         super.initialize();
      }
      
      [Bindable(event="propertyChange")]
      public function get championImage() : Image
      {
         return this._204468622championImage;
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         invalidateProperties();
      }
   }
}

