package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol244")]
   public dynamic class ToolbarPopinBtn extends UIMovieClip
   {
      
      public function ToolbarPopinBtn()
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

