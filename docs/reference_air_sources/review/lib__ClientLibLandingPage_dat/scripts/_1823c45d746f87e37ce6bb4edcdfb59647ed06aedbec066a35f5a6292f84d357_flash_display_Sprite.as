package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _1823c45d746f87e37ce6bb4edcdfb59647ed06aedbec066a35f5a6292f84d357_flash_display_Sprite extends Sprite
   {
      
      public function _1823c45d746f87e37ce6bb4edcdfb59647ed06aedbec066a35f5a6292f84d357_flash_display_Sprite()
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

