package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _815fc904026b0d928e6f5ae4d4ee92db4b443cbfa63771ba409ae7d7ddf12433_flash_display_Sprite extends Sprite
   {
      
      public function _815fc904026b0d928e6f5ae4d4ee92db4b443cbfa63771ba409ae7d7ddf12433_flash_display_Sprite()
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

