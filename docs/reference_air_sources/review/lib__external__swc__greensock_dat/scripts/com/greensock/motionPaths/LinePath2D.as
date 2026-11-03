package com.greensock.motionPaths
{
   import flash.display.Graphics;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class LinePath2D extends MotionPath
   {
      
      protected var _points:Array;
      
      protected var _totalLength:Number;
      
      public var autoUpdatePoints:Boolean;
      
      protected var _hasAutoRotate:Boolean;
      
      protected var _first:PathPoint;
      
      protected var _prevMatrix:Matrix;
      
      public function LinePath2D(points:Array = null, x:Number = 0, y:Number = 0, autoUpdatePoints:Boolean = false)
      {
         super();
         _points = [];
         _totalLength = 0;
         this.autoUpdatePoints = autoUpdatePoints;
         if(points != null)
         {
            insertMultiplePoints(points,0);
         }
         super.x = x;
         super.y = y;
      }
      
      protected function _organize() : void
      {
         var pp:PathPoint = null;
         _totalLength = 0;
         _hasAutoRotate = false;
         var last:int = _points.length - 1;
         if(last == -1)
         {
            _first = null;
         }
         else if(last == 0)
         {
            _first = _points[0];
            _first.progress = _first.xChange = _first.yChange = _first.length = 0;
            return;
         }
         for(var i:int = 0; i <= last; i++)
         {
            if(_points[i] != null)
            {
               pp = _points[i];
               pp.x = pp.point.x;
               pp.y = pp.point.y;
               if(i == last)
               {
                  pp.length = 0;
                  pp.next = null;
               }
               else
               {
                  pp.next = _points[i + 1];
                  pp.xChange = pp.next.x - pp.x;
                  pp.yChange = pp.next.y - pp.y;
                  pp.length = Math.sqrt(pp.xChange * pp.xChange + pp.yChange * pp.yChange);
                  _totalLength += pp.length;
               }
            }
         }
         _first = pp = _points[0];
         var curTotal:Number = 0;
         while(Boolean(pp))
         {
            pp.progress = curTotal / _totalLength;
            curTotal += pp.length;
            pp = pp.next;
         }
         _updateAngles();
      }
      
      public function set points(value:Array) : void
      {
         _points = [];
         insertMultiplePoints(value,0);
         _redrawLine = true;
         update(null);
      }
      
      protected function _updateAngles() : void
      {
         var m:Matrix = this.transform.matrix;
         var pp:PathPoint = _first;
         while(Boolean(pp))
         {
            pp.angle = Math.atan2(pp.xChange * m.b + pp.yChange * m.d,pp.xChange * m.a + pp.yChange * m.c) * _RAD2DEG;
            pp = pp.next;
         }
         _prevMatrix = m;
      }
      
      public function getSegmentProgress(segment:uint, progress:Number) : Number
      {
         if(_first == null)
         {
            return 0;
         }
         if(_points.length <= segment)
         {
            segment = _points.length;
         }
         var pp:PathPoint = _points[segment - 1];
         return pp.progress + progress * pp.length / _totalLength;
      }
      
      public function appendMultiplePoints(points:Array) : void
      {
         insertMultiplePoints(points,_points.length);
      }
      
      override public function renderObjectAt(target:Object, progress:Number, autoRotate:Boolean = false, rotationOffset:Number = 0) : void
      {
         var pathProg:Number = NaN;
         var px:Number = NaN;
         var py:Number = NaN;
         var m:Matrix = null;
         if(progress > 1)
         {
            progress -= int(progress);
         }
         else if(progress < 0)
         {
            progress -= int(progress) - 1;
         }
         if(_first == null)
         {
            return;
         }
         var pp:PathPoint = _first;
         while(pp.next != null && pp.next.progress < progress)
         {
            pp = pp.next;
         }
         if(pp != null)
         {
            pathProg = (progress - pp.progress) / (pp.length / _totalLength);
            px = pp.x + pathProg * pp.xChange;
            py = pp.y + pathProg * pp.yChange;
            m = this.transform.matrix;
            target.x = px * m.a + py * m.c + m.tx;
            target.y = px * m.b + py * m.d + m.ty;
            if(autoRotate)
            {
               if(_prevMatrix.a != m.a || _prevMatrix.b != m.b || _prevMatrix.c != m.c || _prevMatrix.d != m.d)
               {
                  _updateAngles();
               }
               target.rotation = pp.angle + rotationOffset;
            }
         }
      }
      
      override public function update(event:Event = null) : void
      {
         var px:Number = NaN;
         var py:Number = NaN;
         var pp:PathPoint = null;
         var followerProgress:Number = NaN;
         var pathProg:Number = NaN;
         var g:Graphics = null;
         if(_first == null || _points.length <= 1)
         {
            return;
         }
         var updatedAngles:Boolean = false;
         var m:Matrix = this.transform.matrix;
         var a:Number = m.a;
         var b:Number = m.b;
         var c:Number = m.c;
         var d:Number = m.d;
         var tx:Number = m.tx;
         var ty:Number = m.ty;
         var f:PathFollower = _rootFollower;
         if(autoUpdatePoints)
         {
            pp = _first;
            while(Boolean(pp))
            {
               if(pp.point.x != pp.x || pp.point.y != pp.y)
               {
                  _organize();
                  _redrawLine = true;
                  update();
                  return;
               }
               pp = pp.next;
            }
         }
         while(Boolean(f))
         {
            followerProgress = f.cachedProgress;
            pp = _first;
            while(pp != null && pp.next.progress < followerProgress)
            {
               pp = pp.next;
            }
            if(pp != null)
            {
               pathProg = (followerProgress - pp.progress) / (pp.length / _totalLength);
               px = pp.x + pathProg * pp.xChange;
               py = pp.y + pathProg * pp.yChange;
               f.target.x = px * a + py * c + tx;
               f.target.y = px * b + py * d + ty;
               if(f.autoRotate)
               {
                  if(!updatedAngles && (_prevMatrix.a != a || _prevMatrix.b != b || _prevMatrix.c != c || _prevMatrix.d != d))
                  {
                     _updateAngles();
                     updatedAngles = true;
                  }
                  f.target.rotation = pp.angle + f.rotationOffset;
               }
            }
            f = f.cachedNext;
         }
         if(_redrawLine)
         {
            g = this.graphics;
            g.clear();
            g.lineStyle(_thickness,_color,_lineAlpha,_pixelHinting,_scaleMode,_caps,_joints,_miterLimit);
            pp = _first;
            g.moveTo(pp.x,pp.y);
            while(Boolean(pp))
            {
               g.lineTo(pp.x,pp.y);
               pp = pp.next;
            }
            _redrawLine = false;
         }
      }
      
      public function appendPoint(point:Point) : void
      {
         _insertPoint(point,_points.length,false);
      }
      
      public function insertPoint(point:Point, index:uint = 0) : void
      {
         _insertPoint(point,index,false);
      }
      
      protected function _insertPoint(point:Point, index:uint, skipOrganize:Boolean) : void
      {
         _points.splice(index,0,new PathPoint(point));
         if(!skipOrganize)
         {
            _organize();
         }
      }
      
      public function snap(target:Object, autoRotate:Boolean = false, rotationOffset:Number = 0) : PathFollower
      {
         return this.addFollower(target,getClosestProgress(target),autoRotate,rotationOffset);
      }
      
      public function get points() : Array
      {
         var a:Array = [];
         var l:int = int(_points.length);
         for(var i:int = 0; i < l; i++)
         {
            a[i] = _points[i].point;
         }
         return a;
      }
      
      public function insertMultiplePoints(points:Array, index:uint = 0) : void
      {
         var l:int = int(points.length);
         for(var i:int = 0; i < l; i++)
         {
            _insertPoint(points[i],index + i,true);
         }
         _organize();
      }
      
      public function removePointByIndex(index:uint) : void
      {
         _points.splice(index,1);
         _organize();
      }
      
      public function getClosestProgress(target:Object) : Number
      {
         var closestPath:PathPoint = null;
         var dxTarg:Number = NaN;
         var dyTarg:Number = NaN;
         var dxNext:Number = NaN;
         var dyNext:Number = NaN;
         var dTarg:Number = NaN;
         var angle:Number = NaN;
         var next:PathPoint = null;
         var curDist:Number = NaN;
         if(_first == null || _points.length == 1)
         {
            return 0;
         }
         var closest:Number = 9999999999;
         var length:Number = 0;
         var halfPI:Number = Math.PI / 2;
         var xTarg:Number = Number(target.x);
         var yTarg:Number = Number(target.y);
         var pp:PathPoint = _first;
         while(Boolean(pp))
         {
            dxTarg = xTarg - pp.x;
            dyTarg = yTarg - pp.y;
            next = pp.next != null ? pp.next : pp;
            dxNext = next.x - pp.x;
            dyNext = next.y - pp.y;
            dTarg = Math.sqrt(dxTarg * dxTarg + dyTarg * dyTarg);
            angle = Math.atan2(dyTarg,dxTarg) - Math.atan2(dyNext,dxNext);
            if(angle < 0)
            {
               angle = -angle;
            }
            if(angle > halfPI)
            {
               if(dTarg < closest)
               {
                  closest = dTarg;
                  closestPath = pp;
                  length = 0;
               }
            }
            else
            {
               curDist = Math.cos(angle) * dTarg;
               if(curDist < 0)
               {
                  curDist = -curDist;
               }
               if(curDist > pp.length)
               {
                  dxNext = xTarg - next.x;
                  dyNext = yTarg - next.y;
                  curDist = Math.sqrt(dxNext * dxNext + dyNext * dyNext);
                  if(curDist < closest)
                  {
                     closest = curDist;
                     closestPath = pp;
                     length = pp.length;
                  }
               }
               else
               {
                  curDist = Math.sin(angle) * dTarg;
                  if(curDist < closest)
                  {
                     closest = curDist;
                     closestPath = pp;
                     length = Math.cos(angle) * dTarg;
                  }
               }
            }
            pp = pp.next;
         }
         return closestPath.progress + length / _totalLength;
      }
      
      public function get totalLength() : Number
      {
         return _totalLength;
      }
      
      public function removePoint(point:Point) : void
      {
         var i:int = int(_points.length);
         while(--i > -1)
         {
            if(_points[i].point == point)
            {
               _points.splice(i,1);
            }
         }
         _organize();
      }
   }
}

import flash.geom.Point;

class PathPoint
{
   
   public var next:PathPoint;
   
   public var length:Number;
   
   public var y:Number;
   
   public var yChange:Number;
   
   public var progress:Number;
   
   public var xChange:Number;
   
   public var angle:Number;
   
   public var point:Point;
   
   public var x:Number;
   
   public function PathPoint(point:Point)
   {
      super();
      this.x = point.x;
      this.y = point.y;
      this.point = point;
   }
}
