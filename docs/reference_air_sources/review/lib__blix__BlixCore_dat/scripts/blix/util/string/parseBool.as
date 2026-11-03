package blix.util.string
{
   public function parseBool(param1:String, param2:Boolean = false) : Boolean
   {
      if(!param1)
      {
         return param2;
      }
      param1 = param1.toLowerCase();
      return param1 == "1" || param1 == "true" || param1 == "t";
   }
}

