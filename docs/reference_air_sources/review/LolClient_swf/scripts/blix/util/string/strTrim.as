package blix.util.string
{
   public function strTrim(param1:String) : String
   {
      if(!param1)
      {
         return param1;
      }
      return param1.replace(/^\s+|\s+$/g,"");
   }
}

