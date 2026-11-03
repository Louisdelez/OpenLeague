class Riot.EndOfGame.Main
{
   static var root;
   static var DEBUG = false;
   static var initialized = true;
   function Main()
   {
   }
   static function main()
   {
      Riot.EndOfGame.Communication.CommandParser.genFunctions();
      Riot.EndOfGame.GameComponents.GameComponentFactory.initialize();
      var _loc2_ = DDW.Managers.GameManager.getInstance();
      root = new Riot.EndOfGame.GameComponents.EndOfGame("layoutMc");
      _loc2_.addChild(root);
      Stage.scaleMode = "noScale";
      Stage.align = "TL";
      if(DEBUG)
      {
         trace("DEBUG");
         _global.SetX(50);
         _global.SetY(50);
         _global.SetIsVictory(true);
         _global.OpenSplashScreen();
      }
   }
}
