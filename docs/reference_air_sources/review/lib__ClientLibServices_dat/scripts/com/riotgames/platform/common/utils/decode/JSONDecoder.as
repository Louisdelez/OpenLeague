package com.riotgames.platform.common.utils.decode
{
   import com.riotgames.util.json.jsonDecode;
   
   public class JSONDecoder implements IDecode
   {
      
      private var debugSuppressError:Boolean;
      
      public function JSONDecoder(param1:Boolean = false)
      {
         super();
         this.debugSuppressError = param1;
      }
      
      private function doDecodeWithErrorCatch(param1:String) : Object
      {
         var str:String = param1;
         var object:Object = null;
         try
         {
            object = this.doDecode(str);
         }
         catch(e:Error)
         {
         }
         return object;
      }
      
      public function decode(param1:String) : Object
      {
         return this.debugSuppressError ? this.doDecodeWithErrorCatch(param1) : this.doDecode(param1);
      }
      
      private function doDecode(param1:String) : Object
      {
         return jsonDecode(param1);
      }
   }
}

