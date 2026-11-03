package flexlib.controls.iconLoaderClasses
{
   import flash.utils.ByteArray;
   
   public class IconParserFactory
   {
      
      public function IconParserFactory()
      {
         super();
      }
      
      public static function newParser(data:ByteArray) : IIconParser
      {
         var b1:int = 0;
         var b2:int = 0;
         var b3:int = 0;
         var b4:int = 0;
         data.position = 0;
         b1 = int(data.readUnsignedByte());
         b2 = int(data.readUnsignedByte());
         b3 = int(data.readUnsignedByte());
         b4 = int(data.readUnsignedByte());
         if(b1 == 0 && b2 == 0 && b3 == 1 && b4 == 0)
         {
            return new IcoParser();
         }
         if(b1 == 105 && b2 == 99 && b3 == 110 && b4 == 115)
         {
            return new IcnsParser();
         }
         return null;
      }
   }
}

