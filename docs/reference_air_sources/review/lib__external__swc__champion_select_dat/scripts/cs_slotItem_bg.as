package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol166")]
   public dynamic class cs_slotItem_bg extends MovieClip
   {
      
      public var orange_animation:MovieClip;
      
      public var commend_champ_frame:MovieClip;
      
      public var animation:MovieClip;
      
      public var blue_animation:MovieClip;
      
      public function cs_slotItem_bg()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

