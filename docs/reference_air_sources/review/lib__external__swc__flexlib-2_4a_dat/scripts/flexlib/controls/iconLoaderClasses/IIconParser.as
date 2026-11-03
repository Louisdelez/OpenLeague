package flexlib.controls.iconLoaderClasses
{
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   
   public interface IIconParser
   {
      
      function get sizes() : Array;
      
      function parse() : void;
      
      function set data(param1:ByteArray) : void;
      
      function get validIcon() : Boolean;
      
      function get data() : ByteArray;
      
      function getIconForSize(param1:int) : BitmapData;
   }
}

