package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _2a5fa259681664850f9029f1f822546688f45103c97a13162572a171c5e8406f_flash_display_Sprite extends Sprite
   {
      
      public function _2a5fa259681664850f9029f1f822546688f45103c97a13162572a171c5e8406f_flash_display_Sprite()
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

