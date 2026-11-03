package com.riotgames.pvpnet.chrome
{
   import com.riotgames.pvpnet.system.config.WindowConstants;
   import flash.display.NativeWindow;
   import flash.display.NativeWindowDisplayState;
   import flash.events.NativeWindowBoundsEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.WindowedApplication;
   
   public class WindowControlsProviderImpl implements IWindowControlsProvider
   {
      
      private var _windowedApplication:WindowedApplication;
      
      private var _nativeWindow:NativeWindow;
      
      private var ratio:Number;
      
      private var adaptedScreenResolution:Point;
      
      public function WindowControlsProviderImpl(param1:WindowedApplication, param2:NativeWindow)
      {
         super();
         this._windowedApplication = param1;
         this._nativeWindow = param2;
      }
      
      public function initResizing() : void
      {
         this.ratio = this._nativeWindow.width / this._nativeWindow.height;
         this._nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZING,this.resizing);
      }
      
      public function setToDefaultSize() : void
      {
         var _loc5_:Point = null;
         var _loc1_:Rectangle = WindowConstants.getCurrentScreenVisibleBounds(this._nativeWindow);
         this.adaptedScreenResolution = new Point(_loc1_.width,_loc1_.height);
         this._windowedApplication.maxWidth = _loc1_.width;
         this._windowedApplication.maxHeight = _loc1_.height;
         var _loc2_:Number = Number(WindowConstants.DEFAULT_SCREEN_WIDTH);
         var _loc3_:Number = Number(WindowConstants.DEFAULT_SCREEN_HEIGHT);
         if(WindowConstants.requiresSmallResolutionSupport(this._nativeWindow))
         {
            _loc5_ = WindowConstants.findSmallDefaultResolution(this._nativeWindow);
            _loc2_ = _loc5_.x;
            _loc3_ = _loc5_.y;
         }
         this._windowedApplication.width = _loc2_;
         this._windowedApplication.height = _loc3_;
         var _loc4_:Point = new Point(Math.round(_loc1_.width / 2 - this._windowedApplication.width / 2),Math.round(_loc1_.height / 2 - this._windowedApplication.height / 2));
         this._nativeWindow.x = _loc1_.x + _loc4_.x;
         this._nativeWindow.y = _loc1_.y + _loc4_.y;
         this.refreshWindowSize();
      }
      
      public function requestMinimize() : void
      {
         this._windowedApplication.minimize();
      }
      
      private function resizing(param1:NativeWindowBoundsEvent) : void
      {
         var _loc2_:Rectangle = WindowConstants.getCurrentScreenVisibleBounds(this._nativeWindow);
         if(_loc2_.width != this.adaptedScreenResolution.x || _loc2_.height != this.adaptedScreenResolution.y)
         {
            this.setToDefaultSize();
         }
         param1.afterBounds.bottom = param1.afterBounds.width / this.ratio + param1.afterBounds.top;
         this._nativeWindow.bounds = param1.afterBounds;
         this._nativeWindow.dispatchEvent(new NativeWindowBoundsEvent(NativeWindowBoundsEvent.RESIZE));
         param1.preventDefault();
      }
      
      public function refreshWindowSize() : void
      {
         if(Boolean(this._nativeWindow) && !this._nativeWindow.closed)
         {
            if(this._nativeWindow.displayState == NativeWindowDisplayState.NORMAL)
            {
               this._nativeWindow.width = this._windowedApplication.x + this._windowedApplication.width;
               this._nativeWindow.height = this._windowedApplication.y + this._windowedApplication.height;
            }
         }
      }
      
      public function initializeApplicationDimensions() : void
      {
         this.setToDefaultSize();
      }
      
      public function beginResize(param1:String) : void
      {
         this._nativeWindow.startResize(param1);
      }
      
      public function beginDrag() : void
      {
         this._nativeWindow.startMove();
      }
   }
}

