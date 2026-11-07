package
{
   import mx.flash.ContainerMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4")]
   public dynamic class slotItem_championImgContainer extends ContainerMovieClip
   {
      
      public function slotItem_championImgContainer()
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

