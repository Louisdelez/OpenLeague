package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _875a28f990fd365ab9e4b5188d4840640847710c8515d654df7939cdf99bab8b_flash_display_Sprite extends Sprite
   {
      
      public function _875a28f990fd365ab9e4b5188d4840640847710c8515d654df7939cdf99bab8b_flash_display_Sprite()
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

