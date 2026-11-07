class Riot.EndOfGame.Communication.CommandParser
{
   static var ContentWidth = 666;
   static var ContentHeight = 666;
   function CommandParser()
   {
   }
   static function parseCommand(command, value, ind)
   {
      var _loc5_ = command.toString() + " ::: ";
      _loc5_ += value == null ? "" : value;
      _loc5_ += " : ";
      _loc5_ += ind == null ? "" : ind;
      if(command[0] == "root")
      {
         Riot.EndOfGame.Main.root.doCommand(command.slice(1,command.length),value,ind);
      }
   }
   static function Log(s)
   {
   }
   static function genFunctions(command, value)
   {
      _global.SetX = SetX;
      _global.SetY = SetY;
      _global.Set_Options_Xpos = SetX;
      _global.Set_Options_Ypos = SetY;
      _global.SetScaleX = SetScaleX;
      _global.SetScaleY = SetScaleY;
      _global.SetWidthAspectLocked = SetWidthAspectLocked;
      _global.SetViewArea = SetViewArea;
      _global.SetIsVictory = SetIsVictory;
      _global.OpenSplashScreen = OpenSplashScreen;
      _global.CloseSplashScreen = CloseSplashScreen;
      _global.ContentWidth = ContentWidth;
      _global.ContentHeight = ContentHeight;
      _global.closeTooltip = function()
      {
      };
   }
   static function SetX(value)
   {
      parseCommand(["root","setX"],value);
   }
   static function SetY(value)
   {
      parseCommand(["root","setY"],value);
   }
   static function SetScaleX(value)
   {
      parseCommand(["root","scaleX"],value);
   }
   static function SetScaleY(value)
   {
      parseCommand(["root","scaleY"],value);
   }
   static function SetWidthAspectLocked(value)
   {
      parseCommand(["root","setWidthAspectLocked"],value);
   }
   static function SetViewArea(value)
   {
      parseCommand(["root","viewportSetup"],value);
   }
   static function SetIsVictory(value)
   {
      parseCommand(["root","setIsVictory"],value);
   }
   static function OpenSplashScreen(value)
   {
      parseCommand(["root","openSplashScreen"],value);
   }
   static function CloseSplashScreen(value)
   {
      parseCommand(["root","closeSplashScreen"],value);
   }
}
