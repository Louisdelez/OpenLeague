package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _392ec122aff7efc4f27804aff3ee522d09c63d2cc68f49e09e70fe82b895def6_flash_display_Sprite extends Sprite
   {
      
      public function _392ec122aff7efc4f27804aff3ee522d09c63d2cc68f49e09e70fe82b895def6_flash_display_Sprite()
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

