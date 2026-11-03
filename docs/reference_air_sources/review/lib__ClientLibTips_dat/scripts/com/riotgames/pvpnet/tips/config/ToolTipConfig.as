package com.riotgames.pvpnet.tips.config
{
   import flash.geom.Point;
   
   public class ToolTipConfig
   {
      
      private var _mouseSize:Point = new Point(15,20);
      
      private var _gap:Point = new Point(0,0);
      
      private var _showDelay:int = 500;
      
      private var _hideDelay:int = 0;
      
      private var _toolTipPosition:RectPosition = null;
      
      private var _cacheView:Boolean = true;
      
      private var _mouseOverToolTip:Boolean = false;
      
      public function ToolTipConfig()
      {
         super();
      }
      
      public function get cacheView() : Boolean
      {
         return this._cacheView;
      }
      
      public function set cacheView(param1:Boolean) : void
      {
         this._cacheView = param1;
      }
      
      public function get toolTipPosition() : RectPosition
      {
         return this._toolTipPosition;
      }
      
      public function set toolTipPosition(param1:RectPosition) : void
      {
         this._toolTipPosition = param1;
      }
      
      public function get mouseSize() : Point
      {
         return this._mouseSize;
      }
      
      public function set mouseSize(param1:Point) : void
      {
         this._mouseSize = param1;
      }
      
      public function get gap() : Point
      {
         return this._gap;
      }
      
      public function set gap(param1:Point) : void
      {
         this._gap = param1;
      }
      
      public function get showDelay() : int
      {
         return this._showDelay;
      }
      
      public function set showDelay(param1:int) : void
      {
         this._showDelay = param1;
      }
      
      public function get hideDelay() : int
      {
         return this._hideDelay;
      }
      
      public function set hideDelay(param1:int) : void
      {
         this._hideDelay = param1;
      }
      
      public function get mouseOverToolTip() : Boolean
      {
         return this._mouseOverToolTip;
      }
      
      public function set mouseOverToolTip(param1:Boolean) : void
      {
         this._mouseOverToolTip = param1;
      }
   }
}

