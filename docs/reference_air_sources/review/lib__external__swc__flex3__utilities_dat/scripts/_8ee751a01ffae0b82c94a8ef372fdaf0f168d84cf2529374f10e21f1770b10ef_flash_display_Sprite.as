package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _8ee751a01ffae0b82c94a8ef372fdaf0f168d84cf2529374f10e21f1770b10ef_flash_display_Sprite extends Sprite
   {
      
      public function _8ee751a01ffae0b82c94a8ef372fdaf0f168d84cf2529374f10e21f1770b10ef_flash_display_Sprite()
      {
         super();
      }
      
      public function allowDomainInRSL(... rest) : void
      {
         Security.allowDomain(rest);
      }
      
      public function allowInsecureDomainInRSL(... rest) : void
      {
         Security.allowInsecureDomain(rest);
      }
   }
}

