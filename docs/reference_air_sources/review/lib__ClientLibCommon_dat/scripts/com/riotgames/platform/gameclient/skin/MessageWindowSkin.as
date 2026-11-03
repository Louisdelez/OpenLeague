package com.riotgames.platform.gameclient.skin
{
   import flash.filters.DropShadowFilter;
   import mx.containers.Canvas;
   import mx.controls.Label;
   import mx.controls.TextArea;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   
   public class MessageWindowSkin extends Canvas
   {
      
      private var panel:Canvas;
      
      private var header_lb:Label;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {
               "width":400,
               "height":300
            };
         }
      });
      
      private var message_txt:TextArea;
      
      private var _1823111375dropshadow:DropShadowFilter;
      
      public function MessageWindowSkin()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.width = 400;
         this.height = 300;
         this._MessageWindowSkin_DropShadowFilter1_i();
      }
      
      public function set dropshadow(param1:DropShadowFilter) : void
      {
         var _loc2_:Object = this._1823111375dropshadow;
         if(_loc2_ !== param1)
         {
            this._1823111375dropshadow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dropshadow",_loc2_,param1));
         }
      }
      
      private function init() : void
      {
         filters = [this.dropshadow];
      }
      
      private function _MessageWindowSkin_DropShadowFilter1_i() : DropShadowFilter
      {
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         this.dropshadow = _loc1_;
         _loc1_.distance = 4;
         _loc1_.alpha = 0.5;
         _loc1_.quality = 3;
         _loc1_.blurX = 6;
         _loc1_.blurY = 6;
         return _loc1_;
      }
      
      override public function initialize() : void
      {
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         super.initialize();
      }
      
      [Bindable(event="propertyChange")]
      public function get dropshadow() : DropShadowFilter
      {
         return this._1823111375dropshadow;
      }
   }
}

