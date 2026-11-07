package com.greensock.motionPaths
{
   import flash.display.Graphics;
   import flash.events.Event;
   import flash.geom.Matrix;
   
   public class CirclePath2D extends MotionPath
   {
      
      protected var _radius:Number;
      
      public function CirclePath2D(x:Number, y:Number, radius:Number)
      {
         super();
         _radius = radius;
         super.x = x;
         super.y = y;
      }
      
      public function get radius() : Number
      {
         return _radius;
      }
      
      override public function renderObjectAt(target:Object, progress:Number, autoRotate:Boolean = false, rotationOffset:Number = 0) : void
      {
         var angle:Number = progress * Math.PI * 2;
         var m:Matrix = this.transform.matrix;
         var px:Number = Math.cos(angle) * _radius;
         var py:Number = Math.sin(angle) * _radius;
         target.x = px * m.a + py * m.c + m.tx;
         target.y = px * m.b + py * m.d + m.ty;
         if(autoRotate)
         {
            angle += Math.PI / 2;
            px = Math.cos(angle) * _radius;
            py = Math.sin(angle) * _radius;
            target.rotation = Math.atan2(px * m.b + py * m.d,px * m.a + py * m.c) * _RAD2DEG + rotationOffset;
         }
      }
      
      override public function update(event:Event = null) : void
      {
         var angle:Number = NaN;
         var px:Number = NaN;
         var py:Number = NaN;
         var g:Graphics = null;
         var m:Matrix = this.transform.matrix;
         var a:Number = m.a;
         var b:Number = m.b;
         var c:Number = m.c;
         var d:Number = m.d;
         var tx:Number = m.tx;
         var ty:Number = m.ty;
         var f:PathFollower = _rootFollower;
         while(Boolean(f))
         {
            angle = f.cachedProgress * Math.PI * 2;
            px = Math.cos(angle) * _radius;
            py = Math.sin(angle) * _radius;
            f.target.x = px * a + py * c + tx;
            f.target.y = px * b + py * d + ty;
            if(f.autoRotate)
            {
               angle += Math.PI / 2;
               px = Math.cos(angle) * _radius;
               py = Math.sin(angle) * _radius;
               f.target.rotation = Math.atan2(px * m.b + py * m.d,px * m.a + py * m.c) * _RAD2DEG + f.rotationOffset;
            }
            f = f.cachedNext;
         }
         if(_redrawLine)
         {
            g = this.graphics;
            g.clear();
            g.lineStyle(_thickness,_color,_lineAlpha,_pixelHinting,_scaleMode,_caps,_joints,_miterLimit);
            g.drawCircle(0,0,_radius);
            _redrawLine = false;
         }
      }
      
      public function progressToAngle(progress:Number, useRadians:Boolean = false) : Number
      {
         var revolution:Number = useRadians ? Math.PI * 2 : 360;
         return progress * revolution;
      }
      
      public function angleToProgress(angle:Number, useRadians:Boolean = false) : Number
      {
         var revolution:Number = useRadians ? Math.PI * 2 : 360;
         if(angle < 0)
         {
            angle += (int(-angle / revolution) + 1) * revolution;
         }
         else if(angle > revolution)
         {
            angle -= int(angle / revolution) * revolution;
         }
         return angle / revolution;
      }
      
      public function set radius(value:Number) : void
      {
         _radius = value;
         _redrawLine = true;
         update();
      }
      
      public function followerTween(follower:*, endAngle:Number, direction:String = "clockwise", extraRevolutions:uint = 0, useRadians:Boolean = false) : String
      {
         var revolution:Number = useRadians ? Math.PI * 2 : 360;
         return String(anglesToProgressChange(getFollower(follower).progress * revolution,endAngle,direction,extraRevolutions,useRadians));
      }
      
      public function anglesToProgressChange(startAngle:Number, endAngle:Number, direction:String = "clockwise", extraRevolutions:uint = 0, useRadians:Boolean = false) : Number
      {
         var revolution:Number = useRadians ? Math.PI * 2 : 360;
         var dif:Number = endAngle - startAngle;
         if(dif < 0 && direction == "clockwise")
         {
            dif += (int(-dif / revolution) + 1) * revolution;
         }
         else if(dif > 0 && direction == "counterClockwise")
         {
            dif -= (int(dif / revolution) + 1) * revolution;
         }
         else if(direction == "shortest")
         {
            dif %= revolution;
            if(dif != dif % (revolution * 0.5))
            {
               dif = dif < 0 ? dif + revolution : dif - revolution;
            }
         }
         if(dif < 0)
         {
            dif -= extraRevolutions * revolution;
         }
         else
         {
            dif += extraRevolutions * revolution;
         }
         return dif / revolution;
      }
   }
}

