package com.greensock.plugins
{
   import com.greensock.*;
   import com.greensock.motionPaths.CirclePath2D;
   import com.greensock.motionPaths.PathFollower;
   import flash.geom.Matrix;
   
   public class CirclePath2DPlugin extends TweenPlugin
   {
      
      public static const API:Number = 1;
      
      private static const _2PI:Number = Math.PI * 2;
      
      private static const _RAD2DEG:Number = 180 / Math.PI;
      
      protected var _start:Number;
      
      protected var _autoRotate:Boolean;
      
      protected var _circle:CirclePath2D;
      
      protected var _target:Object;
      
      protected var _autoRemove:Boolean;
      
      protected var _change:Number;
      
      protected var _rotationOffset:Number;
      
      public function CirclePath2DPlugin()
      {
         super();
         this.propName = "circlePath2D";
         this.overwriteProps = ["x","y"];
      }
      
      override public function killProps(lookup:Object) : void
      {
         super.killProps(lookup);
         if("x" in lookup || "y" in lookup)
         {
            this.overwriteProps = [];
         }
      }
      
      override public function set changeFactor(n:Number) : void
      {
         var angle:Number = (_start + _change * n) * _2PI;
         var radius:Number = _circle.radius;
         var m:Matrix = _circle.transform.matrix;
         var px:Number = Math.cos(angle) * radius;
         var py:Number = Math.sin(angle) * radius;
         _target.x = px * m.a + py * m.c + m.tx;
         _target.y = px * m.b + py * m.d + m.ty;
         if(_autoRotate)
         {
            angle += Math.PI / 2;
            px = Math.cos(angle) * _circle.radius;
            py = Math.sin(angle) * _circle.radius;
            _target.rotation = Math.atan2(px * m.b + py * m.d,px * m.a + py * m.c) * _RAD2DEG + _rotationOffset;
         }
      }
      
      override public function onInitTween(target:Object, value:*, tween:TweenLite) : Boolean
      {
         if(!("path" in value) || !(value.path is CirclePath2D))
         {
            trace("CirclePath2DPlugin error: invalid \'path\' property. Please define a CirclePath2D instance.");
            return false;
         }
         _target = target;
         _circle = value.path as CirclePath2D;
         _autoRotate = Boolean(value.autoRotate == true);
         _rotationOffset = Number(value.rotationOffset) || 0;
         var f:PathFollower = _circle.getFollower(target);
         if(f != null && !("startAngle" in value))
         {
            _start = f.progress;
         }
         else
         {
            _start = _circle.angleToProgress(Number(value.startAngle) || 0,value.useRadians);
            _circle.renderObjectAt(_target,_start);
         }
         _change = Number(_circle.anglesToProgressChange(_circle.progressToAngle(_start),Number(value.endAngle) || 0,value.direction || "clockwise",uint(value.extraRevolutions) || 0,Boolean(value.useRadians)));
         return true;
      }
   }
}

