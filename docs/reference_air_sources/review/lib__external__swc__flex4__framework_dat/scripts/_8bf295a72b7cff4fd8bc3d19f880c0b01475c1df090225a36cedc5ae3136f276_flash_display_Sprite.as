package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _8bf295a72b7cff4fd8bc3d19f880c0b01475c1df090225a36cedc5ae3136f276_flash_display_Sprite extends Sprite
   {
      
      public function _8bf295a72b7cff4fd8bc3d19f880c0b01475c1df090225a36cedc5ae3136f276_flash_display_Sprite()
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

