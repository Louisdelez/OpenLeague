package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _f9df3933a59a2f034ae96f202caa5463134c2e89e9f347a2575329024706437b_flash_display_Sprite extends Sprite
   {
      
      public function _f9df3933a59a2f034ae96f202caa5463134c2e89e9f347a2575329024706437b_flash_display_Sprite()
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

