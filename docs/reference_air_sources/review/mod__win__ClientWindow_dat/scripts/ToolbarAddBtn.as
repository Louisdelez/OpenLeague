package
{
   import mx.flash.UIMovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol330")]
   public dynamic class ToolbarAddBtn extends UIMovieClip
   {
      
      public function ToolbarAddBtn()
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

