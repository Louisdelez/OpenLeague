class Riot.EndOfGame.GameComponents.EndOfGame extends DDW.Components.DisplayObjectContainer
{
   var curSplash;
   var layoutData;
   var libraryName;
   var splashDefeat;
   var splashVictory;
   var targX;
   var targY;
   var x;
   var y;
   var _class = "EndOfGame";
   var isVictory = false;
   var layoutHash = [["splashVictory","VictorySplash"],["splashDefeat","DefeatSplash"]];
   var commMappings = {};
   function EndOfGame(layoutMcName, mx)
   {
      super(null,mx);
      this.layoutData = DDW.Managers.LayoutManager.getLayout(layoutMcName);
   }
   function setCommNames(commMappings)
   {
   }
   function setX(value)
   {
      this.x = value;
      this.targX = value;
   }
   function setY(value)
   {
      this.y = value;
      this.targY = value;
   }
   function setIsVictory(value)
   {
      var _loc3_ = !(value == "false" || value == "0");
      this.isVictory = _loc3_;
      if(this.isVictory)
      {
         this.curSplash = this.splashVictory;
         _global.ContentWidth = this.splashVictory.width;
         _global.ContentHeight = this.splashVictory.height;
      }
      else
      {
         this.curSplash = this.splashDefeat;
         _global.ContentWidth = this.splashDefeat.width;
         _global.ContentHeight = this.splashDefeat.height;
      }
   }
   function openSplashScreen(value)
   {
      var _loc3_ = this.curSplash.getMetrics();
      _loc3_.alpha = 100;
      this.curSplash.alpha = 0;
      this.splashDefeat.visible = !this.isVictory;
      this.splashVictory.visible = this.isVictory;
      this.curSplash.animateTo(_loc3_,20);
   }
   function closeSplashScreen(value)
   {
      this.splashDefeat.visible = false;
      this.splashVictory.visible = false;
   }
   function createGraphics()
   {
      super.createGraphics();
      this.splashDefeat.visible = false;
      this.splashVictory.visible = false;
      this.splashDefeat.alpha = 0;
      this.splashVictory.alpha = 0;
      this.targX = this.splashVictory.x;
      this.targY = this.splashVictory.y;
      _global.ContentWidth = this.splashVictory.width;
      _global.ContentHeight = this.splashVictory.height;
   }
   function toString()
   {
      return this._class + " : " + this.libraryName;
   }
}
