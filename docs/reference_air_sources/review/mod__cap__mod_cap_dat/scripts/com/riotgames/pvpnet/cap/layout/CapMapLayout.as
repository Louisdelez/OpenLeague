package com.riotgames.pvpnet.cap.layout
{
   import blix.layout.LayoutEntry;
   import blix.layout.algorithms.IVirtualizedLayoutAlgorithm;
   import blix.layout.algorithms.VirtualizedLayoutBase;
   import com.greensock.TweenLite;
   import com.greensock.data.TweenLiteVars;
   import com.riotgames.pvpnet.cap.renderers.CapMapRenderer;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class CapMapLayout extends VirtualizedLayoutBase implements IVirtualizedLayoutAlgorithm
   {
      
      public function CapMapLayout()
      {
         super();
      }
      
      override public function getOffset(param1:Rectangle, param2:Rectangle, param3:uint, param4:uint, param5:Boolean) : Number
      {
         return 0;
      }
      
      override public function getShouldShowRenderer(param1:Rectangle, param2:Number, param3:Number, param4:Boolean) : Boolean
      {
         return true;
      }
      
      override public function updateLayoutEntry(param1:Number, param2:Number, param3:LayoutEntry, param4:uint, param5:Number, param6:uint, param7:Rectangle, param8:Boolean) : Rectangle
      {
         var _loc12_:TweenLiteVars = null;
         var _loc9_:CapMapRenderer = param3.element as CapMapRenderer;
         var _loc10_:Point = _loc9_.getExplicitPosition();
         var _loc11_:Boolean = Boolean(_loc9_) && Boolean(_loc9_.getVisible()) && _loc9_.getAlpha() == 1;
         if(Boolean(UserPreferencesManager.globalPrefs.enableAnimations) && _loc11_)
         {
            _loc12_ = new TweenLiteVars();
            _loc12_.x(_loc10_.x);
            _loc12_.y(_loc10_.y);
            TweenLite.to(_loc9_.getSetterProxy(),0.5,_loc12_);
         }
         else
         {
            _loc9_.setX(_loc10_.x);
            _loc9_.setY(_loc10_.y);
         }
         return new Rectangle(0,0,0,0);
      }
   }
}

