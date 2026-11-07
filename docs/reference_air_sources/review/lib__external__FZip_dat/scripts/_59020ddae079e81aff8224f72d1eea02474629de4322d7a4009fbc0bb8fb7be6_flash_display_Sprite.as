package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _59020ddae079e81aff8224f72d1eea02474629de4322d7a4009fbc0bb8fb7be6_flash_display_Sprite extends Sprite
   {
      
      public function _59020ddae079e81aff8224f72d1eea02474629de4322d7a4009fbc0bb8fb7be6_flash_display_Sprite()
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

