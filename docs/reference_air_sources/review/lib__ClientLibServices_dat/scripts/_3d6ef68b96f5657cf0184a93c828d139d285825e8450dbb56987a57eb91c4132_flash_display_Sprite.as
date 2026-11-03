package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _3d6ef68b96f5657cf0184a93c828d139d285825e8450dbb56987a57eb91c4132_flash_display_Sprite extends Sprite
   {
      
      public function _3d6ef68b96f5657cf0184a93c828d139d285825e8450dbb56987a57eb91c4132_flash_display_Sprite()
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

