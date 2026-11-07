package mx.utils
{
   public final class HSBColor
   {
      
      private var _hue:Number;
      
      private var _saturation:Number;
      
      private var _brightness:Number;
      
      public function HSBColor(hue:Number = NaN, saturation:Number = NaN, brightness:Number = NaN)
      {
         super();
         this.hue = hue;
         this.saturation = saturation;
         this.brightness = brightness;
      }
      
      public static function convertHSBtoRGB(hue:Number, saturation:Number, brightness:Number) : uint
      {
         var r:Number = NaN;
         var g:Number = NaN;
         var b:Number = NaN;
         var h:Number = NaN;
         var i:int = 0;
         var f:Number = NaN;
         var p:Number = NaN;
         var q:Number = NaN;
         var t:Number = NaN;
         if(saturation == 0)
         {
            r = g = b = brightness;
         }
         else
         {
            h = hue % 360 / 60;
            i = int(h);
            f = h - i;
            p = brightness * (1 - saturation);
            q = brightness * (1 - saturation * f);
            t = brightness * (1 - saturation * (1 - f));
            switch(i)
            {
               case 0:
                  r = brightness;
                  g = t;
                  b = p;
                  break;
               case 1:
                  r = q;
                  g = brightness;
                  b = p;
                  break;
               case 2:
                  r = p;
                  g = brightness;
                  b = t;
                  break;
               case 3:
                  r = p;
                  g = q;
                  b = brightness;
                  break;
               case 4:
                  r = t;
                  g = p;
                  b = brightness;
                  break;
               case 5:
                  r = brightness;
                  g = p;
                  b = q;
            }
         }
         r *= 255;
         g *= 255;
         b *= 255;
         return r << 16 | g << 8 | b;
      }
      
      public static function convertRGBtoHSB(rgb:uint) : HSBColor
      {
         var hue:Number = NaN;
         var saturation:Number = NaN;
         var brightness:Number = NaN;
         var r:Number = (rgb >> 16 & 0xFF) / 255;
         var g:Number = (rgb >> 8 & 0xFF) / 255;
         var b:Number = (rgb & 0xFF) / 255;
         var max:Number = Math.max(r,Math.max(g,b));
         var min:Number = Math.min(r,Math.min(g,b));
         var delta:Number = max - min;
         brightness = max;
         if(max != 0)
         {
            saturation = delta / max;
         }
         else
         {
            saturation = 0;
         }
         if(saturation == 0)
         {
            hue = NaN;
         }
         else
         {
            if(r == max)
            {
               hue = (g - b) / delta;
            }
            else if(g == max)
            {
               hue = 2 + (b - r) / delta;
            }
            else if(b == max)
            {
               hue = 4 + (r - g) / delta;
            }
            hue *= 60;
            if(hue < 0)
            {
               hue += 360;
            }
         }
         return new HSBColor(hue,saturation,brightness);
      }
      
      public function get hue() : Number
      {
         return this._hue;
      }
      
      public function set hue(value:Number) : void
      {
         this._hue = value % 360;
      }
      
      public function get saturation() : Number
      {
         return this._saturation;
      }
      
      public function set saturation(value:Number) : void
      {
         this._saturation = value;
      }
      
      public function get brightness() : Number
      {
         return this._brightness;
      }
      
      public function set brightness(value:Number) : void
      {
         this._brightness = value;
      }
   }
}

