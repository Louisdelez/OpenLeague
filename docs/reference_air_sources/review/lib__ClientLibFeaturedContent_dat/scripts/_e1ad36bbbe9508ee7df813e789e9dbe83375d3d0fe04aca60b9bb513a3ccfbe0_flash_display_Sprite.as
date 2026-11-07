package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _e1ad36bbbe9508ee7df813e789e9dbe83375d3d0fe04aca60b9bb513a3ccfbe0_flash_display_Sprite extends Sprite
   {
      
      public function _e1ad36bbbe9508ee7df813e789e9dbe83375d3d0fe04aca60b9bb513a3ccfbe0_flash_display_Sprite()
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

