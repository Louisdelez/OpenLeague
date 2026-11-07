package blix.util.string.format
{
   public function bytesToStr(param1:Number) : String
   {
      if(param1 < 1024)
      {
         return param1 + " B";
      }
      if(param1 < 1048576)
      {
         return (param1 / 1024).toFixed(2) + " KB";
      }
      if(param1 < 1073741824)
      {
         return (param1 / 1048576).toFixed(2) + " MB";
      }
      if(param1 < 1099511627776)
      {
         return (param1 / 1073741824).toFixed(2) + " GB";
      }
      if(param1 < 1125899906842624)
      {
         return (param1 / 1099511627776).toFixed(2) + " TB";
      }
      if(param1 < 1152921504606846980)
      {
         return (param1 / 1125899906842624).toFixed(2) + " PB";
      }
      if(param1 < 1.1805916207174113e+21)
      {
         return (param1 / 1152921504606846980).toFixed(2) + " EB";
      }
      if(param1 < 1.2089258196146292e+24)
      {
         return (param1 / 1.1805916207174113e+21).toFixed(2) + " ZB";
      }
      return (param1 / 1.2089258196146292e+24).toFixed(2) + " YB";
   }
}

