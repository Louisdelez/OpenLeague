package com.rational.serialization.json
{
   import cmodule.cson.CLibInit;
   import com.adobe.serialization.json.JSONEncoder;
   import flash.utils.ByteArray;
   
   public final class JSON
   {
      
      private static const lib:* = new CLibInit().init();
      
      private static const decoder:Decoder = new Decoder();
      
      private static const typedDecoder:TypedDecoder = new TypedDecoder();
      
      private static const namespace:Namespace = new Namespace("cmodule.cson");
      
      private static const ram:ByteArray = namespace::gstate.ds;
      
      private static const ref:Reference = new Reference();
      
      public function JSON()
      {
         super();
      }
      
      public static function decode(param1:String, param2:Class = null) : *
      {
         var s:String = param1;
         var type:Class = param2;
         var buffer:String = s + String.fromCharCode(0);
         var length:int = s.length;
         var ref:Reference = com.rational.serialization.json.JSON.ref;
         switch(lib.compile(buffer,length,ref))
         {
            case 0:
               try
               {
                  return type ? typedDecoder.decode(ram,ref.referent,type) : decoder.decode(ram,ref.referent);
               }
               finally
               {
                  lib.release(ref.referent);
               }
               break;
            case 1:
               throw new JSONError(ref.referent);
            case 2:
               throw new JSONError(ref.referent);
            default:
               throw new Error("fallthrough");
         }
      }
      
      public static function encode(param1:*) : String
      {
         return new JSONEncoder(param1).getString();
      }
   }
}

