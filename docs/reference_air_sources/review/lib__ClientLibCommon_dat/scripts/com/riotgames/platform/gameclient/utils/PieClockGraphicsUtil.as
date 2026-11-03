package com.riotgames.platform.gameclient.utils
{
   import flash.display.Graphics;
   
   public class PieClockGraphicsUtil
   {
      
      public function PieClockGraphicsUtil()
      {
         super();
      }
      
      public static function drawPieClockGraphic(param1:Graphics, param2:Number, param3:Number = 15, param4:uint = 0, param5:uint = 16777215, param6:uint = 1) : void
      {
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         if(!param1)
         {
            return;
         }
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         var _loc9_:Number = 0.2;
         param1.lineStyle();
         param1.beginFill(param4);
         param1.drawCircle(_loc7_,_loc8_,param3);
         param1.endFill();
         param3 -= param6;
         var _loc10_:Number = param2 * Math.PI * 2 - 0.5 * Math.PI;
         param1.moveTo(_loc7_,_loc8_);
         param1.beginFill(param5);
         param1.lineTo(_loc7_,_loc8_ - param3);
         var _loc11_:Number = Math.PI * 1.5;
         var _loc12_:Boolean = false;
         var _loc13_:Number = Math.PI * 1.5 - _loc9_;
         while(!_loc12_)
         {
            if(_loc13_ <= _loc10_)
            {
               _loc13_ = _loc10_;
               _loc12_ = true;
            }
            _loc14_ = param3 * Math.cos(_loc13_);
            _loc15_ = param3 * Math.sin(_loc13_);
            _loc16_ = param3 * (Math.cos(_loc11_) - Math.cos(_loc13_)) / (Math.sin(_loc13_) + Math.sin(_loc11_));
            _loc17_ = _loc14_ + _loc16_ * Math.sin(_loc13_);
            _loc18_ = _loc15_ - _loc16_ * Math.cos(_loc13_);
            param1.curveTo(_loc7_ + _loc17_,_loc8_ + _loc18_,_loc7_ + _loc14_,_loc8_ + _loc15_);
            _loc11_ = _loc13_;
            _loc13_ -= _loc9_;
         }
         param1.lineTo(_loc7_,_loc8_);
         param1.endFill();
      }
   }
}

