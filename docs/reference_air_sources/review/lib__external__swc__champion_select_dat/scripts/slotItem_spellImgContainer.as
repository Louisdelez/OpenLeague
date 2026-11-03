package
{
   import mx.flash.ContainerMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3")]
   public dynamic class slotItem_spellImgContainer extends ContainerMovieClip
   {
      
      public function slotItem_spellImgContainer()
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

