class DDW.Components.DefaultProgressBar extends DDW.Components.DisplayObjectContainer
{
   var _layer;
   var _mask;
   var _meter;
   var addChild;
   var addEventListener;
   var graphics;
   var height;
   var id;
   var libraryName;
   var visualButton;
   var width;
   var _class = "DefaultProgressBar";
   var _total = 1;
   var _progress = 0;
   function DefaultProgressBar(libraryName, mx)
   {
      super(libraryName,mx);
      this.addEventListener(DDW.Events.Event.ADDED_TO_STAGE,this,this.addedToStage);
   }
   function get total()
   {
      return this._total;
   }
   function set total(value)
   {
      this._total = value;
      this.setBar();
   }
   function get progress()
   {
      return this._progress;
   }
   function set progress(value)
   {
      this._progress = value;
      this.setBar();
   }
   function setBar()
   {
      var _loc2_;
      if(this._mask != null)
      {
         _loc2_ = this._progress / this._total;
         this._mask.clear();
         this._mask.beginFill(0);
         this._mask.moveTo(this._meter.x,this._meter.y);
         this._mask.lineTo(this._meter.x + this._meter.width * _loc2_,this._meter.y);
         this._mask.lineTo(this._meter.x + this._meter.width * _loc2_,this._meter.y + this._meter.height);
         this._mask.lineTo(this._meter.x,this._meter.y + this._meter.height);
         this._mask.lineTo(this._meter.x,this._meter.y);
         this._meter.graphics.setMask(this._mask);
      }
   }
   function addedToStage(event)
   {
      super.addedToStage();
   }
   function removedFromStage(event)
   {
      super.removedFromStage();
      this.graphics = null;
   }
   function barHighlights(value)
   {
      this.visualButton.graphics.enabled = value;
   }
   function addTo(parent)
   {
      this.graphics = parent.graphics.createEmptyMovieClip("_" + this.id,this._layer);
      this.visualButton = new DDW.Components.DefaultButton("");
      this.addChild(this.visualButton);
      this.visualButton.graphics.enabled = false;
      this._meter = new DDW.Components.DisplayObject(this.libraryName);
      this._meter.width = this.width;
      this._meter.height = this.height;
      this.addChild(this._meter);
      this._mask = this.visualButton.graphics.createEmptyMovieClip("mask",99);
   }
}
