package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _aea5130a76a1ac903cb5bcfc042cdaf5d5d445aeb12017f6faad028f91653a68_flash_display_Sprite extends Sprite
   {
      
      public function _aea5130a76a1ac903cb5bcfc042cdaf5d5d445aeb12017f6faad028f91653a68_flash_display_Sprite()
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

