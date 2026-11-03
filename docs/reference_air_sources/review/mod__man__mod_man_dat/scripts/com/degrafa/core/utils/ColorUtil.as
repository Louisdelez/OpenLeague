package com.degrafa.core.utils
{
   import com.degrafa.paint.palette.PaletteEntry;
   
   public class ColorUtil
   {
      
      public function ColorUtil()
      {
         super();
      }
      
      private static function resolveColorFromString(param1:String, param2:uint = 0) : uint
      {
         if(param1.search(",") == 3)
         {
            if(param1.search("%") != -1)
            {
               return resolveColorFromRGBPercent(param1 as String);
            }
            return resolveColorFromRGB(param1 as String);
         }
         if(param1.search(",") == 4)
         {
            return resolveColorFromCMYK(param1 as String);
         }
         var _loc3_:uint = 0;
         if(String(param1).charAt(0) == "#" || String(param1).substr(0,2) == "0x")
         {
            param1 = param1.replace("#","");
            if(param1.length == 3)
            {
               _loc3_ = parseColorNotation(param1);
            }
            else
            {
               _loc3_ = parseInt(param1,16);
            }
         }
         else
         {
            _loc3_ = parseInt(String(param1),10);
         }
         if(isNaN(_loc3_) || _loc3_ == 0)
         {
            _loc3_ = resolveColorFromKey(param1 as String,param2);
         }
         return _loc3_;
      }
      
      public static function hexToRgb(param1:Number) : Object
      {
         var _loc2_:Number = param1 >> 16;
         var _loc3_:Number = param1 - (_loc2_ << 16);
         var _loc4_:Number = _loc3_ >> 8;
         var _loc5_:Number = _loc3_ - (_loc4_ << 8);
         return {
            "red":_loc2_,
            "green":_loc4_,
            "blue":_loc5_
         };
      }
      
      public static function resolveColor(param1:Object, param2:uint = 0) : uint
      {
         if(param1 is uint)
         {
            return param1 as uint;
         }
         if(param1 is String)
         {
            return resolveColorFromString(param1 as String,param2);
         }
         if(param1 is PaletteEntry)
         {
            return resolveColor(PaletteEntry(param1).value,param2);
         }
         return 0;
      }
      
      public static function resolveColorFromRGBPercent(param1:String) : uint
      {
         var _loc2_:Array = param1.replace(/%/g,"").split(",");
         return uint(int(Math.round(_loc2_[0] / 100 * 255)) << 16 | int(Math.round(_loc2_[1] / 100 * 255)) << 8 | int(Math.round(_loc2_[2] / 100 * 255)));
      }
      
      public static function parseColorNotation(param1:String) : uint
      {
         param1 = param1.replace("#","");
         param1 = "0x" + param1.charAt(0) + param1.charAt(0) + param1.charAt(1) + param1.charAt(1) + param1.charAt(2) + param1.charAt(2);
         return uint(param1);
      }
      
      public static function resolveColorFromRGB(param1:String) : Number
      {
         var _loc2_:Array = param1.split(",");
         return uint(int(_loc2_[0]) << 16 | int(_loc2_[1]) << 8 | int(_loc2_[2]));
      }
      
      public static function resolveColorFromCMYK(param1:String) : uint
      {
         var _loc2_:Array = param1.split(",");
         var _loc3_:int = 255 * _loc2_[0] / 100;
         var _loc4_:int = 255 * _loc2_[1] / 100;
         var _loc5_:int = 255 * _loc2_[2] / 100;
         var _loc6_:int = 255 * _loc2_[3] / 100;
         var _loc7_:int = int(decColorToHex(Math.round((255 - _loc3_) * (255 - _loc6_) / 255)));
         var _loc8_:int = int(decColorToHex(Math.round((255 - _loc4_) * (255 - _loc6_) / 255)));
         var _loc9_:int = int(decColorToHex(Math.round((255 - _loc5_) * (255 - _loc6_) / 255)));
         return resolveColorFromRGB(_loc7_ + "," + _loc8_ + "," + _loc9_);
      }
      
      public static function resolveColorFromKey(param1:String, param2:uint = 0) : uint
      {
         var _loc3_:String = param1.toUpperCase();
         if(ColorKeys[_loc3_] != null)
         {
            return uint(ColorKeys[_loc3_]);
         }
         return param2;
      }
      
      public static function decColorToHex(param1:uint, param2:String = "0x") : String
      {
         var _loc3_:String = ("00000" + param1.toString(16).toUpperCase()).substr(-6);
         return param2 + _loc3_;
      }
   }
}

