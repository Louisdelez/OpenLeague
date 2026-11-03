package spark.effects.interpolation
{
   import mx.styles.StyleManager;
   import mx.utils.HSBColor;
   
   public class HSBInterpolator implements IInterpolator
   {
      
      private static var theInstance:HSBInterpolator;
      
      private var startHSB:HSBColor;
      
      private var endHSB:HSBColor;
      
      public function HSBInterpolator(startRGB:uint = 4294967295, endRGB:uint = 4294967295)
      {
         super();
         if(startRGB != StyleManager.NOT_A_COLOR)
         {
            this.startHSB = HSBColor.convertRGBtoHSB(startRGB);
         }
         if(endRGB != StyleManager.NOT_A_COLOR)
         {
            this.endHSB = HSBColor.convertRGBtoHSB(endRGB);
         }
      }
      
      public static function getInstance() : HSBInterpolator
      {
         if(!theInstance)
         {
            theInstance = new HSBInterpolator();
         }
         return theInstance;
      }
      
      public function interpolate(fraction:Number, startValue:Object, endValue:Object) : Object
      {
         var deltaH:Number = NaN;
         var hue:Number = NaN;
         if(fraction == 0)
         {
            return startValue;
         }
         if(fraction == 1)
         {
            return endValue;
         }
         var start:HSBColor = this.startHSB;
         var end:HSBColor = this.endHSB;
         if(!start)
         {
            start = HSBColor.convertRGBtoHSB(uint(startValue));
         }
         if(!end)
         {
            end = HSBColor.convertRGBtoHSB(uint(endValue));
         }
         var startH:Number = Number(start.hue);
         var endH:Number = Number(end.hue);
         var deltaS:Number = end.saturation - start.saturation;
         var deltaB:Number = end.brightness - start.brightness;
         if(isNaN(startH) || isNaN(endH))
         {
            deltaH = 0;
         }
         else
         {
            deltaH = endH - startH;
            if(Math.abs(deltaH) > 180)
            {
               if(startH < endH)
               {
                  startH += 360;
               }
               else
               {
                  endH += 360;
               }
               deltaH = endH - startH;
            }
         }
         var saturation:Number = start.saturation + deltaS * fraction;
         var brightness:Number = start.brightness + deltaB * fraction;
         if(isNaN(startH))
         {
            hue = endH;
         }
         else if(isNaN(endH))
         {
            hue = startH;
         }
         else
         {
            hue = startH + deltaH * fraction;
         }
         return uint(HSBColor.convertHSBtoRGB(hue,saturation,brightness));
      }
      
      private function combine(baseValue:uint, deltaValue:uint, increment:Boolean) : Object
      {
         var newH:Number = NaN;
         var newS:Number = NaN;
         var newB:Number = NaN;
         var start:HSBColor = HSBColor.convertRGBtoHSB(baseValue);
         var delta:HSBColor = HSBColor.convertRGBtoHSB(deltaValue);
         if(increment)
         {
            newH = (start.hue + delta.hue) % 360;
            newS = Math.min(start.saturation + delta.saturation,1);
            newB = Math.min(start.brightness + delta.brightness,1);
         }
         else
         {
            newH = (start.hue + delta.hue) % 360;
            newS = Math.max(start.saturation - delta.saturation,0);
            newB = Math.max(start.brightness - delta.brightness,0);
         }
         return HSBColor.convertHSBtoRGB(newH,newS,newB);
      }
      
      public function increment(baseValue:Object, incrementValue:Object) : Object
      {
         return this.combine(uint(baseValue),uint(incrementValue),true);
      }
      
      public function decrement(baseValue:Object, decrementValue:Object) : Object
      {
         return this.combine(uint(baseValue),uint(decrementValue),false);
      }
   }
}

