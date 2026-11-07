package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _fda5defb426efb0a60d6f0ce7d436c219cc90ac6eddabe33dfccedd857ce015c_flash_display_Sprite extends Sprite
   {
      
      public function _fda5defb426efb0a60d6f0ce7d436c219cc90ac6eddabe33dfccedd857ce015c_flash_display_Sprite()
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

