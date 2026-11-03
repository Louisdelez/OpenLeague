package
{
   import mx.flash.ContainerMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol132")]
   public dynamic class cs_championItem extends ContainerMovieClip
   {
      
      public var banned:championItem_banned;
      
      public function cs_championItem()
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

