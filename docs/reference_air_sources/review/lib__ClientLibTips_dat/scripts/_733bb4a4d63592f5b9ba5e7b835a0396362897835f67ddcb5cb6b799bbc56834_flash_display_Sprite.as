package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _733bb4a4d63592f5b9ba5e7b835a0396362897835f67ddcb5cb6b799bbc56834_flash_display_Sprite extends Sprite
   {
      
      public function _733bb4a4d63592f5b9ba5e7b835a0396362897835f67ddcb5cb6b799bbc56834_flash_display_Sprite()
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

