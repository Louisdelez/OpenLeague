package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _8a96e28024b401f519a16e47b18d733e80c45eb473871c39e6da0edfd2028a9e_flash_display_Sprite extends Sprite
   {
      
      public function _8a96e28024b401f519a16e47b18d733e80c45eb473871c39e6da0edfd2028a9e_flash_display_Sprite()
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

