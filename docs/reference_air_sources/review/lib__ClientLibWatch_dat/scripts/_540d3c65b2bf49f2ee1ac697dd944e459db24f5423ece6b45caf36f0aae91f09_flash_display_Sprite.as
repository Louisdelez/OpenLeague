package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _540d3c65b2bf49f2ee1ac697dd944e459db24f5423ece6b45caf36f0aae91f09_flash_display_Sprite extends Sprite
   {
      
      public function _540d3c65b2bf49f2ee1ac697dd944e459db24f5423ece6b45caf36f0aae91f09_flash_display_Sprite()
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

