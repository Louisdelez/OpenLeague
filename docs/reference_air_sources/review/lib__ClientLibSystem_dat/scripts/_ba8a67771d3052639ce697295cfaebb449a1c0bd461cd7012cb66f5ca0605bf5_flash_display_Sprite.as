package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _ba8a67771d3052639ce697295cfaebb449a1c0bd461cd7012cb66f5ca0605bf5_flash_display_Sprite extends Sprite
   {
      
      public function _ba8a67771d3052639ce697295cfaebb449a1c0bd461cd7012cb66f5ca0605bf5_flash_display_Sprite()
      {
         super();
      }
      
      public function allowDomainInRSL(... rest) : void
      {
         Security.allowDomain.apply(null,rest);
      }
      
      public function allowInsecureDomainInRSL(... rest) : void
      {
         Security.allowInsecureDomain.apply(null,rest);
      }
   }
}

