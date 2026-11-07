package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _8ed1cc8ade1eb915c3e689024c359b7e09236c3a123b51a562d848174d72397f_flash_display_Sprite extends Sprite
   {
      
      public function _8ed1cc8ade1eb915c3e689024c359b7e09236c3a123b51a562d848174d72397f_flash_display_Sprite()
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

