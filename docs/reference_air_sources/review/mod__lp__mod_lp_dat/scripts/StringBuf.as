package
{
   import flash.Boot;
   
   public class StringBuf
   {
      
      public var b:String;
      
      public function StringBuf()
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         b = "";
      }
      
      public function toString() : String
      {
         return b;
      }
      
      public function addSub(param1:String, param2:int, param3:Object = undefined) : void
      {
         if(param3 == null)
         {
            b += param1.substr(param2);
         }
         else
         {
            b += param1.substr(param2,param3);
         }
      }
      
      public function addChar(param1:int) : void
      {
         b += String.fromCharCode(param1);
      }
      
      public function add(param1:* = undefined) : void
      {
         b += param1;
      }
   }
}

