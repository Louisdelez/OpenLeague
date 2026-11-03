package blix.util.type
{
   import flash.utils.describeType;
   
   public function describeType(param1:Object, param2:Boolean = false) : XML
   {
      if(!(param1 is Class))
      {
         param1 = getType(param1);
      }
      if(param2 || typeCache[param1] == null)
      {
         typeCache[param1] = flash.utils.describeType(param1);
      }
      return typeCache[param1];
   }
}

