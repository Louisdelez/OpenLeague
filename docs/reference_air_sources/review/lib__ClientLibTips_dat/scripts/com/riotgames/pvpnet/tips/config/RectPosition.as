package com.riotgames.pvpnet.tips.config
{
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class RectPosition
   {
      
      public static const TOP_LEFT:String = "TOP_LEFT";
      
      public static const TOP_MIDDLE:String = "TOP_MIDDLE";
      
      public static const TOP_RIGHT:String = "TOP_RIGHT";
      
      public static const RIGHT_MIDDLE:String = "RIGHT_MIDDLE";
      
      public static const BOTTOM_RIGHT:String = "BOTTOM_RIGHT";
      
      public static const BOTTOM_MIDDLE:String = "BOTTOM_MIDDLE";
      
      public static const BOTTOM_LEFT:String = "BOTTOM_LEFT";
      
      public static const LEFT_MIDDLE:String = "LEFT_MIDDLE";
      
      public static const CENTER:String = "CENTER";
      
      private var _sourceRectLocation:String;
      
      private var _targetRectLocation:String;
      
      private var _adjustment:Point;
      
      public function RectPosition(param1:String, param2:String, param3:Point = null)
      {
         super();
         this._sourceRectLocation = param1;
         this._targetRectLocation = param2;
         this._adjustment = param3;
      }
      
      private static function getPointForLocation(param1:String, param2:Rectangle) : Point
      {
         var _loc3_:Point = null;
         switch(param1)
         {
            case TOP_LEFT:
               _loc3_ = new Point(0,0);
               break;
            case TOP_MIDDLE:
               _loc3_ = new Point(param2.width / 2,0);
               break;
            case TOP_RIGHT:
               _loc3_ = new Point(param2.width,0);
               break;
            case RIGHT_MIDDLE:
               _loc3_ = new Point(param2.width,param2.height / 2);
               break;
            case BOTTOM_RIGHT:
               _loc3_ = new Point(param2.width,param2.height);
               break;
            case BOTTOM_MIDDLE:
               _loc3_ = new Point(param2.width / 2,param2.height);
               break;
            case BOTTOM_LEFT:
               _loc3_ = new Point(0,param2.height);
               break;
            case LEFT_MIDDLE:
               _loc3_ = new Point(0,param2.height / 2);
               break;
            case CENTER:
               _loc3_ = new Point(param2.width / 2,param2.height / 2);
         }
         if(_loc3_ == null)
         {
            throw new IllegalOperationError("Invalid lock position location: " + param1);
         }
         return _loc3_;
      }
      
      public function calculateSourceOffset(param1:Rectangle, param2:Rectangle) : Point
      {
         var _loc3_:Point = getPointForLocation(this._sourceRectLocation,param1);
         var _loc4_:Point = getPointForLocation(this._targetRectLocation,param2);
         if(this._adjustment != null)
         {
            _loc3_ = _loc3_.add(this._adjustment);
         }
         return new Point(_loc4_.x - _loc3_.x,_loc4_.y - _loc3_.y);
      }
   }
}

