package com.greensock.plugins
{
   import com.greensock.*;
   import flash.display.*;
   import flash.geom.Rectangle;
   
   public class ScrollRectPlugin extends TweenPlugin
   {
      
      public static const API:Number = 1;
      
      protected var _target:DisplayObject;
      
      protected var _rect:Rectangle;
      
      public function ScrollRectPlugin()
      {
         super();
         this.propName = "scrollRect";
         this.overwriteProps = ["scrollRect"];
      }
      
      override public function onInitTween(target:Object, value:*, tween:TweenLite) : Boolean
      {
         var p:String = null;
         var r:Rectangle = null;
         if(!(target is DisplayObject))
         {
            return false;
         }
         _target = target as DisplayObject;
         if(_target.scrollRect != null)
         {
            _rect = _target.scrollRect;
         }
         else
         {
            r = _target.getBounds(_target);
            _rect = new Rectangle(0,0,r.width + r.x,r.height + r.y);
         }
         for(p in value)
         {
            addTween(_rect,p,_rect[p],value[p],p);
         }
         return true;
      }
      
      override public function set changeFactor(n:Number) : void
      {
         updateTweens(n);
         _target.scrollRect = _rect;
      }
   }
}

