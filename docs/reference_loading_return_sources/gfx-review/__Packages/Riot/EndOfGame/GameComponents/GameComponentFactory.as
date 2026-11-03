class Riot.EndOfGame.GameComponents.GameComponentFactory
{
   static var _instance;
   function GameComponentFactory(s)
   {
      if(s != "use getInstance")
      {
         throw new Error("GameComponentFactory is automatically created and attached to the main component factory.");
      }
   }
   static function initialize(s)
   {
      if(_instance == null)
      {
         _instance = new Riot.EndOfGame.GameComponents.GameComponentFactory("use getInstance");
         DDW.Managers.ComponentFactory.getInstance().componentFactories.push(_instance);
      }
   }
   function createInstance(type, libName, mx)
   {
      var _loc5_ = null;
      switch(type)
      {
         case "EndOfGame":
            _loc5_ = new Riot.EndOfGame.GameComponents.EndOfGame(libName,mx);
            break;
         case "VictorySplash":
            _loc5_ = new Riot.EndOfGame.GameComponents.VictorySplash(libName,mx);
            break;
         case "DefeatSplash":
            _loc5_ = new Riot.EndOfGame.GameComponents.DefeatSplash(libName,mx);
      }
      return _loc5_;
   }
}
