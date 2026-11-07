package com.riotgames.rust.components.grouplist
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.signals.Signal;
   import flash.geom.Rectangle;
   
   public class VisibilityModel
   {
      
      public var visibilityContext:DisplayObjectContainerProxy;
      
      private var _visibleRect:Rectangle;
      
      public var visibleRectChanged:Signal = new Signal();
      
      public function VisibilityModel()
      {
         super();
      }
      
      public function get visibleRect() : Rectangle
      {
         return this._visibleRect;
      }
      
      public function set visibleRect(param1:Rectangle) : void
      {
         this._visibleRect = param1;
         this.visibleRectChanged.dispatch(this);
      }
   }
}

