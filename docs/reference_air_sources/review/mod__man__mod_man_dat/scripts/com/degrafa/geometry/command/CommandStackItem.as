package com.degrafa.geometry.command
{
   import com.degrafa.geometry.utilities.GeometryUtils;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.registerClassAlias;
   
   public final class CommandStackItem
   {
      
      public static const IS_REGISTERED:Boolean = !(Boolean(registerClassAlias("com.degrafa.geometry.command.CommandStackItem",CommandStackItem)) || Boolean(registerClassAlias("flash.geom.Point",Point)) || Boolean(registerClassAlias("flash.geom.Rectangle",Rectangle)));
      
      public static const MOVE_TO:int = 0;
      
      public static const LINE_TO:int = 1;
      
      public static const CURVE_TO:int = 2;
      
      public static const DELEGATE_TO:int = 3;
      
      public static const COMMAND_STACK:int = 4;
      
      private var _y:Number;
      
      private var _y1:Number;
      
      private var _cy:Number;
      
      public var id:String;
      
      private var _segmentLength:Number = 0;
      
      internal var indexInParent:uint;
      
      private var _cx:Number;
      
      internal var parent:CommandStack;
      
      private var _renderDelegateStart:Array;
      
      private var _renderDelegateEnd:Array;
      
      public var type:int;
      
      private var _lengthInvalidated:Boolean = true;
      
      private var _invalidated:Boolean = true;
      
      public var reference:String;
      
      private var _next:CommandStackItem;
      
      private var _bounds:Rectangle;
      
      private var _previous:CommandStackItem;
      
      private var _x1:Number;
      
      private var _commandStack:CommandStack;
      
      private var _delegate:Function;
      
      private var _x:Number;
      
      public var skip:Boolean;
      
      public function CommandStackItem(param1:int = 0, param2:Number = NaN, param3:Number = NaN, param4:Number = NaN, param5:Number = NaN, param6:Number = NaN, param7:Number = NaN, param8:CommandStack = null)
      {
         super();
         invalidated = true;
         this.type = param1;
         _x = param2;
         _y = param3;
         _x1 = param4;
         _y1 = param5;
         _cx = param6;
         _cy = param7;
         if(param8)
         {
            this.commandStack = param8;
         }
      }
      
      public function get y() : Number
      {
         return _y;
      }
      
      public function get commandStack() : CommandStack
      {
         return _commandStack;
      }
      
      public function get delegate() : Function
      {
         return _delegate;
      }
      
      public function set lengthInvalidated(param1:Boolean) : void
      {
         _lengthInvalidated = param1;
         if(_lengthInvalidated != param1)
         {
            _lengthInvalidated = param1;
            if(_lengthInvalidated)
            {
               parent.lengthInvalidated = param1;
            }
         }
      }
      
      public function get invalidated() : Boolean
      {
         return _invalidated;
      }
      
      public function set delegate(param1:Function) : void
      {
         if(_delegate != param1)
         {
            _delegate = param1;
            invalidated = true;
         }
      }
      
      private function curvePointAt(param1:Number, param2:Point = null, param3:Point = null) : Point
      {
         var _loc4_:Point = Point.interpolate(control,start,param1);
         var _loc5_:Point = Point.interpolate(end,control,param1);
         return Point.interpolate(_loc5_,_loc4_,param1);
      }
      
      public function get segmentLength() : Number
      {
         if(!_segmentLength || lengthInvalidated)
         {
            switch(type)
            {
               case CommandStackItem.MOVE_TO:
                  _segmentLength = 0;
                  break;
               case CommandStackItem.LINE_TO:
                  _segmentLength = lineLength(start,end);
                  break;
               case CommandStackItem.CURVE_TO:
                  _segmentLength = curveLength();
                  break;
               case CommandStackItem.COMMAND_STACK:
                  _segmentLength = commandStack.pathLength;
                  break;
               default:
                  _segmentLength = 0;
            }
         }
         return _segmentLength;
      }
      
      public function set invalidated(param1:Boolean) : void
      {
         _invalidated = param1;
         if(_invalidated != param1)
         {
            _invalidated = param1;
            if(_invalidated)
            {
               parent.invalidated = _invalidated;
               lengthInvalidated = _invalidated;
            }
         }
      }
      
      private function curveAngleAt(param1:Number, param2:Point = null, param3:Point = null) : Number
      {
         param2 = linePointAt(param1,start,control);
         param3 = linePointAt(param1,control,end);
         return lineAngleAt(param1,param2,param3);
      }
      
      public function set y(param1:Number) : void
      {
         if(_y != param1)
         {
            _y = param1;
            invalidated = true;
         }
      }
      
      public function get renderDelegateEnd() : Array
      {
         return _renderDelegateEnd;
      }
      
      private function lineLength(param1:Point = null, param2:Point = null) : Number
      {
         if(!param1)
         {
            param1 = start;
         }
         if(!param2)
         {
            param2 = end;
         }
         var _loc3_:Number = param2.x - param1.x;
         var _loc4_:Number = param2.y - param1.y;
         return Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
      }
      
      public function set x1(param1:Number) : void
      {
         if(_x1 != param1)
         {
            _x1 = param1;
            invalidated = true;
         }
      }
      
      public function derive(param1:CommandStackItem) : void
      {
         if(!type)
         {
            type = param1.type;
         }
         if(!x)
         {
            _x = param1.x;
         }
         if(!y)
         {
            _y = param1.y;
         }
         if(!x1)
         {
            _x1 = param1.x1;
         }
         if(!y1)
         {
            _y1 = param1.y1;
         }
         if(!cx)
         {
            _cx = param1.cx;
         }
         if(!cy)
         {
            _cy = param1.cy;
         }
         if(!reference)
         {
            reference = param1.reference;
         }
         invalidated = true;
      }
      
      public function get bounds() : Rectangle
      {
         if(invalidated)
         {
            calcBounds();
         }
         return _bounds;
      }
      
      public function set end(param1:Point) : void
      {
         if(type == 1 || type == 0)
         {
            x = param1.x;
            y = param1.y;
         }
         else
         {
            x1 = param1.x;
            y1 = param1.y;
         }
      }
      
      public function get x1() : Number
      {
         return _x1;
      }
      
      private function curveLength(param1:int = 5, param2:Point = null, param3:Point = null, param4:Point = null) : Number
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc14_:Point = null;
         var _loc15_:int = 0;
         if(!param2)
         {
            param2 = start;
         }
         if(!param3)
         {
            param3 = control;
         }
         if(!param4)
         {
            param4 = end;
         }
         var _loc5_:Number = param4.x - param2.x;
         var _loc6_:Number = param4.y - param2.y;
         var _loc7_:Number = _loc5_ == 0 ? 0 : (param3.x - param2.x) / _loc5_;
         var _loc8_:Number = _loc6_ == 0 ? 0 : (param3.y - param2.y) / _loc6_;
         var _loc12_:Number = 0;
         var _loc13_:Point = param2;
         _loc15_ = 1;
         while(_loc15_ < param1)
         {
            _loc11_ = _loc15_ / param1;
            _loc9_ = 2 * _loc11_ * (1 - _loc11_);
            _loc10_ = _loc11_ * _loc11_;
            _loc14_ = new Point(param2.x + _loc5_ * (_loc9_ * _loc7_ + _loc10_),param2.y + _loc6_ * (_loc9_ * _loc8_ + _loc10_));
            _loc12_ += lineLength(_loc13_,_loc14_);
            _loc13_ = _loc14_;
            _loc15_++;
         }
         return _loc12_ + lineLength(_loc13_,param4);
      }
      
      public function set y1(param1:Number) : void
      {
         if(_y1 != param1)
         {
            _y1 = param1;
            invalidated = true;
         }
      }
      
      public function set renderDelegateEnd(param1:Array) : void
      {
         if(_renderDelegateEnd != param1)
         {
            _renderDelegateEnd = param1;
            invalidated = true;
         }
      }
      
      public function set control(param1:Point) : void
      {
         cx = param1.x;
         cy = param1.y;
      }
      
      public function get lengthInvalidated() : Boolean
      {
         return _lengthInvalidated;
      }
      
      public function set renderDelegateStart(param1:Array) : void
      {
         if(_renderDelegateStart != param1)
         {
            _renderDelegateStart = param1;
            invalidated = true;
         }
      }
      
      private function linePointAt(param1:Number, param2:Point = null, param3:Point = null) : Point
      {
         if(!param2)
         {
            param2 = start;
         }
         if(!param3)
         {
            param3 = end;
         }
         var _loc4_:Number = param3.x - param2.x;
         var _loc5_:Number = param3.y - param2.y;
         return new Point(param2.x + _loc4_ * param1,param2.y + _loc5_ * param1);
      }
      
      public function get transformedLength() : Number
      {
         if(!CommandStack.transMatrix)
         {
            return segmentLength;
         }
         var _loc1_:Matrix = CommandStack.transMatrix;
         if(!_segmentLength || lengthInvalidated)
         {
            switch(type)
            {
               case CommandStackItem.MOVE_TO:
                  return 0;
               case CommandStackItem.LINE_TO:
                  return lineLength(_loc1_.transformPoint(start),_loc1_.transformPoint(end));
               case CommandStackItem.CURVE_TO:
                  return curveLength(5,_loc1_.transformPoint(start),_loc1_.transformPoint(control),_loc1_.transformPoint(end));
               case CommandStackItem.COMMAND_STACK:
                  return commandStack.transformedPathLength;
            }
         }
         return 0;
      }
      
      private function lineAngleAt(param1:Number, param2:Point = null, param3:Point = null) : Number
      {
         if(!param2)
         {
            param2 = start;
         }
         if(!param3)
         {
            param3 = end;
         }
         return Math.atan2(param3.y - param2.y,param3.x - param2.x);
      }
      
      public function get control() : Point
      {
         return new Point(cx,cy);
      }
      
      public function get y1() : Number
      {
         return _y1;
      }
      
      public function segmentAngleAt(param1:Number) : Number
      {
         switch(type)
         {
            case CommandStackItem.MOVE_TO:
               return 0;
            case CommandStackItem.LINE_TO:
               return lineAngleAt(param1);
            case CommandStackItem.CURVE_TO:
               return curveAngleAt(param1);
            case CommandStackItem.COMMAND_STACK:
               return commandStack.pathAngleAt(param1);
            default:
               return 0;
         }
      }
      
      public function get start() : Point
      {
         if(_previous)
         {
            if(_previous.skip)
            {
               return _previous.start;
            }
            return _previous.end;
         }
         return new Point(0,0);
      }
      
      public function set next(param1:CommandStackItem) : void
      {
         if(_next != param1)
         {
            _next = param1;
            if(type == CommandStackItem.COMMAND_STACK)
            {
               commandStack.lastNonCommandStackItem.next = param1;
            }
         }
      }
      
      public function get renderDelegateStart() : Array
      {
         return _renderDelegateStart;
      }
      
      public function segmentPointAt(param1:Number) : Point
      {
         switch(type)
         {
            case CommandStackItem.MOVE_TO:
               return start.clone();
            case CommandStackItem.LINE_TO:
               return linePointAt(param1,start,end);
            case CommandStackItem.CURVE_TO:
               return curvePointAt(param1);
            case CommandStackItem.COMMAND_STACK:
               return commandStack.pathPointAt(param1);
            default:
               return null;
         }
      }
      
      public function calcBounds() : void
      {
         var _loc1_:Point = null;
         if(!invalidated)
         {
            return;
         }
         switch(type)
         {
            case CommandStackItem.MOVE_TO:
               if(isNaN(_x) || isNaN(_y))
               {
                  _bounds = new Rectangle();
                  skip = true;
                  break;
               }
               _bounds = new Rectangle(x,y,0,0);
               break;
            case CommandStackItem.LINE_TO:
               if(isNaN(_x) || isNaN(_y))
               {
                  _bounds = new Rectangle();
                  skip = true;
                  break;
               }
               _loc1_ = this.start;
               _bounds = new Rectangle(Math.min(x,_loc1_.x),Math.min(y,_loc1_.y),Math.abs(x - _loc1_.x),Math.abs(y - _loc1_.y));
               if(!_bounds.width)
               {
                  _bounds.width = 0.0001;
               }
               if(!_bounds.height)
               {
                  _bounds.height = 0.0001;
               }
               break;
            case CommandStackItem.CURVE_TO:
               if(isNaN(_cx) || isNaN(_cy) || isNaN(_x1) || isNaN(_y1))
               {
                  _bounds = new Rectangle();
                  skip = true;
                  break;
               }
               _loc1_ = this.start;
               _bounds = GeometryUtils.bezierBounds(_loc1_.x,_loc1_.y,cx,cy,x1,y1).clone();
               break;
            case CommandStackItem.COMMAND_STACK:
               _bounds = commandStack.bounds;
         }
         invalidated = false;
      }
      
      public function set cy(param1:Number) : void
      {
         if(_cy != param1)
         {
            _cy = param1;
            invalidated = true;
         }
      }
      
      public function set previous(param1:CommandStackItem) : void
      {
         if(_previous != param1)
         {
            _previous = param1;
            if(param1.type == CommandStackItem.COMMAND_STACK)
            {
               _previous = param1.commandStack.lastNonCommandStackItem;
            }
            if(type == CommandStackItem.COMMAND_STACK && Boolean(commandStack.length))
            {
               CommandStackItem(commandStack.source[0]).previous = _previous;
            }
         }
      }
      
      public function set x(param1:Number) : void
      {
         if(_x != param1)
         {
            _x = param1;
            invalidated = true;
         }
      }
      
      public function set cx(param1:Number) : void
      {
         if(_cx != param1)
         {
            _cx = param1;
            invalidated = true;
         }
      }
      
      public function get next() : CommandStackItem
      {
         return _next;
      }
      
      public function get cy() : Number
      {
         return _cy;
      }
      
      public function get previous() : CommandStackItem
      {
         return _previous;
      }
      
      public function get x() : Number
      {
         return _x;
      }
      
      public function set commandStack(param1:CommandStack) : void
      {
         if(_commandStack != param1)
         {
            _commandStack = param1;
            param1.parent = this;
            invalidated = true;
         }
      }
      
      public function get cx() : Number
      {
         return _cx;
      }
      
      public function get end() : Point
      {
         return new Point(type == 1 || type == 0 ? _x : _x1,type == 1 || type == 0 ? _y : _y1);
      }
   }
}

