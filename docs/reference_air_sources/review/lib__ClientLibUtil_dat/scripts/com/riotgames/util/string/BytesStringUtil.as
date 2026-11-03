package com.riotgames.util.string
{
   import mx.resources.ResourceManager;
   
   public class BytesStringUtil
   {
      
      private static const BYTES:String = ResourceManager.getInstance().getString("resources","abbrev_bytes");
      
      private static const KILO_BYTES:String = ResourceManager.getInstance().getString("resources","abbrev_kiloBytes");
      
      private static const MEGA_BYTES:String = ResourceManager.getInstance().getString("resources","abbrev_megaBytes");
      
      private static const GIGA_BYTES:String = ResourceManager.getInstance().getString("resources","abbrev_gigaBytes");
      
      private static const TERA_BYTES:String = ResourceManager.getInstance().getString("resources","abbrev_teraBytes");
      
      private static const PETA_BYTES:String = ResourceManager.getInstance().getString("resources","abbrev_petaBytes");
      
      public function BytesStringUtil()
      {
         super();
      }
      
      public static function getBytesToStrLocalized(param1:Number) : String
      {
         if(param1 < 1024)
         {
            return Math.round(param1) + BYTES;
         }
         if(param1 < 1048576)
         {
            return Math.round(param1 / 1024) + KILO_BYTES;
         }
         if(param1 < 1073741824)
         {
            return Math.round(param1 / 1048576) + MEGA_BYTES;
         }
         if(param1 < 1099511627776)
         {
            return Math.round(param1 / 1073741824) + GIGA_BYTES;
         }
         if(param1 < 1125899906842624)
         {
            return Math.round(param1 / 1099511627776) + TERA_BYTES;
         }
         return Math.round(param1 / 1125899906842624) + PETA_BYTES;
      }
   }
}

