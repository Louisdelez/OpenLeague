package champion_select_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol162")]
   public dynamic class cs_slotItem_bg_activeSelf_9 extends MovieClip
   {
      
      public var arrow_mc:MovieClip;
      
      public function cs_slotItem_bg_activeSelf_9()
      {
         super();
         addFrameScript(0,this.frame1,48,this.frame49,49,this.frame50);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame49() : *
      {
         gotoAndPlay("loop");
      }
      
      internal function frame50() : *
      {
         stop();
      }
   }
}

