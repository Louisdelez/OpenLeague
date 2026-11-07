package com.riotgames.util.vector
{
   public function vectorToArray(param1:*) : Array
   {
      var array:Array = null;
      var item:* = undefined;
      var vector:* = param1;
      try
      {
         array = new Array();
         for each(item in vector)
         {
            array.push(item);
         }
         return array;
      }
      catch(e:Error)
      {
         throw new ArgumentError("The specified item is not a vector!");
      }
   }
}

