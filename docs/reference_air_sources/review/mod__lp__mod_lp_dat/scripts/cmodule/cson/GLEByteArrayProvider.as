package cmodule.cson
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   internal class GLEByteArrayProvider
   {
      
      public function GLEByteArrayProvider()
      {
         super();
      }
      
      public static function get() : ByteArray
      {
         var result:ByteArray = null;
         try
         {
            result = cmodule.cson.gdomainClass.currentDomain.domainMemory;
         }
         catch(e:*)
         {
         }
         if(!result)
         {
            result = new LEByteArray();
            try
            {
               result.length = cmodule.cson.gdomainClass.MIN_DOMAIN_MEMORY_LENGTH;
               cmodule.cson.gdomainClass.currentDomain.domainMemory = result;
            }
            catch(e:*)
            {
               cmodule.cson.log(3,"Not using domain memory");
            }
         }
         return result;
      }
   }
}

