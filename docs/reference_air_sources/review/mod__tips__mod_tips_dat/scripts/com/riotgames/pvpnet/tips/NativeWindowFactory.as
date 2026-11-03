package com.riotgames.pvpnet.tips
{
   import flash.display.NativeWindow;
   import flash.display.NativeWindowInitOptions;
   import flash.display.NativeWindowSystemChrome;
   import flash.display.NativeWindowType;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.utils.Dictionary;
   
   public class NativeWindowFactory
   {
      
      private var _ownerWindowToToolTipWindowCache:Dictionary = new Dictionary();
      
      public function NativeWindowFactory()
      {
         super();
      }
      
      public function createToolTipWindow(param1:NativeWindow) : NativeWindow
      {
         var _loc3_:NativeWindowInitOptions = null;
         var _loc2_:NativeWindow = this._ownerWindowToToolTipWindowCache[param1] as NativeWindow;
         if(_loc2_ == null)
         {
            _loc3_ = new NativeWindowInitOptions();
            _loc3_.owner = param1;
            _loc3_.maximizable = false;
            _loc3_.minimizable = false;
            _loc3_.resizable = false;
            _loc3_.systemChrome = NativeWindowSystemChrome.NONE;
            _loc3_.type = NativeWindowType.LIGHTWEIGHT;
            _loc3_.transparent = true;
            _loc2_ = new NativeWindow(_loc3_);
            _loc2_.stage.scaleMode = StageScaleMode.NO_SCALE;
            _loc2_.stage.align = StageAlign.TOP_LEFT;
            _loc2_.stage.mouseChildren = false;
            this._ownerWindowToToolTipWindowCache[param1] = _loc2_;
         }
         return _loc2_;
      }
   }
}

