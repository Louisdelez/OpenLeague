package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _f8b3379e56274a4e140f5cae06bfd1075acb7b0d6cb035250db2c130f7e5473d_flash_display_Sprite extends Sprite
   {
      
      public function _f8b3379e56274a4e140f5cae06bfd1075acb7b0d6cb035250db2c130f7e5473d_flash_display_Sprite()
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

