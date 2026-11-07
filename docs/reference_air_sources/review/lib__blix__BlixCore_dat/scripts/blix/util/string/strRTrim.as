package blix.util.string
{
   public function strRTrim(param1:String) : String
   {
      if(!param1)
      {
         return param1;
      }
      return param1.replace(/\s+$/g,"");
   }
}

