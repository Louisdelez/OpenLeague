package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _95145902e2523303d40639d1023f17ca8321f7ee2463a75ff9cb231251e0d69f_flash_display_Sprite extends Sprite
   {
      
      public function _95145902e2523303d40639d1023f17ca8321f7ee2463a75ff9cb231251e0d69f_flash_display_Sprite()
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

