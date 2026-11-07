package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _ae0f6f9e9092bf0910b69c05902d5927fbc6e727c34950a634094e53794dc6d1_flash_display_Sprite extends Sprite
   {
      
      public function _ae0f6f9e9092bf0910b69c05902d5927fbc6e727c34950a634094e53794dc6d1_flash_display_Sprite()
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

