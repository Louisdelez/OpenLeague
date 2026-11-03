package com.riotgames.platform.common.utils.encode
{
   import com.riotgames.util.json.jsonEncode;
   
   public class JSONEncoder implements IEncode
   {
      
      public function JSONEncoder()
      {
         super();
      }
      
      public function encode(param1:Object) : String
      {
         return jsonEncode(param1);
      }
   }
}

