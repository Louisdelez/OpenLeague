package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _ed73851672c985e21fab7275ff4888637d5715f3c85915ef191be0a9b1d0e5bc_flash_display_Sprite extends Sprite
   {
      
      public function _ed73851672c985e21fab7275ff4888637d5715f3c85915ef191be0a9b1d0e5bc_flash_display_Sprite()
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

