package cmodule.cson
{
   import flash.display.Sprite;
   
   public class ConSprite extends Sprite
   {
      
      private var runner:CRunner = new CRunner();
      
      public function ConSprite()
      {
         super();
         if(cmodule.cson.gsprite)
         {
            cmodule.cson.log(1,"More than one sprite!");
         }
         cmodule.cson.gsprite = this;
         this.runner.startSystem();
      }
   }
}

