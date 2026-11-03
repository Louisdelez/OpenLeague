package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _0005d58bfc697ced0003d54f44c311d591d2e02d1b67f087e5578174305e8711_flash_display_Sprite extends Sprite
   {
      
      public function _0005d58bfc697ced0003d54f44c311d591d2e02d1b67f087e5578174305e8711_flash_display_Sprite()
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

