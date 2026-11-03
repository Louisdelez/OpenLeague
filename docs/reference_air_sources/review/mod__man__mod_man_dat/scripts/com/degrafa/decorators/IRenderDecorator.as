package com.degrafa.decorators
{
   import flash.display.Graphics;
   
   public interface IRenderDecorator extends IDecorator
   {
      
      function curveTo(param1:Number, param2:Number, param3:Number, param4:Number, param5:Graphics) : void;
      
      function get isValid() : Boolean;
      
      function moveTo(param1:Number, param2:Number, param3:Graphics) : void;
      
      function lineTo(param1:Number, param2:Number, param3:Graphics) : void;
   }
}

