class DDW.Components.DrawnProgressBar extends DDW.Components.DefaultProgressBar
{
   var _layer;
   var _progress;
   var _total;
   var addEventListener;
   var addedToStage;
   var graphics;
   var height;
   var id;
   var width;
   var _class = "DrawnProgressBar";
   function DrawnProgressBar(libraryName, mx)
   {
      super(libraryName,mx);
      this.addEventListener(DDW.Events.Event.ADDED_TO_STAGE,this,this.addedToStage);
   }
   function setBar()
   {
      var _loc2_ = this._progress / this._total;
      this.graphics.clear();
      var _loc3_ = new flash.geom.Rectangle(0,0,this.width,this.height);
      DDW.Utils.DrawingUtils.drawRect(this.graphics,_loc3_,16711680,100,2,16777215,100);
   }
   function addTo(parent)
   {
      this.graphics = parent.graphics.createEmptyMovieClip("_" + this.id,this._layer);
      this._total = 100;
      this._progress = 40;
      this.setBar();
   }
}
